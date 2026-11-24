# 회원가입 예외 테스트
- 요청: `POST /api/members`

| 번호 | 상황 | 기대 status |
|---|---|---|
| E1 | 이미 가입된 이메일 | 409 |

## E1. 이미 가입된 이메일
준비: 같은 이메일로 먼저 가입
```json
{ "email": "user@example.com", "password": "abcd1234", "nickname": "gygim" }
```
응답 `409`
```json
{ "code": "DUPLICATE_EMAIL", "message": "이미 사용 중인 이메일입니다." }
```
