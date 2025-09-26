
# 9장. Git 사용 고급 테크닉

---

## 9-1. 커밋 되돌리기 (revert, reset)

### 1) 이전 커밋 취소: `git revert`
- **특정 커밋의 변경만 취소하고, 취소 이력을 남김**
  ```bash
  git revert <커밋ID>
  ```
- 협업 시 안전!  
  → 기존 히스토리를 보존하며, 취소한 내용만 새 커밋으로 남음

### 2) 커밋 자체를 히스토리에서 삭제: `git reset`
- **최근 상태를 아예 과거로 되돌리고 싶을 때 사용**
  - 소스트리: `reset --hard`
  - CLI:
    ```bash
    git reset --hard <커밋ID>
    ```
- **주의:**  
  - 이미 push된 커밋을 reset하면 협업자와 히스토리가 꼬일 수 있음(위험!)
  - 혼자 쓰거나, push 전에만 사용 권장

---

## 9-2. 커밋 합치기 (squash, rebase)

### 1) 여러 커밋을 하나로: `rebase -i`
- **불필요하게 쪼개진 커밋을 정리할 때**
  ```bash
  git rebase -i HEAD~3
  ```
  - 최근 3개 커밋을 한 커밋으로 합치고 메시지 재작성  
  - ‘pick’ 대신 ‘squash’ 또는 ‘fixup’ 사용

### 2) 커밋 히스토리 깔끔하게 만들기
- PR 병합 전, 리팩토링 후 등에서 자주 사용

---

## 9-3. stash: 임시 저장과 복원

- **작업 중인 내용을 임시로 저장**
  ```bash
  git stash
  ```
- **임시 저장 불러오기**
  ```bash
  git stash pop
  ```
- **여러 개의 stash 관리**
  ```bash
  git stash list
  git stash apply stash@{1}
  ```

---

## 9-4. 태그(Tag)로 버전 관리

- **특정 커밋에 버전 태그 달기**
  ```bash
  git tag v1.0.0
  ```
- **태그 목록 보기**
  ```bash
  git tag
  ```
- **태그 push**
  ```bash
  git push origin v1.0.0
  ```
- **주로 릴리즈, 배포 시점에 사용**

---

## 9-5. 로그 보기 고급 옵션

- **그래프 형태로 보기**
  ```bash
  git log --oneline --graph --all
  ```
- **특정 파일만 로그 보기**
  ```bash
  git log -- <파일명>
  ```

---

## 9-6. .gitignore로 불필요 파일 관리

- **추적 제외 파일 설정**
  - `.gitignore` 파일에 추가  
    ```
    *.log
    /build/
    .env
    ```
- **프로젝트별, 언어별 샘플은 [gitignore.io](https://www.toptal.com/developers/gitignore)에서 생성 가능**

---

## 9-7. alias로 자주 쓰는 명령 단축

- **자주 쓰는 명령어 단축키 등록**
  ```bash
  git config --global alias.lg "log --oneline --graph --all"
  ```
  - 사용 예:  
    ```bash
    git lg
    ```

---

## 9-8. 실전 팁

- **위험한 명령(reset, rebase 등)은 협업 전 신중하게!**
- **stash, tag, alias 등으로 개발 생산성 향상**
- **최신 git 기능은 공식 문서, 블로그 등에서 꾸준히 학습**

---

더 구체적인 예제, 실제 실습 시나리오, 심화 질문이 필요하다면 말씀해 주세요!
