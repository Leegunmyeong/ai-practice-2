# AI 협업 가이드

## 처음 한 번
1. 설치: Claude Code, GitHub CLI(`gh auth login`), jq, Docker Desktop → IntelliJ 재시작
2. `.env.example` → `.env` 복사 후 비밀번호 입력, DB 는 `SETUP-DB.md` 의 D 섹션
3. `bash scripts/setup-check.sh` 가 전부 ✅ 면 끝

## 사용법 (IntelliJ 터미널에서 `claude`)
| 할 일 | Claude 에게 |
|---|---|
| API 명세 | `planner 에이전트로 <기능> API 명세 만들어서 PR 올려줘. <요구사항>` |
| 결정 반영 | `docs/decisions/<기능명>.md` 의 결정 칸을 채운 뒤 `planner로 PR #<번호> 결정 반영해줘` |

## 규칙
- 머지는 사람만 한다. `.env` 는 커밋하지 않는다.
- AI 결과가 이상하면 해당 폴더 `README.md` 에 **한 줄**만 추가한다. 늘리기 전에 팀과 상의한다.
