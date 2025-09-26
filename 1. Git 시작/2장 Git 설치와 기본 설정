
# 2장: Git 설치와 기본 설정

---

## 2-1. Git이란 무엇인가?

- Git: 분산 버전 관리 시스템(DVCS)
- 소스 코드 이력 관리, 협업, 백업 등 다양한 목적
- 다양한 운영체제에서 사용 가능

---

## 2-2. Git 설치하기

### Windows

1. [Git 공식사이트](https://git-scm.com/download/win) 접속  
2. 최신 버전 다운로드 및 실행
3. 설치 옵션 기본값으로 진행(중요 옵션: Git Bash 설치 여부, 기본 에디터 선택 등)
4. 설치 완료 후 ‘Git Bash’ 실행

### Mac

1. 터미널에서 다음 명령어 입력  
   ```
   brew install git
   ```
   (Homebrew가 없다면 [공식사이트](https://git-scm.com/download/mac)에서 설치)
2. 설치 완료 후 터미널에서 git 명령어 사용 가능

### Linux

1. 배포판별 설치 명령어
   - Ubuntu/Debian:  
     ```
     sudo apt update
     sudo apt install git
     ```
   - CentOS/Fedora:  
     ```
     sudo dnf install git
     ```
2. 설치 완료 후 터미널에서 git 명령어 사용 가능

---

## 2-3. 설치 확인

- 터미널(또는 명령 프롬프트)에서 아래 명령어 입력  
  ```
  git --version
  ```
- 버전 정보가 출력되면 설치 성공  
  예시:  
  ```
  git version 2.41.0
  ```

---

## 2-4. Git 기본 설정

### 사용자 이름과 이메일 등록

- 터미널(또는 명령 프롬프트)에서 입력  
  ```
  git config --global user.name "홍길동"
  git config --global user.email "hong@example.com"
  ```

- 이 정보는 커밋 작성자 정보로 사용됨

### 설정 확인

- 현재 설정 확인  
  ```
  git config --global --list
  ```
- 결과 예시  
  ```
  user.name=홍길동
  user.email=hong@example.com
  ```

### 기본 에디터 설정(선택 사항)

- 기본 커밋 메시지 에디터 변경  
  ```
  git config --global core.editor "code --wait"
  ```
  (VSCode를 기본 에디터로 지정하는 예시)

---

## 2-5. 기타 유용한 기본 설정

- 줄바꿈 자동 변환(Windows 사용자 추천)
  ```
  git config --global core.autocrlf true
  ```
- 색상 출력 활성화
  ```
  git config --global color.ui auto
  ```

---

## 2-6. 실습: Git 설치 및 기본 설정 직접 해보기

1. 각자 PC에 Git 설치
2. 터미널에서 사용자 정보 등록
3. 설정 내용 출력해서 확인

---

## 2-7. 참고 자료

- [Git 공식 설치 페이지](https://git-scm.com/downloads)
- [Git 공식 문서](https://git-scm.com/doc)

