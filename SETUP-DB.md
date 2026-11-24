# DB 세팅 가이드

> 팀이 방식 하나를 골라 프로젝트 시작 때 한 번 적용한다. **우리 팀 기본값: D. Docker MySQL**
> 예시 이름은 `ai_practice` / 컨테이너 `ai-practice-mysql`. 프로젝트 이름에 맞게 바꾼다.

## 방식 비교

| | D. Docker MySQL (기본) | B. PC 설치 MySQL | C. MySQL + 테스트 H2 | A. H2만 |
|---|---|---|---|---|
| 추천 | 팀 프로젝트 | Docker 를 못 쓸 때 | CI 테스트를 빠르게 | 연습 |
| 준비물 | Docker Desktop | MySQL 설치 | MySQL | 없음 |
| 팀원마다 버전 같음 | ✅ | ❌ | ❌ | ✅ |
| 테스트 전에 DB 켜기 | 필요 | 필요 | 불필요 | 불필요 |
| GitHub Actions 테스트 | MySQL 서비스 필요 | MySQL 서비스 필요 | 그대로 됨 | 그대로 됨 |

## 공통 파일 구조

```
.env                                  ← 내 비밀번호 (커밋 금지)
.env.example                          ← 양식 (커밋)
src/main/resources/application.yml         ← 공통: .env 읽기 + 기본 프로필
src/main/resources/application-local.yml   ← 내 PC 실행용
src/main/resources/application-prod.yml    ← 배포(AWS)용
src/test/resources/application.yml         ← 테스트용 (main 쪽 application.yml 을 통째로 대신함)
```

`src/main/resources/application.yml` (모든 방식 공통)
```yaml
spring:
  config:
    import: optional:file:.env[.properties]
  profiles:
    active: local
```

---

## D. Docker MySQL (우리 팀 기본)

**1. 처음 한 번: 컨테이너 만들기** (강의 4-2 방식, 비밀번호는 `.env` 와 같게)
```bash
docker run -d -p 3307:3306 --name ai-practice-mysql -e MYSQL_ROOT_PASSWORD=<비밀번호> -e MYSQL_DATABASE=ai_practice mysql:8
```
10초 뒤 테스트용 DB 추가:
```bash
docker exec ai-practice-mysql sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS ai_practice_test; SHOW DATABASES;"'
```
- 포트 3307: PC 에 설치된 MySQL(3306)과 충돌하지 않게 한다.
- 비밀번호는 처음 `run` 할 때만 정해진다. 바꾸려면 `docker rm -f ai-practice-mysql` 후 다시 만든다 (데이터 삭제됨).

**2. 매일**
| 하고 싶은 것 | 명령 (또는 Docker Desktop 버튼) |
|---|---|
| 켜기 | `docker start ai-practice-mysql` (▶) |
| 끄기 | `docker stop ai-practice-mysql` (■) — 데이터 유지 |
| 확인 | `docker ps` (초록 점) |
| 로그 | `docker logs ai-practice-mysql` |

**3. `.env`**
```properties
DB_USERNAME=root
DB_PASSWORD=<컨테이너 만들 때 쓴 비밀번호>
```

**4. `application-local.yml`**
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3307/ai_practice
    username: ${DB_USERNAME:root}
    password: ${DB_PASSWORD}
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
```

**5. `src/test/resources/application.yml`**
```yaml
spring:
  config:
    import: optional:file:.env[.properties]
  datasource:
    url: jdbc:mysql://localhost:3307/ai_practice_test
    username: ${DB_USERNAME:root}
    password: ${DB_PASSWORD}
  jpa:
    hibernate:
      ddl-auto: create-drop
```

**6. IntelliJ Database 창**: Host `localhost`, Port `3307`, User `root`, Password `.env` 값. DB 가 안 보이면 `@localhost` 옆 `n of n` → All schemas.

---

## B. PC 설치 MySQL

D 와 같고 다음만 다르다.
- 컨테이너 대신 MySQL 에서 `CREATE DATABASE ai_practice; CREATE DATABASE ai_practice_test;`
- URL 포트 `3306`
- 서비스(`services.msc` → MySQL80)가 실행 중이어야 한다.

## C. MySQL(실행) + H2(테스트)

`build.gradle` 에 `testRuntimeOnly 'com.h2database:h2'`. main 쪽은 D 또는 B 와 같고, 테스트 파일만:
```yaml
spring:
  datasource:
    url: jdbc:h2:mem:testdb;MODE=MySQL
    driver-class-name: org.h2.Driver
  jpa:
    hibernate:
      ddl-auto: create-drop
```
주의: MySQL 전용 문법(네이티브 쿼리 등)은 H2 에서 다르게 동작할 수 있다.

## A. H2만

`runtimeOnly 'com.h2database:h2'`, `.env` 불필요. `application.yml`:
```yaml
spring:
  datasource:
    url: jdbc:h2:mem:devdb;MODE=MySQL
  h2:
    console:
      enabled: true
  jpa:
    hibernate:
      ddl-auto: create-drop
```

---

## prod (AWS 배포)

`src/main/resources/application-prod.yml` — 값은 전부 서버 환경변수로 받는다. 파일에 실제 값을 쓰지 않는다.
```yaml
spring:
  datasource:
    url: ${DB_URL}              # jdbc:mysql://<RDS 또는 EC2 주소>:3306/ai_practice
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}
  jpa:
    hibernate:
      ddl-auto: none            # 운영 테이블은 JPA 가 건드리지 않는다
    show-sql: false
```
서버에서 실행 (강의 4-2 의 `-e` 환경변수 주입 방식):
```bash
docker run -d -p 8080:8080 --name my-app \
  -e SPRING_PROFILES_ACTIVE=prod \
  -e DB_URL=jdbc:mysql://<주소>:3306/ai_practice \
  -e DB_USERNAME=<계정> \
  -e DB_PASSWORD=<비밀번호> \
  <이미지>:<태그>
```
- 로컬·테스트에서 운영 DB 에 접속하지 않는다 (`create-drop` 이 운영 테이블을 지울 수 있다).
- AWS MySQL 버전과 로컬 Docker 버전을 맞춘다 (`mysql:8` → 필요하면 `mysql:8.0.xx`).

---

## 비밀번호 관리 규칙

| 어디 | 무엇을 | 어떻게 |
|---|---|---|
| 내 PC | 로컬 DB 비밀번호 | `.env` (git 제외). 팀원마다 달라도 된다 |
| 레포 | 양식만 | `.env.example` 에 키 이름만, 값은 비움 |
| GitHub Actions | API 키, 토큰 | Settings → Secrets and variables → Actions |
| AWS 서버 | 운영 DB 계정 | 서버 환경변수(`docker run -e`). 담당자만 안다 |

- 비밀번호를 코드, yml, 커밋 메시지, PR, 채팅방, 스크린샷에 남기지 않는다.
- 실수로 커밋했으면: `git rm --cached .env` 후 커밋하고, **비밀번호를 바꾼다** (기록에 남기 때문).
- Claude 는 `.env` 를 읽지 못하게 막혀 있다 (`.claude/settings.json` deny).

## 문제 해결

| 증상 | 원인 → 해결 |
|---|---|
| `Connection refused` | DB 가 꺼져 있음 → `docker start ...` 또는 MySQL 서비스 시작 |
| `Access denied (using password: YES)` | 비밀번호 불일치, 또는 테스트 yml 에 `config.import` 누락 |
| `Unknown database` | 테스트용 DB 를 안 만듦 → D-1 의 `docker exec` |
| `Unable to determine Dialect` | 위 셋 중 하나. `./gradlew test --info \| grep -i "denied\|refused\|unknown"` |
| `port is already allocated` | 3307 을 다른 프로그램이 사용 중 → `docker ps -a` 로 확인 |
