# PR

submodule 레포에 PR을 만들 때 따르는 규칙. 부모 레포(`flex-backend-repositories`)는 sync 자동화가 없으므로 PR을 만들지 않고 `main`에 직접 커밋·push 한다 — 단, 부모 커밋에도 아래 메시지 규칙은 동일하게 적용한다.

## base — submodule의 default branch

backend 레포는 default branch가 **대개 `develop`**(43개 중 39개), 일부 `main`(4개)이다. 하드코딩하지 말고 확인한다.

```bash
git symbolic-ref --short refs/remotes/origin/HEAD   # 예) origin/develop
```

## 항상 draft로 시작

```bash
gh pr create --base <default-branch> --draft
```

사용자가 명시적으로 ready를 요청하면 예외.

## 메시지 — Conventional Commits

PR 제목 = squash 후 커밋 메시지. 같은 형식을 커밋 메시지에도 사용한다.

```
<type>(<scope>): <subject>

# submodule PR
feat(work-income): 고초수 정산 로직 추가
fix(withholding-tax): 원천세 계산 반올림 오류 수정

# 부모 레포 커밋
docs(.): CLAUDE.md 다듬기
chore(submodules): 서브모듈 핀 갱신
```

### type
`feat` / `fix` / `refactor` / `test` / `build` / `ci` / `docs` / `perf` / `chore`

### scope
- **submodule 레포**: 작업한 **도메인 모듈명** (`work-income`, `withholding-tax`, `appointment`, `time-tracking`, ...). 모듈이 모호하면 도메인 약칭(`payroll`, `core`).
- **부모 레포** (`flex-backend-repositories`):
  - `.` — 루트·전체 (README, .gitignore 등)
  - `claude` — `.claude/` 변경 (규칙/라우팅/설정)
  - `submodules` — `.gitmodules` 또는 submodule 핀 변경

### subject
- 한국어 / 영어 일관성 있게
- 명령형 / 현재형 (`추가` / `정리` / `제거`)
- 마침표 없이

## 본문 구조

```markdown
## AS-IS
변경 전 상태·문제.

## TO-BE
변경 후 상태·해결.

## Test plan
- [ ] 시나리오 1
- [ ] 시나리오 2
```

- **AS-IS / TO-BE**는 리뷰어가 의도를 빠르게 잡게 한다 (필수).
- **Test plan**은 reviewer가 확인할 시나리오 — 셀프 리뷰 흔적.

## 분량 — 500L 이내 지향

PR 본체 +/- 합산 **500L 이내**. 넘어가면 분리 검토.
예외: 자동 생성 코드, 일괄 rename/포맷팅, lockfile, changelog 대량 추가.

## Push 전 검증 (필수)

영향 모듈에 대해 0 errors:

```bash
./gradlew :<module>:build        # compileKotlin + test + 검사
```

- 컴파일·테스트는 필수. warnings 허용, errors는 0.
- 통합 테스트(`integrationTest`)는 Docker가 필요하고 느리니, 변경이 통합 영역에 닿을 때 실행한다.
- 비-Kotlin 레포는 `package.json` scripts(예: `yarn lint && yarn test`)로 검증.
- 실패하면 push 금지. CI에 미루지 않는다. 사용자가 "건너뛰어"라고 명시한 경우만 예외.

## 리뷰 / 머지

- **최소 1명 승인** 후 squash merge.
- 코드 오너 자동 할당: 각 submodule `.github/CODEOWNERS`.

## 커밋 정리 전략

### 단위 — 리뷰어가 읽기 쉽게

한 커밋 = **한 가지 변경 의도**. 위에서부터 차례로 읽으면 자연스럽게 이해되도록 쪼갠다.

좋은 분리 기준:
- **기능 vs 리팩터링 vs 포맷팅 분리**
- **준비 → 본체 → 후속** 순서 (보일러플레이트·rename·signature 먼저, 핵심 가운데, 사용처·테스트 뒤로)
- **레이어별 분리가 자연스러우면 분리** — domain/entity → service → application(API/consumer)
- **changelog(DDL)는 별도 커밋**으로 분리
- **revert 단위로 의미가 있게**

피할 패턴: "wip"/"fix"/"리뷰 반영" 같은 무의미 메시지, 같은 파일을 여러 커밋에서 왔다갔다, 한 커밋에 무관한 변경 다수, 컴파일 안 되는 중간 상태.

### 단계별 정책

| 단계 | 정책 |
|---|---|
| **Draft 단계** | force push로 커밋 정리 OK (rebase/squash/amend). push 전 `git log --oneline` 확인 → rebase 계획 제안 → 사용자 승인 후 실행 |
| **Ready 이후 / 리뷰 반영** | **새 커밋만**. amend + force push 금지 — 리뷰어 이력 추적 보호 |

`--no-verify`, `--no-gpg-sign` 등 hook/서명 우회는 사용자 명시 지시 외엔 금지.
