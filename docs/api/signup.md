# 회원가입

domain: member

url: /api/members

method: POST

success: 201 Created

# 01. 설명

이메일, 비밀번호, 닉네임으로 회원으로 가입할 때 사용한다.

- 필수 사항: 이메일, 비밀번호, 닉네임
- 이메일은 중복될 수 없다.
- 비밀번호 규칙 `결정 필요 D1`, 닉네임 중복 `결정 필요 D2`, 이메일 형식 검증 `결정 필요 D3`, 길이 제한 `결정 필요 D4`, 이메일 대소문자 `결정 필요 D5`, 비밀번호 저장 방식 `결정 필요 D6`, 응답 필드 `결정 필요 D7`

# 02. 요청(Request)

## a. Parameter & Querystring

```txt
/api/members
```

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| 없음 | | | |

## b. request headers

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| Content-Type | String | Y | `application/json` |

## c. request body

```json
{
  "email": "user@example.com",
  "password": "abcd1234",
  "nickname": "gygim"
}
```

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| email | String | Y | 가입할 이메일. 중복 불가. 형식 검증 `결정 필요 D3`, 길이 `결정 필요 D4`, 대소문자 `결정 필요 D5` |
| password | String | Y | 비밀번호. 규칙 `결정 필요 D1`, 저장 방식 `결정 필요 D6` |
| nickname | String | Y | 닉네임. 중복 허용 여부 `결정 필요 D2`, 길이 `결정 필요 D4` |

# 03. 응답(Response)

## a. response header

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| 없음 | | | |

## b. response body

**성공 응답:** `201 Created`

```json
{
  "id": 1,
  "email": "user@example.com",
  "nickname": "gygim"
}
```

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| id | Long | Y | 가입된 회원 식별자 |
| email | String | Y | 가입한 이메일 |
| nickname | String | Y | 가입한 닉네임 |

비밀번호는 응답에 포함하지 않는다. 응답 필드 범위 `결정 필요 D7`

**에러 응답:** `400 Bad Request` — 필수 값(email, password, nickname)이 없거나 비어 있을 때

```json
{
  "status": 400,
  "message": "필수 값이 누락되었습니다."
}
```

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| status | Integer | Y | HTTP 상태 코드 |
| message | String | Y | 에러 메시지 |

**에러 응답:** `409 Conflict` — 이미 가입된 이메일일 때

```json
{
  "status": 409,
  "message": "이미 사용 중인 이메일입니다."
}
```

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| status | Integer | Y | HTTP 상태 코드 |
| message | String | Y | 에러 메시지 |
