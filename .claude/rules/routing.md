# Backend 라우팅 가이드

"어떤 질문/디버깅이 들어왔을 때 어느 backend 레포를 봐야 하는지" 결정하기 위한 표다.
도메인이 애매하면 후보 레포의 자체 `CLAUDE.md`와 최상위 모듈 디렉토리명을 먼저 확인한다.

> 표기: **FE** = 대응하는 frontend 레포(`flex-frontend-repositories` 기준).

## 1. 도메인 서비스

| 도메인 / 질문 | backend 레포 | FE 대응 |
|---|---|---|
| 급여 계산·정산(2/4단계)·지급·공제·원천세·고초수·사회보험·급여명세서 | **flex-payroll-backend** | apps-payroll |
| 연말정산·중도정산 | **flex-yearend-backend** | apps-payroll(year-end-settlement) |
| 인사·조직·구성원·인사발령·부서·체크리스트 | **flex-core-backend** | apps-people, core-* |
| 사용자 그룹/조직 그룹 | flex-user-group-backend | apps-people |
| 근태·근무·휴가·근무이벤트 | **flex-timetracking-backend** | apps-time-tracking |
| 근무 이벤트 전송(transmitter) | flex-work-event-transmitter-backend | apps-time-tracking |
| 비용관리(Fins) | **flex-fins-backend** | apps-fins |
| 회계 메타데이터(계정과목 등) | flex-accounting-meta-backend | apps-fins |
| 전자결재·승인 | **flex-approval-backend** | apps-workflow |
| 워크플로 엔진(승인 흐름 실행) | flex-workflow-engine-backend | apps-workflow |
| 플로우/정책(approval-document 등) | flex-flow-backend | apps-workflow / pop |
| POP 정책·플로우 엔진 | flex-pop-backend | flex-frontend-pop, fins automation |
| 채용 | flex-recruiting-backend | apps-recruiting |
| 성과 Goal | flex-goal-backend | apps-performance-management(goal) |
| 성과 Review/피드백 | flex-review-backend | apps-performance-management(review), one-on-one |
| 분석·리포트·인사이트 | flex-insight-backend | apps-insight |
| AI(Corporate Brain) | flex-ai-backend | apps-brain |
| 지식/위키(knowledge) | flex-knowledge-backend | apps-brain(custom-page) |
| 디지콘(디지털 컨텐츠/서명) | flex-digicon-backend | apps-digicon |
| 캘린더 | flex-calendar-backend | — |
| 셀프서비스 포털(비구성원) | flex-selfservice-backend | apps-selfservice |
| 고객사 온보딩/오프보딩 | flex-customer-station-backend | — |
| 그로스(AB테스트·서베이·analytics·Activation) | flex-growth-backend | — |
| Leaf 제품 | leaf-backend (+ leaf-backend-gateway) | apps-leaf |
| 개인 계정(비법인) | personal-account-backend | apps-selfservice |

## 2. 인증/권한/보안

| 영역 | 레포 |
|---|---|
| 권한·접근제어 | flex-permission-backend |
| 인증서·전자서명(PKI, JCE, sign) | flex-cert-backend |
| 감사 로그(audit) | flex-audit-backend |

## 3. 플랫폼 / 인프라 / 횡단

| 영역 | 레포 |
|---|---|
| 공통 라이브러리(shared) | **flex-v2-backend-commons** |
| API 게이트웨이(본체) | flex-backend-gateway |
| 외부 OpenAPI / 시스템 통합 | flex-openapi-backend |
| 결제(PG / payment-gateway) | flex-payment-backend |
| 빌링/구독(SaaS billing) | flex-billing-backend |
| 파일 스토리지 | flex-file-storage-backend |
| 이벤트/행동 트래킹(Amplitude 파이프라인) | flex-data-tracker-backend |
| 렌더러(PDF/HTML/CRDT/서명, Node) | flex-renderer-node-backend |
| 실시간 협업 웹소켓(Yjs/CRDT) | flex-yjs-websocket-backend |
| 웹 자동화(TS) | flex-web-automation-backend |
| 플랫폼 기반(커스텀페이지·신원확인·인박스·커넥터) | flex-pavement-backend |
| 잡 스케줄러/자동화 엔진(clockwork) | flex-marvel-clockwork-backend |
| 내부 코드네임(matrix/rosetta-stone 등) — 용도 확인 필요 | flex-marvel-backend |
| approval-document·ai 모듈 포함 — 용도 확인 필요 | flex-impact-backend |

## 4. 주의

- 위 매핑은 레포 이름·모듈 구조 기반 추정이 일부 포함된다(특히 §3 하단 코드네임 레포). 정확한 책임 범위는 **해당 레포의 `CLAUDE.md` + `settings.gradle.kts` 모듈 목록**으로 확정한다.
- 한 기능이 여러 레포에 걸치는 경우가 흔하다 (예: 급여명세서 = flex-payroll-backend 데이터 + flex-renderer-node-backend 렌더링; 정산 = payroll + core(구성원) + timetracking(근무시간)).
