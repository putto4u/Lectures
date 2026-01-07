## Environment Setup (로컬·보안·IaC 및 자동화 환경 구축)

본격적인 클라우드 네이티브 설계와 IaC(코드 기반 인프라) 및 구성 관리 자동화 실습을 위해 가상화 환경, 자동화 도구, 원격 접속 환경을 구축합니다. 클라우드 실습은 설정 실수로 인한 **'요금 폭탄'** 위험이 크므로, 로컬 가상 머신에서 충분히 숙달하는 과정이 필수적입니다.

---

### **1. 실습 소프트웨어 및 도구 설치 목록 (System Prerequisites)**

실습의 효율성을 위해 관련 있는 도구끼리 그룹화하였습니다. 모든 소프트웨어는 공식 배포처를 통해 설치하시기 바랍니다. 특히 도커는 GUI 환경인 'Desktop'과 서버 환경용 'Engine'을 구분하여 준비합니다.

| 분류 | 소프트웨어 및 OS | 권장 버전 | 공식 다운로드 링크 | 비고 |
| --- | --- | --- | --- | --- |
| **가상화** | **VirtualBox** | **7.0.6** | [다운로드](https://www.virtualbox.org/wiki/Download_Old_Builds_7_0) | 하이퍼바이저 엔진 |
|  | **VirtualBox Extension Pack** | **7.0.6** | [다운로드](https://www.virtualbox.org/wiki/Downloads) | USB/RDP 등 부가기능 애드온 |
| **운영체제** | **Ubuntu Desktop** | **22.04.3 LTS** | [다운로드](https://releases.ubuntu.com/22.04/) | 기본 서버 실습용 OS |
|  | **Kali Linux** | **Latest** | [다운로드](https://www.kali.org/get-kali/) | 보안 및 모니터링 실습용 |
| **컨테이너** | **Docker Engine (정식)** | **Latest** | [설치안내](https://docs.docker.com/engine/install/ubuntu/) | 리눅스 서버용 정식 도커 엔진 |
|  | **Docker Desktop** | **Latest** | [다운로드](https://www.docker.com/products/docker-desktop/) | Windows/Mac용 GUI 관리 도구 |
|  | **Minikube** | **Latest** | [다운로드](https://minikube.sigs.k8s.io/docs/start/) | 로컬 쿠버네티스 환경 |
| **자동화/IaC** | **Terraform** | **Latest** | [다운로드](https://developer.hashicorp.com/terraform/downloads) | 인프라 자동화 구성 (IaC) |
|  | **Ansible** | **Latest** | [설치안내](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) | 구성 관리 자동화 도구 |
| **웹 실습** | **Playground** | **-** | [접속](https://labs.play-with-docker.com/) | Docker/K8s 웹 기반 실습 환경 |
| **원격 접속** | **Xshell** | **Latest** | [다운로드](https://www.netsarang.com/ko/free-for-home-school/) | 강력한 세션 관리 (가정/학교 무료) |
|  | **MobaXterm** | **Latest** | [다운로드](https://mobaxterm.mobatek.net/download.html) | **[추천]** SSH/SFTP/X11 통합 무료 도구 |
|  | **PuTTY** | **Latest** | [다운로드](https://www.putty.org/) | 가장 가볍고 표준적인 SSH 클라이언트 |
| **개발/관리** | **VS Code** | **Latest** | [다운로드](https://code.visualstudio.com/) | 인프라 코드 작성용 에디터 |
|  | **Git** | **Latest** | [다운로드](https://www.google.com/search?q=https://git-scm.com/downloads) | 코드 이력 관리 및 협업 도구 |

---

### **2. 필수 확장팩 및 부가 도구 (Add-ons & Extensions)**

* **Docker Engine vs Desktop:** 실무 서버 환경과 동일한 실습을 위해 Ubuntu VM 내에 **Docker Engine**을 직접 설치하는 과정이 포함됩니다. Desktop 버전은 로컬 개발 편의성을 위해 사용합니다.
* **Ansible Core:** 리눅스(Ubuntu) 가상 머신 내에서 설치하여 여러 대의 서버 설정을 한 번에 제어하는 실습에 사용합니다.
* **VS Code 필수 확장팩:**
* *HashiCorp Terraform:* Terraform 문법 강조
* *Ansible Extension:* 플레이북 작성 지원
* *Remote - SSH:* 가상 머신 및 AWS 서버 원격 편집


* **MobaXterm & PuTTY:**
* **PuTTY**는 설치가 필요 없는 단일 실행 파일로 매우 가벼우며 기본적인 SSH 연결 테스트에 최적입니다.
* **MobaXterm**은 SSH 접속과 동시에 SFTP(파일 탐색기)를 지원하여 파일 전송이 매우 직관적입니다.



---

### **3. 핵심 도구별 실습 역할**

* **Docker & Kubernetes:** 애플리케이션의 컨테이너화와 오케스트레이션 운영을 학습합니다. 특히 정식 엔진 설치를 통해 리눅스 환경에서의 데몬(Daemon) 관리를 익힙니다.
* **Terraform & Ansible:** Terraform으로 AWS 인프라(하드웨어)를 생성하고, Ansible로 그 내부의 소프트웨어 설정을 자동화하는 전체 파이프라인을 구축합니다.
* **Kali Linux:** 구축된 자동화 인프라의 보안 취약점을 점검하는 도구로 활용합니다.

---

### **4. 환경 구성 권장 사양 (Lab Spec)**

* **가상 머신 사양:** Ubuntu(2 CPU / 4GB RAM), Kali(2 CPU / 2GB RAM) 권장.
* **네트워크 구성:** VM 간 원활한 Ansible 통신 및 Docker 클러스터 구성을 위해 '호스트 전용 어댑터'를 추가로 활성화합니다.

---

### **5. [학습 전략 및 예방 조치]**

* **원격 접속 도구 활용:** 가상 머신의 좁은 콘솔 대신 **MobaXterm**이나 **PuTTY**를 사용하는 것이 복사/붙여넣기 및 효율적인 작업 관리에 유리합니다.
* **IaC 사전 검증:** Terraform 적용 전 `terraform plan`을 통해 생성될 자원을 반드시 확인하십시오. 불필요한 고사양 자원 생성을 막는 최전방 방어선입니다.
* **[유료 과금 및 관리 주의]:**
* **AWS Budgets:** AWS 실습 시작 즉시 예상 비용 알람을 설정하십시오.
* **Docker Desktop 라이선스:** 기업 환경(직원 250명 이상 또는 매출 1천만 달러 이상)에서 사용 시 유료 구독이 필요할 수 있으니 주의하십시오.
* **VirtualBox Extension Pack:** 개인 및 교육용(PUEL)으로만 무료이며, 기업체에서 상업용으로 사용 시 라이선스 구매가 필요합니다.



Next Step: **Docker Engine(정식) 및 Terraform 초기 환경 설정 실습**
