# AIHub 시스템 문서 및 엔지니어링 가이드

## 1. 비즈니스 비전 및 전략 로드맵
*핵심 사업 계획서(2026) 기반*

### 1.1 문제 정의 (Problem)
AI 시장이 직면한 "실행 격차(Execution Gap)":
1.  **선택 마비 (Selection Paralysis)**: 5,000개 이상의 AI 도구가 존재하지만, 사용자는 자신에게 맞는 도구를 찾는 데 시간을 허비함.
2.  **활용 격차 (Usage Inequality)**: 상위 지식 근로자는 AI를 빠르게 도입하는 반면, 다수는 "표준화된 활용 절차(SOP)" 부재로 뒤쳐짐.
3.  **맥락의 파편화 (Fragmented Context)**: 정보가 흩어져 있음. 사용자는 ChatGPT가 *무엇인지*는 알지만, *어떻게* 내 업무에 효율적으로 적용할지는 모름.

### 1.2 솔루션: AIHub 플랫폼
격차를 해소하는 "상황 입력-실행" 통합 플랫폼.
*   **핵심 흐름 (Core Flow)**: 사용자 "내 상황" 입력 -> 시스템 "Top List" 추천 -> "실행 콘텐츠"(가이드북/프리셋) 연결.
*   **핵심 차별점**:
    *   **RAG 추천 챗봇**: 내부 DB(`guides`, `presets`)를 활용하여 "X를 어떻게 해?"라는 질문에 *구체적인* 플랫폼 자산으로 답변.
    *   **메타데이터 표준화**: 도구, 프리셋, 가이드북을 "직무", "목표", "난이도", "산출물" 기준으로 통일되게 태깅.

### 1.3 성장 전략 및 수익 모델
*   **타겟 고객 (SOM)**: 대학생, 취준생, 주니어 PM/마케터 (목표: 활성 사용자 50,000명).
*   **수익화 단계**:
    1.  **1단계 (현재)**: 토스페이먼츠를 통한 단건 구매 (가이드북/프리셋).
    2.  **2단계**: 개인 구독 (프리미엄 추천, 번들).
    3.  **3단계**: B2B 패키지 (팀 온보딩, 직무별 커리큘럼).
*   **Exit 전략**: 생산성 SaaS/AI 워크플로우 기업에 인수 (M&A); 시드/Pre-A 투자 유치 목표.

### 1.4 기술 로드맵 (우선순위)
1.  **온보딩 최적화**: "상황 입력" 폼 -> 자동 추천 로직 구현.
2.  **RAG 챗봇 (v1)**: `guides` 및 `presets`의 벡터 임베딩을 통한 자연어 검색 구현.
3.  **리텐션 기능**: `bookmark_folders` (보관함), `user_activities` (스트릭/게이미피케이션)으로 LTV 증대.

---

## 2. 데이터베이스 스키마 레퍼런스
시스템은 Supabase (PostgreSQL) 기반입니다. 스키마는 명확한 기능 도메인으로 나뉩니다. 모든 쿼리는 이 관계를 **반드시** 준수해야 합니다.

### 도메인 A: 사용자 프로필 및 게이미피케이션
핵심 사용자 식별 및 참여 엔진.
*   **`profiles`**: **루트 사용자 테이블**. `auth.users`를 확장함.
    *   *컬럼*: `reputation` (평판), `level` (레벨), `total_points` (총 포인트), `is_verified`, `is_creator`, `is_moderator`, `points_this_week`, `streak_days`.
    *   *로직*: UI 표시용으로는 절대 `auth.users`를 쿼리하지 말고, 항상 `profiles`를 사용할 것.
*   **`level_config`**: 레벨 승급 규칙 정의.
    *   *컬럼*: `level` (1-100), `min_experience` (필요 경험치), `badge_color`.
*   **`point_rules`**: 포인트 보상 중앙 설정.
    *   *컬럼*: `action_type` (예: 'comment_create'), `points` (+5), `daily_limit`.
*   **`point_history`**: 모든 포인트 트랜잭션 장부.
    *   *컬럼*: `action_type`, `points`, `target_type` (다형성 관계), `target_id`.
*   **`achievements`**: 배지 정의.
    *   *컬럼*: `requirement_type`, `requirement_value`, `points_reward`, `badge_color`.
*   **`user_achievements`**: 획득 배지 링크 테이블.
*   **`user_activities`**: 피드용 일반 활동 로그.
*   **`user_follows`**: 소셜 팔로워 그래프 (`follower_id` -> `following_id`).

### 도메인 B: 가이드북 LMS 시스템
다층 구조의 교육 콘텐츠 시스템.
*   **`guides`**: 코스 컨테이너.
    *   *컬럼*: `title`, `difficulty_level`, `estimated_time`, `ai_model_id`, `category_id`, `tags`.
*   **`guide_steps`**: 개별 챕터. 계층 구조 (`parent_step_id`).
    *   *컬럼*: `step_order`, `content` (마크다운), `checklist`, `done_when`.
*   **`guide_sections`**: 특정 레이아웃을 위한 가이드/스텝 내 하위 유닛.
*   **`guide_scenarios`**: 인터랙티브 케이스 스터디.
    *   *컬럼*: `situation` (상황), `goal` (목표), `result` (결과 - 완전한 학습 루프).
*   **`guide_prompts`**: 스텝 내에 삽입된 복사 가능한 프롬프트 자산.
*   **`guide_workbook_fields`**: 사용자 실습을 위한 입력 필드.
    *   *컬럼*: `field_key`, `field_type` (text/area), `placeholder`.
*   **`guide_progress`**: 사용자 완료 추적.
    *   *컬럼*: `user_id`, `guide_id`, `step_id`, `completed`, `workbook_data` (JSON).
*   **`prompt_engineering_progress`**: "프롬프트 엔지니어링" 특정 코스를 위한 별도 추적.
*   **`guide_folders`** / **`guide_bookmarks`**: 사용자 정의 가이드 보관함.
*   **`guide_submissions`**: 신규 가이드 제출을 위한 크리에이터 이코노미 흐름.
    *   *상태*: 'pending' -> 'approved' -> Live.
*   **`guide_categories`**: 다대다 카테고리 분류.

### 도메인 C: 프리셋 마켓플레이스 (5개 버티컬)
단일 제네릭 테이블이 **아닌**, 자산 유형별로 구분된 별도 테이블 사용.
1.  **`preset_workflows`**: 자동화 흐름 (N8n, Make).
    *   *상세*: `apps` (도구 목록), `diagram_url`, `steps`, `complexity`.
2.  **`preset_agents`**: 커스텀 챗봇 (GPTs, Claude).
    *   *상세*: `platform` (Enum: GPT, Claude...), `instructions`, `capabilities` (Web, DALL-E).
3.  **`preset_prompt_templates`**: 텍스트 프롬프트.
    *   *상세*: `prompt`, `variables` (JSON 플레이스홀더), `example_io`.
4.  **`preset_designs`**: 이미지 생성.
    *   *상세*: `image_url` (미리보기), `params` (JSON 생성 파라미터), `midjourney_id`.
5.  **`preset_templates`**: 생산성 문서 파일.
    *   *상세*: `category` (Notion/Sheets), `preview_url`, `duplicate_url`.
*   **`content_submissions`**: 승인 전 모든 프리셋 유형을 위한 통합 제출 테이블.
*   **`presets`**: 레거시/집계 테이블 (사용 전 확인 필요).

### 도메인 D: AI 도구 디렉토리
AI 서비스 "위키".
*   **`ai_models`**: 메인 디렉토리.
    *   *컬럼*: `pricing_info`, `comparison_data` (JSON), `features`, `best_for`, `pros`/`cons`.
*   **`categories`**: 도구 분류 체계 (예: "Image Gen", "LLM").
*   **`ratings`**: 도구 사용자 리뷰 (0.5 - 5.0 척도).
*   **`tool_bookmarks`** / **`bookmark_folders`**: 사용자 즐겨찾기.
*   **`tool_proposals`**: 사용자 제안 신규 도구.
*   **`recommendations`**: 사용 사례 기반 AI 추천.
*   **`use_cases`** / **`use_case_guides`**: "상황 Y에서 도구 X를 사용하는 법".

### 도메인 E: 소셜 커뮤니티
*   **`posts`**: 사용자 토론.
    *   *컬럼*: `category_id`, `is_pinned`, `is_locked`, `upvotes_count`.
*   **`comments`**: 스레드형 토론 (`parent_comment_id`).
    *   *컬럼*: `is_accepted` (지식iN 스타일), `images`.
*   **`mentions`**: 게시글/댓글 내 `@username` 태그 처리.
*   **`notifications`**: 시스템 알림 (`type`: mention, reply, system).
*   **`post_categories`** / **`community_sections`**: 커뮤니티 분류 체계.
*   **`post_votes`** / **`comment_votes`**: 추천/비추천 추적 (+1/-1).
*   **`post_bookmarks`**: 게시글 저장.
*   **`post_reports`** / **`comment_reports`**: 신고 대기열.

### 도메인 F: 커머스 및 시스템
*   **`purchases`**: 거래 장부.
    *   *핵심 필드*: `order_id` (토스 ID), `item_type` ('guide'/'preset'), `item_id`, `payment_key`.
*   **`feedbacks`**: 일반 시스템 피드백/버그 제보.

---

## 3. 운영 워크플로우

### 3.1 결제 검증 (토스페이먼츠)
1.  **UI**: 사용자가 `useTossPayment.ts`를 통해 구매 요청.
2.  **Toss**: 카드/이체 처리. `paymentKey` 반환.
3.  **Edge Function**: `verify-payment` 호출 (메타데이터 포함).
4.  **검증 (Validation)**:
    *   Auth Header에서 사용자 ID 추출.
    *   `order_id` 유일성 검증 (멱등성).
    *   토스 API를 호출하여 거래 확인.
5.  **데이터베이스**: RPC `handle_new_purchase`를 실행하여 `purchases` 테이블에 기록.

### 3.2 콘텐츠 제출 시스템
1.  **크리에이터**: 초안을 `content_submissions` (프리셋) 또는 `guide_submissions` (가이드)로 전송.
2.  **상태**: `status` = 'pending'.
3.  **관리자**: 관리자 대시보드를 통해 콘텐츠 검토.
4.  **승인 (Approval)**:
    *   해당 행이 각 공개 테이블(예: `preset_agents`)로 이동/복사됨.
    *   `profiles` 테이블의 `is_creator` 플래그가 TRUE로 설정됨.
    *   사용자에게 알림 전송.

---

## 4. 코딩 표준

### TypeScript 및 데이터 페칭
*   **Strict Typing**: 항상 `@/integrations/supabase/types`의 `Database` 타입을 사용할 것.
*   **JSDoc**: 모든 비즈니스 로직 함수에 필수.
*   **TanStack Query**: 모든 페칭은 캐싱을 위해 `useQuery` 또는 `useMutation`으로 래핑해야 함.
*   **Keys**: 표준 쿼리 키 사용: `['guides', id]`, `['presets', category, id]`.

### 디렉토리 구조
*   `src/components/preset-store`: 5개 버티컬 마켓플레이스 UI.
*   `src/components/community`: 포럼, 댓글 섹션.
*   `src/components/guidebook`: LMS 렌더러.
*   `src/integrations/toss`: 결제 로직.
*   `supabase/migrations`: **절대적인 진실의 원천 (Source of Truth)**.

---

## 5. 개발 명령어
-   `npm run dev`: 서버 시작 (Port 8080).
-   `npm run build`: 프로덕션 빌드.
-   `npm run supabase:types`: **스키마 변경 후 반드시 실행할 것**.
