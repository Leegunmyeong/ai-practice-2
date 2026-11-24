# 회원가입

domain: member

url: /api/members

method: POST

success: 201 Created

# 01. 설명

이메일, 비밀번호, 닉네임으로 회원으로 가입할 때 사용한다.

- 필수 사항: 이메일, 비밀번호, 닉네임
- 이메일은 중복될 수 없다. 대소문자를 구분하지 않으며 소문자로 저장한다. (D5)
- 닉네임도 중복될 수 없다. (D2)
- 이메일은 형식을 검증하며, 최대 100자이다. (D3, D4)
- 비밀번호는 4자 이상 20자 이하이며 영문, 숫자, 특수문자를 사용할 수 있다. (D1)
- 닉네임은 최대 20자이다. 초과하면 검증 실패로 처리한다. (D4)
- 비밀번호 저장 방식: `결정 필요 D6`

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
| email | String | Y | 가입할 이메일. 중복 불가. 이메일 형식이어야 하며 최대 100자. 대소문자 구분 안 함(소문자로 저장) |
| password | String | Y | 비밀번호. 4~20자, 영문·숫자·특수문자 사용 가능. 저장 방식 `결정 필요 D6` |
| nickname | String | Y | 닉네임. 중복 불가. 최대 20자 |

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
  "nickname": "gygim",
  "createdAt": "2026-11-24T14:30:00"
}
```

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| id | Long | Y | 가입된 회원 식별자 |
| email | String | Y | 가입한 이메일 |
| nickname | String | Y | 가입한 닉네임 |
| createdAt | String | Y | 회원가입 일시 (ISO-8601, 예: `2026-11-24T14:30:00`) |

비밀번호는 응답에 포함하지 않는다.

**에러 응답:** `400 Bad Request` — 필수 값(email, password, nickname)이 없거나 비어 있을 때 (메시지는 아래 검증 실패 목록 참고)

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

**에러 응답:** `409 Conflict` — 이미 사용 중인 닉네임일 때

```json
{
  "status": 409,
  "message": "이미 사용 중인 닉네임입니다."
}
```

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| status | Integer | Y | HTTP 상태 코드 |
| message | String | Y | 에러 메시지 |

**에러 응답:** `400 Bad Request` — 검증 실패. 상황별 message 는 다음과 같다. 응답 형식은 위 400 과 같다.

| 상황 | message |
|---|---|
| 이메일 형식이 올바르지 않음 | 이메일 형식이 올바르지 않습니다. |
| 이메일이 100자 초과 | 이메일은 100자 이하여야 합니다. |
| 비밀번호가 4자 미만 또는 20자 초과 | 비밀번호는 4자 이상 20자 이하여야 합니다. |
| 비밀번호에 영문·숫자·특수문자 외 문자 포함 | 비밀번호는 영문, 숫자, 특수문자만 사용할 수 있습니다. |
| 닉네임이 20자 초과 | 닉네임은 20자 이하여야 합니다. |
