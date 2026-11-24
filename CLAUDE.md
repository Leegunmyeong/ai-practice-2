# 작업 지침서
- Spring Boot 3 / Java 17 REST API 서버. 명세는 `docs/`, 폴더별 규칙은 각 폴더 `README.md` 를 먼저 읽는다.
- 작업 전 `git switch main && git pull origin main` 후 브랜치를 만든다. main 에 직접 커밋하지 않는다.
- 요구사항에 없는 기능·정책을 추가하지 않는다. 불명확·중복·충돌하는 요구사항은 `docs/decisions/<기능명>.md` 에 정리한다.
- 명시적인 요청 없이 기존 명세서와 `src/` 를 수정하지 않는다.
- 커밋 `docs: <기능명> API 명세 추가`, push 후 `gh pr create` 로 PR 을 올린다 (base main).
