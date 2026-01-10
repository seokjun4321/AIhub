-- Guide 20: Git & GitHub 입문

BEGIN;

DO $migration$
DECLARE
    v_guide_id BIGINT := 20;
    v_category_id INTEGER;
    v_model_id INTEGER;
BEGIN
    -- 1. Get IDs
    SELECT id INTO v_category_id FROM public.categories WHERE name = '개발 & 코딩' LIMIT 1;
    IF v_category_id IS NULL THEN
        SELECT id INTO v_category_id FROM public.categories LIMIT 1;
    END IF;

    -- Get or Create 'Developer Essentials' Model ID
    -- This acts as a placeholder for guides that don't use a specific AI model
    SELECT id INTO v_model_id FROM public.ai_models WHERE name = 'Developer Essentials' LIMIT 1;
    
    IF v_model_id IS NULL THEN
        INSERT INTO public.ai_models (name, description, website_url)
        VALUES (
            'Developer Essentials',
            'Core development tools and practices',
            'https://github.com'
        ) RETURNING id INTO v_model_id;
    END IF;

    -- 2. Cleanup
    DELETE FROM public.guide_sections WHERE guide_id = v_guide_id;
    DELETE FROM public.guide_prompts WHERE step_id IN (SELECT id FROM public.guide_steps WHERE guide_id = v_guide_id);
    DELETE FROM public.guide_steps WHERE guide_id = v_guide_id;
    DELETE FROM public.guide_categories WHERE guide_id = v_guide_id;
    -- Note: We no longer delete from guide_prompts by guide_id directly as it might not have that column or relies on cascades

    -- 3. Insert Guide
    INSERT INTO public.guides (
        id,
        title, 
        category_id, 
        ai_model_id,
        difficulty_level, 
        estimated_time, 
        description,
        tags,
        image_url
    ) 
    OVERRIDING SYSTEM VALUE
    VALUES (
        v_guide_id,
        'Git & GitHub 입문',
        v_category_id,
        v_model_id,
        'beginner',
        '2~3시간',
        '코드 변경 사항을 추적하고, 팀과 협업하며, 작업 실수를 되돌릴 수 있는 Git과 GitHub의 완벽한 초보자 가이드입니다.',
        ARRAY['Git', 'GitHub', '버전 관리', '커밋', '푸시', '브랜치', '협업', '명령어'],
        'https://images.unsplash.com/photo-1556075798-4825dfaaf498?q=80&w=2076&auto=format&fit=crop'
    )
    ON CONFLICT (id) DO UPDATE SET
        title = EXCLUDED.title,
        category_id = EXCLUDED.category_id,
        ai_model_id = EXCLUDED.ai_model_id,
        difficulty_level = EXCLUDED.difficulty_level,
        estimated_time = EXCLUDED.estimated_time,
        description = EXCLUDED.description,
        tags = EXCLUDED.tags,
        image_url = EXCLUDED.image_url;

    -- 4. Link Category
    INSERT INTO public.guide_categories (guide_id, category_id, is_primary)
    VALUES (v_guide_id, v_category_id, true)
    ON CONFLICT (guide_id, category_id) DO UPDATE SET is_primary = true;

    -- 5. Overview Cards
    -- Card 1: Summary
    INSERT INTO public.guide_sections (guide_id, section_order, section_type, title, content)
    VALUES (
        v_guide_id, 1, 'summary', '한 줄 요약',
        'Git은 코드 변경을 기록·추적하는 도구고, GitHub는 그 기록을 클라우드에 저장해 팀과 공유하는 플랫폼입니다. 개발자라면 반드시 배워야 하는 필수 기술입니다.'
    );

    -- Card 2: Recommend
    INSERT INTO public.guide_sections (guide_id, section_order, section_type, title, data)
    VALUES (
        v_guide_id, 2, 'target_audience', '이런 분께 추천',
        '["프로그래밍을 배우고 있는데 코드 관리가 필요한 학생", "처음으로 협업 프로젝트에 참여하는 개발자", "명령어가 무섭다며 Git을 미뤄왔던 분", "로컬에서 코드를 작성하는데 클라우드에 백업하고 싶은 사람", "GitHub 계정은 있지만 제대로 사용해본 적 없는 사람"]'::jsonb
    );

    -- Card 3: Preparation
    INSERT INTO public.guide_sections (guide_id, section_order, section_type, title, data)
    VALUES (
        v_guide_id, 3, 'preparation', '준비물',
        '["컴퓨터 (Windows, Mac, Linux 모두 OK)", "터미널/명령 프롬프트 (기본 제공)", "Git 설치 파일 (무료)", "GitHub 계정 (무료 가입)", "텍스트 에디터 또는 IDE (VS Code 추천)"]'::jsonb
    );

    -- Card 4: Principles
    INSERT INTO public.guide_sections (guide_id, section_order, section_type, title, data)
    VALUES (
        v_guide_id, 4, 'core_principles', '핵심 사용 원칙',
        '["의미 있는 단위로 커밋하기: 매번 의미 있는 작업 단위마다 commit을 남기기", "메시지를 명확하게: 수정함 X → 로그인 버튼 디자인 수정 O", "푸시 전에 풀하기: git pull → git push 순서 지키기", "자주 푸시하기: 컴퓨터가 망가져도 코드는 안전하도록 자주 백업", "브랜치로 안전하게: 새 기능은 항상 새 브랜치에서 작업하기"]'::jsonb
    );

    -- 6. Steps
    -- Step 1
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id,
        1,
        'Git과 GitHub 개념 이해하기',
        'Git과 GitHub의 차이점을 명확히 이해하고, 왜 필요한지 안다.',
        $$- Git = 버전 관리 도구 (로컬)
- GitHub = Git 저장소 호스팅 서비스 (클라우드)
- 둘의 관계를 이해함$$,
        $$#### (A) 왜 이 단계가 필요한가

많은 초보자가 **"Git과 GitHub가 같은 거 아니야?"**라고 생각합니다.

다르지 않으면 새 것을 배워도 헷갈립니다.

**명확한 이해** → **효율적인 학습** → **제대로 사용**으로 이어지기 때문에, 이 단계는 매우 중요합니다.

#### (B) 해야 할 일

1. **아래 개념을 읽고 이해하기**
   - 개념 파악이 우선입니다. "Git은 내 컴퓨터(로컬)에서 관리하는 도구, GitHub는 그걸 올려두는 클라우드(원격)"라는 점을 기억하세요.

2. **개념을 자신의 말로 설명해보기**
   - "Git은 로컬 저장소, GitHub는 원격 저장소"라는 문장을 친구에게 설명하듯 말해보세요.
   - 예: "Git은 내 컴퓨터에 있는 일기장이고, GitHub는 그 일기장을 보관하는 도서관이야."

3. **왜 둘 다 필요한지 생각해보기**
   - "내 컴퓨터가 고장 나면?", "팀원과 일기장을 공유하려면?" 같은 질문을 던져보세요.

![Git vs GitHub 개념도](/images/git_vs_github_concept.png)

#### (C) 예시: 실제 작업 흐름

```
1단계 (로컬 - Git 사용)
- 파일 수정 (코드 작성)
- git add (변경사항 준비)
- git commit -m "로그인 기능 추가" (로컬에 기록)

2단계 (클라우드 - GitHub 사용)
- git push (로컬 커밋들을 GitHub으로 업로드)
- GitHub에서 코드 공개/공유

3단계 (협업)
- 팀원이 GitHub에서 코드 확인
- 피드백/리뷰 진행
- 팀원이 pull request로 코드 제안
```$$,
        $$- (X) 실수: Git과 GitHub를 같은 것으로 생각
- (V) 팁: **Git은 도구, GitHub는 서비스**라고 기억하세요
- (X) 실수: GitHub 없이 Git만 쓰려고 함
- (V) 팁: Git + GitHub 조합이 가장 강력합니다
- (X) 실수: 커밋하면 자동으로 GitHub에 올라간다고 생각
- (V) 팁: **Push를 해야** GitHub에 올라갑니다. 커밋과 구분하세요$$,
        $$[{"id": "s1_c1", "text": "Git이 뭔지 설명할 수 있는가?"}, {"id": "s1_c2", "text": "GitHub가 뭔지 설명할 수 있는가?"}, {"id": "s1_c3", "text": "\"왜 둘 다 필요한가?\"에 답할 수 있는가?"}, {"id": "s1_c4", "text": "로컬 저장소와 원격 저장소의 차이를 알았는가?"}]$$::jsonb
    );

    -- Step 2
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id,
        2,
        'Git 설치 및 기초 설정하기',
        'Git을 설치하고, 사용자 정보를 등록한다.',
        $$- Git이 정상 설치됨
- 터미널에서 `git --version` 실행 가능
- 사용자 이름과 이메일 설정 완료$$,
        $$#### (A) 왜 이 단계가 필요한가

Git을 설치하고 설정해야 **처음 커밋을 할 수 있습니다.**

특히 사용자 정보 설정은 **"누가 이 코드를 작성했는가?"**를 추적하기 위해 필수입니다.

팀 프로젝트에서는 **각 커밋이 누가 작성했는지 명확히 남아야** 효율적인 협업이 가능합니다.

#### (B) 해야 할 일

1. **Git 설치**
   - Windows: git-scm.com에서 "Git for Windows" 다운로드 → 설치
   - Mac: 터미널에서 `brew install git` 실행
   - Linux: 터미널에서 `sudo apt install git` 실행 (또는 distro에 맞는 명령)

2. **설치 확인**
   - 터미널/명령 프롬프트 열기
   - `git --version` 입력
   - 버전 번호가 나오면 ✅ 설치 완료

3. **사용자 정보 설정**
   - `git config --global user.name "Your Name"` 입력
   - `git config --global user.email "your.email@example.com"` 입력
   - (이후 모든 커밋에 이 정보가 자동 포함)

#### (C) 블록: 설정 명령어

터미널에 다음 명령어들을 복사-붙여넣으세요 (따옴표 포함):

```
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main
git --version
git config --list
```

마지막 두 명령어:

* `git --version`: 설치 확인
* `git config --list`: 설정 확인

#### (D) 예시: 실제 설정 과정

**터미널에 입력:**

```
git config --global user.name "Kim Developer"
git config --global user.email "kim@example.com"
```

**확인:**

```
git config --list
```

**출력 결과 (일부):**

```
user.name=Kim Developer
user.email=kim@example.com
...
```

→ ✅ 설정 완료!$$,
        $$- (X) 실수: 설정할 때 따옴표 빼먹음
- (V) 팁: **공백이 포함되면 따옴표를 넣는 것을 권장**합니다. (공백이 없으면 생략 가능)
- (X) 실수: 이메일을 틀려서 입력
- (V) 팁: **정확한 이메일**로 설정하세요. 나중에 수정 가능
- (X) 실수: "설정했는데 적용 안 된다"고 생각
- (V) 팁: `git config --list`로 **설정 확인**하세요$$,
        $$[{"id": "s2_c1", "text": "Git 설치되었는가? (`git --version` 실행 확인)"}, {"id": "s2_c2", "text": "사용자 이름을 설정했는가?"}, {"id": "s2_c3", "text": "사용자 이메일을 설정했는가?"}, {"id": "s2_c4", "text": "`git config --list`로 설정을 확인했는가?"}]$$::jsonb
    );

    -- Step 3
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id,
        3,
        'GitHub 계정 생성 및 첫 리포지토리 만들기',
        'GitHub 계정을 만들고, 첫 저장소(Repository)를 생성한다.',
        $$- GitHub 계정 생성 완료
- 첫 Repository 생성됨
- README.md 파일이 있음$$,
        $$#### (A) 왜 이 단계가 필요한가

GitHub는 **Git 저장소를 호스팅하는 가장 유명한 플랫폼**입니다.

계정을 만들어야:

* 코드를 클라우드에 백업
* 포트폴리오 구축 (면접/취업에서 보여줄 자료)
* 팀과 협업
* 오픈소스에 기여

따라서 **개발자라면 GitHub 계정은 필수**입니다.

#### (B) 해야 할 일

1. **GitHub 계정 생성**
   - github.com 접속
   - "Sign up" 클릭
   - 이메일 입력 → 비밀번호 설정 → 사용자명 입력
   - 이메일 인증 (받은 메일에서 링크 클릭)

2. **Repository 생성**
   - GitHub 로그인 후 우측 상단 "+" 아이콘 클릭
   - "New repository" 선택
   - Repository name 입력 (예: "my-first-project")
   - "Public" 선택 (공개)
   - "Add a README file" 체크
   - "Create repository" 클릭

3. **Repository 확인**
   - 생성된 Repository 페이지에서:
     - README.md 파일 확인
     - "Clone" 버튼 위치 확인 (다음에 사용)

#### (C) 블록: Repository 체크리스트

생성한 Repository가 다음을 모두 포함하는지 확인:

```
✅ 체크리스트

[ ] Repository 이름이 명확한가?
    (예: my-first-project, calculator, todo-app)

[ ] "Public" 설정되어 있는가?
    (Public = 누구나 볼 수 있음)

[ ] README.md 파일이 있는가?
    (프로젝트 설명 파일)

[ ] Clone URL을 복사할 수 있는가?
    (우측 상단 "Code" → HTTPS 복사)
```

#### (D) 예시: Repository 생성 과정

**생성 후 화면:**

```
Repository: my-first-project
Owner: your-username
Public
Main branch: main

README.md (자동 생성됨)
# my-first-project
Your project description here.

[Code] [Issues] [Pull requests] [Discussions]
```$$,
        $$- (X) 실수: Private로 설정 (다른 사람이 못 봄)
- (V) 팁: **처음엔 Public**으로 시작하세요. 포트폴리오가 되니까
- (X) 실수: Repository 이름을 너무 복잡하게 지음
- (V) 팁: **영문, 숫자, 하이픈만** 사용하는 게 관례
- (X) 실수: .gitignore를 안 설정
- (V) 팁: 나중에 배우니까 **지금은 생략**해도 OK$$,
        $$[{"id": "s3_c1", "text": "GitHub 계정을 만들었는가?"}, {"id": "s3_c2", "text": "이메일 인증을 완료했는가?"}, {"id": "s3_c3", "text": "Repository를 생성했는가?"}, {"id": "s3_c4", "text": "README.md 파일이 있는가?"}, {"id": "s3_c5", "text": "Repository Clone URL을 찾을 수 있는가?"}]$$::jsonb
    );

    -- Step 4
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id,
        4,
        '로컬 저장소 만들고 GitHub과 연결하기',
        '컴퓨터에 로컬 폴더를 만들고, GitHub과 연결한다.',
        $$- 로컬 폴더를 Git 저장소로 초기화
- GitHub 원격 저장소와 연결됨
- `git remote -v` 명령어로 연결 확인$$,
        $$#### (A) 왜 이 단계가 필요한가

GitHub에 저장소를 만들었지만, **아직 로컬 컴퓨터와 연결이 안 된 상태입니다.**

이 단계에서:

* 로컬 폴더를 Git이 추적하는 저장소로 만들고
* GitHub의 원격 저장소와 연결합니다

이제 **로컬에서 코드 작성 → GitHub에 백업**이 가능해집니다.

#### (B) 해야 할 일

1. **로컬 폴더 생성**
   - 데스크톱 또는 Documents에 새 폴더 생성
   - 폴더명: `my-first-project` (GitHub Repository 이름과 동일하게)

2. **터미널에서 그 폴더로 이동**
   - 터미널 열기
   - `cd` 명령어로 폴더로 이동
   - 예: `cd Desktop/my-first-project`

3. **Git 저장소 초기화**
   - `git init` 입력
   - `.git` 폴더가 생성됨 (숨김 폴더)

4. **GitHub와 연결 (Remote 설정)**
   - GitHub Repository 페이지에서 "Code" 버튼 클릭
   - HTTPS URL 복사 (예: `https://github.com/username/my-first-project.git`)
   - 터미널에서 입력: `git remote add origin [복사한 URL]`

5. **연결 확인**
   - `git remote -v` 입력
   - URL이 2번 나오면 ✅ 연결 완료

#### (C) 블록: 연결 명령어

GitHub URL을 복사한 후, 터미널에 다음을 입력하세요:

```
cd /path/to/my-first-project
git init
git remote add origin https://github.com/YOUR-USERNAME/my-first-project.git
git remote -v
```

마지막 줄의 결과 (예시):

```
origin  https://github.com/YOUR-USERNAME/my-first-project.git (fetch)
origin  https://github.com/YOUR-USERNAME/my-first-project.git (push)
```

#### (D) 예시: 실제 연결 과정

**터미널:**

```
$ cd Desktop/my-first-project
$ git init
Initialized empty Git repository in /Users/username/Desktop/my-first-project/.git/

$ git remote add origin https://github.com/kim-dev/my-first-project.git

$ git remote -v
origin  https://github.com/kim-dev/my-first-project.git (fetch)
origin  https://github.com/kim-dev/my-first-project.git (push)
```

→ ✅ 연결 완료!

#### (E) 분기: GitHub에 README가 이미 있는 경우 (권장 흐름)

Step 3에서 **“Add a README file”을 체크했다면**, 원격 저장소(GitHub)에 이미 첫 커밋이 존재합니다.
이때 Step 4처럼 `git init`로 새 로컬 저장소를 만들고 바로 push를 시도하면 **거절/충돌이 날 수 있어**, 아래 방식이 더 간단합니다.

**방법: GitHub 저장소를 clone로 가져오기**

```
cd /path/to/parent-folder
git clone https://github.com/YOUR-USERNAME/my-first-project.git
cd my-first-project
git remote -v
```

* 이미 만들어둔 로컬 파일이 있다면, **clone 받은 폴더로 파일을 옮긴 뒤** Step 5(커밋)로 진행하면 됩니다.$$,
        $$- (X) 실수: 로컬 폴더 이름과 GitHub Repository 이름이 다름
- (V) 팁: **이름을 같게** 해두면 헷갈리지 않습니다
- (X) 실수: URL을 잘못 복사
- (V) 팁: GitHub에서 "Code" 버튼 → HTTPS → 복사 (정확히 따르기)
- (X) 실수: `git init` 대신 `git clone` 사용
- (V) 팁: **새로 만들 때는 `init`, 기존 저장소를 가져올 때는 `clone`**$$,
        $$[{"id": "s4_c1", "text": "로컬 폴더를 만들었는가?"}, {"id": "s4_c2", "text": "`git init`을 실행했는가?"}, {"id": "s4_c3", "text": "GitHub URL을 `git remote add`로 연결했는가?"}, {"id": "s4_c4", "text": "`git remote -v`로 연결을 확인했는가?"}]$$::jsonb
    );

    -- Step 5
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id,
        5,
        '첫 커밋 해보기',
        '파일을 수정하고, Stage → Commit → Push까지 완성한다.',
        $$- 로컬 파일 수정 (또는 파일 생성)
- 첫 커밋 완료
- GitHub에 Push 완료$$,
        $$#### (A) 왜 이 단계가 필요한가

이제 **실제로 Git의 핵심 기능을 써보는 단계**입니다.

Commit은 **"이 시점에서의 코드 스냅샷을 저장한다"**는 뜻입니다.

실제로 경험해보면:

* Git의 흐름을 이해
* Stage와 Commit의 차이를 깨달음
* Push 후 GitHub에서 코드가 나타나는 신기함 경험

#### (B) 해야 할 일

1. **파일 수정 (또는 생성)**
   - VS Code 등에서 `test.txt` 파일 생성
   - 내용 입력: "Hello, Git!"
   - 저장

2. **변경사항 확인**
   - 터미널에서 `git status` 입력
   - 빨간색으로 "test.txt" 파일 표시됨

3. **Staging (준비)**
   - `git add test.txt` 입력 (또는 `git add .` 모든 파일)
   - `git status` 다시 입력
   - 초록색으로 바뀌면 ✅ Staging 완료

4. **Commit (저장)**
   - `git commit -m "Initial commit: add test.txt"` 입력
   - 메시지는 "뭘 했는가"를 설명해야 함

5. **Push (업로드)**
   - `git push origin main` 입력
   - GitHub에 업로드 시작
   - 업로드 완료 후 GitHub 웹사이트에서 파일 확인

#### (C) 블록: 첫 커밋 명령어

VS Code에서 `test.txt` 파일을 만든 후, 터미널에 입력:

```
git status
git add test.txt
git status
git commit -m "Initial commit: add test.txt"
git push origin main
```

각 단계별로 한 줄씩 입력하고, `git status`로 상태를 확인하세요.

#### (D) 예시: 실제 커밋 과정

**터미널:**

```
$ git status
On branch main
Untracked files:
  (use "git add <file>..." to include in what will be committed)
    test.txt

nothing added to commit but untracked files present

$ git add test.txt

$ git status
On branch main
Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
    new file:   test.txt

$ git commit -m "Initial commit: add test.txt"
[main (root-commit) a1b2c3d] Initial commit: add test.txt
 1 file changed, 1 insertion(+)
 create mode 100644 test.txt

$ git push origin main
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
...
To https://github.com/kim-dev/my-first-project.git
 * [new branch]      main -> main
```

→ ✅ GitHub에 Push 완료!

**GitHub 웹사이트에서 확인:**

* Repository 페이지 새로고침
* `test.txt` 파일이 나타남!

#### (E) 분기: 파일 여러 개를 Commit하려면?

**방법 1: 전체 파일 한 번에**

```
git add .
git commit -m "메시지"
git push origin main
```

**방법 2: 특정 파일만**

```
git add file1.txt file2.txt
git commit -m "메시지"
git push origin main
```$$,
        $$- (X) 실수: `git add` 빼먹고 바로 `git commit` 함
- (V) 팁: **반드시 순서**: Add → Commit → Push
- (X) 실수: 커밋 메시지를 대충 "수정" 이라고 씀
- (V) 팁: **구체적으로**: "로그인 기능 추가", "버그 수정: 닫기 버튼"
- (X) 실수: `git push`만 하고 GitHub 확인 안 함
- (V) 팁: **GitHub 웹사이트에서 실제로 보이는지 확인**하세요!$$,
        $$[{"id": "s5_c1", "text": "로컬 파일을 수정/생성했는가?"}, {"id": "s5_c2", "text": "`git status`로 변경사항을 확인했는가?"}, {"id": "s5_c3", "text": "`git add`로 Staging 했는가?"}, {"id": "s5_c4", "text": "`git commit -m \"메시지\"`로 Commit 했는가?"}, {"id": "s5_c5", "text": "`git push origin main`으로 Push 했는가?"}, {"id": "s5_c6", "text": "GitHub 웹사이트에서 파일이 보이는가?"}]$$::jsonb
    );

    -- Step 6
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id,
        6,
        '브랜치로 안전하게 작업하기',
        'Main 브랜치 외에 새 브랜치를 만들고, 그곳에서 작업한 후 병합한다.',
        $$- 새 브랜치 생성 (`git branch`)
- 브랜치 전환 (`git switch` 또는 `git checkout`)
- 새 파일 생성 + Commit
- GitHub에서 병합 (Merge)$$,
        $$#### (A) 왜 이 단계가 필요한가

**Main 브랜치는 "안정적인 코드"가 있는 곳**입니다.

새 기능을 개발할 때 Main에서 직접 하면, 버그가 생길 수 있어요.

대신 **별도의 브랜치에서 개발**하고, 완성되면 Main에 병합합니다.

이렇게 하면:

* Main 코드는 항상 안전
* 팀원 여러 명이 동시에 다른 기능 개발 가능
* 버그 수정과 새 기능을 독립적으로 관리

#### (B) 해야 할 일

1. **현재 브랜치 확인**
   - `git branch` 입력
   - 현재 Main 브랜치에 있음을 확인 (* 표시)

2. **새 브랜치 생성**
   - `git branch feature/add-feature` 입력
   - (브랜치 이름: feature/기능명 관례)

3. **새 브랜치로 전환**
   - `git switch feature/add-feature` 입력
   - (또는 `git checkout feature/add-feature`)
   - `git branch`로 확인 (새 브랜치에 * 표시)

4. **새 파일 생성 + Commit**
   - `feature.txt` 파일 생성
   - 내용 입력
   - `git add feature.txt` + `git commit -m "Add feature"`

5. **GitHub에 Push**
   - `git push origin feature/add-feature` 입력
   - GitHub 웹사이트에서 새 브랜치 확인

6. **Main 브랜치로 병합 (GitHub 웹사이트에서)**
   - GitHub Repository 페이지 접속
   - "Pull requests" 탭 → "New Pull Request" 클릭
   - 비교 브랜치 선택: `feature/add-feature` → `main`
   - "Create Pull Request" 클릭
   - "Merge Pull Request" 클릭

#### (C) 블록: 브랜치 명령어

```
git branch
git branch feature/add-feature
git switch feature/add-feature
git branch
git add feature.txt
git commit -m "Add feature"
git push origin feature/add-feature
```

마지막 단계는 GitHub 웹사이트에서 Pull Request → Merge

#### (D) 예시: 브랜치 작업 흐름

**터미널:**

```
$ git branch
* main

$ git branch feature/add-feature

$ git switch feature/add-feature
Switched to branch 'feature/add-feature'

$ git branch
  main
* feature/add-feature

$ git add feature.txt
$ git commit -m "Add feature"
[feature/add-feature a1b2c3d] Add feature
 1 file changed, 1 insertion(+)

$ git push origin feature/add-feature
Enumerating objects: 3, done.
...
To https://github.com/kim-dev/my-first-project.git
 * [new branch]      feature/add-feature -> feature/add-feature
```

**GitHub 웹사이트:**

```
1. Repository 페이지
2. "Pull requests" 탭 → 자동 제안 나타남
3. "Compare & pull request" 클릭
4. "Create pull request" 클릭
5. "Merge pull request" 클릭
6. 병합 완료!
```

#### (E) 분기: 병합 후 브랜치 삭제

병합 후 더 이상 필요 없으면 삭제:

```
git branch -d feature/add-feature
git push origin --delete feature/add-feature
```$$,
        $$- (X) 실수: Main 브랜치에서 바로 개발
- (V) 팁: **새 기능은 항상 새 브랜치에서**
- (X) 실수: 브랜치 이름을 대충 "new" 또는 "test"로 함
- (V) 팁: **관례 따르기**: `feature/기능명`, `bugfix/버그명`
- (X) 실수: 로컬에서는 다른 브랜치인데 GitHub에는 안 보임
- (V) 팁: **`git push origin 브랜치명`** 으로 GitHub에도 올려야 함$$,
        $$[{"id": "s6_c1", "text": "`git branch`로 브랜치 목록을 봤는가?"}, {"id": "s6_c2", "text": "새 브랜치를 생성했는가?"}, {"id": "s6_c3", "text": "`git switch`로 브랜치를 전환했는가?"}, {"id": "s6_c4", "text": "새 파일을 생성 + Commit 했는가?"}, {"id": "s6_c5", "text": "`git push origin 브랜치명`으로 Push 했는가?"}, {"id": "s6_c6", "text": "GitHub 웹사이트에서 Pull Request를 만들어 Merge 했는가?"}]$$::jsonb
    );

    -- Step 7
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id,
        7,
        '깃 로그로 커밋 히스토리 보기',
        '지금까지 한 커밋들의 기록을 보고, 필요하면 이전 상태로 돌아간다.',
        $$- `git log`로 커밋 히스토리 확인
- 각 커밋이 누가, 언제, 뭘 했는지 파악
- (선택) 이전 커밋으로 돌아가기$$,
        $$#### (A) 왜 이 단계가 필요한가

**Git의 가장 큰 강점은 "시간 여행"이 가능하다**는 것입니다.

언제든 이전 버전의 코드로 돌아갈 수 있어요.

버그를 발견했을 때:

* "어느 커밋부터 버그가 생겼지?"를 파악
* 그 전의 상태로 되돌리기
* 차이점 분석

이 모든 게 **커밋 히스토리 덕분**입니다.

#### (B) 해야 할 일

1. **커밋 히스토리 보기**
   - `git log` 입력
   - 모든 커밋이 최신순으로 표시됨
   - Q 키를 눌러 나가기

2. **간단한 형식으로 보기**
   - `git log --oneline` 입력
   - 한 줄씩 간단하게 표시 (편함)

3. **그래프로 보기**
   - `git log --oneline --graph` 입력
   - 브랜치와 병합이 시각적으로 표시됨

4. **(선택) 특정 커밋 확인**
   - `git show [커밋해시]` 입력
   - 그 커밋에서 뭐가 바뀌었는지 확인

#### (C) 블록: 커밋 확인 명령어

```
git log
git log --oneline
git log --oneline --graph
git log --oneline -10
```

마지막 명령어는 최근 10개 커밋만 보기 (로그가 길 때 유용)

#### (D) 예시: 실제 로그 화면

**`git log --oneline` 결과:**

```
a1b2c3d (HEAD -> main) Merge pull request #1 from kim-dev/feature/add-feature
f4e5d6c Add feature
e7d8c9b Initial commit: add test.txt

(END)
```

각 항목:

* `a1b2c3d`: 커밋 ID (짧은 버전)
* `HEAD -> main`: 현재 위치
* `Merge pull request...`: 커밋 메시지$$,
        $$- (X) 실수: 커밋 메시지를 대충 "수정" 이라고 남김
- (V) 팁: **구체적인 메시지를 남기면**, 나중에 로그를 보기 쉬움
- (X) 실수: "로그가 너무 길다"고 overwhelm 됨
- (V) 팁: **`git log --oneline -10`** 으로 최근 10개만 보기
- (X) 실수: 과거 커밋을 보고 싶은데 어떻게 해야 하나 모름
- (V) 팁: 나중에 배울 `git reset`, `git revert` 사용$$,
        $$[{"id": "s7_c1", "text": "`git log`로 커밋 히스토리를 봤는가?"}, {"id": "s7_c2", "text": "`git log --oneline`의 간단한 형식이 편한가?"}, {"id": "s7_c3", "text": "`git log --graph`로 브랜치 흐름을 이해했는가?"}, {"id": "s7_c4", "text": "각 커밋의 메시지를 읽을 수 있는가?"}]$$::jsonb
    );

    -- Step 8
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id,
        8,
        'Pull & Fetch - 팀원의 코드 받아오기',
        'GitHub에서 최신 코드를 받아와서 로컬에 반영한다.',
        $$- `git pull` 명령어 이해
- GitHub의 코드가 로컬로 동기화됨
- Push 전에 Pull 하는 습관 형성$$,
        $$#### (A) 왜 이 단계가 필요한가

**협업할 때 가장 중요한 명령어 중 하나**입니다.

팀원이 코드를 수정해서 GitHub에 올렸는데, 당신의 로컬은 여전히 이전 상태입니다.

`git pull`을 하면 **GitHub의 최신 코드를 로컬로 받아옵니다.**

특히 **Push 하기 전에 항상 Pull을 하는 습관**이 매우 중요합니다.

왜? 충돌(Merge conflict)을 피하기 위해!

#### (B) 해야 할 일

#### (B) 해야 할 일

1. **현재 상태 확인**
   - `git status` 입력
   - "Your branch is up to date"가 나오면 이미 최신
   - 다르면 Pull 필요

2. **Pull 하기**
   - `git pull` 입력 (또는 `git pull origin main`)
   - GitHub의 최신 코드가 로컬로 다운로드됨
   - 로컬 파일들이 자동 업데이트됨

3. **결과 확인**
   - 로컬 폴더를 보면 파일들이 업데이트됨
   - `git status`로 "Your branch is up to date" 확인

#### (C) 블록: Pull 명령어

```
git status
git pull
git status
git log --oneline
```

마지막은 새로운 커밋들이 로컬에 반영되었는지 확인

#### (D) 예시: 실제 Pull 과정

**시나리오:**

* 당신: 로컬에서 작업 중
* 팀원: GitHub에 코드 올림
* 당신: 팀원의 코드가 자신의 로컬에 없음

**터미널:**

```
$ git status
On branch main
Your branch is behind 'origin/main' by 1 commit.

$ git pull
remote: Enumerating objects: 3, done.
...
Updating a1b2c3d..e7d8c9b
Fast-forward
 feature.txt | 1 +
 1 file changed, 1 insertion(+)

$ git status
On branch main
Your branch is up to date with 'origin/main'.
```

→ ✅ Pull 완료!

#### (E) 분기: Fetch vs Pull

**Pull:**

```
git pull = git fetch + git merge (한 번에)
```

**Fetch (고급 사용법):**

```
git fetch (다운로드만, 아직 적용 안 함)
git merge (적용)
```

→ **처음엔 `git pull`만 알면 OK**$$,
        $$- (X) 실수: Pull 없이 바로 Push
- (V) 팁: **항상 순서**: Pull → 작업 → Commit → Push
- (X) 실수: "충돌이 나면 어떻게 하지?"라고 불안함
- (V) 팁: 충돌은 **정상**입니다. 다음 스텝에서 배움
- (X) 실수: Fetch와 Pull의 차이를 헷갈림
- (V) 팁: **처음엔 Pull만 사용**, 나중에 Fetch 배우기$$,
        $$[{"id": "s8_c1", "text": "`git pull`이 뭘 하는지 이해했는가?"}, {"id": "s8_c2", "text": "`git status`로 현재 상태를 확인했는가?"}, {"id": "s8_c3", "text": "`git pull`을 실행했는가?"}, {"id": "s8_c4", "text": "\"Pull 후에 Push\"는 규칙을 기억했는가?"}]$$::jsonb
    );

    -- Step 9
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id,
        9,
        'Git & GitHub 완벽 정리',
        '지금까지 배운 것들을 정리하고, 다음 단계를 계획한다.',
        $$- 8가지 기본 명령어를 정리
- 일반적인 작업 흐름을 이해
- "다음에 배울 것"을 안다$$,
        $$#### (A) 왜 이 단계가 필요한가

Step 1~8을 완료했으니, 이제 **"내가 뭘 배웠는가?"**를 정리할 시간입니다.

명확한 이해 → 실전 적용 → 습관 형성 으로 이어지기 때문입니다.

#### (B) 해야 할 일

#### (B) 해야 할 일

아래 8가지 명령어를 정리하고, 각각 언제 쓰는지 이해하세요:

1. **git init**
   - 언제: 새 프로젝트를 시작할 때
   - 설명: 로컬 폴더를 Git 저장소로 초기화

2. **git add [파일명]**
   - 언제: 파일을 수정하고 commit 준비할 때
   - 설명: 변경사항을 staging area에 추가
   - 팁: 모든 파일 추가는 `git add .`

3. **git commit -m "메시지"**
   - 언제: 의미 있는 작업을 완료했을 때
   - 설명: 변경사항을 로컬 저장소에 저장
   - 예: `git commit -m "로그인 기능 추가"`

4. **git push origin [브랜치명]**
   - 언제: 커밋들을 GitHub에 올릴 준비가 됐을 때
   - 설명: 로컬 커밋들을 원격 저장소(GitHub)에 업로드

5. **git pull origin [브랜치명]**
   - 언제: GitHub의 최신 코드를 받아올 때
   - 설명: 원격 저장소의 최신 코드를 로컬로 다운로드 (Push 전에 필수!)

6. **git branch [브랜치명]**
   - 언제: 새로운 작업을 시작할 때
   - 설명: 새로운 브랜치 생성 (독립적인 작업 공간)

7. **git switch [브랜치명]**
   - 언제: 다른 브랜치로 옮길 때
   - 설명: 현재 작업 브랜치 전환

8. **git log**
   - 언제: 커밋 히스토리를 보고 싶을 때
   - 설명: 지금까지의 커밋 기록 확인 (`git log --oneline` 추천)

#### (D) 예시: 실무 작업 흐름

**하루의 작업 흐름:**

```
1. 아침 (최신 코드 받기)
   git pull origin main

2. 오전 (코드 작성)
   파일 수정 → git add . → git commit -m "메시지"

3. 점심 시간 (코드 백업)
   git push origin main

4. 오후 (새 기능 개발)
   git branch feature/new-feature
   git switch feature/new-feature
   파일 수정 → git add . → git commit -m "메시지"
   git push origin feature/new-feature

5. 저녁 (코드 리뷰/병합)
   GitHub에서 Pull Request 생성 → Merge
   git switch main
   git pull origin main
```$$,
        $$- (X) 실수: 8가지 명령어를 다 외우려고 함
- (V) 팁: **자주 쓰다 보면 자동으로 외워집니다**. 지금은 이해만
- (X) 실수: "나는 Git 고수다"라고 생각하고 더 배우지 않음
- (V) 팁: **이건 시작일 뿐**, 다음: merge conflict, rebase, stash 등
- (X) 실수: 혼자만 배웠다고 생각
- (V) 팁: 팀과 협업해봐야 진짜 배웁니다!$$,
        $$[{"id": "s9_c1", "text": "8가지 명령어를 모두 설명할 수 있는가?"}, {"id": "s9_c2", "text": "일반적인 작업 흐름을 이해했는가?"}, {"id": "s9_c3", "text": "Push 전에 Pull 하는 습관을 키웠는가?"}, {"id": "s9_c4", "text": "다음 스텝(merge conflict, advanced git)을 알고 있는가?"}]$$::jsonb
    );

    -- 7. Prompts (using guide_sections type='prompt_pack')
    INSERT INTO public.guide_sections (guide_id, section_order, section_type, title, data)
    VALUES (
        v_guide_id,
        5, -- Order after overview cards
        'prompt_pack',
        '프롬프트 팩',
        '[
            {
                "id": "p1",
                "title": "Git 기본 명령어 요약",
                "description": "- Git 명령어를 빠르게 기억하고 싶을 때 사용\n- 새 프로젝트를 시작할 때",
                "prompt": "# 새 프로젝트 시작\ngit init\ngit remote add origin [GitHub URL]\n\n# 기본 작업 흐름\ngit pull origin main          # 최신 코드 받기\ngit add .                     # 모든 파일 준비\ngit commit -m \"메시지\"        # 저장\ngit push origin main          # GitHub에 올리기\n\n# 상태 확인\ngit status                    # 현재 상태\ngit log --oneline            # 커밋 히스토리",
                "failurePatterns": "- ❌ 실수: 명령어를 외우려다 포기함\n- ✅ 팁: 이 요약을 복사해두고 필요할 때마다 보세요",
                "relatedStep": [1, 2]
            },
            {
                "id": "p2",
                "title": "브랜치 전략 (Feature Branch)",
                "description": "- 새로운 기능을 개발할 때 사용\n- Main 브랜치를 안전하게 보호하고 싶을 때",
                "prompt": "# 새 기능 개발 시작\ngit branch feature/기능명\ngit switch feature/기능명\n\n# 개발 진행\ngit add .\ngit commit -m \"기능 설명\"\ngit push origin feature/기능명\n\n# GitHub에서 Pull Request 생성 → Merge\n# 또는 로컬에서 병합\ngit switch main\ngit pull origin main\ngit merge feature/기능명\ngit push origin main",
                "failurePatterns": "- ❌ 실수: Main 브랜치에서 직접 작업\n- ✅ 팁: 항상 \"feature\" 브랜치를 만드는 습관을 들이세요",
                "relatedStep": [6]
            },
            {
                "id": "p3",
                "title": "커밋 메시지 작성 가이드",
                "description": "- 커밋 메시지를 구체적으로 작성하고 싶을 때 사용\n- 팀원들이 내 커밋을 쉽게 이해하게 하고 싶을 때",
                "prompt": "❌ 나쁜 메시지:\n\"수정\"\n\"작업 완료\"\n\"버그\"\n\n✅ 좋은 메시지:\n\"로그인 기능 추가\"\n\"이메일 유효성 검증 버그 수정\"\n\"사용자 프로필 페이지 UI 개선\"\n\n📌 패턴:\n[타입] 메시지\n- feat: 새 기능 추가\n- fix: 버그 수정\n- docs: 문서 수정\n- style: 코드 포맷팅 (기능 변화 없음)\n- refactor: 코드 리팩토링\n\n예:\ngit commit -m \"feat: 로그인 기능 추가\"\ngit commit -m \"fix: 댓글 삭제 버그 수정\"",
                "failurePatterns": "- ❌ 실수: \"update\"라고만 씀\n- ✅ 팁: \"무엇을, 왜\" 바꿨는지 적으세요",
                "relatedStep": [5]
            },
            {
                "id": "p4",
                "title": "충돌 해결 (Merge Conflict) 기초",
                "description": "- Pull 할 때 충돌이 발생했을 때 사용\n- 당황하지 않고 차근차근 해결하고 싶을 때",
                "prompt": "# 충돌이 발생했을 때\ngit pull origin main\n\n# 충돌 파일 확인\ngit status\n\n# VS Code에서 파일을 열면:\n<<<<<<< HEAD\n(현재 로컬 코드)\n=======\n(GitHub의 코드)\n>>>>>>> origin/main\n\n# 수정:\n1. 두 코드 중 어느 것을 쓸지 선택\n2. <<<<, ====, >>>> 표시 삭제\n3. 저장\n\n# 충돌 해결\ngit add .\ngit commit -m \"Merge conflict resolved\"\ngit push origin main",
                "failurePatterns": "- ❌ 실수: 충돌 마커(<<<<)를 지우지 않고 커밋\n- ✅ 팁: 코드를 깔끔하게 정리한 후 커밋하세요",
                "relatedStep": [8]
            },
            {
                "id": "p5",
                "title": "실수 되돌리기",
                "description": "- 잘못 커밋했을 때\n- 이전 버전으로 돌아가고 싶을 때",
                "prompt": "📌 상황별 되돌리기\n\n1️⃣ 아직 Commit 전 (Add만 함)\n   git reset             # 모든 파일 unstage\n   git reset [파일명]    # 특정 파일만 unstage\n\n2️⃣ Commit했는데 Push 안 함\n   git reset HEAD~1      # 마지막 커밋 취소 (파일 유지)\n   git reset --hard HEAD~1  # 마지막 커밋 취소 (파일도 삭제)\n\n3️⃣ 이전 버전 코드 보기\n   git log --oneline     # 커밋 ID 확인\n   git show [커밋ID]     # 그 버전의 코드 확인\n\n4️⃣ 특정 커밋으로 완전히 돌아가기 (위험함)\n   git reset --hard [커밋ID]",
                "failurePatterns": "- ❌ 실수: reset --hard를 남발함 (데이터 삭제됨)\n- ✅ 팁: reset --hard는 신중하게 사용하세요",
                "relatedStep": [7]
            },
            {
                "id": "p6",
                "title": "GitHub 협업 플로우",
                "description": "- 팀 프로젝트 협업 시 전체 흐름을 보고 싶을 때",
                "prompt": "📌 GitHub 협업의 표준 플로우\n\n1️⃣ 저장소 Clone\n   git clone [URL]\n\n2️⃣ 새 브랜치에서 작업\n   git branch feature/기능명\n   git switch feature/기능명\n\n3️⃣ 코드 작성 + Commit\n   git add .\n   git commit -m \"기능 설명\"\n\n4️⃣ Push\n   git push origin feature/기능명\n\n5️⃣ GitHub에서 Pull Request (PR) 생성\n   - \"Pull requests\" 탭 → \"New Pull Request\"\n   - Base: main, Compare: feature/기능명\n   - \"Create Pull Request\" 클릭\n\n6️⃣ 코드 리뷰 (팀원들이 검토)\n   - 피드백 받음\n   - 필요하면 추가 수정 + Push\n\n7️⃣ Merge (팀장이 승인)\n   - GitHub에서 \"Merge Pull Request\" 클릭\n   - 브랜치 삭제\n\n8️⃣ 최신 코드 받기 (로컬)\n   - git switch main\n   - git pull origin main",
                "failurePatterns": "- ❌ 실수: PR 없이 바로 Main에 Push\n- ✅ 팁: PR을 통해 코드 리뷰를 받는 것이 협업의 핵심입니다",
                "relatedStep": [6, 8]
            }
        ]'::jsonb
    );

END $migration$;

COMMIT;
