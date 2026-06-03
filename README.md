# flex-backend-repositories

flex-team의 backend 레포지토리(`*-backend`)를 **서브모듈로 모은 개인 참고용 미러**입니다.
용도는 **디버깅 · 로직 인덱싱 · 크로스 레포 검색** 등 참고/활용이며, 빌드·배포 대상이 아닙니다.

`flex-frontend-repositories`와 동일한 모델입니다 — 부모 레포 + lazy 서브모듈 + `ignore = dirty`.

## 구조

- 부모 레포(`flex-wonkook/flex-backend-repositories`, private) 아래 43개 backend 레포를 서브모듈로 등록.
- 모든 서브모듈은 **lazy**: 등록(핀)만 되어 있고 로컬은 비어 있습니다. 필요한 것만 그때 init 합니다.
- `ignore = dirty`로 서브모듈 내부 working tree 변경은 부모 `git status`에 안 뜹니다.

## 사용

```bash
# 특정 서비스만 받기
git submodule update --init flex-payroll-backend

# 전부 받기 (디스크 많이 씀 — 40+ Kotlin 레포)
git submodule update --init

# 핀을 각 레포 default HEAD로 최신화 (clone 없이) 후 커밋
bin/refresh-pins.sh && git commit -am "chore: refresh pins"
```

> ⚠️ 참고용 미러입니다. 실제 코드 변경·PR은 **각 backend 레포 자체에서** 하세요. 여기 서브모듈 안에서 커밋하지 마세요.

## 서비스 인덱스

| 레포 | 언어 | 설명 |
|---|---|---|
| [flex-accounting-meta-backend](https://github.com/flex-team/flex-accounting-meta-backend) | Kotlin |  |
| [flex-ai-backend](https://github.com/flex-team/flex-ai-backend) | Kotlin |  |
| [flex-approval-backend](https://github.com/flex-team/flex-approval-backend) | Kotlin |  |
| [flex-audit-backend](https://github.com/flex-team/flex-audit-backend) | Kotlin |  |
| [flex-backend-gateway](https://github.com/flex-team/flex-backend-gateway) | Kotlin |  |
| [flex-billing-backend](https://github.com/flex-team/flex-billing-backend) | Kotlin |  |
| [flex-calendar-backend](https://github.com/flex-team/flex-calendar-backend) | Kotlin |  |
| [flex-cert-backend](https://github.com/flex-team/flex-cert-backend) | Kotlin | 🔏 |
| [flex-core-backend](https://github.com/flex-team/flex-core-backend) | Kotlin |  |
| [flex-customer-station-backend](https://github.com/flex-team/flex-customer-station-backend) | Kotlin | 고객사 온보딩/오프보딩 |
| [flex-data-tracker-backend](https://github.com/flex-team/flex-data-tracker-backend) | Kotlin |  |
| [flex-digicon-backend](https://github.com/flex-team/flex-digicon-backend) | Kotlin |  |
| [flex-file-storage-backend](https://github.com/flex-team/flex-file-storage-backend) | Kotlin |  |
| [flex-fins-backend](https://github.com/flex-team/flex-fins-backend) | Kotlin |  |
| [flex-flow-backend](https://github.com/flex-team/flex-flow-backend) | Kotlin |  |
| [flex-goal-backend](https://github.com/flex-team/flex-goal-backend) | Kotlin |  |
| [flex-growth-backend](https://github.com/flex-team/flex-growth-backend) | Kotlin | AB 테스트, 서베이, 데모 등 어플리케이션의 Activation 요소를 구현합니다. |
| [flex-impact-backend](https://github.com/flex-team/flex-impact-backend) | Kotlin |  |
| [flex-insight-backend](https://github.com/flex-team/flex-insight-backend) | Kotlin |  |
| [flex-knowledge-backend](https://github.com/flex-team/flex-knowledge-backend) | Kotlin |  |
| [flex-marvel-backend](https://github.com/flex-team/flex-marvel-backend) | Kotlin |  |
| [flex-marvel-clockwork-backend](https://github.com/flex-team/flex-marvel-clockwork-backend) | Kotlin |  |
| [flex-openapi-backend](https://github.com/flex-team/flex-openapi-backend) | Kotlin |  |
| [flex-pavement-backend](https://github.com/flex-team/flex-pavement-backend) | Kotlin |  |
| [flex-payment-backend](https://github.com/flex-team/flex-payment-backend) | Kotlin |  |
| [flex-payroll-backend](https://github.com/flex-team/flex-payroll-backend) | Kotlin | 멋진 신세계 |
| [flex-permission-backend](https://github.com/flex-team/flex-permission-backend) | Kotlin |  |
| [flex-pop-backend](https://github.com/flex-team/flex-pop-backend) | Kotlin |  |
| [flex-recruiting-backend](https://github.com/flex-team/flex-recruiting-backend) | Kotlin |  |
| [flex-renderer-node-backend](https://github.com/flex-team/flex-renderer-node-backend) | TypeScript |  |
| [flex-review-backend](https://github.com/flex-team/flex-review-backend) | Kotlin |  |
| [flex-selfservice-backend](https://github.com/flex-team/flex-selfservice-backend) | Kotlin |  |
| [flex-timetracking-backend](https://github.com/flex-team/flex-timetracking-backend) | Kotlin | 땅땅치킨 |
| [flex-user-group-backend](https://github.com/flex-team/flex-user-group-backend) | Kotlin |  |
| [flex-v2-backend-commons](https://github.com/flex-team/flex-v2-backend-commons) | Kotlin |  |
| [flex-web-automation-backend](https://github.com/flex-team/flex-web-automation-backend) | TypeScript | flex 웹 자동화 백엔드 |
| [flex-work-event-transmitter-backend](https://github.com/flex-team/flex-work-event-transmitter-backend) | Kotlin |  |
| [flex-workflow-engine-backend](https://github.com/flex-team/flex-workflow-engine-backend) | Kotlin |  |
| [flex-yearend-backend](https://github.com/flex-team/flex-yearend-backend) | Kotlin | 눈이 오네 |
| [flex-yjs-websocket-backend](https://github.com/flex-team/flex-yjs-websocket-backend) | JavaScript |  |
| [leaf-backend](https://github.com/flex-team/leaf-backend) | Kotlin | 🍃 |
| [leaf-backend-gateway](https://github.com/flex-team/leaf-backend-gateway) | Kotlin |  |
| [personal-account-backend](https://github.com/flex-team/personal-account-backend) | Kotlin |  |
