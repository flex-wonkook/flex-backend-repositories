# flex-backend-repositories

flex-team의 backend 레포지토리(`*-backend`, 43개)를 서브모듈로 모은 **개인 참고용 미러**다.
용도는 **디버깅 · 로직 인덱싱 · 크로스 레포 검색/참고**이며, **빌드·배포 대상이 아니다**.
`flex-frontend-repositories`와 동일한 모델(부모 레포 + 서브모듈 + `ignore = dirty`).

## 리서치 시작 순서 (중요)

1. **이 파일**로 전체 구조·규약·용어를 잡는다.
2. **[`.claude/rules/routing.md`](.claude/rules/routing.md)** 로 "이 질문/도메인 → 어느 backend 레포"를 정한다.
3. 대상 레포 디렉토리의 **자체 `CLAUDE.md`를 먼저 읽는다** (대부분 보유, 모듈 구조·실행법이 정확하게 적혀 있음).
4. `rg`로 검색한다 (아래 검색 가이드).

## 구조

- 43개 backend 레포가 서브모듈로 등록(핀)되어 있고, 현재 **전부 init/clone된 상태**(약 2.8G).
- `ignore = dirty`라 서브모듈 내부 변경은 부모 `git status`에 안 뜬다.
- 새 머신에서 받을 때: `git submodule update --init`(전부) 또는 `git submodule update --init <path>`(선택).

## 코드 규약 (거의 모든 레포 공통)

- **Kotlin + Spring, Gradle 멀티모듈** (`settings.gradle.kts`). TS: `flex-renderer-node-backend`·`flex-web-automation-backend`, JS: `flex-yjs-websocket-backend`.
- 패키지 루트: **`team.flex.*`**, 소스는 `**/src/main/kotlin/team/flex/...`.
- **도메인 = 최상위 모듈 디렉토리.** 예) `flex-payroll-backend/`에 `work-income`, `withholding-tax`, `social-insurance`, `severance-income`, `allowance`, `payee` ... 각 도메인 모듈이 평면으로 존재.
- `application-*` 모듈(`application`, `application-api`, `application-consumer`, `application-cron`, `application-config`)은 **부트/진입점**(REST API, Kafka consumer, 스케줄러, 설정). 도메인 로직은 그 외 모듈에 있다.
- `changelog*` 모듈/디렉토리 = **DB 마이그레이션**(liquibase 등).
- 테스트: `src/test`(unit), `src/integrationTest`(통합, testcontainers 사용하는 레포 다수).

## 검색 가이드

- `rg`(ripgrep) 설치됨. **각 서브모듈의 `.gitignore`를 존중**하므로 빌드해도 `build/`·`.gradle/`는 자동 제외된다.
- 특정 도메인부터 좁혀서: `rg "fixedOverWork" flex-payroll-backend flex-yearend-backend`
- 심볼 정의 위주: `rg -t kotlin "class .*Service|fun .*\(" <repo>/<module>`
- API 엔드포인트: `rg -t kotlin "@(Get|Post|Put|Delete)Mapping|@RequestMapping" <repo>`
- 이벤트/카프카: `rg -t kotlin "@KafkaListener|EventProducer|topic" <repo>`
- 전체 fan-out이 필요하면 모든 레포 대상으로 rg를 돌리되, 먼저 routing.md로 후보를 2~3개로 줄이는 게 빠르다.

## 도메인 용어집 (한국어 ↔ 코드)

| 한국어 | 코드/영문 | 주 위치 |
|---|---|---|
| (급여)정산 | settlement | flex-payroll-backend `work-income` |
| 연말정산 | year-end settlement | flex-yearend-backend |
| 중도정산 | interim settlement | flex-payroll/yearend |
| 고정초과근무수당(고초수) | fixedOverWork(PaymentAllowance) | flex-payroll-backend `allowance`/`work-income` |
| 귀속연월 | belongedYearMonth | payroll/yearend |
| 원천징수/원천세 | withholding(Tax) | flex-payroll-backend `withholding-tax` |
| 지급/공제 | payment / deduction | payroll |
| 비과세 | nonTaxable | payroll |
| 사회보험(4대보험) | socialInsurance | flex-payroll-backend `social-insurance` |
| 급여명세서 | payslip / paySlip | payroll + flex-renderer-node-backend |
| 인사발령 | personnelAppointment | flex-core-backend `appointment` |
| 구성원/조직 | user / department | flex-core-backend, flex-user-group-backend |
| 전자결재/승인 | approval | flex-approval-backend, flex-workflow-engine-backend |
| 근태/근무 | timeTracking / workEvent | flex-timetracking-backend |
| 휴가 | timeOff / leave | flex-timetracking-backend |
| 비용관리 | fins / expense | flex-fins-backend |

## 유지보수

- init된 서브모듈 전부 최신화: `bin/pull-all.sh`
- 부모 핀을 각 레포 default HEAD로 갱신(clone 없이): `bin/refresh-pins.sh` 후 commit

## 주의

- **참고용 미러다.** 실제 코드 변경·PR은 각 backend 레포 자체에서 한다. 여기 서브모듈 안에서 커밋하지 말 것.
