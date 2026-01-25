## VirtualBox 및 DevOps 도구 통합 배포 최종 프로젝트 (개정판)

이 프로젝트는 Windows 호스트 환경에서 VirtualBox 인프라를 구축하고, 생성된 VM 내부의 보안 및 네트워크 설정을 자동화하는 전체 공정을 포함합니다. 요청하신 사용자 계정 설정, SSH 키 주입, 네트워크 고정 IP 설정 및 가변적인 설치 프로그램 관리 기능을 추가하였습니다.

---

### 1. 프로젝트 디렉토리 구조

```plaintext
ansible-devops-project/
├── inventory/
│   └── hosts.ini            # 대상 Windows 호스트 및 VM IP/네트워크 설정
├── vars/
│   ├── main.yml             # 시스템 경로 및 VBox 기본 변수
│   └── packages.yml         # 추가 설치할 패키지 목록 (간단 리스트)
└── site.yml                 # 전체 공정을 제어하는 메인 플레이북

```

---

### 2. 파일별 상세 내용

#### ① 인벤토리 및 네트워크 설정 (inventory/hosts.ini)

각 PC별로 생성될 VM에 부여할 고정 IP 정보를 포함합니다.

```ini
[physical_pcs]
# Windows 호스트 PC 정보와 해당 PC에 생성될 VM의 네트워크 설정
pc-01 ansible_host=192.168.1.10 vm_ip="192.168.21.101" vm_mask="24" vm_gw="192.168.21.1" vm_dns="8.8.8.8"
pc-02 ansible_host=192.168.1.11 vm_ip="192.168.21.102" vm_mask="24" vm_gw="192.168.21.1" vm_dns="8.8.8.8"

[physical_pcs:vars]
ansible_user=Administrator
ansible_password=YourPassword
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore

```

#### ② 설치 프로그램 변수 (vars/packages.yml)

차후 설치 항목이 늘어날 경우 이 파일의 리스트만 수정하면 됩니다.

```yaml
# 간단한 초기 설치 패키지 목록
devops_packages:
  - git
  - curl
  - wget
  - vim
  - net-tools
  - openssh-server

```

#### ③ 메인 플레이북 (site.yml)

Windows 호스트 설정부터 VM 내부의 보안/네트워크 설정까지 수행합니다.

```yaml
---
- name: Windows 호스트 가상화 및 VM 내부 환경 통합 구축
  hosts: physical_pcs
  vars_files:
    - vars/main.yml
    - vars/packages.yml

  tasks:
    # [STEP 1] Windows 호스트 선행 설치 (기존 로직 유지)
    - name: Microsoft Visual C++ Redistributable 설치
      win_package:
        path: "{{ vcredist_url }}"
        arguments: /install /quiet /norestart
        state: present

    - name: VirtualBox 소프트웨어 설치
      win_package:
        path: "{{ vbox_installer_url }}"
        arguments: /s
        state: present

    # [STEP 2] VM 생성 및 스토리지 설정
    - name: VM 생성 및 네트워크/스토리지 설정
      win_shell: |
        $vbox = "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe"
        & $vbox createvm --name "{{ vm_name }}" --register
        & $vbox modifyvm "{{ vm_name }}" --memory {{ vm_memory }} --cpus {{ vm_cpus }} --nic1 bridged
        & $vbox storagectl "{{ vm_name }}" --name "SATA Controller" --add sata
        & $vbox storageattach "{{ vm_name }}" --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium "{{ guest_additions_iso }}"

    # [STEP 3] VM 내부 설정 (VBoxManage Guest Control 이용)
    # ※ 주의: VM이 구동 중이고 게스트OS에 통신이 가능한 상태여야 함

    - name: master 계정 생성 및 비밀번호 1234 강제 설정
      win_shell: |
        $vbox = "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe"
        & $vbox guestcontrol "{{ vm_name }}" run --username root --password init_pass -- /usr/sbin/useradd -m -s /bin/bash master
        & $vbox guestcontrol "{{ vm_name }}" run --username root --password init_pass -- /bin/sh -c "echo 'master:1234' | chpasswd"

    - name: master 계정 sudo 시 패스워드 미요구 설정
      win_shell: |
        $vbox = "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe"
        & $vbox guestcontrol "{{ vm_name }}" run --username root --password init_pass -- /bin/sh -c "echo 'master ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/master"

    - name: SSH 마스터키 주입 및 권한 설정
      win_shell: |
        $vbox = "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe"
        & $vbox guestcontrol "{{ vm_name }}" run --username master --password 1234 -- /bin/sh -c "mkdir -p ~/.ssh && chmod 700 ~/.ssh"
        & $vbox guestcontrol "{{ vm_name }}" copyto --username master --password 1234 "~/.ssh/id_rsa.pub" "/home/master/.ssh/authorized_keys"

    - name: Netplan 고정 IP 설정 적용 (인벤토리 기반)
      win_shell: |
        $vbox = "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe"
        $netplan = @"
        network:
          version: 2
          ethernets:
            enp0s3:
              addresses: [{{ vm_ip }}/{{ vm_mask }}]
              gateway4: {{ vm_gw }}
              nameservers:
                addresses: [{{ vm_dns }}]
        "@
        & $vbox guestcontrol "{{ vm_name }}" run --username master --password 1234 -- /bin/sh -c "echo '$netplan' | sudo tee /etc/netplan/01-netcfg.yaml"
        & $vbox guestcontrol "{{ vm_name }}" run --username master --password 1234 -- sudo netplan apply

    # [STEP 4] 외부 변수 파일(packages.yml) 기반 프로그램 설치
    - name: 초기 필수 패키지 설치
      win_shell: |
        $vbox = "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe"
        & $vbox guestcontrol "{{ vm_name }}" run --username master --password 1234 -- sudo apt-get update
      loop: "{{ devops_packages }}"
      loop_control:
        loop_var: pkg_item
      register: pkg_install
      ignore_errors: yes

    - name: 패키지 개별 설치 실행
      win_shell: |
        $vbox = "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe"
        & $vbox guestcontrol "{{ vm_name }}" run --username master --password 1234 -- sudo apt-get install -y {{ item }}
      with_items: "{{ devops_packages }}"

    - name: 최종 완료 보고
      debug:
        msg: "계정설정, SSH 키 주입 및 {{ vm_ip }} 고정 IP 설정이 완료되었습니다."

```

---

### 3. 최종 실행 명령어

```bash
# 앤서블 플레이북 실행
ansible-playbook -i inventory/hosts.ini site.yml

```

---

### ⚠️ 비용 및 환경 주의사항

* **AWS 중첩 가상화**: Bare Metal 인스턴스 사용 시 **시간당 약 4달러($)** 이상의 비용이 발생하므로 실습 후 반드시 **인스턴스 종료(Terminate)**를 확인하세요.
* **VBox 확장팩**: 개인/학습 용도 외 상업적 이용 시 라이선스 비용이 발생할 수 있으니 주의바랍니다.

---

요청하신 대로 `master/1234` 계정 설정, sudo 무패스워드, SSH 키 주입 및 인벤토리 기반 고정 IP 설정을 통합하였습니다. 패키지 목록은 `vars/packages.yml`에서 간편하게 관리할 수 있습니다.

Next Step: VM 대량 복제를 위한 VBoxManage CloneVM 자동화 전략
