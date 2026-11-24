# 회원가입 예외 테스트
- 요청: `POST /api/members`

| 번호 | 상황 | 기대 status |
|---|---|---|
| E1 | 필수 값 누락 (email 없음) | 400 |
| E2 | 이미 가입된 이메일 | 409 |
| E3 | 이미 사용 중인 닉네임 | 409 |
| E4 | 이메일 형식 오류 | 400 |
| E5 | 이메일 100자 초과 | 400 |
| E6 | 비밀번호 길이 오류 (3자) | 400 |
| E7 | 비밀번호에 허용되지 않는 문자 포함 | 400 |
| E8 | 닉네임 20자 초과 | 400 |

## E1. 필수 값 누락 (email 없음)
준비: 없음

요청
```json
{
  "password": "abcd1234",
  "nickname": "gygim"
}
```

응답 `400`
```json
{
  "status": 400,
  "message": "필수 값이 누락되었습니다."
}
```

## E2. 이미 가입된 이메일
준비: 같은 이메일로 먼저 가입

요청
```json
{
  "email": "user@example.com",
  "password": "abcd1234",
  "nickname": "gygim"
}
```

응답 `409`
```json
{
  "status": 409,
  "message": "이미 사용 중인 이메일입니다."
}
```

## E3. 이미 사용 중인 닉네임
준비: 같은 닉네임으로 다른 이메일 회원을 먼저 가입

요청
```json
{
  "email": "other@example.com",
  "password": "abcd1234",
  "nickname": "gygim"
}
```

응답 `409`
```json
{
  "status": 409,
  "message": "이미 사용 중인 닉네임입니다."
}
```

## E4. 이메일 형식 오류
준비: 없음

요청
```json
{
  "email": "not-an-email",
  "password": "abcd1234",
  "nickname": "gygim"
}
```

응답 `400`
```json
{
  "status": 400,
  "message": "이메일 형식이 올바르지 않습니다."
}
```

## E5. 이메일 100자 초과
준비: 없음

요청
```json
{
  "email": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@test.com",
  "password": "abcd1234",
  "nickname": "gygim"
}
```

응답 `400`
```json
{
  "status": 400,
  "message": "이메일은 100자 이하여야 합니다."
}
```

## E6. 비밀번호 길이 오류 (3자)
준비: 없음

요청
```json
{
  "email": "user@example.com",
  "password": "abc",
  "nickname": "gygim"
}
```

응답 `400`
```json
{
  "status": 400,
  "message": "비밀번호는 4자 이상 20자 이하여야 합니다."
}
```

## E7. 비밀번호에 허용되지 않는 문자 포함
준비: 없음

요청
```json
{
  "email": "user@example.com",
  "password": "비밀번호1234",
  "nickname": "gygim"
}
```

응답 `400`
```json
{
  "status": 400,
  "message": "비밀번호는 영문, 숫자, 특수문자만 사용할 수 있습니다."
}
```

## E8. 닉네임 20자 초과
준비: 없음

요청
```json
{
  "email": "user@example.com",
  "password": "abcd1234",
  "nickname": "nnnnnnnnnnnnnnnnnnnnn"
}
```

응답 `400`
```json
{
  "status": 400,
  "message": "닉네임은 20자 이하여야 합니다."
}
```
