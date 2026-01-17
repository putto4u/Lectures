## 마스터 PC 및 예비 서버 가상화 환경 통합 구축 가이드

이 가이드는 **모든 PC가 윈도우(Windows) 초기 상태**이며, 가상화 소프트웨어가 전혀 설치되지 않았다는 가정하에 출발합니다. 마스터 PC를 제어 노드로 만들고, 20대의 예비 서버를 동시에 구축하는 전체 프로세스입니다.

---

### 1. 전체 구축 아키텍처

모든 PC는 동일한 네트워크에 연결되어 있어야 하며, 마스터 PC는 파일을 배포하는 **서버 역할**과 설정을 지시하는 **앤서블 제어 노드 역할**을 동시에 수행합니다.

---

### 2. [단계 1] 마스터 PC(강사) 환경 조성

마스터 PC는 예비 서버들을 제어하기 위해 **WSL2(Windows Subsystem for Linux)**와 **앤서블(Ansible)**을 먼저 갖춰야 합니다.

1. **WSL2 및 Ubuntu 설치:** * PowerShell(관리자)에서 실행: `wsl --install`
* 재부팅 후 Ubuntu 환경에서 `sudo apt update && sudo apt install -y ansible` 실행


2. **배포 파일 서버 구동:** * 마스터 PC의 특정 폴더에 `VirtualBox 설치파일`과 `Ubuntu VDI 이미지`를 준비합니다.
* 해당 폴더에서 PowerShell을 열고 파일 서버 실행: `python -m http.server 80`
* 이제 예비 서버들은 `http://마스터PC_IP/파일명`으로 파일을 다운로드할 수 있습니다.



---

### 3. [단계 2] 예비 서버(수강생) 원격 접속 허용

예비 서버 20대의 Windows가 마스터 PC의 명령을 받을 수 있도록 통로를 열어줍니다. 이 작업은 각 PC에서 최초 1회 수동으로 진행하거나, USB에 담긴 배치 파일(`.bat`)로 일괄 실행합니다.

```powershell
# WinRM(원격 관리) 활성화
Enable-PSRemoting -Force

# 마스터 PC의 접속을 허용하는 보안 설정
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true
NetworkPrompt -SkipNetworkProfileCheck

```

---

### 4. [단계 3] 앤서블을 이용한 통합 자동 배포

이제 마스터 PC의 WSL2 터미널에서 아래 플레이북을 실행합니다. 이 명령 한 번으로 20대의 예비 서버는 아래 과정을 **동시에** 진행합니다.

#### **배포 자동화 플레이북 (deploy_infra.yml)**

| 구축 순서 | 작업 내용 | 사용 모듈 |
| --- | --- | --- |
| **1. VirtualBox 설치** | 마스터 PC로부터 파일을 받아 무인 설치 | `win_package` |
| **2. 이미지 다운로드** | 마스터 PC의 파일 서버에서 VDI 복사 | `win_get_url` |
| **3. 네트워크 설정** | 물리 어댑터를 찾아 브리지 모드 연결 | `win_shell` |
| **4. VM 생성 및 가동** | VBoxManage 명령어로 VM 즉시 실행 | `win_shell` |

```yaml
- name: 마스터 PC 주도 예비 서버 통합 구축
  hosts: standby_servers
  tasks:
    - name: VirtualBox 소프트웨어 설치
      win_package:
        path: "http://{{ master_ip }}/VirtualBox-7.0.exe"
        arguments: --silent --ignore-reboots

    - name: VM 베이스 이미지(VDI) 복사
      win_get_url:
        url: "http://{{ master_ip }}/ubuntu_base.vdi"
        dest: "C:\Lab\ubuntu.vdi"

    - name: VBoxManage를 통한 브리지 모드 VM 구축
      win_shell: |
        $vbox = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
        # 1. VM 생성 및 등록
        & $vbox createvm --name "Target_Node" --register
        # 2. 브리지 어댑터 이름 동적 획득 후 설정
        $adapter = (Get-NetAdapter | Where-Object {$_.Status -eq "Up"}).Name[0]
        & $vbox modifyvm "Target_Node" --memory 2048 --cpus 2 --nic1 bridged --bridgeadapter1 $adapter
        # 3. 디스크 연결
        & $vbox storagectl "Target_Node" --name "SATA" --add sata
        & $vbox storageattach "Target_Node" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "C:\Lab\ubuntu.vdi"
        # 4. 전원 켜기
        & $vbox startvm "Target_Node" --type headless

```

---

### 5. 인프라 운영 및 비용 고찰

* **무료 소프트웨어 활용:** * **VirtualBox / Ubuntu:** 오픈소스로 비용 0원.
* **Ansible:** 오픈소스로 비용 0원.


* **네트워크 과부하 주의:** * 20대가 동시에 2GB 이상의 VDI 파일을 마스터 PC에서 가져가면 네트워크(L2 스위치)에 병목이 생깁니다.
* 앤서블의 `serial: 5` 설정을 추가하여 **5대씩 순차적으로** 구축하는 것을 권장합니다.


* **AWS 전환 시 비용:** * 동일한 작업을 AWS에서 수행하려면 전용 서버급 인스턴스(Bare Metal)가 필요하며, 시간당 약 **$4.00 이상의 고비용**이 발생합니다. 교육용으로는 로컬 환경 구축이 가장 효율적입니다.

Next Step: 마스터 PC용 파일 서버(Python) 구동 및 연결 테스트

---

* 마스터 PC의 윈도우에는 가상화 기능(Hyper-V 또는 VT-x)이 BIOS에서 활성화되어 있어야 합니다.
* 예비 서버의 윈도우 방화벽에서 ICMP(Ping)와 WinRM 포트(5985)가 허용되었는지 확인하십시오.

준비물 확인: 마스터 PC 1대, 예비 서버 20대, 기가비트 스위칭 허브 1대, 마스터 PC 내 배포용 VDI 파일.
