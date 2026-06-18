# 빌드 · 실행 · 테스트

대다수 레포는 **Kotlin + Spring + Gradle 멀티모듈**이다. 아래는 일반 흐름 — **실제 모듈명·태스크·프로파일·외부 의존은 그 레포의 자체 `CLAUDE.md`와 `settings.gradle.kts`를 우선 확인**한다. 레포별 차이가 크다.

## Gradle 멀티모듈

- 항상 **래퍼** 사용: `./gradlew` (43개 중 40개 보유).
- 모듈 목록·구성은 `settings.gradle.kts`.
- `application-*` 모듈 = 부트/진입점 — `application-api`(REST), `application-consumer`(Kafka), `application-cron`(스케줄러), `application-config`(설정). **도메인 로직은 그 외 도메인 모듈**에 있으니 수정은 대개 도메인 모듈에서 한다.

## 빌드 / 컴파일

```bash
cd <repo>
./gradlew :<module>:compileKotlin     # 빠른 컴파일 확인
./gradlew :<module>:build             # 컴파일 + 테스트 + 검사
./gradlew build                       # 전체 (무겁다, 지양 — 영향 모듈만 빌드)
```

## 테스트

- **unit** (`src/test`): `./gradlew :<module>:test`
- **통합** (`src/integrationTest`): `./gradlew :<module>:integrationTest`
  - testcontainers를 쓰는 레포가 많다 → **Docker 데몬이 떠 있어야** 한다.
- 특정 테스트만: `./gradlew :<module>:test --tests "team.flex.*.SomeTest"`

## 로컬 기동

진입점은 `application(-api)` 모듈의 Spring Boot `main`.

```bash
./gradlew :application-api:bootRun
```

프로파일(`-Dspring.profiles.active=...`)·환경변수·외부 의존(DB·Kafka·Redis)은 레포마다 다르다 → **자체 `CLAUDE.md` / `docker-compose*.yml` / `application-*.yml`**을 확인한다.

## DB 마이그레이션

- `changelog*` 모듈/디렉토리 = liquibase 등. 스키마 변경은 새 changelog 파일을 추가하는 식으로 한다 (기존 changelog 수정 금지).
- DDL 컨벤션·롤백 정책은 **`/backend-guidelines` 스킬**의 DB 변경 규칙을 따른다.

## 비-Kotlin 레포 (gradlew 없음)

- TS: `flex-renderer-node-backend`, `flex-web-automation-backend`
- JS: `flex-yjs-websocket-backend`

→ `package.json`의 `scripts`로 빌드·실행·테스트(`yarn`/`pnpm`/`npm`은 그 레포 lockfile 기준).
