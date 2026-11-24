# 회원 조회 예외 테스트
- 요청: `GET /api/members/{memberId}`

| 번호 | 상황 | 기대 status |
|---|---|---|
| E1 | 존재하지 않는 회원 | 404 |
| E2 | memberId 가 숫자가 아님 | 400 |
| E3 | memberId 가 0 이하 | 400 |

## E1. 존재하지 않는 회원
준비: 없음 (해당 ID의 회원이 없는 상태)

요청
```txt
GET /api/members/999999
```

응답 `404`
```json
{
  "status": 404,
  "message": "회원을 찾을 수 없습니다."
}
```

## E2. memberId 가 숫자가 아님
준비: 없음

요청
```txt
GET /api/members/abc
```

응답 `400`
```json
{
  "status": 400,
  "message": "회원 식별자가 올바르지 않습니다."
}
```

## E3. memberId 가 0 이하
준비: 없음

요청
```txt
GET /api/members/0
```

응답 `400`
```json
{
  "status": 400,
  "message": "회원 식별자가 올바르지 않습니다."
}
```
