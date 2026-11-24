# 회원 조회

domain: member

url: /api/members/{memberId}

method: GET

success: 200 OK

# 01. 설명

회원 식별자(ID)로 회원 한 명을 조회할 때 사용한다.

- 필수 사항: memberId
- 응답에 포함할 필드는 id, email, nickname, createdAt 이며 비밀번호는 포함하지 않는다. 결정 필요 D1
- 인증·권한 없이 호출할 수 있다. 결정 필요 D2
- 존재하지 않는 회원이면 404 를 응답한다. 결정 필요 D3
- memberId 가 양의 정수가 아니면 400 을 응답한다. 결정 필요 D4
- 탈퇴 회원 처리는 별도로 정하지 않는다(탈퇴 기능 없음). 결정 필요 D5

# 02. 요청(Request)

## a. Parameter & Querystring

```txt
/api/members/{memberId}
/api/members/1
```

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| memberId | Long | Y | 조회할 회원 식별자. 양의 정수여야 함 (결정 필요 D4) |

## b. request headers

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| 없음 | | | 인증 헤더 없음 (결정 필요 D2) |

## c. request body

없음

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| 없음 | | | |

# 03. 응답(Response)

## a. response header

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| 없음 | | | |

## b. response body

**성공 응답:** `200 OK`

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
| id | Long | Y | 회원 식별자 |
| email | String | Y | 회원 이메일 (결정 필요 D1) |
| nickname | String | Y | 회원 닉네임 (결정 필요 D1) |
| createdAt | String | Y | 회원가입 일시 (ISO-8601, 예: `2026-11-24T14:30:00`) (결정 필요 D1) |

비밀번호는 응답에 포함하지 않는다.

**에러 응답:** `404 Not Found` — 해당 ID의 회원이 없을 때 (결정 필요 D3)

```json
{
  "status": 404,
  "message": "회원을 찾을 수 없습니다."
}
```

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| status | Integer | Y | HTTP 상태 코드 |
| message | String | Y | 에러 메시지 |

**에러 응답:** `400 Bad Request` — memberId 가 숫자가 아니거나 0 이하일 때 (결정 필요 D4)

```json
{
  "status": 400,
  "message": "회원 식별자가 올바르지 않습니다."
}
```

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| status | Integer | Y | HTTP 상태 코드 |
| message | String | Y | 에러 메시지 |
