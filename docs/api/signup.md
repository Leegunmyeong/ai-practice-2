# 회원가입

domain: member

url: /api/members

method: POST

# 01. 설명

이메일, 비밀번호, 닉네임으로 신규 회원을 가입시킨다.

- 필수 사항: 이메일, 비밀번호, 닉네임
- 이메일은 중복될 수 없다.
- 이메일 형식·길이, 비밀번호 규칙, 닉네임 규칙과 중복 여부는 결정 필요 (D1 ~ D5, `docs/decisions/회원가입.md` 참고)

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
| email | String | Y | 가입할 이메일. 중복 불가. 형식·길이·대소문자 처리 결정 필요 D1 |
| password | String | Y | 비밀번호. 규칙(길이·문자 조합) 결정 필요 D2 |
| nickname | String | Y | 닉네임. 길이·허용 문자 결정 필요 D3, 중복 허용 여부 결정 필요 D4 |

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
| id | Long | Y | 가입된 회원 식별자. 응답 필드 구성 결정 필요 D6 |
| email | String | Y | 가입된 이메일. 비밀번호는 응답에 포함하지 않는다. |
| nickname | String | Y | 가입된 닉네임 |

**에러 응답:** `409 Conflict` — 이미 가입된 이메일일 때

```json
{
  "code": "DUPLICATE_EMAIL",
  "message": "이미 사용 중인 이메일입니다."
}
```

| 이름 | 데이터타입 | 필수 | 설명 |
|---|---|---|---|
| code | String | Y | 에러 코드 |
| message | String | Y | 에러 메시지 |

**에러 응답:** 필수값 누락·형식 오류 등 입력값 검증 실패 — 상태 코드와 에러 코드 결정 필요 D5 (명세 미확정, 예외 테스트 제외)
