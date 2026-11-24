# 회원가입 예외 테스트
- 요청: `POST /api/members`

| 번호 | 상황 | 기대 status |
|---|---|---|
| E1 | 필수 값 누락 (email 없음) | 400 |
| E2 | 이미 가입된 이메일 | 409 |

## E1. 필수 값 누락 (email 없음)
준비: 없음
```json
{ "password": "abcd1234", "nickname": "gygim" }
```
응답 `400`
```json
{ "code": "INVALID_REQUEST", "message": "필수 값이 누락되었습니다." }
```

## E2. 이미 가입된 이메일
준비: 같은 이메일로 먼저 가입
```json
{ "email": "user@example.com", "password": "abcd1234", "nickname": "gygim" }
```
응답 `409`
```json
{ "code": "DUPLICATE_EMAIL", "message": "이미 사용 중인 이메일입니다." }
```
