-- Restore Guide 14 Tips Data to Database
-- This migration restores the tips column data for all Guide 14 steps

-- Step 1
UPDATE guide_steps
SET tips = $$- (X) 실수: 프롬프트에 "professional, 4K, high quality" 같은 무의미한 단어 나열
- (V) 팁: 이런 단어는 AI가 무시함. 대신 **구체적 장면 묘사**에 집중
- (X) 실수: 100자 넘는 긴 프롬프트 작성
- (V) 팁: AI는 **간결한 지시**를 더 잘 이해함
- (X) 실수: ChatGPT 출력을 그대로 사용하지 않고 손으로 다시 씀
- (V) 팁: ChatGPT 결과를 **복사-붙여넣기**로 그대로 활용$$
WHERE guide_id = 14 AND step_order = 1;

-- Step 2
UPDATE guide_steps
SET tips = $$- (X) 실수: 한 번 생성 후 "이게 다야?"라고 실망
- (V) 팁: AI 영상은 **확률 게임**. 같은 프롬프트도 3~5번 돌리면 그중 1~2개는 대박
- (X) 실수: 무료 크레딧 아껴쓰려고 생성 안 함
- (V) 팁: Kling은 **매일 크레딧이 리필**됨. 오늘 안 쓰면 내일 사라지니 매일 연습!
- (X) 실수: 생성 중 탭을 닫음
- (V) 팁: 생성 중에도 **탭을 열어두거나 "My Creations"에서 확인** 가능$$
WHERE guide_id = 14 AND step_order = 2;

-- Step 3
UPDATE guide_steps
SET tips = $$- (X) 실수: 프롬프트를 완전히 새로 쓰기
- (V) 팁: **기존 프롬프트의 일부만 수정**해야 변화를 정확히 파악 가능
- (X) 실수: 여러 요소를 한 번에 다 바꿈
- (V) 팁: **한 번에 1~2개 요소만** 변경해야 무엇이 효과 있었는지 알 수 있음
- (X) 실수: 실패한 프롬프트를 버림
- (V) 팁: 실패도 **학습 데이터**. 어떤 표현이 안 통하는지 기록해두기$$
WHERE guide_id = 14 AND step_order = 3;

-- Step 4
UPDATE guide_steps
SET tips = $$- (X) 실수: 이미지에 없는 새로운 요소를 프롬프트에 추가
- (V) 팁: **이미지 속 요소만 움직이게** 하세요. 없는 걸 만들려 하면 실패율 급증
- (X) 실수: 저해상도(720p 이하) 이미지 사용
- (V) 팁: **1080p 이상** 이미지를 사용해야 영상 품질 유지
- (X) 실수: 복잡한 움직임 프롬프트 (예: "걷다가 뛰다가 점프")
- (V) 팁: **한 가지 단순한 액션**만 지정 (예: "천천히 고개 끄덕이기")$$
WHERE guide_id = 14 AND step_order = 4;

-- Step 5
UPDATE guide_steps
SET tips = $$- (X) 실수: 한 도구만 써보고 "AI 영상은 이 정도구나" 판단
- (V) 팁: **최소 3가지 도구 비교** 필수. 같은 프롬프트도 도구마다 결과 천차만별
- (X) 실수: 무료 크레딧 다 쓰고 포기
- (V) 팁: Kling/Hailuo는 **매일 크레딧 리필**. 내일 다시 와서 연습하세요
- (X) 실수: 최신 모델 업데이트를 놓침
- (V) 팁: 2025년은 AI 영상 전쟁 중. **분기마다 새 모델 출시**되니 뉴스 체크$$
WHERE guide_id = 14 AND step_order = 5;

-- Step 6
UPDATE guide_steps
SET tips = $$- (X) 실수: 카메라 용어를 한꺼번에 너무 많이 넣음 (예: "Wide tracking dolly crane shot")
- (V) 팁: **1개 앵글 + 1개 움직임**만 사용 (예: "Wide tracking shot")
- (X) 실수: 한국어로 카메라 용어 입력 (예: "클로즈업")
- (V) 팁: 반드시 **영어 원어** 사용
- (X) 실수: 조명 키워드를 빼먹음
- (V) 팁: 조명이 분위기의 80%. **항상 조명 키워드 1개 이상** 추가$$
WHERE guide_id = 14 AND step_order = 6;

-- Step 7
UPDATE guide_steps
SET tips = $$- (X) 실수: 업스케일 없이 720p 그대로 업로드
- (V) 팁: 유튜브/인스타는 **최소 1080p** 필수. 4K면 알고리즘 우대 받음
- (X) 실수: 배경음악에 저작권 음원 사용
- (V) 팁: YouTube Audio Library 등 **저작권 프리** 음원만 사용
- (X) 실수: 자막을 너무 많이, 길게 넣음
- (V) 팁: 자막은 **핵심 1~2문장**만. 너무 많으면 산만함$$
WHERE guide_id = 14 AND step_order = 7;

-- Step 8
UPDATE guide_steps
SET tips = $$- (X) 실수: 프롬프트를 저장하지 않고 매번 새로 작성
- (V) 팁: **성공한 건 즉시 저장**. 나중에 찾으려면 기억 안 남
- (X) 실수: 프롬프트만 저장하고 메타데이터(도구, 성공률) 누락
- (V) 팁: **"어느 도구에서 잘 됐는지"** 메모 필수
- (X) 실수: 템플릿을 너무 복잡하게 만듦
- (V) 팁: 템플릿은 **3개 이하 변수**만. 단순할수록 재사용 쉬움$$
WHERE guide_id = 14 AND step_order = 8;

-- Step 9
UPDATE guide_steps
SET tips = $$- (X) 실수: 각 클립의 스타일(조명, 색감)이 제각각
- (V) 팁: 모든 프롬프트에 **같은 조명 키워드** 사용 (예: 전부 "golden hour")
- (X) 실수: 트랜지션을 너무 많이, 화려하게 사용
- (V) 팁: 트랜지션은 **최소화**. 자연스러운 Cut이 가장 프로페셔널
- (X) 실수: 음악 볼륨이 너무 크거나 작음
- (V) 팁: 음악은 **배경**이 목적. 영상보다 조용하게 (-10dB)$$
WHERE guide_id = 14 AND step_order = 9;

-- Step 10
UPDATE guide_steps
SET tips = $$- (X) 실수: 10개를 하나씩 생성하고 기다림
- (V) 팁: **대기열에 한꺼번에 쌓아두고** 다른 작업 병행
- (X) 실수: 모든 결과물을 다운로드
- (V) 팁: **미리보기에서 1차 선별** 후 베스트만 다운로드
- (X) 실수: 왜 좋은지/나쁜지 기록 안 함
- (V) 팁: 선정 이유를 간단히 메모 (나중에 패턴 파악 가능)$$
WHERE guide_id = 14 AND step_order = 10;

-- Step 11
UPDATE guide_steps
SET tips = $$- (X) 실수: 같은 제목/설명을 모든 플랫폼에 복붙
- (V) 팁: 플랫폼마다 **문화와 용어**가 다름. 맞춤 최적화 필수
- (X) 실수: 업로드 후 방치
- (V) 팁: **첫 1시간이 골든타임**. 댓글 적극 답변
- (X) 실수: 실패한 영상을 삭제
- (V) 팁: 실패도 데이터. **왜 안 됐는지 분석** 후 다음에 반영$$
WHERE guide_id = 14 AND step_order = 11;
