# flex-backend-repositories

flex-team의 backend 레포지토리(`*-backend`, 43개)를 서브모듈로 묶은 **작업용 워크스페이스**다.
디버깅·로직 인덱싱·크로스 레포 검색은 물론, **각 submodule에서 직접 코드를 고치고 PR을 올리는 작업**까지 여기서 한다.
`flex-frontend-repositories`와 동일한 모델 — 부모 레포 + 서브모듈(`ignore = dirty`), **worktree 기반 작업 → submodule PR**.

## 개발 규칙

설계·코드 작성·리팩터링은 **`/backend-guidelines` 스킬**의 규칙(멀티모듈 헥사고날 구조, 모듈 책임, DB 변경 컨벤션, 빌드 스크립트 정책, 테스트 원칙)을 따른다. 새 도메인 모듈 생성·모듈 경계 결정·liquibase DDL 추가·큰 리팩터링 전에는 그 스킬을 먼저 읽는다.

규칙을 만족하지 못하는 방향이 발견되면 사용자에게 보고한다.

## 작업 시작 순서 (중요)

1. **이 파일**로 전체 구조·규약·용어를 잡는다.
2. **[`.claude/rules/routing.md`](.claude/rules/routing.md)** 로 "이 질문/도메인 → 어느 backend 레포"를 정한다.
3. 대상 레포 디렉토리의 **자체 `CLAUDE.md`를 먼저 읽는다** (대부분 보유, 모듈 구조·실행법이 정확하게 적혀 있음).
4. `rg`로 검색한다 (아래 검색 가이드).
5. 코드를 고친다면 [`아래 작업 → PR`](#작업--pr) 흐름으로 worktree에 격리해 진행한다.

## 작업 라우팅

- 결정 표: [`.claude/rules/routing.md`](.claude/rules/routing.md) — "질문/도메인 → 어느 레포·모듈"
- 빌드·실행·테스트: [`.claude/rules/dev.md`](.claude/rules/dev.md) — gradle 멀티모듈, application-* 진입점, 통합 테스트
- PR 규약: [`.claude/rules/pr.md`](.claude/rules/pr.md) — draft PR, conventional commits, 검증, 커밋 정리

## 구조

- 43개 backend 레포가 서브모듈로 등록(핀)되어 있고, 현재 **전부 init/clone된 상태**(약 2.8G).
- `ignore = dirty`라 서브모듈 내부의 working tree 변경은 부모 `git status`에 안 뜬다.
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

## 부모 레포 동기화

이 부모 레포에는 frontend 쪽 같은 cron sync 자동화가 **없다.** 수동 스크립트로 정렬한다.

- init된 서브모듈 전부 default branch 최신으로: `bin/pull-all.sh` (로컬 변경/비-fast-forward는 건너뛰고 보존)
- 부모 핀을 각 레포 default HEAD로 갱신(clone 없이): `bin/refresh-pins.sh` 후 commit

부모 레포(`flex-backend-repositories`) 자체의 변경(`.claude/`, `bin/`, `.gitmodules`, 핀 등)은 **PR 없이 `main`에 직접 커밋·push** 한다. 실제 도메인 코드 변경은 submodule 레포에 PR로 올린다 (아래).

## 작업 → PR

**트리거**: 새 작업 요청을 받을 때마다 아래 흐름을 자동 수행한다. 다른 도메인·submodule·이슈 언급, 현재 worktree 주제와 무관한 신규 요청, "새 작업/다른 거" 명시 중 하나라도면 **새 작업** — 처음부터 새 worktree로 격리한다. 애매하면 연장으로 본다.

### 1. 동기화

작업 전 대상 submodule을 default branch 최신으로 맞춘다.

```bash
bin/pull-all.sh                       # 전체 init된 서브모듈 ff 정렬
# 또는 대상만:  git -C <sub> fetch origin && git -C <sub> checkout <default> && git -C <sub> pull --ff-only
```

### 2. worktree 진입

worktree는 **부모 레포 전체가 아니라 작업이 닿는 submodule 한 개**에 만든다. [`routing.md`](.claude/rules/routing.md)로 대상 submodule `<sub>`를 확정하고 그 디렉토리에서 진입한다.

1. `<sub>` 확정 (init 안 됐으면 `git submodule update --init <sub>`).
2. base branch 확인 — 그 submodule의 default branch. 대개 `develop`(43개 중 39개), 일부 `main`:
   ```bash
   git -C <sub> symbolic-ref --short refs/remotes/origin/HEAD   # 예) origin/develop
   ```
3. worktree 생성 — `<sub>` 기준으로 `EnterWorktree` 호출.
   - `EnterWorktree`가 세션 cwd(부모 레포)를 잡아 submodule을 못 짚으면 **수동 생성**:
     ```bash
     cd <sub> && git worktree add .claude/worktrees/<ticket> -b feature/<ticket> origin/<default>
     ```
   - ⚠️ **submodule 본체 체크아웃에서 직접 feature 작업하지 않는다.** `bin/pull-all.sh`가 본체를 default branch로 checkout/ff 정렬하므로, 본체에 올려둔 feature 브랜치 팁이 분실·혼동될 수 있다. 작업은 worktree에 격리한다.
4. worktree 디렉토리에서 작업 → push 후 `ExitWorktree`(`action: keep`).

### 3. Push & PR

push 전 검증·PR 생성 규칙은 [`pr.md`](.claude/rules/pr.md). PR은 **submodule 레포**에 만든다(base = 그 submodule의 default branch). 부모 레포는 PR 없이 `main`에 직접 push.
