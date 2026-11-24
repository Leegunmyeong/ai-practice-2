# AI 협업 가이드

## 처음 한 번
**설치:** JDK 17, IntelliJ, Git, Docker Desktop(WSL2), Claude Code, GitHub CLI(`gh auth login`), jq → IntelliJ 재시작
PC 에 MySQL 이 설치돼 있으면 `services.msc` → MySQL80 → 시작 유형 "수동" → 중지

**프로젝트:**
1. clone 후 IntelliJ 로 열기
2. `.env.example` 을 복사해 `.env` 로 만들고 비밀번호를 정한다
3. DB 컨테이너 만들기: `SETUP-DB.md` 의 D-1 (비밀번호는 `.env` 와 같게)
4. `bash scripts/setup-check.sh` 가 전부 ✅ 면 끝

**IntelliJ 설정:**
- Project Structure → SDK **17** / Settings → Gradle → Gradle JVM **17**
- Settings → Compiler → Annotation Processors → **Enable annotation processing** (Lombok)
- Settings → Tools → Terminal → Shell path: **Git Bash** (`C:\Program Files\Git\bin\bash.exe`)
- Settings → Editor → File Encodings → 전부 **UTF-8**
- 실행 설정의 Environment variables, Active profiles 는 **비워 둔다** (`.env` 가 대신함)
- Database 창: `localhost` / `3307` / `root` / `.env` 비밀번호

## 매일
- 시작: `docker start ai-practice2-mysql`
- 머지 후 정리: `bash scripts/done.sh`

## 사용법 (터미널에서 `claude`)
| 할 일 | Claude 에게 |
|---|---|
| API 명세 | `planner 에이전트로 <기능> API 명세 만들어서 PR 올려줘. <요구사항>` |
| 결정 반영 | `docs/decisions/<기능명>.md` 의 `결정` 칸을 채우고 커밋 → `planner로 PR #<번호> 결정 반영해줘` |

`결정` 칸에는 `추천대로`, 원하는 값이나 문장, `질문: …` 을 쓴다. 비우면 안 바뀐다. 정하고 싶은 게 더 있으면 줄을 추가한다.

## 규칙
- 머지는 사람만 한다. `.env` 는 커밋하지 않는다.
- AI 결과가 이상하면 해당 폴더 `README.md` 에 **한 줄**만 추가한다. 늘리기 전에 팀과 상의한다.
