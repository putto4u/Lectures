

# 8장. 협업 실전: Fork, Pull Request, Issue

---

## 8-1. Fork란?

- **Fork(포크):**
  - 다른 사람의 GitHub 저장소를 내 계정으로 “복제”하는 기능
  - 원본 저장소에는 권한이 없어도, 내 저장소에서 자유롭게 실험/수정 가능
- **사용 목적:**
  - 오픈소스 프로젝트에 기여
  - 실습, 실험, 독립적인 개발 등

---

## 8-2. Fork 사용 방법

1. **GitHub에서 저장소 접속**
2. 상단의 **Fork** 버튼 클릭
3. 내 계정에 복제본 저장소 생성됨
4. 내 저장소를 clone해서 로컬에서 작업  
   ```bash
   git clone https://github.com/내아이디/저장소명.git
   ```

---

## 8-3. 내 저장소에서 기능 개발

- 별도 브랜치 생성  
  ```bash
  git checkout -b feature/새기능
  ```
- 코드 수정 및 커밋  
  ```bash
  git add .
  git commit -m "새 기능 추가"
  ```
- 내 원격 저장소로 push  
  ```bash
  git push origin feature/새기능
  ```

---

## 8-4. Pull Request(풀리퀘스트, PR) 만들기

- **Pull Request란?**
  - 내 저장소의 변경사항을 원본 저장소에 “병합 요청”하는 것
- **PR 생성 절차**
  1. GitHub 내 저장소에서 “Compare & pull request” 클릭
  2. 변경 내용, 목적, 설명을 작성
  3. PR 생성 후, 저장소 관리자(원저자)에게 리뷰와 승인 요청

---

## 8-5. PR 리뷰 & 병합 과정

- **저장소 관리자는**
  - 변경 내용 확인(코드 리뷰)
  - 질문 또는 추가 요청 가능(Comment)
  - 승인(Approve) 또는 거절(Close) 가능
- **병합(Merge)**
  - 리뷰 승인 후, PR을 원본 저장소에 병합

---

## 8-6. Issue 활용하기

- **Issue(이슈):**
  - 버그 신고, 개선 요청, 질문 등 협업 시 소통 창구
  - 프로젝트의 “할 일 목록(To-Do List)” 역할
- **이슈 생성 방법**
  1. 저장소의 “Issues” 탭 클릭
  2. “New Issue”로 제목/내용 작성
  3. 라벨(Label), 담당자(Assignee) 지정 가능

---

## 8-7. 원본 저장소 변경사항 동기화

- **원본 저장소의 최신 내용을 내 저장소로 가져오기**
  1. 원본 저장소를 upstream으로 등록  
     ```bash
     git remote add upstream https://github.com/원본아이디/저장소명.git
     ```
  2. 동기화  
     ```bash
     git fetch upstream
     git merge upstream/main
     ```
- **Fork 후에도 원본 최신 상태 유지가 중요!**

---

## 8-8. 실습 예제

1. 팀원 저장소를 Fork  
2. 내 저장소 clone 후 브랜치 생성/작업/커밋  
3. 내 원격 저장소에 push  
4. Pull Request 생성  
5. 원본 저장소 관리자가 PR을 리뷰/병합  
6. Issue로 소통하며 협업 경험

---

## 8-9. 협업 실전 팁

- **충분한 설명과 문서화:** PR, Issue에 목적/변경점/테스트 방법 명확히 작성
- **작업 단위 나누기:** 큰 변경은 여러 PR로 분할
- **적극적 소통:** 질문, 피드백, 리뷰 적극 활용
- **원본 저장소와 주기적 동기화(Upstream Fetch/Merge)**

---

더 구체적인 실습 시나리오, 예제, 화면 캡처 등이 필요하면 말씀해 주세요!
