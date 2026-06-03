# flex-backend-repositories

flex-team의 backend 레포지토리(`*-backend`)를 서브모듈로 모은 **개인 참고용 미러**다. 용도는 디버깅·로직 인덱싱·크로스 레포 검색 등 참고/활용이며, **빌드·배포 대상이 아니다**. `flex-frontend-repositories`와 동일한 모델(부모 레포 + lazy 서브모듈 + `ignore = dirty`).

## 구조

- 부모 레포(`flex-wonkook/flex-backend-repositories`, private) 아래 backend 레포를 서브모듈로 등록.
- 모든 서브모듈은 **lazy**: 등록(핀)만 되어 있고 로컬은 비어 있다. 탐색/디버깅 시점에 필요한 것만 init.
- `ignore = dirty`라 서브모듈 내부 변경은 부모 `git status`에 안 뜬다.
- 서비스 목록·설명은 [`README.md`](./README.md).

## 사용

- 특정 서비스 받기: `git submodule update --init <path>` (예: `flex-payroll-backend`)
- 전부 받기: `git submodule update --init` (디스크 많이 씀 — 40+ Kotlin 레포)
- 핀 최신화(clone 없이 default HEAD로): `bin/refresh-pins.sh` 후 commit
- 이미 init된 서브모듈 최신화: 해당 디렉토리에서 직접 `git pull`

## 주의

- **참고용 미러다.** 실제 코드 변경·PR은 각 backend 레포 자체에서 한다. 여기 서브모듈 안에서 커밋하지 말 것.
- 대부분 Kotlin/Spring 서비스다. 도메인 경계는 레포 이름으로 대체로 식별된다 (payroll/yearend/fins/timetracking/approval/recruiting/insight/permission/core 등).
