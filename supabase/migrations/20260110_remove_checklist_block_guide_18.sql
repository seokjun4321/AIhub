-- Migration: Remove redundant "Checklist Block" from Guide 18 Step 1
-- Date: 2026-01-10

BEGIN;

DO $migration$
BEGIN
    -- Update Guide 18, Step 1 Content
    UPDATE public.guide_steps
    SET content = $$#### (A) 왜 이 단계가 필요한가
Liner AI는 **한국에서 만들었지만 전 세계 연구자들이 쓰는 AI 검색 엔진**입니다. 학생·연구자·직장인들이 논문을 빠르게 정리하기 위해 쓰는 필수 도구예요.
특히 **학술 자료에 신뢰도가 중요한 분야**(대학원, 연구소, 기업 R&D 등)에서 최신 연구를 5분 만에 파악하는 데 강력합니다.

#### (B) 해야 할 일
1. 웹 브라우저 열기 (Chrome, Safari, Edge 뭐든 OK)
2. 주소창에 `liner.com` 또는 `getliner.com` 입력
3. 오른쪽 상단 "Sign Up" 또는 "Get Started" 클릭
4. 로그인 방법 선택:
   - 구글 계정으로 (가장 빠름)
   - 또는 이메일 + 비밀번호
5. 이메일 인증 (받은 메일에서 확인 링크 클릭)
6. 로그인 완료 → Liner AI 메인 화면 진입

#### (D) 예시: 가입 방법
**구글 계정으로 가입:**
1. liner.com 접속
2. "Sign up with Google" 클릭
3. 구글 로그인
4. 완료!

**이메일로 가입:**
1. liner.com 접속
2. 이메일 입력 → 비밀번호 설정
3. 회원가입 메일 확인
4. 완료!
$$
    WHERE guide_id = 18 AND step_order = 1;

END $migration$;
