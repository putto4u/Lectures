요청하신 설정과 가이드라인에 맞춰 WSL(Windows Subsystem for Linux) 사용법을 강의 교재 형식으로 구성하였습니다.

---

## WSL(Windows Subsystem for Linux) 개요 및 설치

WSL은 Windows 운영 체제 내에서 별도의 가상 머신 설정 없이도 GNU/Linux 환경을 직접 실행할 수 있게 해주는 호환성 레이어입니다. 최신 버전인 **WSL 2**는 실제 리눅스 커널을 탑재하여 시스템 호출 호환성을 높이고 파일 시스템 성능을 대폭 향상했습니다.

### 1. 시스템 요구 사항 확인

* **Windows 10:** 버전 2004 이상(빌드 19041 이상)
* **Windows 11:** 모든 버전 지원
* **가상화 지원:** BIOS/UEFI 설정에서 'Virtualization Technology(VT-x 또는 AMD-V)'가 활성화되어 있어야 합니다.

### 2. WSL 및 배포판 설치 (PowerShell)

Windows 터미널 또는 PowerShell을 **관리자 권한**으로 실행한 후 다음 명령어를 입력합니다.

```powershell
# WSL 기본 설치 (기본 배포판: Ubuntu)
wsl --install

```

> **[참고]** 특정 배포판을 선택하여 설치하고 싶을 경우:
> 1. `wsl --list --online` 명령어로 설치 가능한 배포판 목록 확인
> 2. `wsl --install -d <배포판이름>` (예: `wsl --install -d Debian`)
> 
> 

### 3. 설치 완료 및 초기 설정

1. 명령어 실행 후 PC를 **재부팅**합니다.
2. 부팅 후 자동으로 Linux 터미널이 열리며 설치가 마무리됩니다.
3. **사용자 이름(Username)**과 **비밀번호(Password)**를 설정합니다. (Windows 계정과 무관한 독자적 계정입니다.)

---

## 주요 명령어 및 환경 관리

WSL을 효율적으로 관리하기 위한 핵심 명령어입니다. 모든 명령어는 Windows PowerShell에서 수행합니다.

### 1. 상태 확인 및 버전 관리

* **설치된 배포판 목록 및 버전 확인:**
```powershell
wsl -l -v

```


* **WSL 2를 기본 버전으로 설정:**
```powershell
wsl --set-default-version 2

```


* **특정 배포판을 WSL 2로 전환:**
```powershell
wsl --set-version <배포판이름> 2

```



### 2. 실행 및 종료

* **기본 배포판 실행:** `wsl`
* **특정 사용자로 실행:** `wsl -u <유저명>`
* **배포판 종료(종료 시 메모리 반환):** `wsl --terminate <배포판이름>`
* **WSL 전체 시스템 셧다운:** `wsl --shutdown`

### 3. 백업 및 복구 (배포판 이동)

WSL 데이터는 기본적으로 C 드라이브에 저장됩니다. 용량 확보를 위해 다른 드라이브로 내보낼 수 있습니다.

* **내보내기(Export):** `wsl --export <배포판이름> <경로\파일명.tar>`
* **가져오기(Import):** `wsl --import <새이름> <설치경로> <경로\파일명.tar>`

---

## Windows와 Linux 간의 상호 운용성

WSL의 가장 강력한 특징은 두 OS 간의 파일 공유 및 명령 공유입니다.

### 1. 파일 시스템 접근

* **Linux에서 Windows 파일 접근:** `/mnt/` 디렉토리에 각 드라이브가 마운트되어 있습니다.
* 예: `cd /mnt/c/Users`


* **Windows에서 Linux 파일 접근:** 파일 탐색기 주소창에 다음 경로를 입력합니다.
* `\\wsl$` 또는 `\\wsl.localhost\Ubuntu`



### 2. 개발 도구 연동 (VS Code)

1. Windows용 **Visual Studio Code**를 설치합니다.
2. 확장 프로그램(Extension)에서 **"WSL"**을 검색하여 설치합니다.
3. WSL 터미널에서 작업 디렉토리로 이동 후 `code .`을 입력하면 해당 환경에서 코딩이 가능합니다.

---

## [AWS 서비스 활용 시 주의사항]

WSL 환경 내에서 AWS CLI 등을 설치하여 사용할 때, **Amazon EC2**나 **S3** 등의 유료 리소스를 생성할 경우 비용이 발생합니다. 특히 프리티어 기간이 만료되었거나, 인스턴스 타입(t2.micro 이상 등) 선택에 따라 **유료 과금**으로 전환되므로 리소스 사용 후 반드시 `terminate` 하시기 바랍니다.

---

Next Step: WSL 네트워크 설정 및 고정 IP 할당 방법
