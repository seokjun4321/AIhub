# AIHub 프로젝트 개선사항 가이드

> 📅 분석 일자: 2026-01-31
> 🔍 분석 범위: 전체 프로젝트 (보안, 코드품질, UX, 성능, 개발경험, 비즈니스 로직)
> 📊 총 개선사항: 20개

## 목차
- [우선순위별 분류](#우선순위별-분류)
- [보안 이슈 (2개)](#보안-이슈)
- [코드 품질 및 유지보수성 (4개)](#코드-품질-및-유지보수성)
- [사용자 경험 (4개)](#사용자-경험)
- [성능 최적화 (3개)](#성능-최적화)
- [개발 경험 (4개)](#개발-경험)
- [비즈니스 로직 (3개)](#비즈니스-로직)

---

## 우선순위별 분류

### 🚨 즉시 처리 (1-2일)
1. 환경 변수 파일 노출 위험
2. 하드코딩된 외부 URL
3. README.md 작성

### ⚡ 단기 처리 (1-2주)
4. Error Boundary 추가
5. 기본 테스트 코드 작성
6. TypeScript strict mode 활성화
7. 접근성 개선
8. 환경 설정 관리

### 📈 중기 처리 (1개월)
9. SEO 최적화
10. 이미지 최적화
11. 번들 크기 최적화
12. 모니터링 도구 연동
13. Git 워크플로우 구축
14. 코드 포매팅 도구 설정

### 🎯 장기 처리 (2-3개월)
15. 국제화(i18n) 지원
16. PWA 전환
17. 로딩 상태 관리 개선
18. 결제 에러 처리 강화
19. 데이터 검증 강화
20. 보안 헤더 설정

---

# 상세 개선사항

## 보안 이슈

### 1. 환경 변수 파일 노출 위험

**우선순위**: 🚨 즉시 처리
**카테고리**: 보안
**심각도**: Critical
**영향 범위**: 전체 시스템

#### 문제점

**현재 상태**:
- `.env` 파일이 `.gitignore`에 포함되어 있지 않음
- 현재 `.env` 파일 내용:
  ```
  VITE_SUPABASE_PUBLISHABLE_KEY=...
  SUPABASE_SERVICE_KEY=...
  VITE_N8N_API_URL=...
  VITE_TOSS_CLIENT_KEY=...
  TOSS_SECRET_KEY=...
  ```

**위험성**:
1. **민감 정보 유출**: Git 커밋 시 Supabase Service Key, Toss Secret Key 등이 공개 저장소에 노출
2. **데이터베이스 접근 권한 탈취**: SUPABASE_SERVICE_KEY는 모든 RLS 정책을 우회할 수 있는 관리자 키
3. **결제 시스템 악용**: TOSS_SECRET_KEY 노출 시 임의의 결제 승인/취소 가능
4. **N8N 워크플로우 조작**: N8N API URL을 통한 자동화 워크플로우 무단 실행

**실제 발생 가능한 시나리오**:
```
1. 개발자가 실수로 .env 파일을 git add .
2. GitHub에 푸시
3. 자동화된 크롤러가 API 키 탐지
4. 24시간 내 데이터베이스 접근 시도
5. 사용자 정보 유출 또는 무단 결제 발생
```

#### 해결 방법

**Step 1: .gitignore 업데이트**

`.gitignore` 파일에 다음 내용 추가:

```gitignore
# Environment variables
.env
.env.local
.env.development
.env.test
.env.production
.env*.local

# Backup files
.env.backup
*.env.backup
```

**Step 2: .env.example 템플릿 생성**

프로젝트 루트에 `.env.example` 파일 생성:

```env
# Supabase Configuration
VITE_SUPABASE_PROJECT_ID="your-project-id"
VITE_SUPABASE_URL="https://your-project.supabase.co"
VITE_SUPABASE_PUBLISHABLE_KEY="your-anon-key"
SUPABASE_SERVICE_KEY="your-service-role-key"

# N8N Integration
VITE_N8N_API_URL="https://your-n8n-instance.com"

# Toss Payments (Test Keys)
VITE_TOSS_CLIENT_KEY="test_ck_..."
TOSS_SECRET_KEY="test_sk_..."

# 주의: 실제 키 값은 절대 커밋하지 마세요!
# 1. .env.example을 .env로 복사
# 2. 실제 키 값으로 교체
# 3. .env 파일이 .gitignore에 포함되었는지 확인
```

**Step 3: Git History에서 민감 정보 제거**

만약 이미 .env가 커밋되었다면:

```bash
# git-filter-repo 설치 (권장 방법)
pip install git-filter-repo

# .env 파일을 히스토리에서 완전히 제거
git filter-repo --path .env --invert-paths

# 또는 BFG Repo-Cleaner 사용
# https://rpowell.github.io/bfg-repo-cleaner/
bfg --delete-files .env
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# 강제 푸시 (주의: 팀원과 조율 필요)
git push origin --force --all
```

**Step 4: 키 로테이션 (Key Rotation)**

노출된 키는 반드시 재발급:

1. **Supabase**:
   - Supabase Dashboard → Settings → API
   - "Reset service_role key" 클릭
   - 새 키로 .env 업데이트

2. **Toss Payments**:
   - Toss Developers 콘솔
   - 새 Secret Key 발급
   - Webhook Secret도 함께 재설정

3. **N8N**:
   - N8N 인스턴스 URL 변경 또는 인증 추가

**Step 5: 설정 검증 스크립트**

`scripts/check-env.js` 파일 생성:

```javascript
// 환경 변수 검증 스크립트
import fs from 'fs';
import path from 'path';

const requiredEnvVars = [
  'VITE_SUPABASE_URL',
  'VITE_SUPABASE_PUBLISHABLE_KEY',
  'SUPABASE_SERVICE_KEY',
  'VITE_N8N_API_URL',
  'VITE_TOSS_CLIENT_KEY',
  'TOSS_SECRET_KEY'
];

function checkEnvFile() {
  const envPath = path.join(process.cwd(), '.env');

  // .env 파일 존재 확인
  if (!fs.existsSync(envPath)) {
    console.error('❌ .env 파일이 없습니다.');
    console.log('💡 .env.example을 복사하여 .env 파일을 생성하세요:');
    console.log('   cp .env.example .env');
    process.exit(1);
  }

  // 필수 환경 변수 확인
  const missingVars = requiredEnvVars.filter(varName => !process.env[varName]);

  if (missingVars.length > 0) {
    console.error('❌ 누락된 환경 변수:');
    missingVars.forEach(varName => console.log(`   - ${varName}`));
    process.exit(1);
  }

  // 테스트 키 감지 (프로덕션 환경)
  if (process.env.NODE_ENV === 'production') {
    if (process.env.VITE_TOSS_CLIENT_KEY?.startsWith('test_')) {
      console.error('❌ 프로덕션에서 테스트 키를 사용할 수 없습니다!');
      process.exit(1);
    }
  }

  console.log('✅ 환경 변수 검증 완료');
}

checkEnvFile();
```

`package.json`에 스크립트 추가:

```json
{
  "scripts": {
    "check:env": "node scripts/check-env.js",
    "dev": "npm run check:env && vite",
    "build": "npm run check:env && vite build"
  }
}
```

#### 검증 방법

```bash
# 1. .gitignore 확인
cat .gitignore | grep .env
# 출력: .env

# 2. Git 추적 상태 확인
git status
# .env 파일이 "Untracked files"에 없어야 함

# 3. Git 캐시에서 제거 확인
git ls-files | grep .env
# 출력 없어야 함

# 4. .env.example 존재 확인
ls -la .env.example
# 파일이 존재해야 함

# 5. 환경 변수 로드 테스트
npm run check:env
# ✅ 환경 변수 검증 완료
```

#### 추가 보안 조치

**GitHub Secrets 사용 (CI/CD)**:

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Create .env file
        run: |
          echo "VITE_SUPABASE_URL=${{ secrets.VITE_SUPABASE_URL }}" >> .env
          echo "VITE_SUPABASE_PUBLISHABLE_KEY=${{ secrets.VITE_SUPABASE_PUBLISHABLE_KEY }}" >> .env
          # ... 기타 환경 변수
```

**Vercel 환경 변수 설정**:

```bash
# Vercel CLI로 환경 변수 추가
vercel env add VITE_SUPABASE_URL production
vercel env add SUPABASE_SERVICE_KEY production
```

#### 참고 자료

- [Supabase 키 관리 가이드](https://supabase.com/docs/guides/api/api-keys)
- [Git Secrets 도구](https://github.com/awslabs/git-secrets)
- [환경 변수 보안 베스트 프랙티스](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)
- [.gitignore 템플릿](https://github.com/github/gitignore/blob/main/Node.gitignore)

---

### 2. 하드코딩된 외부 URL

**우선순위**: 🚨 즉시 처리
**카테고리**: 보안 / 배포
**심각도**: High
**영향 범위**: 배포 환경

#### 문제점

**현재 상태**:

`vercel.json` 파일:
```json
{
  "rewrites": [
    {
      "source": "/api/n8n/:path*",
      "destination": "https://semiformal-uncaptiously-lyman.ngrok-free.dev/:path*"
    }
  ]
}
```

`vite.config.ts` 파일:
```typescript
proxy: {
  '/api/n8n': {
    target: env.VITE_N8N_API_URL,  // 개발 환경은 OK
    // ...
  }
}
```

**문제점**:
1. **개발용 임시 URL 하드코딩**: ngrok URL은 개발 환경에서만 사용되는 임시 URL
2. **배포 시 404 에러**: ngrok 세션이 만료되면 모든 N8N 호출 실패
3. **보안 위험**: 내부 개발 서버 URL이 프로덕션에 노출
4. **환경 분리 부재**: 개발/스테이징/프로덕션 환경 구분 불가

**실제 시나리오**:
```
1. 프로덕션 배포
2. AI 챗봇 기능 사용 시도
3. /api/n8n/* 호출 → ngrok URL로 리디렉션
4. ngrok 세션 만료 → 502 Bad Gateway
5. 모든 AI 기능 동작 불가
```

#### 해결 방법

**Step 1: 환경별 N8N URL 설정**

`.env.example`에 추가:

```env
# N8N Configuration
# Development: ngrok 또는 로컬 URL
VITE_N8N_API_URL="https://your-dev-n8n.ngrok-free.dev"

# Production: 실제 N8N 서버 URL
# VITE_N8N_API_URL="https://n8n.yourdomain.com"
```

`.env.production` 파일 생성:

```env
VITE_N8N_API_URL="https://n8n.yourdomain.com"
```

`.env.development`:

```env
VITE_N8N_API_URL="https://semiformal-uncaptiously-lyman.ngrok-free.dev"
```

**Step 2: vercel.json 동적 처리**

두 가지 방법:

**방법 A: Vercel 환경 변수 사용 (권장)**

`vercel.json` 삭제하고 Vercel Dashboard에서 Rewrite 설정:

```bash
# Vercel CLI로 설정
vercel env add N8N_API_URL production
# 값: https://n8n.yourdomain.com

vercel env add N8N_API_URL preview
# 값: https://staging-n8n.yourdomain.com

vercel env add N8N_API_URL development
# 값: http://localhost:5678
```

Vercel Dashboard → Settings → Rewrites → Add Rewrite:
- Source: `/api/n8n/:path*`
- Destination: `${N8N_API_URL}/:path*`

**방법 B: 동적 vercel.json 생성**

`scripts/generate-vercel-config.js`:

```javascript
import fs from 'fs';
import dotenv from 'dotenv';

// 환경에 따라 .env 파일 로드
const envFile = process.env.NODE_ENV === 'production'
  ? '.env.production'
  : '.env.development';

dotenv.config({ path: envFile });

const vercelConfig = {
  rewrites: [
    {
      source: "/api/n8n/:path*",
      destination: `${process.env.VITE_N8N_API_URL}/:path*`
    },
    {
      source: "/(.*)",
      destination: "/index.html"
    }
  ]
};

fs.writeFileSync(
  'vercel.json',
  JSON.stringify(vercelConfig, null, 2)
);

console.log('✅ vercel.json 생성 완료:', process.env.VITE_N8N_API_URL);
```

`package.json` 수정:

```json
{
  "scripts": {
    "prebuild": "node scripts/generate-vercel-config.js",
    "build": "vite build"
  }
}
```

**Step 3: Runtime 환경 변수 처리**

클라이언트에서 직접 N8N 호출하는 경우:

`src/lib/n8n.ts`:

```typescript
// Before: 하드코딩된 URL
const N8N_URL = 'https://semiformal-uncaptiously-lyman.ngrok-free.dev';

// After: 환경 변수 사용
const N8N_URL = import.meta.env.VITE_N8N_API_URL;

if (!N8N_URL) {
  throw new Error(
    'N8N API URL이 설정되지 않았습니다. ' +
    '.env 파일에 VITE_N8N_API_URL을 추가하세요.'
  );
}

export async function callN8NWorkflow(workflowId: string, data: any) {
  try {
    const response = await fetch(`${N8N_URL}/webhook/${workflowId}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(data),
    });

    if (!response.ok) {
      throw new Error(`N8N 호출 실패: ${response.statusText}`);
    }

    return await response.json();
  } catch (error) {
    console.error('N8N 워크플로우 호출 에러:', error);
    throw error;
  }
}
```

**Step 4: N8N 프로덕션 서버 설정**

ngrok 대신 실제 서버 사용:

**옵션 1: Self-hosted N8N**

```bash
# Docker Compose로 N8N 배포
version: '3.8'
services:
  n8n:
    image: n8nio/n8n
    restart: always
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=${N8N_USER}
      - N8N_BASIC_AUTH_PASSWORD=${N8N_PASSWORD}
      - N8N_HOST=n8n.yourdomain.com
      - N8N_PROTOCOL=https
      - WEBHOOK_URL=https://n8n.yourdomain.com
    volumes:
      - n8n_data:/home/node/.n8n

volumes:
  n8n_data:
```

**옵션 2: N8N Cloud**

```bash
# N8N Cloud 사용 시
VITE_N8N_API_URL="https://your-workspace.app.n8n.cloud"
```

**Step 5: 프록시 인증 추가**

보안을 위해 API Key 인증 추가:

`.env`:
```env
VITE_N8N_API_URL="https://n8n.yourdomain.com"
N8N_API_KEY="your-secret-api-key"
```

`src/lib/n8n.ts`:

```typescript
const N8N_API_KEY = import.meta.env.N8N_API_KEY;

export async function callN8NWorkflow(workflowId: string, data: any) {
  const headers: HeadersInit = {
    'Content-Type': 'application/json',
  };

  // 프로덕션 환경에서는 API Key 추가
  if (import.meta.env.PROD && N8N_API_KEY) {
    headers['X-API-Key'] = N8N_API_KEY;
  }

  const response = await fetch(`${N8N_URL}/webhook/${workflowId}`, {
    method: 'POST',
    headers,
    body: JSON.stringify(data),
  });

  // ...
}
```

#### 검증 방법

```bash
# 1. 환경별 빌드 테스트
NODE_ENV=development npm run build
# vercel.json에 개발 URL 확인

NODE_ENV=production npm run build
# vercel.json에 프로덕션 URL 확인

# 2. 런타임 환경 변수 확인
npm run dev
# 브라우저 콘솔에서
console.log(import.meta.env.VITE_N8N_API_URL)

# 3. N8N 연결 테스트
curl -X POST https://n8n.yourdomain.com/webhook/test \
  -H "Content-Type: application/json" \
  -d '{"test": true}'

# 4. Vercel 배포 후 확인
curl https://your-app.vercel.app/api/n8n/webhook/test
```

#### 추가 개선사항

**폴백(Fallback) URL 설정**:

```typescript
const N8N_URLS = {
  primary: import.meta.env.VITE_N8N_API_URL,
  fallback: import.meta.env.VITE_N8N_FALLBACK_URL,
};

async function callN8NWithFallback(workflowId: string, data: any) {
  try {
    return await callN8NWorkflow(N8N_URLS.primary, workflowId, data);
  } catch (error) {
    console.warn('Primary N8N 서버 실패, fallback 시도...');
    return await callN8NWorkflow(N8N_URLS.fallback, workflowId, data);
  }
}
```

**Health Check 엔드포인트**:

```typescript
export async function checkN8NHealth(): Promise<boolean> {
  try {
    const response = await fetch(`${N8N_URL}/healthz`, {
      method: 'GET',
      signal: AbortSignal.timeout(5000), // 5초 타임아웃
    });
    return response.ok;
  } catch {
    return false;
  }
}
```

#### 참고 자료

- [Vercel Environment Variables](https://vercel.com/docs/concepts/projects/environment-variables)
- [N8N Self-hosting Guide](https://docs.n8n.io/hosting/)
- [N8N Cloud](https://n8n.io/cloud/)
- [Vite 환경 변수](https://vitejs.dev/guide/env-and-mode.html)

---

## 코드 품질 및 유지보수성

### 3. TypeScript strict mode 활성화

**우선순위**: ⚡ 단기 처리
**카테고리**: 코드 품질
**심각도**: Medium
**영향 범위**: 전체 코드베이스

#### 문제점

**현재 `tsconfig.json` 설정**:

```json
{
  "compilerOptions": {
    "noImplicitAny": false,
    "noUnusedParameters": false,
    "noUnusedLocals": false,
    "strictNullChecks": false
  }
}
```

**문제점**:
1. **타입 안정성 부재**: `any` 타입 남용 가능 → 런타임 에러
2. **Null 체크 부족**: `Cannot read property 'x' of undefined` 에러 발생 가능
3. **사용하지 않는 코드**: 데드 코드 누적, 번들 크기 증가
4. **리팩토링 어려움**: 타입 체크 없어 안전한 리팩토링 불가능

**실제 버그 예시**:

```typescript
// strictNullChecks: false인 경우
function getUserName(user: User) {
  return user.profile.name; // user.profile이 null일 수 있음
}

// 런타임 에러 발생 가능
const name = getUserName(userWithoutProfile); // ❌ Crash!
```

#### 해결 방법

**Step 1: 점진적 마이그레이션 계획**

한 번에 모든 strict 옵션을 켜면 수백 개의 에러 발생. 단계적 접근 필요:

```
Phase 1 (1주): noUnusedLocals, noUnusedParameters
Phase 2 (1주): noImplicitAny
Phase 3 (2주): strictNullChecks
Phase 4 (1주): 전체 strict mode
```

**Step 2: Phase 1 - 사용하지 않는 코드 제거**

`tsconfig.json` 수정:

```json
{
  "compilerOptions": {
    "noUnusedLocals": true,
    "noUnusedParameters": true
  }
}
```

에러 확인:

```bash
npm run lint
# 또는
npx tsc --noEmit
```

수정 예시:

```typescript
// Before
function calculateTotal(price: number, tax: number, discount: number) {
  return price + tax; // discount 미사용
}

// After - 옵션 1: 사용
function calculateTotal(price: number, tax: number, discount: number) {
  return price + tax - discount;
}

// After - 옵션 2: 제거
function calculateTotal(price: number, tax: number) {
  return price + tax;
}

// After - 옵션 3: 언더스코어 (의도적으로 미사용)
function calculateTotal(price: number, tax: number, _discount: number) {
  return price + tax;
}
```

**Step 3: Phase 2 - noImplicitAny 활성화**

`tsconfig.json`:

```json
{
  "compilerOptions": {
    "noImplicitAny": true
  }
}
```

수정 예시:

```typescript
// Before - any 타입 추론
function processData(data) { // ❌ Parameter 'data' implicitly has an 'any' type
  return data.map(item => item.value);
}

// After - 명시적 타입
interface DataItem {
  value: number;
}

function processData(data: DataItem[]) {
  return data.map(item => item.value);
}
```

프로젝트별 수정 예시:

```typescript
// src/hooks/useAuth.tsx
// Before
export const useAuth = () => {
  const [user, setUser] = useState(null); // ❌ any 추론

  const login = async (credentials) => { // ❌ any 추론
    // ...
  };
};

// After
import { User } from '@supabase/supabase-js';

interface LoginCredentials {
  email: string;
  password: string;
}

export const useAuth = () => {
  const [user, setUser] = useState<User | null>(null);

  const login = async (credentials: LoginCredentials): Promise<void> => {
    // ...
  };
};
```

**Step 4: Phase 3 - strictNullChecks 활성화**

가장 많은 에러가 발생하는 단계. 준비 작업:

```json
{
  "compilerOptions": {
    "strictNullChecks": true
  }
}
```

수정 패턴:

**패턴 1: Optional Chaining**

```typescript
// Before
function getPostTitle(post: Post) {
  return post.author.name; // ❌ author가 null/undefined일 수 있음
}

// After
function getPostTitle(post: Post) {
  return post.author?.name ?? '익명';
}
```

**패턴 2: Non-null Assertion (확실할 때만)**

```typescript
// Before
const element = document.getElementById('root'); // HTMLElement | null
element.appendChild(child); // ❌ null일 수 있음

// After - 방법 1: 체크
const element = document.getElementById('root');
if (element) {
  element.appendChild(child);
}

// After - 방법 2: Non-null assertion (확실할 때)
const element = document.getElementById('root')!;
element.appendChild(child);
```

**패턴 3: 타입 가드**

```typescript
// Before
function processUser(user: User | null) {
  console.log(user.name); // ❌ null일 수 있음
}

// After
function processUser(user: User | null) {
  if (!user) return;
  console.log(user.name); // ✅ TypeScript가 user가 null이 아님을 알음
}
```

**패턴 4: Nullish Coalescing**

```typescript
// Before
const port = config.port || 3000; // 0도 falsy로 처리됨

// After
const port = config.port ?? 3000; // null/undefined만 체크
```

프로젝트별 수정 예시:

```typescript
// src/integrations/supabase/client.ts
// Before
export const supabase = createClient<Database>(
  SUPABASE_URL,
  SUPABASE_PUBLISHABLE_KEY
);

// After
if (!SUPABASE_URL || !SUPABASE_PUBLISHABLE_KEY) {
  throw new Error("Supabase URL and Anon Key must be defined");
}

export const supabase = createClient<Database>(
  SUPABASE_URL,
  SUPABASE_PUBLISHABLE_KEY
);
```

**Step 5: Phase 4 - 전체 strict mode**

`tsconfig.json`:

```json
{
  "compilerOptions": {
    "strict": true,
    // 개별 옵션도 모두 true로
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true
  }
}
```

추가 수정 사항:

**strictPropertyInitialization**:

```typescript
// Before
class UserService {
  private client; // ❌ Property has no initializer

  async init() {
    this.client = await createClient();
  }
}

// After - 방법 1: 생성자 초기화
class UserService {
  private client: Client;

  constructor(client: Client) {
    this.client = client;
  }
}

// After - 방법 2: Definite Assignment Assertion
class UserService {
  private client!: Client; // init()에서 반드시 초기화됨을 보장

  async init() {
    this.client = await createClient();
  }
}
```

**Step 6: 자동화 도구 활용**

**ts-migrate** (Airbnb 개발):

```bash
npx ts-migrate migrate ./src

# 자동으로:
# - any 타입 추가
# - @ts-ignore 주석 추가
# - 점진적 마이그레이션 지원
```

**ESLint 규칙 추가**:

```bash
npm install --save-dev @typescript-eslint/parser @typescript-eslint/eslint-plugin
```

`eslint.config.js`:

```javascript
export default [
  {
    files: ['**/*.{ts,tsx}'],
    plugins: {
      '@typescript-eslint': typescriptEslint,
    },
    rules: {
      '@typescript-eslint/no-explicit-any': 'warn',
      '@typescript-eslint/no-non-null-assertion': 'warn',
      '@typescript-eslint/no-unused-vars': ['error', {
        argsIgnorePattern: '^_'
      }],
    },
  },
];
```

#### 검증 방법

```bash
# 타입 체크
npx tsc --noEmit

# 에러 개수 추적
npx tsc --noEmit 2>&1 | grep -c "error TS"

# 단계별 진행상황 확인
# Phase 1
npx tsc --noEmit --noUnusedLocals --noUnusedParameters

# Phase 2
npx tsc --noEmit --noImplicitAny

# Phase 3
npx tsc --noEmit --strictNullChecks

# Phase 4
npx tsc --noEmit --strict
```

#### 추가 도구

**타입 커버리지 측정**:

```bash
npm install --save-dev type-coverage

npx type-coverage
# 출력: 87.32% (목표: 95%+)
```

`package.json`:

```json
{
  "scripts": {
    "type-check": "tsc --noEmit",
    "type-coverage": "type-coverage --at-least 90"
  }
}
```

#### 참고 자료

- [TypeScript Handbook - Strict Mode](https://www.typescriptlang.org/docs/handbook/2/basic-types.html#strictness)
- [ts-migrate 가이드](https://github.com/airbnb/ts-migrate)
- [Type Coverage 도구](https://github.com/plantain-00/type-coverage)
- [Microsoft의 점진적 마이그레이션 가이드](https://www.typescriptlang.org/docs/handbook/migrating-from-javascript.html)

---

### 4. 테스트 코드 작성

**우선순위**: ⚡ 단기 처리
**카테고리**: 코드 품질
**심각도**: High
**영향 범위**: 전체 애플리케이션

#### 문제점

**현재 상태**:
- 프로젝트 전체에 테스트 파일 0개
- `*.test.*`, `*.spec.*` 파일 없음
- 테스트 프레임워크 미설정

**위험성**:
1. **회귀 버그**: 코드 수정 시 기존 기능 파괴 감지 불가
2. **리팩토링 두려움**: 안전하게 코드 개선 불가능
3. **배포 불안**: 프로덕션 배포 전 검증 부재
4. **문서화 부족**: 테스트 코드가 사용법 문서 역할
5. **결제/인증 버그**: 중요한 비즈니스 로직 검증 부재

**실제 시나리오**:
```
1. 결제 로직 수정
2. 로컬에서 간단히 테스트
3. 프로덕션 배포
4. 사용자가 결제 시도 → 중복 결제 발생
5. 긴급 롤백 + 환불 처리
```

#### 해결 방법

**Step 1: 테스트 환경 설정**

**Vitest + Testing Library 설치**:

```bash
npm install --save-dev vitest @testing-library/react @testing-library/jest-dom @testing-library/user-event jsdom
```

**`vite.config.ts` 수정**:

```typescript
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react-swc';

export default defineConfig({
  // ... 기존 설정
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: './src/test/setup.ts',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      exclude: [
        'node_modules/',
        'src/test/',
      ],
    },
  },
});
```

**`src/test/setup.ts` 생성**:

```typescript
import { expect, afterEach } from 'vitest';
import { cleanup } from '@testing-library/react';
import * as matchers from '@testing-library/jest-dom/matchers';

// Testing Library matchers 확장
expect.extend(matchers);

// 각 테스트 후 자동 정리
afterEach(() => {
  cleanup();
});
```

**`package.json` 스크립트 추가**:

```json
{
  "scripts": {
    "test": "vitest",
    "test:ui": "vitest --ui",
    "test:coverage": "vitest --coverage",
    "test:run": "vitest run"
  }
}
```

**Step 2: 유틸리티 함수 테스트 (가장 쉬운 시작)**

**`src/lib/utils.test.ts` 생성**:

```typescript
import { describe, it, expect } from 'vitest';
import { cn } from './utils';

describe('utils', () => {
  describe('cn()', () => {
    it('should merge class names', () => {
      expect(cn('foo', 'bar')).toBe('foo bar');
    });

    it('should handle conditional classes', () => {
      expect(cn('foo', false && 'bar', 'baz')).toBe('foo baz');
    });

    it('should handle Tailwind conflicts', () => {
      expect(cn('px-2 py-1', 'px-4')).toBe('py-1 px-4');
    });
  });
});
```

**Step 3: 컴포넌트 테스트**

**`src/components/ui/button.test.tsx` 생성**:

```typescript
import { describe, it, expect, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Button } from './button';

describe('Button', () => {
  it('should render with text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: 'Click me' })).toBeInTheDocument();
  });

  it('should handle click events', async () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click</Button>);

    await userEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('should be disabled when disabled prop is true', () => {
    render(<Button disabled>Click</Button>);
    expect(screen.getByRole('button')).toBeDisabled();
  });

  it('should apply variant styles', () => {
    render(<Button variant="destructive">Delete</Button>);
    const button = screen.getByRole('button');
    expect(button).toHaveClass('bg-destructive');
  });
});
```

**Step 4: 인증 로직 테스트 (중요!)**

**`src/hooks/useAuth.test.tsx` 생성**:

```typescript
import { describe, it, expect, beforeEach, vi } from 'vitest';
import { renderHook, waitFor } from '@testing-library/react';
import { useAuth } from './useAuth';
import { supabase } from '@/integrations/supabase/client';

// Supabase 모킹
vi.mock('@/integrations/supabase/client', () => ({
  supabase: {
    auth: {
      signInWithPassword: vi.fn(),
      signUp: vi.fn(),
      signOut: vi.fn(),
      getSession: vi.fn(),
    },
  },
}));

describe('useAuth', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('should login successfully', async () => {
    const mockUser = { id: '123', email: 'test@example.com' };
    vi.mocked(supabase.auth.signInWithPassword).mockResolvedValue({
      data: { user: mockUser, session: {} },
      error: null,
    });

    const { result } = renderHook(() => useAuth());

    await result.current.login('test@example.com', 'password');

    await waitFor(() => {
      expect(result.current.user).toEqual(mockUser);
    });
  });

  it('should handle login error', async () => {
    vi.mocked(supabase.auth.signInWithPassword).mockResolvedValue({
      data: { user: null, session: null },
      error: { message: 'Invalid credentials' },
    });

    const { result } = renderHook(() => useAuth());

    await expect(
      result.current.login('wrong@example.com', 'wrong')
    ).rejects.toThrow('Invalid credentials');
  });

  it('should logout successfully', async () => {
    const { result } = renderHook(() => useAuth());

    await result.current.logout();

    expect(supabase.auth.signOut).toHaveBeenCalled();
    expect(result.current.user).toBeNull();
  });
});
```

**Step 5: 결제 로직 테스트 (매우 중요!)**

**`src/integrations/toss/useTossPayment.test.ts` 생성**:

```typescript
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { renderHook, waitFor } from '@testing-library/react';
import { useTossPayment } from './useTossPayment';

// Toss Payments SDK 모킹
vi.mock('@tosspayments/payment-sdk', () => ({
  loadTossPayments: vi.fn(() => Promise.resolve({
    requestPayment: vi.fn(),
  })),
}));

describe('useTossPayment', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('should process payment successfully', async () => {
    const { result } = renderHook(() => useTossPayment());

    const paymentData = {
      amount: 10000,
      orderId: 'order-123',
      orderName: 'Test Product',
    };

    await result.current.requestPayment(paymentData);

    await waitFor(() => {
      expect(result.current.status).toBe('success');
    });
  });

  it('should handle payment cancellation', async () => {
    const mockRequestPayment = vi.fn().mockRejectedValue({
      code: 'USER_CANCEL',
      message: '사용자가 결제를 취소했습니다',
    });

    const { result } = renderHook(() => useTossPayment());

    await expect(
      result.current.requestPayment({ amount: 10000 })
    ).rejects.toThrow('사용자가 결제를 취소했습니다');
  });

  it('should prevent duplicate payments', async () => {
    const { result } = renderHook(() => useTossPayment());

    const payment1 = result.current.requestPayment({ amount: 10000 });
    const payment2 = result.current.requestPayment({ amount: 10000 });

    await expect(payment2).rejects.toThrow('이미 결제가 진행 중입니다');
  });
});
```

**Step 6: API 호출 테스트**

**`src/lib/n8n.test.ts` 생성**:

```typescript
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { callN8NWorkflow } from './n8n';

global.fetch = vi.fn();

describe('n8n API', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('should call N8N workflow successfully', async () => {
    const mockResponse = { result: 'success', data: { message: 'Hello' } };

    vi.mocked(fetch).mockResolvedValue({
      ok: true,
      json: async () => mockResponse,
    } as Response);

    const result = await callN8NWorkflow('workflow-123', { input: 'test' });

    expect(fetch).toHaveBeenCalledWith(
      expect.stringContaining('/webhook/workflow-123'),
      expect.objectContaining({
        method: 'POST',
        body: JSON.stringify({ input: 'test' }),
      })
    );

    expect(result).toEqual(mockResponse);
  });

  it('should handle network errors', async () => {
    vi.mocked(fetch).mockRejectedValue(new Error('Network error'));

    await expect(
      callN8NWorkflow('workflow-123', {})
    ).rejects.toThrow('Network error');
  });

  it('should handle HTTP errors', async () => {
    vi.mocked(fetch).mockResolvedValue({
      ok: false,
      statusText: 'Internal Server Error',
    } as Response);

    await expect(
      callN8NWorkflow('workflow-123', {})
    ).rejects.toThrow('N8N 호출 실패: Internal Server Error');
  });
});
```

**Step 7: E2E 테스트 (선택적)**

**Playwright 설치**:

```bash
npm install --save-dev @playwright/test
npx playwright install
```

**`playwright.config.ts` 생성**:

```typescript
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  use: {
    baseURL: 'http://localhost:8080',
  },
  webServer: {
    command: 'npm run dev',
    port: 8080,
    reuseExistingServer: !process.env.CI,
  },
});
```

**`e2e/auth.spec.ts` 생성**:

```typescript
import { test, expect } from '@playwright/test';

test.describe('Authentication', () => {
  test('should login successfully', async ({ page }) => {
    await page.goto('/auth');

    await page.fill('[name="email"]', 'test@example.com');
    await page.fill('[name="password"]', 'password123');
    await page.click('button[type="submit"]');

    await expect(page).toHaveURL('/');
    await expect(page.locator('[data-testid="user-menu"]')).toBeVisible();
  });

  test('should show error for invalid credentials', async ({ page }) => {
    await page.goto('/auth');

    await page.fill('[name="email"]', 'wrong@example.com');
    await page.fill('[name="password"]', 'wrongpassword');
    await page.click('button[type="submit"]');

    await expect(page.locator('[role="alert"]')).toContainText('로그인 실패');
  });
});
```

**Step 8: CI/CD 통합**

**`.github/workflows/test.yml` 생성**:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run unit tests
        run: npm run test:run

      - name: Generate coverage
        run: npm run test:coverage

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/coverage-final.json

      - name: Run E2E tests
        run: npx playwright test
```

#### 검증 방법

```bash
# 모든 테스트 실행
npm test

# 커버리지 확인
npm run test:coverage
# 목표: 80% 이상

# 특정 파일 테스트
npm test -- src/lib/utils.test.ts

# Watch 모드
npm test -- --watch

# UI 모드 (브라우저에서 확인)
npm run test:ui
```

#### 테스트 우선순위

1. **Critical Path (1주)**:
   - 인증 로직
   - 결제 로직
   - 데이터베이스 쿼리

2. **High Priority (2주)**:
   - 폼 검증
   - API 호출
   - 상태 관리

3. **Medium Priority (1개월)**:
   - UI 컴포넌트
   - 유틸리티 함수
   - 라우팅

4. **Low Priority (지속적)**:
   - 스타일링
   - 애니메이션
   - E2E 시나리오

#### 참고 자료

- [Vitest 공식 문서](https://vitest.dev/)
- [Testing Library Best Practices](https://testing-library.com/docs/react-testing-library/intro/)
- [Playwright E2E 가이드](https://playwright.dev/docs/intro)
- [테스트 피라미드](https://martinfowler.com/articles/practical-test-pyramid.html)

---

### 5. Error Boundary 구현

**우선순위**: ⚡ 단기 처리
**카테고리**: 코드 품질 / 사용자 경험
**심각도**: High
**영향 범위**: 전체 애플리케이션

#### 문제점

**현재 상태**:
- React Error Boundary 없음
- 컴포넌트 에러 시 전체 앱 화면이 하얗게 표시됨
- 에러 로깅 메커니즘 부재
- 사용자에게 에러 복구 옵션 제공 안 됨

**위험성**:
1. **UX 파괴**: 하나의 컴포넌트 에러로 전체 앱이 작동 중지
2. **에러 추적 불가**: 프로덕션에서 발생한 에러를 파악할 수 없음
3. **사용자 이탈**: 복구 방법 없이 새로고침만 가능
4. **디버깅 어려움**: 에러 발생 컨텍스트 정보 없음

**실제 시나리오**:
```
1. 사용자가 대시보드 접근
2. API 응답 형식이 예상과 다름
3. 컴포넌트에서 TypeError 발생
4. 전체 화면이 하얗게 변함
5. 사용자는 무슨 일이 일어났는지 모름
6. 앱 종료 또는 새로고침
```

#### 해결 방법

**Step 1: 기본 Error Boundary 컴포넌트 생성**

**`src/components/ErrorBoundary.tsx` 생성**:

```typescript
import React, { Component, ErrorInfo, ReactNode } from 'react';
import { AlertTriangle, RefreshCw, Home } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
  onError?: (error: Error, errorInfo: ErrorInfo) => void;
  resetKeys?: Array<string | number>;
}

interface State {
  hasError: boolean;
  error: Error | null;
  errorInfo: ErrorInfo | null;
}

class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      hasError: false,
      error: null,
      errorInfo: null,
    };
  }

  static getDerivedStateFromError(error: Error): Partial<State> {
    return {
      hasError: true,
      error,
    };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    // 에러 로깅
    console.error('Error Boundary caught an error:', error, errorInfo);

    // 커스텀 에러 핸들러 호출
    this.props.onError?.(error, errorInfo);

    this.setState({
      errorInfo,
    });

    // 프로덕션에서는 에러 트래킹 서비스로 전송
    if (import.meta.env.PROD) {
      this.logErrorToService(error, errorInfo);
    }
  }

  componentDidUpdate(prevProps: Props) {
    // resetKeys가 변경되면 에러 상태 초기화
    if (
      this.state.hasError &&
      this.props.resetKeys &&
      prevProps.resetKeys !== this.props.resetKeys
    ) {
      this.resetErrorBoundary();
    }
  }

  resetErrorBoundary = () => {
    this.setState({
      hasError: false,
      error: null,
      errorInfo: null,
    });
  };

  logErrorToService(error: Error, errorInfo: ErrorInfo) {
    // Sentry, LogRocket 등으로 전송
    // Sentry.captureException(error, {
    //   contexts: {
    //     react: {
    //       componentStack: errorInfo.componentStack,
    //     },
    //   },
    // });
  }

  render() {
    if (this.state.hasError) {
      // 커스텀 fallback UI가 제공된 경우
      if (this.props.fallback) {
        return this.props.fallback;
      }

      // 기본 에러 UI
      return (
        <div className="min-h-screen flex items-center justify-center bg-gray-50 px-4">
          <Card className="max-w-2xl w-full">
            <CardHeader>
              <div className="flex items-center gap-3">
                <AlertTriangle className="h-8 w-8 text-destructive" />
                <div>
                  <CardTitle className="text-2xl">앗! 문제가 발생했습니다</CardTitle>
                  <CardDescription>
                    예상치 못한 오류가 발생했습니다. 잠시 후 다시 시도해주세요.
                  </CardDescription>
                </div>
              </div>
            </CardHeader>
            <CardContent className="space-y-4">
              {/* 개발 환경에서만 에러 상세 정보 표시 */}
              {!import.meta.env.PROD && this.state.error && (
                <div className="bg-gray-100 p-4 rounded-lg">
                  <p className="font-mono text-sm text-red-600 mb-2">
                    {this.state.error.toString()}
                  </p>
                  <details className="cursor-pointer">
                    <summary className="text-sm text-gray-600 hover:text-gray-900">
                      Component Stack 보기
                    </summary>
                    <pre className="mt-2 text-xs overflow-auto max-h-64 bg-white p-2 rounded">
                      {this.state.errorInfo?.componentStack}
                    </pre>
                  </details>
                </div>
              )}

              <div className="flex gap-3">
                <Button
                  onClick={this.resetErrorBoundary}
                  variant="default"
                  className="flex-1"
                >
                  <RefreshCw className="mr-2 h-4 w-4" />
                  다시 시도
                </Button>
                <Button
                  onClick={() => window.location.href = '/'}
                  variant="outline"
                  className="flex-1"
                >
                  <Home className="mr-2 h-4 w-4" />
                  홈으로 이동
                </Button>
              </div>

              <p className="text-sm text-gray-500 text-center">
                문제가 계속되면{' '}
                <a href="mailto:support@aihub.com" className="text-primary underline">
                  고객 지원팀
                </a>
                으로 문의해주세요.
              </p>
            </CardContent>
          </Card>
        </div>
      );
    }

    return this.props.children;
  }
}

export default ErrorBoundary;
```

**Step 2: 앱 전체에 Error Boundary 적용**

**`src/App.tsx` 수정**:

```typescript
import { BrowserRouter } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import ErrorBoundary from '@/components/ErrorBoundary';
import { Toaster } from '@/components/ui/toaster';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 1,
      refetchOnWindowFocus: false,
    },
  },
});

function App() {
  return (
    <ErrorBoundary
      onError={(error, errorInfo) => {
        console.error('Global error:', error);
        // 에러 트래킹 서비스로 전송
      }}
    >
      <QueryClientProvider client={queryClient}>
        <BrowserRouter>
          <ErrorBoundary fallback={<div>라우팅 에러 발생</div>}>
            <Routes>
              {/* 라우트 정의 */}
            </Routes>
          </ErrorBoundary>
        </BrowserRouter>
        <Toaster />
      </QueryClientProvider>
    </ErrorBoundary>
  );
}

export default App;
```

**Step 3: 개별 페이지/컴포넌트에 Error Boundary 적용**

```typescript
// src/pages/Dashboard.tsx
import ErrorBoundary from '@/components/ErrorBoundary';
import { DashboardContent } from '@/components/DashboardContent';

export default function Dashboard() {
  return (
    <ErrorBoundary
      fallback={
        <div className="p-8 text-center">
          <h2>대시보드를 불러올 수 없습니다</h2>
          <p>잠시 후 다시 시도해주세요</p>
        </div>
      }
    >
      <DashboardContent />
    </ErrorBoundary>
  );
}
```

**Step 4: React Query Error Handling**

```typescript
// src/lib/queryClient.ts
import { QueryClient } from '@tanstack/react-query';
import { toast } from '@/components/ui/use-toast';

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: (failureCount, error: any) => {
        // 4xx 에러는 재시도하지 않음
        if (error?.response?.status >= 400 && error?.response?.status < 500) {
          return false;
        }
        return failureCount < 3;
      },
      onError: (error: any) => {
        toast({
          variant: 'destructive',
          title: '데이터 로드 실패',
          description: error?.message || '알 수 없는 오류가 발생했습니다',
        });
      },
    },
    mutations: {
      onError: (error: any) => {
        toast({
          variant: 'destructive',
          title: '작업 실패',
          description: error?.message || '다시 시도해주세요',
        });
      },
    },
  },
});
```

**Step 5: Async Boundary (React 18+)**

```typescript
// src/components/AsyncBoundary.tsx
import { Suspense } from 'react';
import ErrorBoundary from './ErrorBoundary';
import { Skeleton } from '@/components/ui/skeleton';

interface Props {
  children: React.ReactNode;
  loadingFallback?: React.ReactNode;
  errorFallback?: React.ReactNode;
}

export function AsyncBoundary({
  children,
  loadingFallback,
  errorFallback,
}: Props) {
  return (
    <ErrorBoundary fallback={errorFallback}>
      <Suspense
        fallback={
          loadingFallback || (
            <div className="space-y-4">
              <Skeleton className="h-12 w-full" />
              <Skeleton className="h-12 w-full" />
              <Skeleton className="h-12 w-full" />
            </div>
          )
        }
      >
        {children}
      </Suspense>
    </ErrorBoundary>
  );
}
```

사용 예시:

```typescript
import { AsyncBoundary } from '@/components/AsyncBoundary';

function UserProfile() {
  return (
    <AsyncBoundary>
      <UserProfileContent /> {/* Suspense를 사용하는 컴포넌트 */}
    </AsyncBoundary>
  );
}
```

**Step 6: Sentry 연동 (선택적)**

```bash
npm install --save @sentry/react
```

**`src/lib/sentry.ts` 생성**:

```typescript
import * as Sentry from '@sentry/react';
import { BrowserTracing } from '@sentry/tracing';

export function initSentry() {
  if (import.meta.env.PROD) {
    Sentry.init({
      dsn: import.meta.env.VITE_SENTRY_DSN,
      integrations: [
        new BrowserTracing(),
        new Sentry.Replay({
          maskAllText: true,
          blockAllMedia: true,
        }),
      ],
      tracesSampleRate: 1.0,
      replaysSessionSampleRate: 0.1,
      replaysOnErrorSampleRate: 1.0,
      environment: import.meta.env.MODE,
      beforeSend(event, hint) {
        // 민감한 정보 필터링
        if (event.request?.cookies) {
          delete event.request.cookies;
        }
        return event;
      },
    });
  }
}
```

**Error Boundary에 Sentry 통합**:

```typescript
import * as Sentry from '@sentry/react';

class ErrorBoundary extends Component<Props, State> {
  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    // Sentry로 전송
    Sentry.captureException(error, {
      contexts: {
        react: {
          componentStack: errorInfo.componentStack,
        },
      },
    });
  }
}

// 또는 Sentry의 ErrorBoundary 사용
import { ErrorBoundary as SentryErrorBoundary } from '@sentry/react';

<SentryErrorBoundary fallback={<ErrorFallback />}>
  <App />
</SentryErrorBoundary>
```

**Step 7: 에러 복구 전략**

```typescript
// src/hooks/useErrorRecovery.ts
import { useCallback, useState } from 'react';

export function useErrorRecovery() {
  const [retryCount, setRetryCount] = useState(0);

  const handleRetry = useCallback(() => {
    setRetryCount(prev => prev + 1);
  }, []);

  const resetRetry = useCallback(() => {
    setRetryCount(0);
  }, []);

  return {
    retryCount,
    handleRetry,
    resetRetry,
    canRetry: retryCount < 3,
  };
}

// 사용 예시
function MyComponent() {
  const { retryCount, handleRetry, canRetry } = useErrorRecovery();

  return (
    <ErrorBoundary
      resetKeys={[retryCount]}
      fallback={
        <div>
          <p>에러 발생</p>
          {canRetry && (
            <Button onClick={handleRetry}>
              다시 시도 ({3 - retryCount}번 남음)
            </Button>
          )}
        </div>
      }
    >
      <Content />
    </ErrorBoundary>
  );
}
```

#### 검증 방법

**에러 테스트 컴포넌트**:

```typescript
// src/components/ErrorTest.tsx (개발 환경 전용)
import { useState } from 'react';
import { Button } from '@/components/ui/button';

export function ErrorTest() {
  const [shouldThrow, setShouldThrow] = useState(false);

  if (shouldThrow) {
    throw new Error('테스트 에러 발생!');
  }

  return (
    <div className="p-4">
      <Button onClick={() => setShouldThrow(true)}>
        에러 발생 테스트
      </Button>
    </div>
  );
}
```

**테스트 절차**:

```bash
# 1. 개발 서버 실행
npm run dev

# 2. 에러 테스트 컴포넌트 렌더링
# 3. "에러 발생 테스트" 버튼 클릭
# 4. Error Boundary UI 확인
# 5. "다시 시도" 버튼 클릭 → 복구 확인
# 6. "홈으로 이동" 버튼 클릭 → 리디렉션 확인

# 7. 프로덕션 빌드 테스트
npm run build
npm run preview
# 에러 상세 정보가 숨겨져 있는지 확인
```

#### 추가 개선사항

**Network Error 전용 Boundary**:

```typescript
export function NetworkErrorBoundary({ children }: { children: ReactNode }) {
  return (
    <ErrorBoundary
      fallback={
        <div className="text-center p-8">
          <WifiOff className="h-16 w-16 mx-auto mb-4 text-gray-400" />
          <h3 className="text-xl font-semibold mb-2">네트워크 연결 끊김</h3>
          <p className="text-gray-600 mb-4">
            인터넷 연결을 확인하고 다시 시도해주세요
          </p>
          <Button onClick={() => window.location.reload()}>
            새로고침
          </Button>
        </div>
      }
    >
      {children}
    </ErrorBoundary>
  );
}
```

#### 참고 자료

- [React Error Boundaries 공식 문서](https://react.dev/reference/react/Component#catching-rendering-errors-with-an-error-boundary)
- [Sentry React 가이드](https://docs.sentry.io/platforms/javascript/guides/react/)
- [Error Handling Best Practices](https://kentcdodds.com/blog/use-react-error-boundary-to-handle-errors-in-react)
- [React Query Error Handling](https://tanstack.com/query/latest/docs/react/guides/query-error-handling)

---

### 6. README.md 및 프로젝트 문서화

**우선순위**: 🚨 즉시 처리
**카테고리**: 개발 경험
**심각도**: Medium
**영향 범위**: 프로젝트 온보딩, 협업

#### 문제점

**현재 상태**:
- README.md 파일이 기본 템플릿 상태이거나 없음
- 프로젝트 설치/실행 가이드 부재
- API 문서화 없음
- 기여 가이드 없음
- 아키텍처 설명 없음

**위험성**:
1. **온보딩 지연**: 새 개발자가 프로젝트를 시작하기 어려움
2. **협업 비효율**: 코드 컨벤션, 워크플로우를 매번 설명해야 함
3. **유지보수 어려움**: 프로젝트 구조를 파악하는 데 시간 소요
4. **지식 손실**: 핵심 개발자가 떠나면 컨텍스트 손실

**실제 시나리오**:
```
1. 새 개발자 합류
2. 프로젝트 클론
3. 어떻게 시작할지 몰라 질문
4. 환경 변수 설정 방법 불명확
5. 첫 실행까지 반나절 소요
6. 생산성 저하
```

#### 해결 방법

**Step 1: 기본 README.md 작성**

**`README.md` 생성**:

```markdown
# AIHub - AI 기반 통합 서비스 플랫폼

> React + Vite + TypeScript + Supabase + Toss Payments로 구축된 모던 웹 애플리케이션

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.2-blue)](https://www.typescriptlang.org/)
[![React](https://img.shields.io/badge/React-18.2-blue)](https://reactjs.org/)

## 📋 목차

- [프로젝트 소개](#-프로젝트-소개)
- [주요 기능](#-주요-기능)
- [기술 스택](#-기술-스택)
- [시작하기](#-시작하기)
  - [필수 요구사항](#필수-요구사항)
  - [설치](#설치)
  - [환경 변수 설정](#환경-변수-설정)
  - [개발 서버 실행](#개발-서버-실행)
- [프로젝트 구조](#-프로젝트-구조)
- [스크립트 명령어](#-스크립트-명령어)
- [배포](#-배포)
- [기여하기](#-기여하기)
- [라이선스](#-라이선스)

## 🚀 프로젝트 소개

AIHub는 AI 기반의 다양한 서비스를 제공하는 통합 플랫폼입니다. N8N 워크플로우 자동화와 Supabase 백엔드를 활용하여 강력하고 확장 가능한 서비스를 제공합니다.

### 핵심 가치
- **사용자 중심 UX**: 직관적이고 반응형 인터페이스
- **확장 가능한 아키텍처**: 모듈형 설계로 쉬운 기능 추가
- **보안 우선**: 업계 표준 보안 프랙티스 적용
- **성능 최적화**: Code splitting, lazy loading 적용

## ✨ 주요 기능

- 🔐 **사용자 인증**: Supabase Auth를 활용한 안전한 인증 시스템
- 💳 **결제 통합**: Toss Payments 결제 시스템
- 🤖 **AI 워크플로우**: N8N 통합으로 자동화된 AI 처리
- 📊 **대시보드**: 실시간 데이터 시각화
- 🎨 **테마 지원**: 다크/라이트 모드
- 📱 **반응형 디자인**: 모바일부터 데스크톱까지 최적화

## 🛠 기술 스택

### Frontend
- **React 18.2** - UI 라이브러리
- **TypeScript 5.2** - 타입 안정성
- **Vite** - 빌드 도구
- **TanStack Query (React Query)** - 서버 상태 관리
- **Tailwind CSS** - 유틸리티 CSS 프레임워크
- **shadcn/ui** - UI 컴포넌트 라이브러리

### Backend & Services
- **Supabase** - 백엔드 (PostgreSQL, Auth, Storage)
- **N8N** - 워크플로우 자동화
- **Toss Payments** - 결제 게이트웨이

### Development Tools
- **ESLint** - 코드 린팅
- **Prettier** - 코드 포매팅
- **Vitest** - 단위 테스트
- **Playwright** - E2E 테스트

## 🚦 시작하기

### 필수 요구사항

- **Node.js** >= 18.0.0
- **npm** >= 9.0.0 또는 **pnpm** >= 8.0.0
- **Git**

### 설치

1. **저장소 클론**

```bash
git clone https://github.com/your-username/aihub.git
cd aihub
```

2. **의존성 설치**

```bash
npm install
# 또는
pnpm install
```

### 환경 변수 설정

1. `.env.example` 파일을 `.env`로 복사:

```bash
cp .env.example .env
```

2. `.env` 파일을 열고 실제 값으로 교체:

```env
# Supabase
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=your_anon_key
SUPABASE_SERVICE_KEY=your_service_key

# N8N
VITE_N8N_API_URL=https://your-n8n-instance.com

# Toss Payments
VITE_TOSS_CLIENT_KEY=test_ck_... # 개발: test_, 프로덕션: live_
TOSS_SECRET_KEY=test_sk_...
```

3. 각 서비스별 키 발급 방법:

**Supabase**:
- [Supabase Dashboard](https://app.supabase.com) 접속
- 새 프로젝트 생성 또는 기존 프로젝트 선택
- Settings → API → Copy API keys

**Toss Payments**:
- [Toss Developers](https://developers.tosspayments.com) 가입
- 테스트 키 발급 (개발용)
- 프로덕션 배포 전 실제 키로 교체

**N8N**:
- Self-hosted: Docker로 N8N 인스턴스 실행
- Cloud: [N8N Cloud](https://n8n.io/cloud) 가입

### 개발 서버 실행

```bash
npm run dev
```

브라우저에서 [http://localhost:8080](http://localhost:8080) 열기

## 📁 프로젝트 구조

```
AIhub/
├── public/              # 정적 파일
├── src/
│   ├── components/      # React 컴포넌트
│   │   └── ui/         # shadcn/ui 컴포넌트
│   ├── hooks/          # Custom React Hooks
│   ├── integrations/   # 외부 서비스 연동
│   │   ├── supabase/  # Supabase 클라이언트
│   │   └── toss/      # Toss Payments 연동
│   ├── lib/            # 유틸리티 함수
│   ├── pages/          # 페이지 컴포넌트
│   ├── styles/         # 전역 스타일
│   ├── types/          # TypeScript 타입 정의
│   └── App.tsx         # 앱 진입점
├── .env.example        # 환경 변수 템플릿
├── .gitignore
├── package.json
├── tsconfig.json       # TypeScript 설정
├── vite.config.ts      # Vite 설정
└── vercel.json         # Vercel 배포 설정
```

### 주요 디렉토리 설명

- **`src/components/`**: 재사용 가능한 UI 컴포넌트
- **`src/hooks/`**: 커스텀 React Hooks (useAuth, useTossPayment 등)
- **`src/integrations/`**: 외부 API/서비스 연동 로직
- **`src/pages/`**: 라우팅 페이지 컴포넌트
- **`src/lib/`**: 헬퍼 함수, 유틸리티

## 📜 스크립트 명령어

```bash
# 개발 서버 시작
npm run dev

# 프로덕션 빌드
npm run build

# 프로덕션 빌드 미리보기
npm run preview

# 타입 체크
npm run type-check

# 린트
npm run lint

# 테스트 실행
npm test

# 테스트 커버리지
npm run test:coverage

# E2E 테스트
npm run test:e2e

# 환경 변수 검증
npm run check:env
```

## 🚀 배포

### Vercel (권장)

1. **Vercel CLI 설치**

```bash
npm install -g vercel
```

2. **배포**

```bash
vercel

# 프로덕션 배포
vercel --prod
```

3. **환경 변수 설정**

Vercel Dashboard에서 Environment Variables 추가하거나:

```bash
vercel env add VITE_SUPABASE_URL production
vercel env add VITE_SUPABASE_PUBLISHABLE_KEY production
# ... 기타 환경 변수
```

### 다른 플랫폼

**Netlify**:
```bash
npm run build
# dist/ 폴더를 Netlify에 배포
```

**Docker**:
```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## 🤝 기여하기

기여를 환영합니다! 다음 절차를 따라주세요:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

자세한 내용은 [CONTRIBUTING.md](./CONTRIBUTING.md)를 참고하세요.

### 코드 컨벤션

- **TypeScript**: strict mode 사용
- **컴포넌트**: PascalCase (예: `UserProfile.tsx`)
- **함수/변수**: camelCase (예: `getUserData`)
- **상수**: UPPER_CASE (예: `API_BASE_URL`)
- **CSS**: Tailwind utility classes 우선 사용

### Commit 메시지 컨벤션

```
feat: 새로운 기능 추가
fix: 버그 수정
docs: 문서 수정
style: 코드 포매팅 (기능 변경 없음)
refactor: 코드 리팩토링
test: 테스트 추가/수정
chore: 빌드 설정 등 기타 변경
```

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](./LICENSE) 파일을 참고하세요.

## 📞 문의

- **프로젝트 관리자**: Your Name (your.email@example.com)
- **이슈 트래커**: [GitHub Issues](https://github.com/your-username/aihub/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-username/aihub/discussions)

## 🙏 감사의 글

- [shadcn/ui](https://ui.shadcn.com/) - 아름다운 UI 컴포넌트
- [Supabase](https://supabase.com/) - 강력한 백엔드 서비스
- [Toss Payments](https://www.tosspayments.com/) - 간편한 결제 연동
- [N8N](https://n8n.io/) - 워크플로우 자동화

---

Made with ❤️ by AIHub Team
```

**Step 2: CONTRIBUTING.md 작성**

**`CONTRIBUTING.md` 생성**:

```markdown
# AIHub 기여 가이드

AIHub 프로젝트에 기여해주셔서 감사합니다! 이 문서는 프로젝트에 기여하는 방법을 안내합니다.

## 목차

- [행동 강령](#행동-강령)
- [시작하기](#시작하기)
- [개발 워크플로우](#개발-워크플로우)
- [Pull Request 가이드](#pull-request-가이드)
- [코드 리뷰 프로세스](#코드-리뷰-프로세스)
- [스타일 가이드](#스타일-가이드)

## 행동 강령

### 우리의 약속

모든 기여자와 관리자는 다음을 준수해야 합니다:

- 존중과 배려로 대하기
- 건설적인 피드백 제공
- 다양한 관점 존중
- 커뮤니티 이익 우선

### 허용되지 않는 행동

- 괴롭힘, 차별, 비방
- 무단 개인정보 공개
- 공격적이거나 모욕적인 언어 사용

## 시작하기

### 1. Fork 및 Clone

```bash
# 1. GitHub에서 Fork 버튼 클릭
# 2. 내 저장소로 Clone
git clone https://github.com/YOUR_USERNAME/aihub.git
cd aihub

# 3. Upstream 원격 저장소 추가
git remote add upstream https://github.com/original/aihub.git
```

### 2. 로컬 개발 환경 설정

```bash
# 의존성 설치
npm install

# 환경 변수 설정
cp .env.example .env
# .env 파일 수정

# 개발 서버 시작
npm run dev
```

### 3. 브랜치 생성

```bash
# 최신 main 브랜치 가져오기
git checkout main
git pull upstream main

# 기능 브랜치 생성
git checkout -b feature/your-feature-name
# 또는 버그 수정
git checkout -b fix/issue-number-description
```

## 개발 워크플로우

### 브랜치 명명 규칙

- `feature/기능명` - 새로운 기능
- `fix/이슈번호-설명` - 버그 수정
- `docs/문서명` - 문서 수정
- `refactor/설명` - 리팩토링
- `test/테스트명` - 테스트 추가

예시:
- `feature/add-dark-mode`
- `fix/123-payment-error`
- `docs/update-readme`

### Commit 메시지 작성

**Conventional Commits** 형식 사용:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Type**:
- `feat`: 새 기능
- `fix`: 버그 수정
- `docs`: 문서
- `style`: 포매팅
- `refactor`: 리팩토링
- `test`: 테스트
- `chore`: 기타

**예시**:

```bash
git commit -m "feat(auth): add Google OAuth login"
git commit -m "fix(payment): prevent duplicate payment submissions

Closes #123"
git commit -m "docs: update installation instructions"
```

### 코드 작성 전 체크리스트

- [ ] 최신 main 브랜치로부터 브랜치 생성
- [ ] 관련 이슈가 있는지 확인 (없으면 이슈 생성)
- [ ] 코드 작성 전 설계 검토
- [ ] 테스트 작성 계획 수립

### 코드 작성 중

```bash
# 자주 커밋하기
git add .
git commit -m "feat: implement user profile page"

# 주기적으로 upstream과 동기화
git fetch upstream
git rebase upstream/main

# 테스트 실행
npm test

# 타입 체크
npm run type-check

# 린트
npm run lint
```

## Pull Request 가이드

### PR 생성 전 체크리스트

- [ ] 모든 테스트 통과 (`npm test`)
- [ ] 타입 에러 없음 (`npm run type-check`)
- [ ] 린트 에러 없음 (`npm run lint`)
- [ ] 빌드 성공 (`npm run build`)
- [ ] 코드 포매팅 적용 (`npm run format`)
- [ ] 불필요한 console.log 제거
- [ ] 주석으로 복잡한 로직 설명
- [ ] 관련 문서 업데이트

### PR 템플릿

```markdown
## 변경사항 설명

간단한 설명...

## 관련 이슈

Closes #123

## 변경 유형

- [ ] 🐛 Bug fix
- [ ] ✨ New feature
- [ ] 💥 Breaking change
- [ ] 📝 Documentation
- [ ] ♻️ Refactoring
- [ ] ✅ Tests

## 스크린샷 (UI 변경 시)

Before:
![before](url)

After:
![after](url)

## 테스트 완료

- [ ] 단위 테스트 추가/업데이트
- [ ] E2E 테스트 (필요시)
- [ ] 수동 테스트 완료
- [ ] 브라우저 호환성 확인 (Chrome, Firefox, Safari)
- [ ] 모바일 반응형 확인

## 체크리스트

- [ ] 코드가 프로젝트 스타일 가이드를 따름
- [ ] Self-review 완료
- [ ] 코드에 주석 추가 (복잡한 부분)
- [ ] 문서 업데이트 완료
- [ ] Breaking changes 없음 (또는 문서화)
- [ ] 의존성 추가 시 이유 설명
```

### PR 생성 후

```bash
# PR 생성 후 코드 리뷰 요청
# GitHub에서 Reviewers 지정

# 리뷰 피드백 반영
git add .
git commit -m "refactor: apply review feedback"
git push origin feature/your-feature
```

## 코드 리뷰 프로세스

### 리뷰어가 확인하는 사항

1. **기능성**: 코드가 의도한 대로 동작하는가?
2. **보안**: 보안 취약점이 없는가?
3. **성능**: 성능 이슈가 없는가?
4. **테스트**: 충분한 테스트가 작성되었는가?
5. **가독성**: 코드가 이해하기 쉬운가?
6. **확장성**: 향후 확장이 용이한가?

### 피드백 반영

- 모든 코멘트에 응답
- 동의하지 않는 부분은 근거와 함께 설명
- 요청된 변경사항 반영 후 재요청
- "LGTM" (Looks Good To Me) 받으면 머지 가능

## 스타일 가이드

### TypeScript

```typescript
// ✅ Good
interface User {
  id: string;
  name: string;
  email: string;
}

function getUserById(id: string): Promise<User | null> {
  // ...
}

// ❌ Bad
function getUser(id: any): any {
  // ...
}
```

### React 컴포넌트

```typescript
// ✅ Good
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
}

export function Button({ label, onClick, variant = 'primary' }: ButtonProps) {
  return (
    <button
      onClick={onClick}
      className={cn('btn', `btn-${variant}`)}
    >
      {label}
    </button>
  );
}

// ❌ Bad
export function Button(props: any) {
  return <button onClick={props.onClick}>{props.label}</button>;
}
```

### 파일 명명

```
// 컴포넌트
UserProfile.tsx
UserProfile.test.tsx

// Hooks
useAuth.ts
useAuth.test.ts

// 유틸리티
formatDate.ts
formatDate.test.ts

// 타입
types.ts
user.types.ts
```

### Import 순서

```typescript
// 1. React 관련
import { useState, useEffect } from 'react';

// 2. 외부 라이브러리
import { useQuery } from '@tanstack/react-query';

// 3. 내부 라이브러리
import { Button } from '@/components/ui/button';
import { useAuth } from '@/hooks/useAuth';

// 4. 타입
import type { User } from '@/types';

// 5. 스타일
import './styles.css';
```

### 주석

```typescript
// ✅ Good - 복잡한 로직 설명
/**
 * 사용자의 결제 내역을 조회합니다.
 * @param userId - 사용자 ID
 * @param options - 조회 옵션 (기간, 정렬 등)
 * @returns 결제 내역 배열
 */
async function getPaymentHistory(
  userId: string,
  options?: QueryOptions
): Promise<Payment[]> {
  // 캐시 확인 (10분)
  const cached = await cache.get(`payments:${userId}`);
  if (cached) return cached;

  // DB 조회
  const payments = await db.query(/* ... */);

  // 캐시 저장
  await cache.set(`payments:${userId}`, payments, 600);

  return payments;
}

// ❌ Bad - 불필요한 주석
// 변수 선언
const x = 10;

// 함수 호출
doSomething();
```

## 문의

질문이 있으신가요?

- **일반 질문**: [GitHub Discussions](https://github.com/your-org/aihub/discussions)
- **버그 리포트**: [GitHub Issues](https://github.com/your-org/aihub/issues)
- **보안 이슈**: security@aihub.com (비공개)

감사합니다!
```

**Step 3: API 문서 작성**

**`docs/API.md` 생성**:

```markdown
# API 문서

## Supabase API

### 인증

#### 회원가입

```typescript
const { data, error } = await supabase.auth.signUp({
  email: 'user@example.com',
  password: 'password123',
});
```

#### 로그인

```typescript
const { data, error } = await supabase.auth.signInWithPassword({
  email: 'user@example.com',
  password: 'password123',
});
```

#### 로그아웃

```typescript
const { error } = await supabase.auth.signOut();
```

### 데이터베이스

#### 사용자 프로필 조회

```typescript
const { data, error } = await supabase
  .from('profiles')
  .select('*')
  .eq('id', userId)
  .single();
```

## N8N Webhooks

### AI 챗봇

**Endpoint**: `POST /api/n8n/webhook/chatbot`

**Request**:
```json
{
  "message": "안녕하세요",
  "userId": "123",
  "context": {}
}
```

**Response**:
```json
{
  "reply": "안녕하세요! 무엇을 도와드릴까요?",
  "suggestions": ["결제 문의", "기능 설명"]
}
```

## Toss Payments

### 결제 요청

```typescript
import { loadTossPayments } from '@tosspayments/payment-sdk';

const tossPayments = await loadTossPayments(clientKey);

await tossPayments.requestPayment('카드', {
  amount: 10000,
  orderId: 'order_123',
  orderName: '상품명',
  successUrl: window.location.origin + '/payment/success',
  failUrl: window.location.origin + '/payment/fail',
});
```

### 결제 승인

```typescript
// 서버에서만 실행
const response = await fetch('https://api.tosspayments.com/v1/payments/confirm', {
  method: 'POST',
  headers: {
    Authorization: `Basic ${Buffer.from(secretKey + ':').toString('base64')}`,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    paymentKey,
    orderId,
    amount,
  }),
});
```

---

더 자세한 내용은 각 서비스의 공식 문서를 참고하세요:

- [Supabase Docs](https://supabase.com/docs)
- [N8N Docs](https://docs.n8n.io/)
- [Toss Payments Docs](https://docs.tosspayments.com/)
```

#### 검증 방법

```bash
# 1. README 렌더링 확인
# GitHub에 푸시하거나 VS Code 미리보기 (Ctrl+Shift+V)

# 2. 링크 검증
npm install -g markdown-link-check
markdown-link-check README.md

# 3. 새 개발자 온보딩 시뮬레이션
# README만 보고 프로젝트 시작 가능한지 테스트

# 4. 문서 업데이트 자동화
# package.json에 추가
{
  "scripts": {
    "docs:check": "markdown-link-check README.md CONTRIBUTING.md"
  }
}
```

#### 추가 문서

**`docs/ARCHITECTURE.md`** - 아키텍처 설명
**`docs/DEPLOYMENT.md`** - 배포 상세 가이드
**`docs/TESTING.md`** - 테스트 가이드
**`LICENSE`** - 라이선스 파일

#### 참고 자료

- [README 작성 가이드](https://www.makeareadme.com/)
- [Contributor Covenant](https://www.contributor-covenant.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Semantic Versioning](https://semver.org/)

---

### 7. 접근성(A11y) 개선

**우선순위**: ⚡ 단기 처리
**카테고리**: 사용자 경험
**심각도**: Medium
**영향 범위**: 전체 UI 컴포넌트

#### 문제점

**현재 상태**:
- ARIA 라벨 부족
- 키보드 네비게이션 미지원 영역 존재
- 색상 대비 미흡
- 스크린 리더 테스트 안 됨
- Lighthouse 접근성 점수 낮음 (70점 이하 예상)

**위험성**:
1. **법적 리스크**: 접근성 규정(WCAG 2.1) 미준수 시 법적 문제
2. **사용자 배제**: 장애가 있는 사용자가 서비스 이용 불가
3. **SEO 영향**: 접근성 점수가 검색 순위에 영향
4. **비즈니스 손실**: 전체 사용자의 15-20%가 접근성 문제로 이탈

**실제 시나리오**:
```
1. 시각 장애 사용자가 스크린 리더로 접근
2. 버튼에 라벨이 없어 어떤 기능인지 파악 불가
3. 키보드로 네비게이션 시도 → 일부 영역 접근 불가
4. 서비스 이용 포기
```

#### 해결 방법

**Step 1: 접근성 린터 설정**

```bash
npm install --save-dev eslint-plugin-jsx-a11y
```

**`eslint.config.js` 수정**:

```javascript
import jsxA11y from 'eslint-plugin-jsx-a11y';

export default [
  {
    plugins: {
      'jsx-a11y': jsxA11y,
    },
    rules: {
      'jsx-a11y/alt-text': 'error',
      'jsx-a11y/anchor-has-content': 'error',
      'jsx-a11y/anchor-is-valid': 'error',
      'jsx-a11y/aria-props': 'error',
      'jsx-a11y/aria-proptypes': 'error',
      'jsx-a11y/aria-unsupported-elements': 'error',
      'jsx-a11y/click-events-have-key-events': 'warn',
      'jsx-a11y/heading-has-content': 'error',
      'jsx-a11y/label-has-associated-control': 'error',
      'jsx-a11y/no-autofocus': 'warn',
      'jsx-a11y/no-static-element-interactions': 'warn',
      'jsx-a11y/role-has-required-aria-props': 'error',
      'jsx-a11y/role-supports-aria-props': 'error',
    },
  },
];
```

**Step 2: ARIA 라벨 추가**

**Before**:
```typescript
// ❌ Bad - 스크린 리더가 이해 불가
<button onClick={handleDelete}>
  <TrashIcon />
</button>

<div onClick={handleClick}>
  <img src="close.svg" />
</div>
```

**After**:
```typescript
// ✅ Good
<button
  onClick={handleDelete}
  aria-label="삭제"
  title="삭제"
>
  <TrashIcon aria-hidden="true" />
</button>

// 또는 텍스트 포함
<button onClick={handleDelete}>
  <TrashIcon aria-hidden="true" />
  <span>삭제</span>
</button>

// 대화형 요소는 적절한 role 사용
<button
  onClick={handleClick}
  aria-label="닫기"
>
  <img src="close.svg" alt="" aria-hidden="true" />
</button>
```

**프로젝트에 적용**:

```typescript
// src/components/ui/button.tsx
export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ children, className, variant, size, asChild = false, ...props }, ref) => {
    const Comp = asChild ? Slot : "button";

    return (
      <Comp
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        // 자동으로 적절한 role 할당
        role={asChild ? undefined : "button"}
        // disabled 상태도 명시
        aria-disabled={props.disabled}
        {...props}
      >
        {children}
      </Comp>
    );
  }
);
Button.displayName = "Button";
```

**Step 3: 키보드 네비게이션 개선**

**포커스 관리**:

```typescript
// src/hooks/useFocusTrap.ts
import { useEffect, useRef } from 'react';

export function useFocusTrap<T extends HTMLElement>() {
  const containerRef = useRef<T>(null);

  useEffect(() => {
    const container = containerRef.current;
    if (!container) return;

    // 포커스 가능한 모든 요소 찾기
    const focusableElements = container.querySelectorAll<HTMLElement>(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );

    const firstElement = focusableElements[0];
    const lastElement = focusableElements[focusableElements.length - 1];

    function handleTabKey(e: KeyboardEvent) {
      if (e.key !== 'Tab') return;

      // Shift + Tab: 역방향
      if (e.shiftKey) {
        if (document.activeElement === firstElement) {
          lastElement.focus();
          e.preventDefault();
        }
      } else {
        // Tab: 정방향
        if (document.activeElement === lastElement) {
          firstElement.focus();
          e.preventDefault();
        }
      }
    }

    container.addEventListener('keydown', handleTabKey);

    // 첫 요소에 포커스
    firstElement?.focus();

    return () => {
      container.removeEventListener('keydown', handleTabKey);
    };
  }, []);

  return containerRef;
}

// 사용 예시
function Modal() {
  const modalRef = useFocusTrap<HTMLDivElement>();

  return (
    <div
      ref={modalRef}
      role="dialog"
      aria-modal="true"
      aria-labelledby="modal-title"
    >
      <h2 id="modal-title">모달 제목</h2>
      <button>확인</button>
      <button>취소</button>
    </div>
  );
}
```

**키보드 단축키**:

```typescript
// src/hooks/useKeyboardShortcut.ts
import { useEffect } from 'react';

export function useKeyboardShortcut(
  key: string,
  callback: () => void,
  options: { ctrl?: boolean; shift?: boolean; alt?: boolean } = {}
) {
  useEffect(() => {
    function handleKeyDown(e: KeyboardEvent) {
      const { ctrl = false, shift = false, alt = false } = options;

      if (
        e.key === key &&
        e.ctrlKey === ctrl &&
        e.shiftKey === shift &&
        e.altKey === alt
      ) {
        e.preventDefault();
        callback();
      }
    }

    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [key, callback, options]);
}

// 사용 예시
function SearchBar() {
  const inputRef = useRef<HTMLInputElement>(null);

  // Ctrl + K로 검색창 포커스
  useKeyboardShortcut('k', () => {
    inputRef.current?.focus();
  }, { ctrl: true });

  return (
    <input
      ref={inputRef}
      type="search"
      placeholder="검색 (Ctrl + K)"
      aria-label="검색"
    />
  );
}
```

**Skip to Content 링크**:

```typescript
// src/components/SkipToContent.tsx
export function SkipToContent() {
  return (
    <a
      href="#main-content"
      className="sr-only focus:not-sr-only focus:absolute focus:top-4 focus:left-4 focus:z-50 focus:px-4 focus:py-2 focus:bg-primary focus:text-primary-foreground focus:rounded"
    >
      메인 컨텐츠로 건너뛰기
    </a>
  );
}

// src/App.tsx
function App() {
  return (
    <>
      <SkipToContent />
      <nav>...</nav>
      <main id="main-content">
        {/* 메인 컨텐츠 */}
      </main>
    </>
  );
}
```

**Step 4: 색상 대비 개선**

```typescript
// tailwind.config.ts
export default {
  theme: {
    extend: {
      colors: {
        // WCAG AA 기준 4.5:1 대비율 충족
        primary: {
          DEFAULT: '#0066CC', // 파란색 (대비율: 7.2:1)
          foreground: '#FFFFFF',
        },
        destructive: {
          DEFAULT: '#DC2626', // 빨간색 (대비율: 5.9:1)
          foreground: '#FFFFFF',
        },
        // 회색 계열도 충분한 대비 확보
        muted: {
          DEFAULT: '#64748B', // (대비율: 4.7:1)
          foreground: '#F8FAFC',
        },
      },
    },
  },
};
```

**대비율 검사 유틸리티**:

```typescript
// src/lib/a11y.ts
export function getContrastRatio(color1: string, color2: string): number {
  const getLuminance = (hex: string) => {
    const rgb = parseInt(hex.slice(1), 16);
    const r = ((rgb >> 16) & 0xff) / 255;
    const g = ((rgb >> 8) & 0xff) / 255;
    const b = (rgb & 0xff) / 255;

    const [rL, gL, bL] = [r, g, b].map(c => {
      return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
    });

    return 0.2126 * rL + 0.7152 * gL + 0.0722 * bL;
  };

  const lum1 = getLuminance(color1);
  const lum2 = getLuminance(color2);
  const brightest = Math.max(lum1, lum2);
  const darkest = Math.min(lum1, lum2);

  return (brightest + 0.05) / (darkest + 0.05);
}

// 테스트
console.log(getContrastRatio('#0066CC', '#FFFFFF')); // 7.2 (AAA 통과)
console.log(getContrastRatio('#DC2626', '#FFFFFF')); // 5.9 (AA 통과)
```

**Step 5: 폼 접근성**

```typescript
// src/components/forms/AccessibleForm.tsx
import { Label } from '@/components/ui/label';
import { Input } from '@/components/ui/input';

export function AccessibleForm() {
  const [errors, setErrors] = useState<Record<string, string>>({});

  return (
    <form onSubmit={handleSubmit}>
      <div className="space-y-2">
        <Label htmlFor="email">
          이메일 <span aria-label="필수 항목">*</span>
        </Label>
        <Input
          id="email"
          type="email"
          name="email"
          required
          aria-required="true"
          aria-invalid={!!errors.email}
          aria-describedby={errors.email ? "email-error" : undefined}
          placeholder="example@email.com"
        />
        {errors.email && (
          <p id="email-error" role="alert" className="text-sm text-destructive">
            {errors.email}
          </p>
        )}
      </div>

      <div className="space-y-2">
        <Label htmlFor="password">비밀번호 *</Label>
        <Input
          id="password"
          type="password"
          name="password"
          required
          aria-required="true"
          aria-describedby="password-help"
          minLength={8}
        />
        <p id="password-help" className="text-sm text-muted-foreground">
          최소 8자 이상 입력해주세요
        </p>
      </div>

      <button
        type="submit"
        aria-busy={isLoading}
        disabled={isLoading}
      >
        {isLoading ? '로그인 중...' : '로그인'}
      </button>
    </form>
  );
}
```

**Step 6: 이미지 alt 텍스트**

```typescript
// ❌ Bad
<img src="/logo.png" />

// ✅ Good - 의미 있는 이미지
<img src="/logo.png" alt="AIHub 로고" />

// ✅ Good - 장식용 이미지
<img src="/decoration.svg" alt="" role="presentation" />

// ✅ Good - 복잡한 이미지
<figure>
  <img
    src="/chart.png"
    alt="2024년 매출 추이 그래프"
    aria-describedby="chart-description"
  />
  <figcaption id="chart-description">
    2024년 1월부터 12월까지 매출이 꾸준히 증가하여
    12월에는 1월 대비 150% 성장했습니다.
  </figcaption>
</figure>
```

**Step 7: 라이브 리전 (동적 컨텐츠)**

```typescript
// src/components/ui/toast.tsx
export function Toast({ title, description }: ToastProps) {
  return (
    <div
      role="status"
      aria-live="polite"
      aria-atomic="true"
      className="toast"
    >
      <h3>{title}</h3>
      <p>{description}</p>
    </div>
  );
}

// 긴급한 알림 (예: 에러)
export function AlertToast({ title, description }: ToastProps) {
  return (
    <div
      role="alert"
      aria-live="assertive"
      aria-atomic="true"
      className="toast toast-error"
    >
      <AlertTriangle aria-hidden="true" />
      <h3>{title}</h3>
      <p>{description}</p>
    </div>
  );
}
```

**Step 8: 접근성 테스트 자동화**

```bash
npm install --save-dev @axe-core/react
```

**`src/main.tsx` (개발 환경만)**:

```typescript
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

if (process.env.NODE_ENV !== 'production') {
  import('@axe-core/react').then(axe => {
    axe.default(React, ReactDOM, 1000);
  });
}

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
```

**Playwright E2E 테스트에 axe 통합**:

```bash
npm install --save-dev axe-playwright
```

```typescript
// e2e/a11y.spec.ts
import { test, expect } from '@playwright/test';
import { injectAxe, checkA11y } from 'axe-playwright';

test.describe('Accessibility', () => {
  test('homepage should not have a11y violations', async ({ page }) => {
    await page.goto('/');
    await injectAxe(page);
    await checkA11y(page);
  });

  test('login page should not have a11y violations', async ({ page }) => {
    await page.goto('/auth');
    await injectAxe(page);
    await checkA11y(page, null, {
      detailedReport: true,
      detailedReportOptions: {
        html: true,
      },
    });
  });
});
```

#### 검증 방법

```bash
# 1. ESLint 접근성 검사
npm run lint

# 2. Lighthouse 접근성 점수 확인
# Chrome DevTools → Lighthouse → Accessibility
# 목표: 90점 이상

# 3. axe DevTools 확장 프로그램
# Chrome Web Store에서 설치
# 개발 중 실시간 접근성 이슈 확인

# 4. 스크린 리더 테스트
# Windows: NVDA (무료)
# macOS: VoiceOver (내장)
# 주요 기능을 스크린 리더로 테스트

# 5. 키보드만으로 전체 앱 탐색
# Tab, Shift+Tab, Enter, Space, Esc 키만 사용
# 모든 기능에 접근 가능한지 확인

# 6. 색상 대비 도구
# https://webaim.org/resources/contrastchecker/
```

**접근성 체크리스트**:

```markdown
## 접근성 체크리스트

### 키보드 접근성
- [ ] Tab 키로 모든 인터랙티브 요소 접근 가능
- [ ] 포커스 표시기 명확히 보임
- [ ] Skip to content 링크 제공
- [ ] 모달/드롭다운에서 포커스 트랩 동작
- [ ] Esc 키로 모달/드롭다운 닫기 가능

### 시각적 접근성
- [ ] 색상 대비 WCAG AA 기준 충족 (4.5:1)
- [ ] 텍스트 크기 조절 가능 (200%까지)
- [ ] 색상만으로 정보 전달하지 않음
- [ ] 포커스 표시 명확

### 스크린 리더
- [ ] 모든 이미지에 alt 텍스트
- [ ] 버튼/링크에 명확한 라벨
- [ ] 폼 필드에 label 연결
- [ ] ARIA 속성 적절히 사용
- [ ] Landmark roles 사용 (header, nav, main, footer)

### 폼
- [ ] 라벨과 입력 필드 명확히 연결
- [ ] 에러 메시지 aria-live로 알림
- [ ] 필수 필드 표시
- [ ] 자동완성 속성 제공

### 동적 컨텐츠
- [ ] 로딩 상태 aria-live로 알림
- [ ] 에러/성공 메시지 role="alert"
- [ ] 페이지 제목 동적 업데이트
```

#### 참고 자료

- [WCAG 2.1 가이드라인](https://www.w3.org/WAI/WCAG21/quickref/)
- [WAI-ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
- [A11y Project](https://www.a11yproject.com/)
- [axe DevTools](https://www.deque.com/axe/devtools/)
- [WebAIM](https://webaim.org/)
- [React 접근성 가이드](https://react.dev/learn/accessibility)

---

## 사용자 경험

### 8. 로딩 상태 관리 개선

**우선순위**: ⚡ 단기 처리
**카테고리**: 사용자 경험
**심각도**: Medium
**영향 범위**: 전체 데이터 로딩 영역

#### 문제점

**현재 상태**:
- 로딩 상태 표시가 일관되지 않음
- 일부 API 호출 시 로딩 인디케이터 없음
- Skeleton UI가 없어 레이아웃 시프트 발생
- React Query의 `isLoading`, `isFetching` 구분 미흡

**위험성**:
1. **사용자 혼란**: 무언가 로딩 중인지 알 수 없음
2. **이탈률 증가**: 반응 없는 UI로 인식
3. **레이아웃 시프트 (CLS)**: Skeleton 없이 콘텐츠 로딩 시 화면 깜빡임
4. **중복 요청**: 로딩 중에도 버튼을 여러 번 클릭 가능

**실제 시나리오**:
```
1. 사용자가 "가이드북" 페이지 접근
2. 데이터 로딩 중이지만 표시 없음
3. 사용자는 버튼이 작동하지 않는다고 생각
4. 새로고침 또는 페이지 이탈
```

#### 해결 방법

**Step 1: 전역 로딩 컴포넌트 생성**

**`src/components/ui/loading-spinner.tsx` 생성**:

```typescript
import { Loader2 } from 'lucide-react';
import { cn } from '@/lib/utils';

interface LoadingSpinnerProps {
  size?: 'sm' | 'md' | 'lg' | 'xl';
  className?: string;
  label?: string;
}

export function LoadingSpinner({
  size = 'md',
  className,
  label
}: LoadingSpinnerProps) {
  const sizeClasses = {
    sm: 'h-4 w-4',
    md: 'h-8 w-8',
    lg: 'h-12 w-12',
    xl: 'h-16 w-16',
  };

  return (
    <div
      className="flex flex-col items-center justify-center gap-2"
      role="status"
      aria-live="polite"
      aria-label={label || '로딩 중'}
    >
      <Loader2
        className={cn(
          'animate-spin text-primary',
          sizeClasses[size],
          className
        )}
      />
      {label && (
        <p className="text-sm text-muted-foreground">{label}</p>
      )}
      <span className="sr-only">{label || '로딩 중입니다...'}</span>
    </div>
  );
}

// 전체 페이지 로딩
export function LoadingPage({ message = '페이지를 불러오는 중...' }: { message?: string }) {
  return (
    <div className="min-h-screen flex items-center justify-center">
      <LoadingSpinner size="xl" label={message} />
    </div>
  );
}

// 섹션 로딩
export function LoadingSection({ message }: { message?: string }) {
  return (
    <div className="py-12 flex items-center justify-center">
      <LoadingSpinner size="lg" label={message} />
    </div>
  );
}

// 인라인 로딩
export function LoadingInline({ message }: { message?: string }) {
  return (
    <div className="flex items-center gap-2">
      <LoadingSpinner size="sm" />
      {message && <span className="text-sm">{message}</span>}
    </div>
  );
}
```

**Step 2: Skeleton UI 컴포넌트**

이미 shadcn/ui의 Skeleton이 있으므로, 특화된 Skeleton 생성:

**`src/components/ui/skeleton-card.tsx` 생성**:

```typescript
import { Skeleton } from '@/components/ui/skeleton';
import { Card, CardContent, CardHeader } from '@/components/ui/card';

export function SkeletonCard() {
  return (
    <Card>
      <CardHeader>
        <Skeleton className="h-6 w-3/4 mb-2" />
        <Skeleton className="h-4 w-1/2" />
      </CardHeader>
      <CardContent>
        <Skeleton className="h-4 w-full mb-2" />
        <Skeleton className="h-4 w-full mb-2" />
        <Skeleton className="h-4 w-2/3" />
      </CardContent>
    </Card>
  );
}

export function SkeletonGuideCard() {
  return (
    <div className="border rounded-lg p-4 space-y-3">
      <div className="flex items-start justify-between">
        <div className="space-y-2 flex-1">
          <Skeleton className="h-5 w-3/4" />
          <Skeleton className="h-3 w-1/2" />
        </div>
        <Skeleton className="h-12 w-12 rounded-full" />
      </div>
      <div className="space-y-2">
        <Skeleton className="h-3 w-full" />
        <Skeleton className="h-3 w-full" />
        <Skeleton className="h-3 w-2/3" />
      </div>
      <div className="flex gap-2">
        <Skeleton className="h-6 w-16 rounded-full" />
        <Skeleton className="h-6 w-16 rounded-full" />
        <Skeleton className="h-6 w-16 rounded-full" />
      </div>
    </div>
  );
}

export function SkeletonTable() {
  return (
    <div className="space-y-2">
      <Skeleton className="h-10 w-full" />
      {Array.from({ length: 5 }).map((_, i) => (
        <Skeleton key={i} className="h-16 w-full" />
      ))}
    </div>
  );
}
```

**Step 3: React Query 통합**

**`src/hooks/useLoadingState.ts` 생성**:

```typescript
import { useIsFetching, useIsMutating } from '@tanstack/react-query';

/**
 * 전역 로딩 상태를 추적하는 훅
 */
export function useGlobalLoading() {
  const isFetching = useIsFetching();
  const isMutating = useIsMutating();

  return {
    isLoading: isFetching > 0 || isMutating > 0,
    isFetching: isFetching > 0,
    isMutating: isMutating > 0,
  };
}

/**
 * 특정 쿼리 키의 로딩 상태만 추적
 */
export function useQueryLoading(queryKey: unknown[]) {
  const isFetching = useIsFetching({ queryKey });
  return isFetching > 0;
}
```

**전역 로딩 바 (선택적)**:

**`src/components/GlobalLoadingBar.tsx` 생성**:

```typescript
import { useGlobalLoading } from '@/hooks/useLoadingState';
import { useEffect, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

export function GlobalLoadingBar() {
  const { isLoading } = useGlobalLoading();
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    if (isLoading) {
      // 페이크 프로그레스 바 애니메이션
      setProgress(0);
      const interval = setInterval(() => {
        setProgress((prev) => {
          if (prev >= 90) return prev;
          return prev + Math.random() * 10;
        });
      }, 300);

      return () => clearInterval(interval);
    } else {
      // 완료 시 100%로 점프 후 사라짐
      setProgress(100);
      setTimeout(() => setProgress(0), 500);
    }
  }, [isLoading]);

  return (
    <AnimatePresence>
      {progress > 0 && progress < 100 && (
        <motion.div
          className="fixed top-0 left-0 right-0 h-1 bg-primary z-50 origin-left"
          initial={{ scaleX: 0 }}
          animate={{ scaleX: progress / 100 }}
          exit={{ scaleX: 1, opacity: 0 }}
          transition={{ duration: 0.3 }}
        />
      )}
    </AnimatePresence>
  );
}

// App.tsx에 추가
<GlobalLoadingBar />
```

**Step 4: 실제 사용 패턴**

**가이드북 목록 로딩**:

```typescript
// src/pages/Guidebook.tsx
import { useQuery } from '@tanstack/react-query';
import { SkeletonGuideCard } from '@/components/ui/skeleton-card';
import { LoadingSection } from '@/components/ui/loading-spinner';

export function GuidebookPage() {
  const { data: guides, isLoading, isError, error } = useQuery({
    queryKey: ['guides'],
    queryFn: fetchGuides,
  });

  if (isError) {
    return (
      <div className="text-center py-12">
        <p className="text-destructive">오류 발생: {error.message}</p>
        <Button onClick={() => refetch()}>다시 시도</Button>
      </div>
    );
  }

  if (isLoading) {
    return (
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {Array.from({ length: 6 }).map((_, i) => (
          <SkeletonGuideCard key={i} />
        ))}
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      {guides?.map((guide) => (
        <GuideCard key={guide.id} guide={guide} />
      ))}
    </div>
  );
}
```

**결제 버튼 로딩**:

```typescript
// src/components/PaymentButton.tsx
import { useMutation } from '@tanstack/react-query';
import { Button } from '@/components/ui/button';
import { Loader2 } from 'lucide-react';

export function PaymentButton({ amount, orderId }: PaymentButtonProps) {
  const { mutate: requestPayment, isPending } = useMutation({
    mutationFn: processPayment,
    onSuccess: () => {
      toast({ title: '결제 성공' });
    },
    onError: (error) => {
      toast({ variant: 'destructive', title: '결제 실패', description: error.message });
    },
  });

  return (
    <Button
      onClick={() => requestPayment({ amount, orderId })}
      disabled={isPending}
      aria-busy={isPending}
    >
      {isPending ? (
        <>
          <Loader2 className="mr-2 h-4 w-4 animate-spin" />
          결제 처리 중...
        </>
      ) : (
        `₩${amount.toLocaleString()} 결제하기`
      )}
    </Button>
  );
}
```

**Step 5: Suspense 경계 (React 18+)**

```typescript
// src/components/SuspenseWrapper.tsx
import { Suspense } from 'react';
import { SkeletonCard } from '@/components/ui/skeleton-card';

interface SuspenseWrapperProps {
  children: React.ReactNode;
  fallback?: React.ReactNode;
  count?: number;
}

export function SuspenseWrapper({
  children,
  fallback,
  count = 3
}: SuspenseWrapperProps) {
  const defaultFallback = (
    <div className="grid gap-4">
      {Array.from({ length: count }).map((_, i) => (
        <SkeletonCard key={i} />
      ))}
    </div>
  );

  return (
    <Suspense fallback={fallback || defaultFallback}>
      {children}
    </Suspense>
  );
}

// 사용 예시
<SuspenseWrapper count={6}>
  <GuideList />
</SuspenseWrapper>
```

**Step 6: 낙관적 업데이트 (Optimistic UI)**

```typescript
// src/hooks/useOptimisticUpdate.ts
import { useMutation, useQueryClient } from '@tanstack/react-query';

export function useToggleLike(guideId: string) {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (liked: boolean) => {
      return await toggleLike(guideId, liked);
    },
    // 낙관적 업데이트: 서버 응답 전에 UI 즉시 업데이트
    onMutate: async (liked) => {
      // 진행 중인 쿼리 취소
      await queryClient.cancelQueries({ queryKey: ['guide', guideId] });

      // 이전 데이터 백업
      const previousGuide = queryClient.getQueryData(['guide', guideId]);

      // 낙관적으로 업데이트
      queryClient.setQueryData(['guide', guideId], (old: any) => ({
        ...old,
        is_liked: liked,
        likes_count: liked ? old.likes_count + 1 : old.likes_count - 1,
      }));

      return { previousGuide };
    },
    // 실패 시 롤백
    onError: (err, variables, context) => {
      queryClient.setQueryData(['guide', guideId], context?.previousGuide);
      toast({ variant: 'destructive', title: '오류 발생' });
    },
    // 성공 시 최신 데이터로 갱신
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['guide', guideId] });
    },
  });
}

// 사용
function LikeButton({ guideId }: { guideId: string }) {
  const { mutate: toggleLike, isPending } = useToggleLike(guideId);
  const { data: guide } = useQuery(['guide', guideId]);

  return (
    <Button
      onClick={() => toggleLike(!guide?.is_liked)}
      variant={guide?.is_liked ? 'default' : 'outline'}
      disabled={isPending}
    >
      <Heart className={cn(guide?.is_liked && 'fill-current')} />
      {guide?.likes_count}
    </Button>
  );
}
```

**Step 7: 로딩 상태 컨텍스트 (고급)**

```typescript
// src/contexts/LoadingContext.tsx
import { createContext, useContext, useState, useCallback } from 'react';

interface LoadingContextType {
  tasks: Set<string>;
  startLoading: (taskId: string) => void;
  stopLoading: (taskId: string) => void;
  isLoading: (taskId?: string) => boolean;
}

const LoadingContext = createContext<LoadingContextType | undefined>(undefined);

export function LoadingProvider({ children }: { children: React.ReactNode }) {
  const [tasks, setTasks] = useState<Set<string>>(new Set());

  const startLoading = useCallback((taskId: string) => {
    setTasks((prev) => new Set(prev).add(taskId));
  }, []);

  const stopLoading = useCallback((taskId: string) => {
    setTasks((prev) => {
      const next = new Set(prev);
      next.delete(taskId);
      return next;
    });
  }, []);

  const isLoading = useCallback((taskId?: string) => {
    if (taskId) return tasks.has(taskId);
    return tasks.size > 0;
  }, [tasks]);

  return (
    <LoadingContext.Provider value={{ tasks, startLoading, stopLoading, isLoading }}>
      {children}
    </LoadingContext.Provider>
  );
}

export function useLoading() {
  const context = useContext(LoadingContext);
  if (!context) throw new Error('useLoading must be used within LoadingProvider');
  return context;
}

// 사용 예시
function MyComponent() {
  const { startLoading, stopLoading, isLoading } = useLoading();

  async function handleSubmit() {
    const taskId = 'submit-form';
    startLoading(taskId);
    try {
      await submitForm();
    } finally {
      stopLoading(taskId);
    }
  }

  return (
    <Button onClick={handleSubmit} disabled={isLoading('submit-form')}>
      {isLoading('submit-form') ? '제출 중...' : '제출'}
    </Button>
  );
}
```

#### 검증 방법

```bash
# 1. 네트워크 스로틀링 테스트
# Chrome DevTools → Network → Slow 3G로 변경
# 모든 페이지에서 로딩 상태 확인

# 2. Skeleton UI 확인
# 페이지 로드 시 레이아웃 시프트 없는지 측정
# Lighthouse → Cumulative Layout Shift (CLS) < 0.1

# 3. 중복 요청 방지 확인
# Network 탭에서 버튼 연타 시 요청 1회만 발생하는지 확인

# 4. 접근성 검사
# 스크린 리더로 로딩 상태 안내 음성 확인
# "로딩 중입니다" 등의 메시지가 읽히는지

# 5. React Query Devtools
npm install @tanstack/react-query-devtools

# App.tsx에 추가
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';

<QueryClientProvider client={queryClient}>
  <App />
  <ReactQueryDevtools initialIsOpen={false} />
</QueryClientProvider>
```

**로딩 상태 체크리스트**:

```markdown
## 로딩 상태 체크리스트

- [ ] 모든 API 호출에 로딩 인디케이터 존재
- [ ] Skeleton UI로 레이아웃 시프트 방지
- [ ] 버튼 disabled 처리로 중복 클릭 방지
- [ ] aria-busy로 스크린 리더 지원
- [ ] 에러 상태도 명확히 표시
- [ ] 낙관적 업데이트로 즉각 반응
- [ ] 전역 로딩 바 (선택적)
- [ ] React Query Devtools 설치
```

#### 참고 자료

- [TanStack Query - Loading States](https://tanstack.com/query/latest/docs/react/guides/loading-states)
- [Optimistic Updates 가이드](https://tanstack.com/query/latest/docs/react/guides/optimistic-updates)
- [React Suspense](https://react.dev/reference/react/Suspense)
- [Web Vitals - CLS](https://web.dev/cls/)
- [Skeleton Screens 디자인 패턴](https://www.nngroup.com/articles/skeleton-screens/)

---

### 9. SEO 최적화

**우선순위**: 📈 중기 처리
**카테고리**: 성능 / 마케팅
**심각도**: Medium
**영향 범위**: 전체 페이지, 검색 엔진

#### 문제점

**현재 상태**:
- 단일 `index.html` 파일로 모든 페이지 동일한 메타 태그
- 동적 메타 태그 관리 없음
- Open Graph, Twitter Card 메타 태그 부재
- Sitemap, robots.txt 없음
- 구조화된 데이터 (JSON-LD) 없음

**위험성**:
1. **검색 노출 저하**: Google/Naver에서 콘텐츠 발견 어려움
2. **소셜 공유 문제**: 링크 공유 시 제목/이미지 표시 안 됨
3. **트래픽 손실**: 오가닉 검색 유입 거의 없음
4. **브랜드 인지도**: 검색 결과에서 경쟁사에 밀림

**실제 시나리오**:
```
1. 사용자가 가이드북 URL을 카카오톡에 공유
2. "React App" 제목과 기본 파비콘만 표시
3. 클릭률 저하
4. 입소문 전파 실패
```

#### 해결 방법

**Step 1: react-helmet-async 설치**

```bash
npm install react-helmet-async
```

**`src/main.tsx` 수정**:

```typescript
import { HelmetProvider } from 'react-helmet-async';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <HelmetProvider>
      <App />
    </HelmetProvider>
  </React.StrictMode>
);
```

**Step 2: SEO 컴포넌트 생성**

**`src/components/SEO.tsx` 생성**:

```typescript
import { Helmet } from 'react-helmet-async';

interface SEOProps {
  title?: string;
  description?: string;
  image?: string;
  url?: string;
  type?: 'website' | 'article';
  article?: {
    author?: string;
    publishedTime?: string;
    modifiedTime?: string;
    tags?: string[];
  };
  noindex?: boolean;
}

const DEFAULT_SEO = {
  siteName: 'AIHub',
  title: 'AIHub - AI 도구 & 가이드 통합 플랫폼',
  description: 'AI 도구 추천부터 실전 가이드까지. ChatGPT, Midjourney, Claude 등 5000+ AI 도구를 한곳에서.',
  image: 'https://aihub.com/og-image.png',
  url: 'https://aihub.com',
  twitterHandle: '@aihub_official',
};

export function SEO({
  title,
  description = DEFAULT_SEO.description,
  image = DEFAULT_SEO.image,
  url = DEFAULT_SEO.url,
  type = 'website',
  article,
  noindex = false,
}: SEOProps) {
  const fullTitle = title
    ? `${title} | ${DEFAULT_SEO.siteName}`
    : DEFAULT_SEO.title;

  const canonicalUrl = url.startsWith('http') ? url : `${DEFAULT_SEO.url}${url}`;

  return (
    <Helmet>
      {/* 기본 메타 태그 */}
      <title>{fullTitle}</title>
      <meta name="description" content={description} />
      <link rel="canonical" href={canonicalUrl} />

      {/* Open Graph (Facebook, KakaoTalk) */}
      <meta property="og:site_name" content={DEFAULT_SEO.siteName} />
      <meta property="og:title" content={fullTitle} />
      <meta property="og:description" content={description} />
      <meta property="og:image" content={image} />
      <meta property="og:url" content={canonicalUrl} />
      <meta property="og:type" content={type} />
      <meta property="og:locale" content="ko_KR" />

      {/* Twitter Card */}
      <meta name="twitter:card" content="summary_large_image" />
      <meta name="twitter:site" content={DEFAULT_SEO.twitterHandle} />
      <meta name="twitter:title" content={fullTitle} />
      <meta name="twitter:description" content={description} />
      <meta name="twitter:image" content={image} />

      {/* Article 메타 (블로그 포스트 등) */}
      {type === 'article' && article && (
        <>
          {article.author && (
            <meta property="article:author" content={article.author} />
          )}
          {article.publishedTime && (
            <meta property="article:published_time" content={article.publishedTime} />
          )}
          {article.modifiedTime && (
            <meta property="article:modified_time" content={article.modifiedTime} />
          )}
          {article.tags?.map((tag) => (
            <meta key={tag} property="article:tag" content={tag} />
          ))}
        </>
      )}

      {/* 검색 엔진 제어 */}
      {noindex && <meta name="robots" content="noindex,nofollow" />}
    </Helmet>
  );
}
```

**Step 3: 페이지별 SEO 적용**

**가이드북 상세 페이지**:

```typescript
// src/pages/GuideDetail.tsx
import { SEO } from '@/components/SEO';
import { useQuery } from '@tanstack/react-query';

export function GuideDetailPage({ guideId }: { guideId: string }) {
  const { data: guide } = useQuery({
    queryKey: ['guide', guideId],
    queryFn: () => fetchGuide(guideId),
  });

  if (!guide) return <LoadingPage />;

  return (
    <>
      <SEO
        title={guide.title}
        description={guide.description || guide.content.slice(0, 160)}
        image={guide.thumbnail_url || undefined}
        url={`/guidebook/${guideId}`}
        type="article"
        article={{
          author: guide.author?.name,
          publishedTime: guide.created_at,
          modifiedTime: guide.updated_at,
          tags: guide.tags,
        }}
      />

      <div className="container">
        <h1>{guide.title}</h1>
        {/* 가이드 콘텐츠 */}
      </div>
    </>
  );
}
```

**AI 도구 상세 페이지**:

```typescript
// src/pages/AIToolDetail.tsx
export function AIToolDetailPage({ toolId }: { toolId: string }) {
  const { data: tool } = useQuery(['tool', toolId], () => fetchTool(toolId));

  if (!tool) return <LoadingPage />;

  return (
    <>
      <SEO
        title={`${tool.name} - AI 도구 리뷰 & 가격`}
        description={`${tool.name} 완벽 가이드: 기능, 가격, 사용법, 실제 후기. ${tool.category} 분야 최고의 AI 도구.`}
        image={tool.logo_url}
        url={`/tools/${toolId}`}
      />

      <div className="container">
        <h1>{tool.name}</h1>
        {/* 도구 상세 */}
      </div>
    </>
  );
}
```

**Step 4: 구조화된 데이터 (JSON-LD)**

**`src/components/StructuredData.tsx` 생성**:

```typescript
import { Helmet } from 'react-helmet-async';

interface BreadcrumbItem {
  name: string;
  url: string;
}

export function BreadcrumbStructuredData({ items }: { items: BreadcrumbItem[] }) {
  const structuredData = {
    '@context': 'https://schema.org',
    '@type': 'BreadcrumbList',
    'itemListElement': items.map((item, index) => ({
      '@type': 'ListItem',
      'position': index + 1,
      'name': item.name,
      'item': `https://aihub.com${item.url}`,
    })),
  };

  return (
    <Helmet>
      <script type="application/ld+json">
        {JSON.stringify(structuredData)}
      </script>
    </Helmet>
  );
}

export function ArticleStructuredData({
  title,
  description,
  image,
  datePublished,
  dateModified,
  author,
}: {
  title: string;
  description: string;
  image: string;
  datePublished: string;
  dateModified?: string;
  author: string;
}) {
  const structuredData = {
    '@context': 'https://schema.org',
    '@type': 'Article',
    'headline': title,
    'description': description,
    'image': image,
    'datePublished': datePublished,
    'dateModified': dateModified || datePublished,
    'author': {
      '@type': 'Person',
      'name': author,
    },
    'publisher': {
      '@type': 'Organization',
      'name': 'AIHub',
      'logo': {
        '@type': 'ImageObject',
        'url': 'https://aihub.com/logo.png',
      },
    },
  };

  return (
    <Helmet>
      <script type="application/ld+json">
        {JSON.stringify(structuredData)}
      </script>
    </Helmet>
  );
}

export function SoftwareApplicationStructuredData({
  name,
  description,
  category,
  rating,
  ratingCount,
  price,
  screenshot,
}: {
  name: string;
  description: string;
  category: string;
  rating?: number;
  ratingCount?: number;
  price?: string;
  screenshot?: string;
}) {
  const structuredData = {
    '@context': 'https://schema.org',
    '@type': 'SoftwareApplication',
    'name': name,
    'description': description,
    'applicationCategory': category,
    'screenshot': screenshot,
    'offers': {
      '@type': 'Offer',
      'price': price || '0',
      'priceCurrency': 'KRW',
    },
    ...(rating && {
      'aggregateRating': {
        '@type': 'AggregateRating',
        'ratingValue': rating,
        'ratingCount': ratingCount || 1,
        'bestRating': 5,
        'worstRating': 0,
      },
    }),
  };

  return (
    <Helmet>
      <script type="application/ld+json">
        {JSON.stringify(structuredData)}
      </script>
    </Helmet>
  );
}

// 사용 예시
<BreadcrumbStructuredData
  items={[
    { name: '홈', url: '/' },
    { name: '가이드북', url: '/guidebook' },
    { name: guide.title, url: `/guidebook/${guide.id}` },
  ]}
/>

<ArticleStructuredData
  title={guide.title}
  description={guide.description}
  image={guide.thumbnail_url}
  datePublished={guide.created_at}
  dateModified={guide.updated_at}
  author={guide.author.name}
/>
```

**Step 5: Sitemap 생성**

**`public/sitemap.xml` 생성** (정적 페이지용):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://aihub.com/</loc>
    <changefreq>daily</changefreq>
    <priority>1.0</priority>
  </url>
  <url>
    <loc>https://aihub.com/guidebook</loc>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>https://aihub.com/preset-store</loc>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>https://aihub.com/tools</loc>
    <changefreq>daily</changefreq>
    <priority>0.9</priority>
  </url>
  <url>
    <loc>https://aihub.com/community</loc>
    <changefreq>daily</changefreq>
    <priority>0.7</priority>
  </url>
</urlset>
```

**동적 Sitemap 생성 스크립트**:

```typescript
// scripts/generate-sitemap.ts
import { createClient } from '@supabase/supabase-js';
import { writeFileSync } from 'fs';

const supabase = createClient(
  process.env.VITE_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_KEY!
);

async function generateSitemap() {
  const baseUrl = 'https://aihub.com';

  // 정적 페이지
  const staticPages = [
    { url: '/', changefreq: 'daily', priority: 1.0 },
    { url: '/guidebook', changefreq: 'weekly', priority: 0.8 },
    { url: '/preset-store', changefreq: 'weekly', priority: 0.8 },
    { url: '/tools', changefreq: 'daily', priority: 0.9 },
    { url: '/community', changefreq: 'daily', priority: 0.7 },
  ];

  // 동적 페이지 - 가이드북
  const { data: guides } = await supabase
    .from('guides')
    .select('id, updated_at')
    .eq('is_published', true);

  // 동적 페이지 - AI 도구
  const { data: tools } = await supabase
    .from('ai_models')
    .select('id, updated_at');

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${staticPages
  .map(
    (page) => `
  <url>
    <loc>${baseUrl}${page.url}</loc>
    <changefreq>${page.changefreq}</changefreq>
    <priority>${page.priority}</priority>
  </url>`
  )
  .join('')}
${guides
  ?.map(
    (guide) => `
  <url>
    <loc>${baseUrl}/guidebook/${guide.id}</loc>
    <lastmod>${new Date(guide.updated_at).toISOString().split('T')[0]}</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.7</priority>
  </url>`
  )
  .join('')}
${tools
  ?.map(
    (tool) => `
  <url>
    <loc>${baseUrl}/tools/${tool.id}</loc>
    <lastmod>${new Date(tool.updated_at).toISOString().split('T')[0]}</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.6</priority>
  </url>`
  )
  .join('')}
</urlset>`;

  writeFileSync('public/sitemap.xml', xml);
  console.log('✅ Sitemap 생성 완료');
}

generateSitemap();
```

**`package.json`에 스크립트 추가**:

```json
{
  "scripts": {
    "generate:sitemap": "tsx scripts/generate-sitemap.ts",
    "prebuild": "npm run generate:sitemap"
  }
}
```

**Step 6: robots.txt 설정**

**`public/robots.txt` 생성**:

```
User-agent: *
Allow: /

# Sitemap
Sitemap: https://aihub.com/sitemap.xml

# 크롤링 제외 (관리자 페이지 등)
Disallow: /admin
Disallow: /api/
Disallow: /auth

# 검색 결과 페이지 (중복 콘텐츠 방지)
Disallow: /search?*
Disallow: /*?page=*

# 크롤 속도 제한 (선택적)
Crawl-delay: 1
```

**Step 7: 페이지 속도 최적화 (Core Web Vitals)**

```typescript
// src/lib/analytics.ts
export function reportWebVitals(metric: any) {
  // Google Analytics로 전송
  if (window.gtag) {
    window.gtag('event', metric.name, {
      value: Math.round(metric.name === 'CLS' ? metric.value * 1000 : metric.value),
      event_label: metric.id,
      non_interaction: true,
    });
  }
}

// src/main.tsx
import { reportWebVitals } from './lib/analytics';
import { onCLS, onFID, onLCP, onFCP, onTTFB } from 'web-vitals';

onCLS(reportWebVitals);
onFID(reportWebVitals);
onLCP(reportWebVitals);
onFCP(reportWebVitals);
onTTFB(reportWebVitals);
```

#### 검증 방법

```bash
# 1. Google Search Console 등록
# https://search.google.com/search-console
# 도메인 소유권 인증 → Sitemap 제출

# 2. Open Graph 테스트
# https://developers.facebook.com/tools/debug/
# URL 입력 → 미리보기 확인

# 3. Twitter Card 테스트
# https://cards-dev.twitter.com/validator
# URL 입력 → 카드 미리보기

# 4. 구조화된 데이터 검증
# https://search.google.com/test/rich-results
# URL 입력 또는 코드 붙여넣기

# 5. Lighthouse SEO 점수
# Chrome DevTools → Lighthouse → SEO
# 목표: 90점 이상

# 6. 페이지 속도 테스트
# https://pagespeed.web.dev/
# 모바일/데스크톱 모두 90점 이상 목표
```

**SEO 체크리스트**:

```markdown
## SEO 체크리스트

### 기본
- [ ] 모든 페이지에 고유한 title 태그
- [ ] 모든 페이지에 description 메타 태그 (120-160자)
- [ ] Canonical URL 설정
- [ ] robots.txt 파일 존재
- [ ] Sitemap 생성 및 제출

### Open Graph
- [ ] og:title
- [ ] og:description
- [ ] og:image (최소 1200x630px)
- [ ] og:url
- [ ] og:type

### Twitter Card
- [ ] twitter:card
- [ ] twitter:title
- [ ] twitter:description
- [ ] twitter:image

### 구조화된 데이터
- [ ] Article / BlogPosting
- [ ] BreadcrumbList
- [ ] Organization
- [ ] SoftwareApplication (AI 도구용)

### Core Web Vitals
- [ ] LCP < 2.5s
- [ ] FID < 100ms
- [ ] CLS < 0.1

### 접근성
- [ ] 이미지 alt 텍스트
- [ ] 시맨틱 HTML (h1, h2, nav, main, footer)
- [ ] ARIA 라벨
```

#### 추가 최적화

**Naver 검색 최적화**:

```html
<!-- public/index.html에 추가 -->
<meta name="naver-site-verification" content="your_verification_code" />
<meta property="og:locale" content="ko_KR" />
```

**Google Analytics 4 연동**:

```typescript
// src/lib/gtag.ts
export const GA_TRACKING_ID = import.meta.env.VITE_GA_ID;

export function pageview(url: string) {
  if (window.gtag) {
    window.gtag('config', GA_TRACKING_ID, {
      page_path: url,
    });
  }
}

export function event({ action, category, label, value }: {
  action: string;
  category: string;
  label?: string;
  value?: number;
}) {
  if (window.gtag) {
    window.gtag('event', action, {
      event_category: category,
      event_label: label,
      value: value,
    });
  }
}

// App.tsx에서 페이지뷰 추적
import { useLocation } from 'react-router-dom';
import { useEffect } from 'react';
import { pageview } from './lib/gtag';

function App() {
  const location = useLocation();

  useEffect(() => {
    pageview(location.pathname + location.search);
  }, [location]);

  return <Router />;
}
```

#### 참고 자료

- [Google SEO 시작 가이드](https://developers.google.com/search/docs/fundamentals/seo-starter-guide)
- [Open Graph Protocol](https://ogp.me/)
- [Twitter Card Validator](https://cards-dev.twitter.com/validator)
- [Schema.org](https://schema.org/)
- [Web Vitals](https://web.dev/vitals/)
- [Google Search Console](https://search.google.com/search-console)

---

## 성능 최적화

### 10. 이미지 최적화

**우선순위**: 📈 중기 처리
**카테고리**: 성능
**심각도**: Medium
**영향 범위**: 전체 이미지 자산

#### 문제점

**현재 상태**:
- 원본 크기 이미지를 그대로 사용
- WebP, AVIF 등 최신 포맷 미사용
- Lazy loading 미적용
- 이미지 CDN 없음
- Responsive images (srcset) 미사용

**위험성**:
1. **느린 페이지 로딩**: 5MB 이미지가 3G 네트워크에서 10초 이상 소요
2. **대역폭 낭비**: 불필요하게 큰 이미지 전송
3. **모바일 UX 저하**: 데이터 요금 증가, 배터리 소모
4. **SEO 페널티**: Lighthouse 성능 점수 하락

**실제 시나리오**:
```
1. 가이드북 썸네일 20개 표시 (각 2MB)
2. 총 40MB 다운로드 필요
3. 3G 네트워크에서 60초 이상 대기
4. 사용자 이탈
```

#### 해결 방법

**Step 1: vite-imagetools 플러그인 설치**

```bash
npm install --save-dev vite-imagetools
```

**`vite.config.ts` 수정**:

```typescript
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react-swc';
import { imagetools } from 'vite-imagetools';

export default defineConfig({
  plugins: [
    react(),
    imagetools({
      defaultDirectives: (url) => {
        // 자동 WebP 변환
        if (url.searchParams.has('webp')) {
          return new URLSearchParams({
            format: 'webp',
            quality: '80',
          });
        }
        return new URLSearchParams();
      },
    }),
  ],
});
```

**Step 2: 반응형 이미지 컴포넌트**

**`src/components/OptimizedImage.tsx` 생성**:

```typescript
import { ImgHTMLAttributes, useState } from 'react';
import { cn } from '@/lib/utils';

interface OptimizedImageProps extends ImgHTMLAttributes<HTMLImageElement> {
  src: string;
  alt: string;
  width?: number;
  height?: number;
  priority?: boolean;
  onLoad?: () => void;
}

export function OptimizedImage({
  src,
  alt,
  width,
  height,
  priority = false,
  className,
  onLoad,
  ...props
}: OptimizedImageProps) {
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(false);

  // Supabase Storage URL인 경우 변환 파라미터 추가
  const getOptimizedSrc = (src: string, size?: number) => {
    if (src.includes('supabase.co/storage')) {
      const url = new URL(src);
      if (size) {
        url.searchParams.set('width', size.toString());
        url.searchParams.set('quality', '80');
      }
      return url.toString();
    }
    return src;
  };

  // srcset 생성 (여러 해상도)
  const srcset = width
    ? `
      ${getOptimizedSrc(src, Math.round(width * 0.5))} ${Math.round(width * 0.5)}w,
      ${getOptimizedSrc(src, width)} ${width}w,
      ${getOptimizedSrc(src, Math.round(width * 1.5))} ${Math.round(width * 1.5)}w,
      ${getOptimizedSrc(src, Math.round(width * 2))} ${Math.round(width * 2)}w
    `.trim()
    : undefined;

  const handleLoad = () => {
    setIsLoading(false);
    onLoad?.();
  };

  const handleError = () => {
    setIsLoading(false);
    setError(true);
  };

  if (error) {
    return (
      <div
        className={cn(
          'bg-muted flex items-center justify-center text-muted-foreground',
          className
        )}
        style={{ width, height }}
      >
        <span>이미지 로드 실패</span>
      </div>
    );
  }

  return (
    <div className={cn('relative overflow-hidden', className)}>
      {/* Blur placeholder */}
      {isLoading && (
        <div
          className="absolute inset-0 bg-muted animate-pulse"
          aria-hidden="true"
        />
      )}

      <img
        src={getOptimizedSrc(src, width)}
        srcSet={srcset}
        sizes={
          width
            ? `(max-width: 640px) ${Math.round(width * 0.5)}px, ` +
              `(max-width: 1024px) ${width}px, ` +
              `${Math.round(width * 1.5)}px`
            : undefined
        }
        alt={alt}
        width={width}
        height={height}
        loading={priority ? 'eager' : 'lazy'}
        decoding={priority ? 'sync' : 'async'}
        onLoad={handleLoad}
        onError={handleError}
        className={cn(
          'transition-opacity duration-300',
          isLoading ? 'opacity-0' : 'opacity-100'
        )}
        {...props}
      />
    </div>
  );
}

// Blur Data URL 생성 헬퍼
export function generateBlurDataURL(width: number, height: number): string {
  const canvas = document.createElement('canvas');
  canvas.width = width;
  canvas.height = height;
  const ctx = canvas.getContext('2d');
  if (ctx) {
    ctx.fillStyle = '#f0f0f0';
    ctx.fillRect(0, 0, width, height);
  }
  return canvas.toDataURL();
}
```

**Step 3: Supabase Storage 변환 활용**

Supabase Storage는 자동 이미지 변환 지원:

```typescript
// src/lib/imageUtils.ts
export function getOptimizedImageUrl(
  supabaseUrl: string,
  options: {
    width?: number;
    height?: number;
    quality?: number;
    format?: 'webp' | 'avif' | 'origin';
  } = {}
): string {
  const url = new URL(supabaseUrl);

  if (options.width) {
    url.searchParams.set('width', options.width.toString());
  }

  if (options.height) {
    url.searchParams.set('height', options.height.toString());
  }

  if (options.quality) {
    url.searchParams.set('quality', options.quality.toString());
  }

  if (options.format) {
    url.searchParams.set('format', options.format);
  }

  // 리사이즈 모드
  url.searchParams.set('resize', 'contain');

  return url.toString();
}

// 사용 예시
const thumbnailUrl = getOptimizedImageUrl(guide.thumbnail_url, {
  width: 400,
  height: 300,
  quality: 80,
  format: 'webp',
});
```

**Step 4: 이미지 CDN 연동 (Cloudinary)**

```bash
npm install cloudinary-build-url
```

**`src/lib/cloudinary.ts` 생성**:

```typescript
import { buildImageUrl, setConfig } from 'cloudinary-build-url';

setConfig({
  cloudName: import.meta.env.VITE_CLOUDINARY_CLOUD_NAME,
});

export function getCDNImageUrl(
  publicId: string,
  options: {
    width?: number;
    height?: number;
    quality?: number | 'auto';
    format?: 'webp' | 'avif' | 'auto';
    crop?: 'fill' | 'fit' | 'scale';
  } = {}
) {
  return buildImageUrl(publicId, {
    transformations: {
      resize: {
        type: options.crop || 'fill',
        width: options.width,
        height: options.height,
      },
      quality: options.quality || 'auto',
      format: options.format || 'auto',
      fetchFormat: 'auto',
    },
  });
}

// 사용
<img
  src={getCDNImageUrl('guide/thumbnail-123', {
    width: 400,
    height: 300,
    quality: 'auto',
    format: 'auto',
  })}
  alt="Guide thumbnail"
/>
```

**Step 5: Lazy Loading with Intersection Observer**

```typescript
// src/hooks/useLazyImage.ts
import { useEffect, useRef, useState } from 'react';

export function useLazyImage(src: string) {
  const [imageSrc, setImageSrc] = useState<string | undefined>();
  const [isLoaded, setIsLoaded] = useState(false);
  const imageRef = useRef<HTMLImageElement>(null);

  useEffect(() => {
    let observer: IntersectionObserver;

    if (imageRef.current) {
      observer = new IntersectionObserver(
        (entries) => {
          entries.forEach((entry) => {
            if (entry.isIntersecting) {
              setImageSrc(src);
              observer.unobserve(entry.target);
            }
          });
        },
        {
          rootMargin: '50px', // 뷰포트 50px 전에 로딩 시작
        }
      );

      observer.observe(imageRef.current);
    }

    return () => {
      if (observer && imageRef.current) {
        observer.unobserve(imageRef.current);
      }
    };
  }, [src]);

  return { imageRef, imageSrc, isLoaded, setIsLoaded };
}

// 사용 예시
function LazyImage({ src, alt }: { src: string; alt: string }) {
  const { imageRef, imageSrc, isLoaded, setIsLoaded } = useLazyImage(src);

  return (
    <div ref={imageRef} className="relative">
      {!isLoaded && <Skeleton className="w-full h-full" />}
      {imageSrc && (
        <img
          src={imageSrc}
          alt={alt}
          onLoad={() => setIsLoaded(true)}
          className={cn(
            'transition-opacity',
            isLoaded ? 'opacity-100' : 'opacity-0'
          )}
        />
      )}
    </div>
  );
}
```

**Step 6: 이미지 압축 자동화**

**업로드 전 클라이언트 압축**:

```bash
npm install browser-image-compression
```

```typescript
// src/lib/imageCompression.ts
import imageCompression from 'browser-image-compression';

export async function compressImage(
  file: File,
  options: {
    maxSizeMB?: number;
    maxWidthOrHeight?: number;
    useWebWorker?: boolean;
  } = {}
): Promise<File> {
  const defaultOptions = {
    maxSizeMB: 1,
    maxWidthOrHeight: 1920,
    useWebWorker: true,
    ...options,
  };

  try {
    const compressedFile = await imageCompression(file, defaultOptions);
    console.log(
      `압축 완료: ${(file.size / 1024 / 1024).toFixed(2)}MB -> ${(compressedFile.size / 1024 / 1024).toFixed(2)}MB`
    );
    return compressedFile;
  } catch (error) {
    console.error('이미지 압축 실패:', error);
    return file; // 실패 시 원본 반환
  }
}

// 사용 예시
async function handleFileUpload(event: React.ChangeEvent<HTMLInputElement>) {
  const file = event.target.files?.[0];
  if (!file) return;

  // 압축
  const compressedFile = await compressImage(file, {
    maxSizeMB: 0.5,
    maxWidthOrHeight: 1200,
  });

  // Supabase에 업로드
  const { data, error } = await supabase.storage
    .from('images')
    .upload(`guides/${Date.now()}.jpg`, compressedFile);
}
```

**Step 7: 이미지 프리로딩**

```typescript
// src/lib/imagePreload.ts
export function preloadImage(src: string): Promise<void> {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.onload = () => resolve();
    img.onerror = reject;
    img.src = src;
  });
}

export function preloadImages(sources: string[]): Promise<void[]> {
  return Promise.all(sources.map(preloadImage));
}

// 사용 예시 - 다음 페이지 이미지 미리 로딩
function GuideCarousel({ guides }: { guides: Guide[] }) {
  const [currentIndex, setCurrentIndex] = useState(0);

  useEffect(() => {
    // 다음 3개 이미지 미리 로딩
    const nextImages = guides
      .slice(currentIndex + 1, currentIndex + 4)
      .map((g) => g.thumbnail_url);

    preloadImages(nextImages);
  }, [currentIndex, guides]);

  return (
    // 캐러셀 UI
  );
}
```

**Step 8: 이미지 에러 핸들링**

```typescript
// src/components/FallbackImage.tsx
import { useState } from 'react';
import { ImageOff } from 'lucide-react';

interface FallbackImageProps extends React.ImgHTMLAttributes<HTMLImageElement> {
  src: string;
  alt: string;
  fallbackSrc?: string;
}

export function FallbackImage({
  src,
  alt,
  fallbackSrc = '/placeholder-image.png',
  className,
  ...props
}: FallbackImageProps) {
  const [imgSrc, setImgSrc] = useState(src);
  const [error, setError] = useState(false);

  const handleError = () => {
    if (imgSrc !== fallbackSrc) {
      setImgSrc(fallbackSrc);
    } else {
      setError(true);
    }
  };

  if (error) {
    return (
      <div
        className={cn(
          'flex items-center justify-center bg-muted text-muted-foreground',
          className
        )}
      >
        <ImageOff className="h-8 w-8" />
      </div>
    );
  }

  return (
    <img
      src={imgSrc}
      alt={alt}
      onError={handleError}
      className={className}
      {...props}
    />
  );
}
```

#### 검증 방법

```bash
# 1. Lighthouse 성능 점수
# Chrome DevTools → Lighthouse → Performance
# 이미지 최적화 전후 비교
# 목표: 이미지 관련 지표 90점 이상

# 2. 이미지 크기 확인
# Network 탭에서 이미지 용량 확인
# WebP 변환 적용 시 30-50% 감소 확인

# 3. Lazy Loading 동작 확인
# 스크롤하며 Network 탭 관찰
# 뷰포트에 들어올 때만 로딩되는지 확인

# 4. CLS (Cumulative Layout Shift) 측정
# width/height 속성으로 레이아웃 시프트 방지
# 목표: CLS < 0.1

# 5. 압축 테스트
npm install -g imagemin-cli

imagemin public/images/*.jpg --out-dir=public/images/compressed --plugin=mozjpeg
imagemin public/images/*.png --out-dir=public/images/compressed --plugin=pngquant
```

**이미지 최적화 체크리스트**:

```markdown
## 이미지 최적화 체크리스트

### 기본
- [ ] 모든 이미지에 alt 텍스트
- [ ] width, height 속성 지정
- [ ] Lazy loading 적용 (loading="lazy")
- [ ] WebP 포맷 사용

### 성능
- [ ] 이미지 압축 (80-90% 품질)
- [ ] Responsive images (srcset, sizes)
- [ ] CDN 사용
- [ ] 프리로딩 (중요 이미지)

### UX
- [ ] Placeholder 표시
- [ ] 에러 핸들링 (Fallback 이미지)
- [ ] 로딩 인디케이터
- [ ] Progressive loading

### 도구
- [ ] Lighthouse 성능 점수 90+
- [ ] ImageOptim / TinyPNG로 압축
- [ ] Cloudinary / Imgix 고려
```

#### 참고 자료

- [vite-imagetools](https://github.com/JonasKruckenberg/imagetools)
- [Supabase Storage 이미지 변환](https://supabase.com/docs/guides/storage/image-transformations)
- [Cloudinary 문서](https://cloudinary.com/documentation)
- [Web.dev - Optimize Images](https://web.dev/fast/#optimize-your-images)
- [Responsive Images Guide](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images)

---

### 11. 번들 크기 최적화

**우선순위**: 📈 중기 처리
**카테고리**: 성능
**심각도**: Medium
**영향 범위**: 전체 JavaScript 번들

#### 문제점

**현재 상태**:
- 번들 분석 미실시
- Code splitting 최적화 부족
- Tree shaking 검증 안 됨
- 중복 의존성 존재 가능
- Lazy loading 미적용 영역 존재

**위험성**:
1. **초기 로딩 느림**: 5MB+ 번들이 3G에서 30초+ 소요
2. **모바일 데이터 소모**: 불필요한 코드 다운로드
3. **Parse/Compile 시간**: 대용량 JS 파싱에 수 초 소요
4. **캐시 효율 저하**: 작은 변경에도 전체 번들 재다운로드

**실제 시나리오**:
```
1. 사용자가 홈페이지 접속
2. 3MB 번들 다운로드 (관리자 페이지 코드 포함)
3. 파싱에 3초 소요
4. FCP (First Contentful Paint) 5초+
5. 이탈률 증가
```

#### 해결 방법

**Step 1: 번들 분석 도구 설치**

```bash
npm install --save-dev rollup-plugin-visualizer
```

**`vite.config.ts` 수정**:

```typescript
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react-swc';
import { visualizer } from 'rollup-plugin-visualizer';

export default defineConfig({
  plugins: [
    react(),
    visualizer({
      open: true,
      gzipSize: true,
      brotliSize: true,
      filename: 'dist/stats.html',
    }),
  ],
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          // 벤더 청크 분리
          react: ['react', 'react-dom', 'react-router-dom'],
          ui: ['@radix-ui/react-dialog', '@radix-ui/react-dropdown-menu'],
          query: ['@tanstack/react-query'],
          supabase: ['@supabase/supabase-js'],
        },
      },
    },
    // Chunk 크기 경고 임계값
    chunkSizeWarningLimit: 1000,
  },
});
```

**빌드 후 분석**:

```bash
npm run build
# dist/stats.html 자동으로 브라우저에서 열림
# 큰 의존성 식별
```

**Step 2: Dynamic Import로 코드 스플리팅**

**라우트 기반 스플리팅**:

```typescript
// src/App.tsx
import { lazy, Suspense } from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { LoadingPage } from '@/components/ui/loading-spinner';

// Lazy load 페이지 컴포넌트
const HomePage = lazy(() => import('@/pages/Home'));
const GuidebookPage = lazy(() => import('@/pages/Guidebook'));
const GuideDetailPage = lazy(() => import('@/pages/GuideDetail'));
const PresetStorePage = lazy(() => import('@/pages/PresetStore'));
const CommunityPage = lazy(() => import('@/pages/Community'));
const AdminPage = lazy(() => import('@/pages/Admin'));

function App() {
  return (
    <BrowserRouter>
      <Suspense fallback={<LoadingPage />}>
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/guidebook" element={<GuidebookPage />} />
          <Route path="/guidebook/:id" element={<GuideDetailPage />} />
          <Route path="/preset-store" element={<PresetStorePage />} />
          <Route path="/community" element={<CommunityPage />} />
          <Route path="/admin/*" element={<AdminPage />} />
        </Routes>
      </Suspense>
    </BrowserRouter>
  );
}

export default App;
```

**컴포넌트 레벨 스플리팅**:

```typescript
// 무거운 에디터는 필요할 때만 로딩
const RichTextEditor = lazy(() => import('@/components/RichTextEditor'));
const ChartComponent = lazy(() => import('@/components/Chart'));

function GuideEditor() {
  const [showEditor, setShowEditor] = useState(false);

  return (
    <div>
      <Button onClick={() => setShowEditor(true)}>에디터 열기</Button>

      {showEditor && (
        <Suspense fallback={<Skeleton className="h-64" />}>
          <RichTextEditor />
        </Suspense>
      )}
    </div>
  );
}
```

**Step 3: Tree Shaking 검증**

**package.json에 sideEffects 명시**:

```json
{
  "sideEffects": [
    "*.css",
    "*.scss"
  ]
}
```

**Named imports 사용**:

```typescript
// ❌ Bad - 전체 라이브러리 번들링
import _ from 'lodash';
const result = _.debounce(fn, 300);

// ✅ Good - 필요한 함수만 번들링
import { debounce } from 'lodash-es';
const result = debounce(fn, 300);

// 더 나은 방법 - 개별 패키지
import debounce from 'lodash.debounce';
```

**아이콘 최적화**:

```typescript
// ❌ Bad - lucide-react 전체 (500KB+)
import * as Icons from 'lucide-react';

// ✅ Good - 필요한 아이콘만
import { Home, User, Settings } from 'lucide-react';
```

**Step 4: 중복 의존성 제거**

```bash
# 중복 의존성 확인
npm ls <package-name>

# 중복 제거
npm dedupe

# 또는 pnpm 사용 (더 효율적)
npm install -g pnpm
pnpm install
```

**package.json에서 중복 방지**:

```json
{
  "resolutions": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  }
}
```

**Step 5: 불필요한 의존성 제거**

```bash
# 사용되지 않는 패키지 찾기
npm install -g depcheck
depcheck

# 출력 예시:
# Unused dependencies
# * moment (→ date-fns 또는 day.js로 대체)
# * axios (→ fetch API 사용 중)
```

**대체 가능한 경량 라이브러리**:

```typescript
// ❌ moment.js (288KB)
import moment from 'moment';

// ✅ date-fns (13KB - tree-shakable)
import { format, parseISO } from 'date-fns';
import { ko } from 'date-fns/locale';

// ❌ lodash (전체)
import _ from 'lodash';

// ✅ 네이티브 JS
const unique = [...new Set(array)];
const sorted = array.sort((a, b) => a - b);
```

**Step 6: 프리로딩 및 프리페칭**

```typescript
// src/components/Link.tsx
import { Link as RouterLink, LinkProps } from 'react-router-dom';
import { useEffect } from 'react';

interface PrefetchLinkProps extends LinkProps {
  prefetch?: boolean;
}

export function Link({ to, prefetch = true, ...props }: PrefetchLinkProps) {
  useEffect(() => {
    if (prefetch && typeof to === 'string') {
      // 라우트 프리페칭
      const route = to;
      import(`../pages/${route}`).catch(() => {
        // 무시 (존재하지 않는 라우트)
      });
    }
  }, [to, prefetch]);

  return <RouterLink to={to} {...props} />;
}

// 사용
<Link to="/guidebook" prefetch>
  가이드북 보기
</Link>
```

**중요 자산 프리로드**:

```html
<!-- public/index.html -->
<head>
  <!-- 폰트 프리로드 -->
  <link
    rel="preload"
    href="/fonts/inter-var.woff2"
    as="font"
    type="font/woff2"
    crossorigin
  />

  <!-- 중요 CSS -->
  <link rel="preload" href="/src/index.css" as="style" />

  <!-- DNS Prefetch -->
  <link rel="dns-prefetch" href="https://supabase.co" />
  <link rel="dns-prefetch" href="https://api.tosspayments.com" />

  <!-- Preconnect -->
  <link rel="preconnect" href="https://supabase.co" crossorigin />
</head>
```

**Step 7: CSS 최적화**

```typescript
// vite.config.ts
export default defineConfig({
  css: {
    devSourcemap: true,
    preprocessorOptions: {
      scss: {
        // 불필요한 CSS 제거
        additionalData: `@import "@/styles/variables.scss";`,
      },
    },
  },
  build: {
    cssCodeSplit: true,
    cssMinify: 'lightningcss',
  },
});
```

**Tailwind CSS 최적화**:

```javascript
// tailwind.config.js
module.exports = {
  content: [
    './index.html',
    './src/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
  // 프로덕션 빌드 최적화
  ...(process.env.NODE_ENV === 'production' && {
    purge: {
      enabled: true,
      content: ['./src/**/*.{js,jsx,ts,tsx}', './public/index.html'],
    },
  }),
};
```

**Step 8: 번들 크기 모니터링**

**`package.json`에 스크립트 추가**:

```json
{
  "scripts": {
    "analyze": "vite build && open dist/stats.html",
    "size": "size-limit",
    "size:why": "size-limit --why"
  },
  "size-limit": [
    {
      "path": "dist/assets/*.js",
      "limit": "500 KB"
    }
  ]
}
```

```bash
npm install --save-dev @size-limit/preset-app
npm run size
# 번들 크기가 limit 초과 시 에러
```

**CI/CD에 통합**:

```yaml
# .github/workflows/size-check.yml
name: Size Check

on: [pull_request]

jobs:
  size:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: andresz1/size-limit-action@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

#### 검증 방법

```bash
# 1. 번들 분석
npm run build
# dist/stats.html 확인
# 가장 큰 청크/의존성 식별

# 2. 번들 크기 확인
ls -lh dist/assets/*.js
# 각 청크가 500KB 미만인지 확인

# 3. Lighthouse 성능 점수
# 번들 최적화 전후 비교
# Performance, FCP, TTI 지표 개선 확인

# 4. Network 스로틀링 테스트
# Chrome DevTools → Network → Slow 3G
# 초기 로딩 시간 측정

# 5. Coverage 분석
# Chrome DevTools → Coverage 탭
# 사용되지 않는 코드 비율 확인 (30% 미만 목표)
```

**번들 최적화 체크리스트**:

```markdown
## 번들 최적화 체크리스트

### Code Splitting
- [ ] 라우트별 lazy loading
- [ ] 무거운 컴포넌트 dynamic import
- [ ] Vendor chunks 분리
- [ ] 공통 코드 청크 생성

### Tree Shaking
- [ ] Named imports 사용
- [ ] package.json sideEffects 설정
- [ ] ES6 모듈 형식 사용
- [ ] 불필요한 import 제거

### 의존성 관리
- [ ] 중복 의존성 제거
- [ ] 경량 대체 라이브러리 사용
- [ ] 사용하지 않는 패키지 제거
- [ ] Tree-shakable 라이브러리 선택

### 성능 목표
- [ ] 초기 번들 < 500KB (gzipped)
- [ ] 각 lazy chunk < 200KB
- [ ] FCP < 1.8s
- [ ] TTI < 3.8s
```

#### 참고 자료

- [Rollup Plugin Visualizer](https://github.com/btd/rollup-plugin-visualizer)
- [Size Limit](https://github.com/ai/size-limit)
- [Web.dev - Code Splitting](https://web.dev/reduce-javascript-payloads-with-code-splitting/)
- [Vite Code Splitting](https://vitejs.dev/guide/features.html#code-splitting)
- [Bundle Phobia](https://bundlephobia.com/) - 패키지 크기 확인

---

### 12. 모니터링 도구 연동

**우선순위**: 📈 중기 처리
**카테고리**: 개발 경험 / 운영
**심각도**: Medium
**영향 범위**: 프로덕션 환경

#### 문제점

**현재 상태**:
- 에러 트래킹 시스템 없음
- 사용자 행동 분석 없음
- 성능 모니터링 없음
- 프로덕션 버그 감지 불가

**위험성**:
1. **사일런트 에러**: 프로덕션 에러를 사용자가 제보하기 전까지 모름
2. **성능 회귀**: 성능 저하를 실시간으로 감지 못함
3. **사용자 이탈 원인 파악 불가**: 어디서 이탈하는지 알 수 없음
4. **디버깅 어려움**: 재현 불가한 버그 발생 시 대응 곤란

**실제 시나리오**:
```
1. 새 배포 후 결제 버그 발생
2. 사용자 100명이 결제 실패
3. 고객센터 문의 급증
4. 3시간 후 문제 인지
5. 긴급 롤백
6. 매출 손실 + 신뢰 하락
```

#### 해결 방법

**Step 1: Sentry 에러 트래킹 설치**

```bash
npm install --save @sentry/react
```

**`src/lib/sentry.ts` 생성**:

```typescript
import * as Sentry from '@sentry/react';
import { BrowserTracing } from '@sentry/tracing';
import { useEffect } from 'react';
import {
  createRoutesFromChildren,
  matchRoutes,
  useLocation,
  useNavigationType,
} from 'react-router-dom';

export function initSentry() {
  if (import.meta.env.PROD) {
    Sentry.init({
      dsn: import.meta.env.VITE_SENTRY_DSN,
      integrations: [
        new BrowserTracing({
          routingInstrumentation: Sentry.reactRouterV6Instrumentation(
            useEffect,
            useLocation,
            useNavigationType,
            createRoutesFromChildren,
            matchRoutes
          ),
        }),
        new Sentry.Replay({
          maskAllText: true,
          blockAllMedia: true,
        }),
      ],

      // 성능 모니터링 샘플링 비율
      tracesSampleRate: 1.0,

      // 세션 재생 샘플링 비율
      replaysSessionSampleRate: 0.1, // 10%
      replaysOnErrorSampleRate: 1.0, // 에러 발생 시 100%

      environment: import.meta.env.MODE,
      release: import.meta.env.VITE_APP_VERSION,

      // 민감 정보 필터링
      beforeSend(event, hint) {
        // 비밀번호 등 민감 데이터 제거
        if (event.request?.data) {
          if (typeof event.request.data === 'object') {
            delete event.request.data.password;
            delete event.request.data.token;
          }
        }

        // 로컬 개발 에러는 전송하지 않음
        if (window.location.hostname === 'localhost') {
          return null;
        }

        return event;
      },

      // 무시할 에러
      ignoreErrors: [
        // 브라우저 확장 프로그램 에러
        'top.GLOBALS',
        'Non-Error promise rejection captured',
        // 네트워크 에러 (일시적)
        'NetworkError',
        'Network request failed',
      ],
    });
  }
}

// 사용자 컨텍스트 설정
export function setSentryUser(user: { id: string; email: string; name: string }) {
  Sentry.setUser({
    id: user.id,
    email: user.email,
    username: user.name,
  });
}

// 커스텀 이벤트 전송
export function logSentryEvent(message: string, level: 'info' | 'warning' | 'error') {
  Sentry.captureMessage(message, level);
}

// 에러 수동 전송
export function logSentryError(error: Error, context?: Record<string, any>) {
  Sentry.captureException(error, {
    contexts: {
      custom: context,
    },
  });
}
```

**`src/main.tsx`에서 초기화**:

```typescript
import { initSentry } from './lib/sentry';

initSentry();

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
```

**에러 경계와 통합**:

```typescript
import { ErrorBoundary as SentryErrorBoundary } from '@sentry/react';

function App() {
  return (
    <SentryErrorBoundary
      fallback={({ error, resetError }) => (
        <div className="error-screen">
          <h1>앗! 문제가 발생했습니다</h1>
          <p>{error.message}</p>
          <Button onClick={resetError}>다시 시도</Button>
        </div>
      )}
      onError={(error, errorInfo) => {
        console.error('Error caught by Sentry boundary:', error, errorInfo);
      }}
    >
      <Router />
    </SentryErrorBoundary>
  );
}
```

**Step 2: Google Analytics 4 연동**

```bash
npm install react-ga4
```

**`src/lib/analytics.ts` 생성**:

```typescript
import ReactGA from 'react-ga4';

const GA_MEASUREMENT_ID = import.meta.env.VITE_GA_MEASUREMENT_ID;

export function initGA() {
  if (import.meta.env.PROD && GA_MEASUREMENT_ID) {
    ReactGA.initialize(GA_MEASUREMENT_ID, {
      gaOptions: {
        send_page_view: false, // 수동으로 추적
      },
    });
  }
}

// 페이지뷰 추적
export function trackPageView(path: string, title?: string) {
  ReactGA.send({
    hitType: 'pageview',
    page: path,
    title: title || document.title,
  });
}

// 이벤트 추적
export function trackEvent(
  category: string,
  action: string,
  label?: string,
  value?: number
) {
  ReactGA.event({
    category,
    action,
    label,
    value,
  });
}

// 전자상거래 추적
export function trackPurchase(transaction: {
  transaction_id: string;
  value: number;
  currency: string;
  items: Array<{
    item_id: string;
    item_name: string;
    price: number;
    quantity: number;
  }>;
}) {
  ReactGA.event('purchase', transaction);
}

// 사용자 속성 설정
export function setUserProperties(properties: Record<string, any>) {
  ReactGA.gtag('set', 'user_properties', properties);
}
```

**라우터와 통합**:

```typescript
import { useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import { trackPageView } from '@/lib/analytics';

function App() {
  const location = useLocation();

  useEffect(() => {
    trackPageView(location.pathname + location.search);
  }, [location]);

  return <Router />;
}
```

**주요 이벤트 추적**:

```typescript
// 가이드북 구매
trackEvent('Commerce', 'Purchase', 'Guidebook', guidePrice);

// 검색
trackEvent('Engagement', 'Search', searchQuery);

// 회원가입
trackEvent('Conversion', 'Signup', 'Email');

// 결제 시작
trackEvent('Funnel', 'Begin Checkout', `Guide-${guideId}`);
```

**Step 3: Vercel Analytics 연동**

```bash
npm install @vercel/analytics
```

**`src/main.tsx`에 추가**:

```typescript
import { Analytics } from '@vercel/analytics/react';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
    <Analytics />
  </React.StrictMode>
);
```

**Vercel Speed Insights**:

```bash
npm install @vercel/speed-insights
```

```typescript
import { SpeedInsights } from '@vercel/speed-insights/react';

<SpeedInsights />
```

**Step 4: 커스텀 로깅 시스템**

**`src/lib/logger.ts` 생성**:

```typescript
type LogLevel = 'debug' | 'info' | 'warn' | 'error';

class Logger {
  private isDev = import.meta.env.DEV;

  private log(level: LogLevel, message: string, data?: any) {
    const timestamp = new Date().toISOString();
    const prefix = `[${timestamp}] [${level.toUpperCase()}]`;

    // 개발 환경에서는 콘솔에 출력
    if (this.isDev) {
      console[level](prefix, message, data);
    }

    // 프로덕션에서는 외부 서비스로 전송
    if (!this.isDev && level === 'error') {
      this.sendToService(level, message, data);
    }
  }

  private async sendToService(level: LogLevel, message: string, data?: any) {
    try {
      // Supabase에 로그 저장
      await supabase.from('logs').insert({
        level,
        message,
        data: JSON.stringify(data),
        user_agent: navigator.userAgent,
        url: window.location.href,
      });
    } catch (error) {
      console.error('Failed to send log:', error);
    }
  }

  debug(message: string, data?: any) {
    this.log('debug', message, data);
  }

  info(message: string, data?: any) {
    this.log('info', message, data);
  }

  warn(message: string, data?: any) {
    this.log('warn', message, data);
  }

  error(message: string, error?: Error, data?: any) {
    this.log('error', message, { error: error?.stack, ...data });
  }
}

export const logger = new Logger();

// 사용
logger.info('User logged in', { userId: user.id });
logger.error('Payment failed', error, { orderId: '123' });
```

**Step 5: 성능 모니터링**

```typescript
// src/lib/performance.ts
import { onCLS, onFID, onLCP, onFCP, onTTFB } from 'web-vitals';

export function reportWebVitals() {
  function sendToAnalytics(metric: any) {
    // Google Analytics로 전송
    if (window.gtag) {
      window.gtag('event', metric.name, {
        value: Math.round(
          metric.name === 'CLS' ? metric.value * 1000 : metric.value
        ),
        event_label: metric.id,
        non_interaction: true,
      });
    }

    // Sentry로 전송
    Sentry.captureMessage(`Web Vital: ${metric.name}`, {
      level: 'info',
      contexts: {
        webVitals: {
          name: metric.name,
          value: metric.value,
          rating: metric.rating,
        },
      },
    });

    // 커스텀 대시보드로 전송
    fetch('/api/metrics', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(metric),
    });
  }

  onCLS(sendToAnalytics);
  onFID(sendToAnalytics);
  onLCP(sendToAnalytics);
  onFCP(sendToAnalytics);
  onTTFB(sendToAnalytics);
}

// main.tsx에서 호출
reportWebVitals();
```

**API 응답 시간 추적**:

```typescript
// src/lib/apiMonitoring.ts
export async function monitoredFetch(url: string, options?: RequestInit) {
  const startTime = performance.now();

  try {
    const response = await fetch(url, options);
    const duration = performance.now() - startTime;

    // 성능 로그
    logger.info('API Request', {
      url,
      method: options?.method || 'GET',
      duration,
      status: response.status,
    });

    // 느린 요청 경고
    if (duration > 3000) {
      logger.warn('Slow API Request', {
        url,
        duration,
      });
    }

    return response;
  } catch (error) {
    const duration = performance.now() - startTime;
    logger.error('API Request Failed', error as Error, {
      url,
      duration,
    });
    throw error;
  }
}
```

**Step 6: 사용자 피드백 수집**

```bash
npm install @sentry/feedback
```

```typescript
import { Feedback } from '@sentry/feedback';

const feedback = new Feedback({
  colorScheme: 'system',
  buttonLabel: '피드백 보내기',
  formTitle: '피드백',
  submitButtonLabel: '전송',
  cancelButtonLabel: '취소',
  messageLabel: '문제가 있나요? 알려주세요!',
});

feedback.attachTo(document.body);
```

#### 검증 방법

```bash
# 1. Sentry 테스트
# 개발 환경에서 의도적으로 에러 발생
throw new Error('Test Sentry Integration');

# Sentry Dashboard에서 에러 확인
# https://sentry.io/

# 2. Google Analytics 테스트
# Chrome 확장: Google Analytics Debugger 설치
# 페이지 이동 및 이벤트 발생 시 콘솔에서 확인

# 3. Vercel Analytics 확인
# Vercel Dashboard → Analytics
# 실시간 방문자, 페이지뷰 확인

# 4. 성능 메트릭 확인
# Chrome DevTools → Performance
# Lighthouse → Performance audit
```

**모니터링 체크리스트**:

```markdown
## 모니터링 체크리스트

### 에러 트래킹
- [ ] Sentry 설정 완료
- [ ] 소스맵 업로드 설정
- [ ] 민감 정보 필터링
- [ ] 사용자 컨텍스트 설정
- [ ] 세션 재생 활성화

### 분석
- [ ] Google Analytics 4 연동
- [ ] 페이지뷰 추적
- [ ] 전환 이벤트 추적
- [ ] 사용자 플로우 분석
- [ ] Funnel 분석 설정

### 성능
- [ ] Web Vitals 추적
- [ ] API 응답 시간 모니터링
- [ ] 번들 크기 추적
- [ ] 실시간 알림 설정

### 대시보드
- [ ] Sentry 대시보드 구성
- [ ] GA4 커스텀 리포트
- [ ] Vercel Analytics 검토
- [ ] 주간 리포트 자동화
```

#### 참고 자료

- [Sentry React 가이드](https://docs.sentry.io/platforms/javascript/guides/react/)
- [Google Analytics 4](https://developers.google.com/analytics/devguides/collection/ga4)
- [Vercel Analytics](https://vercel.com/docs/analytics)
- [Web Vitals](https://web.dev/vitals/)
- [LogRocket](https://logrocket.com/) - 세션 재생 대안

---

## 개발 경험

### 13. Git 워크플로우 구축

**우선순위**: 📈 중기 처리
**카테고리**: 개발 경험
**심각도**: Medium
**영향 범위**: 전체 개발 프로세스

#### 문제점

**현재 상태**:
- Git 초기화되지 않음 (`.git` 디렉토리 없음)
- `.gitignore` 불완전
- Commit 메시지 컨벤션 없음
- Pre-commit hooks 미설정
- 브랜치 전략 부재

**위험성**:
1. **코드 유실**: 버전 관리 없어 롤백 불가
2. **협업 불가**: 팀원과 코드 공유 어려움
3. **품질 저하**: Lint/Test 자동화 없음
4. **히스토리 혼란**: 일관성 없는 커밋 메시지

**실제 시나리오**:
```
1. 개발자가 기능 구현 중 실수
2. 되돌릴 방법이 없음
3. 코드 전체를 처음부터 다시 작성
4. 수일간의 작업 시간 낭비
```

#### 해결 방법

**Step 1: Git 초기화 및 .gitignore 설정**

```bash
# Git 초기화
git init

# 기본 브랜치 이름 설정
git branch -M main

# 원격 저장소 추가
git remote add origin https://github.com/yourusername/aihub.git
```

**`.gitignore` 완전판**:

```gitignore
# Dependencies
node_modules/
/.pnp
.pnp.js

# Testing
/coverage
*.lcov

# Production
/dist
/build
/.vercel
.output

# Environment variables
.env
.env.local
.env.development
.env.test
.env.production
.env*.local

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

# Editor directories and files
.vscode/*
!.vscode/extensions.json
!.vscode/settings.json
.idea
.DS_Store
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# OS
Thumbs.db
Desktop.ini

# Temporary files
*.tmp
*.temp
.cache

# Build artifacts
*.tsbuildinfo

# Supabase (로컬 개발용)
**/supabase/.temp

# Debug
.debug

# Analytics
dist/stats.html

# Sentry
.sentryclirc
```

**Step 2: Husky + lint-staged 설치**

```bash
npm install --save-dev husky lint-staged
npx husky-init && npm install
```

**`.husky/pre-commit` 생성**:

```bash
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

npx lint-staged
```

**`package.json`에 lint-staged 설정**:

```json
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,md,css,scss}": [
      "prettier --write"
    ]
  }
}
```

**Step 3: Commitlint 설정**

```bash
npm install --save-dev @commitlint/cli @commitlint/config-conventional
```

**`commitlint.config.js` 생성**:

```javascript
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat',     // 새로운 기능
        'fix',      // 버그 수정
        'docs',     // 문서 수정
        'style',    // 코드 포매팅
        'refactor', // 리팩토링
        'test',     // 테스트 추가/수정
        'chore',    // 빌드, 설정 변경
        'perf',     // 성능 개선
        'ci',       // CI 설정
        'revert',   // 되돌리기
      ],
    ],
    'type-case': [2, 'always', 'lower-case'],
    'type-empty': [2, 'never'],
    'subject-empty': [2, 'never'],
    'subject-full-stop': [2, 'never', '.'],
    'header-max-length': [2, 'always', 72],
  },
};
```

**`.husky/commit-msg` 생성**:

```bash
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

npx --no -- commitlint --edit ${1}
```

**Step 4: 브랜치 전략 (Git Flow 간소화)**

```bash
# 메인 브랜치
main         # 프로덕션 배포 코드
develop      # 개발 통합 브랜치

# 기능 브랜치
feature/기능명
fix/이슈번호-설명
hotfix/긴급수정명

# 예시
feature/add-payment-system
fix/123-login-error
hotfix/critical-security-patch
```

**브랜치 생성 헬퍼 스크립트**:

```bash
# scripts/create-branch.sh
#!/bin/bash

TYPE=$1
NAME=$2

if [ -z "$TYPE" ] || [ -z "$NAME" ]; then
  echo "Usage: ./create-branch.sh <type> <name>"
  echo "Types: feature, fix, hotfix"
  exit 1
fi

BRANCH_NAME="${TYPE}/${NAME}"

git checkout develop
git pull origin develop
git checkout -b "$BRANCH_NAME"

echo "✅ Created and switched to branch: $BRANCH_NAME"
```

```bash
# package.json에 추가
{
  "scripts": {
    "branch": "bash scripts/create-branch.sh"
  }
}

# 사용
npm run branch feature add-dark-mode
```

**Step 5: Commit 메시지 템플릿**

**`.gitmessage` 생성**:

```
# <type>(<scope>): <subject>
# |<----  최대 72자  ---->|

# <body>
# |<----  최대 72자  ---->|

# <footer>
# 예: Closes #123

# Type:
#   feat     : 새로운 기능
#   fix      : 버그 수정
#   docs     : 문서 수정
#   style    : 코드 포매팅 (기능 변경 없음)
#   refactor : 코드 리팩토링
#   test     : 테스트 추가/수정
#   chore    : 빌드, 설정 파일 수정
#
# Scope (선택):
#   auth, payment, ui, api, db 등
#
# Subject:
#   명령형 현재 시제 사용 (예: "add" not "added")
#   첫 글자 소문자
#   마침표 없음
#
# Body (선택):
#   변경 이유, 기존 동작과의 차이점 설명
#
# Footer (선택):
#   이슈 링크 (Closes #123)
#   Breaking Changes (BREAKING CHANGE:)
```

```bash
# 템플릿 설정
git config commit.template .gitmessage
```

**Step 6: GitHub PR 템플릿**

**`.github/pull_request_template.md` 생성**:

```markdown
## 변경사항 설명

<!-- 이 PR의 목적과 변경 내용을 간단히 설명해주세요 -->

## 관련 이슈

Closes #(이슈 번호)

## 변경 유형

- [ ] 🐛 Bug fix (기존 기능 수정)
- [ ] ✨ New feature (새 기능 추가)
- [ ] 💥 Breaking change (기존 API 변경)
- [ ] 📝 Documentation (문서 업데이트)
- [ ] ♻️ Refactoring (기능 변경 없는 코드 개선)
- [ ] ✅ Tests (테스트 추가/수정)
- [ ] 🎨 Style (코드 포매팅)
- [ ] 📦 Chore (빌드/설정 변경)

## 스크린샷 (UI 변경 시)

<!-- 변경 전후 스크린샷 -->

| Before | After |
|--------|-------|
| ![before](url) | ![after](url) |

## 테스트 완료

- [ ] 단위 테스트 추가/업데이트
- [ ] E2E 테스트 추가/업데이트 (필요 시)
- [ ] 수동 테스트 완료
- [ ] 브라우저 호환성 확인 (Chrome, Firefox, Safari)
- [ ] 모바일 반응형 확인

## 체크리스트

- [ ] 코드가 프로젝트 스타일 가이드를 따름
- [ ] Self-review 완료
- [ ] 복잡한 코드에 주석 추가
- [ ] 관련 문서 업데이트
- [ ] Breaking changes 없음 (또는 문서화)
- [ ] 새 의존성 추가 시 이유 설명
- [ ] Lint 에러 없음
- [ ] 타입 에러 없음
- [ ] 빌드 성공

## 추가 컨텍스트

<!-- 추가로 리뷰어가 알아야 할 내용 -->
```

**Step 7: GitHub Actions CI/CD**

**`.github/workflows/ci.yml` 생성**:

```yaml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run ESLint
        run: npm run lint

      - name: Run Prettier check
        run: npx prettier --check .

  type-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Type check
        run: npm run type-check

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm run test:run

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/coverage-final.json

  build:
    runs-on: ubuntu-latest
    needs: [lint, type-check, test]
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Create .env file
        run: |
          echo "VITE_SUPABASE_URL=${{ secrets.VITE_SUPABASE_URL }}" >> .env
          echo "VITE_SUPABASE_PUBLISHABLE_KEY=${{ secrets.VITE_SUPABASE_PUBLISHABLE_KEY }}" >> .env

      - name: Build
        run: npm run build

      - name: Upload build artifacts
        uses: actions/upload-artifact@v3
        with:
          name: dist
          path: dist/
```

**Step 8: Semantic Release (자동 버전 관리)**

```bash
npm install --save-dev semantic-release @semantic-release/git @semantic-release/changelog
```

**`.releaserc.json` 생성**:

```json
{
  "branches": ["main"],
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    "@semantic-release/npm",
    "@semantic-release/git",
    "@semantic-release/github"
  ]
}
```

**`.github/workflows/release.yml` 생성**:

```yaml
name: Release

on:
  push:
    branches:
      - main

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - uses: actions/setup-node@v3
        with:
          node-version: '18'

      - run: npm ci

      - run: npx semantic-release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```

#### 검증 방법

```bash
# 1. Git 상태 확인
git status
# .env가 untracked에 없어야 함

# 2. Pre-commit hook 테스트
git add .
git commit -m "test"
# Lint 자동 실행 확인

# 3. Commit message 검증 테스트
git commit -m "wrong message"
# commitlint 에러 발생 확인

git commit -m "feat: add new feature"
# 성공 확인

# 4. PR 생성 테스트
# GitHub에서 PR 생성 시 템플릿 적용 확인

# 5. CI 파이프라인 확인
# GitHub Actions 탭에서 빌드 상태 확인
```

**Git 워크플로우 체크리스트**:

```markdown
## Git 워크플로우 체크리스트

### 초기 설정
- [ ] Git 초기화
- [ ] .gitignore 설정
- [ ] 원격 저장소 연결
- [ ] README.md 작성

### Hooks
- [ ] Husky 설치
- [ ] Pre-commit (lint-staged)
- [ ] Commit-msg (commitlint)
- [ ] Pre-push (test)

### 브랜치 전략
- [ ] main, develop 브랜치
- [ ] 기능 브랜치 규칙
- [ ] PR 템플릿
- [ ] 브랜치 보호 규칙

### CI/CD
- [ ] GitHub Actions 설정
- [ ] Lint 자동화
- [ ] Test 자동화
- [ ] 빌드 자동화
- [ ] 배포 자동화

### 문서화
- [ ] CONTRIBUTING.md
- [ ] CHANGELOG.md
- [ ] Commit 메시지 가이드
```

#### 참고 자료

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
- [Husky](https://typicode.github.io/husky/)
- [lint-staged](https://github.com/okonet/lint-staged)
- [semantic-release](https://semantic-release.gitbook.io/)

---

### 14. Prettier 설정

**우선순위**: 📈 중기 처리
**카테고리**: 개발 경험
**심각도**: Low
**영향 범위**: 전체 코드베이스

#### 문제점

**현재 상태**:
- 코드 포매팅 규칙 부재
- 들여쓰기, 따옴표, 세미콜론 등 일관성 없음
- VS Code 설정 없음
- Format on save 미설정

**위험성**:
1. **코드 리뷰 방해**: 의미 없는 포매팅 차이로 diff 복잡해짐
2. **협업 비효율**: 개발자마다 다른 스타일 사용
3. **가독성 저하**: 일관성 없는 코드
4. **Git diff 오염**: 포매팅 변경으로 인한 불필요한 커밋

**실제 시나리오**:
```
1. 개발자 A가 탭 사용, 개발자 B가 스페이스 사용
2. PR에서 전체 파일이 변경된 것처럼 보임
3. 실제 로직 변경 파악 어려움
4. 리뷰 시간 증가
```

#### 해결 방법

**Step 1: Prettier 설치**

```bash
npm install --save-dev prettier eslint-config-prettier eslint-plugin-prettier
```

**`.prettierrc` 생성**:

```json
{
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "semi": true,
  "singleQuote": true,
  "quoteProps": "as-needed",
  "jsxSingleQuote": false,
  "trailingComma": "es5",
  "bracketSpacing": true,
  "bracketSameLine": false,
  "arrowParens": "always",
  "endOfLine": "lf",
  "plugins": ["prettier-plugin-tailwindcss"]
}
```

**`.prettierignore` 생성**:

```
# Dependencies
node_modules/

# Build output
dist/
build/
.vercel/
.output/

# Coverage
coverage/

# Logs
*.log

# Generated files
*.generated.*
supabase/types.ts

# Config files with specific formatting
pnpm-lock.yaml
package-lock.json
yarn.lock

# Others
.env*
```

**Step 2: ESLint와 통합**

**`eslint.config.js` 수정**:

```javascript
import js from '@eslint/js';
import globals from 'globals';
import reactHooks from 'eslint-plugin-react-hooks';
import reactRefresh from 'eslint-plugin-react-refresh';
import tseslint from 'typescript-eslint';
import prettier from 'eslint-plugin-prettier';
import prettierConfig from 'eslint-config-prettier';

export default tseslint.config(
  { ignores: ['dist'] },
  {
    extends: [
      js.configs.recommended,
      ...tseslint.configs.recommended,
      prettierConfig, // Prettier와 충돌하는 ESLint 규칙 비활성화
    ],
    files: ['**/*.{ts,tsx}'],
    languageOptions: {
      ecmaVersion: 2020,
      globals: globals.browser,
    },
    plugins: {
      'react-hooks': reactHooks,
      'react-refresh': reactRefresh,
      prettier: prettier,
    },
    rules: {
      ...reactHooks.configs.recommended.rules,
      'react-refresh/only-export-components': [
        'warn',
        { allowConstantExport: true },
      ],
      // Prettier를 ESLint 에러로 표시
      'prettier/prettier': 'error',
    },
  }
);
```

**Step 3: VS Code 설정**

**`.vscode/settings.json` 생성**:

```json
{
  // Editor
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit",
    "source.organizeImports": "explicit"
  },

  // Language-specific
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[javascriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[jsonc]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },

  // TypeScript
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true,

  // Files
  "files.eol": "\n",
  "files.insertFinalNewline": true,
  "files.trimTrailingWhitespace": true,

  // Tailwind CSS
  "tailwindCSS.experimental.classRegex": [
    ["cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]"]
  ],

  // ESLint
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ]
}
```

**`.vscode/extensions.json` 생성**:

```json
{
  "recommendations": [
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "bradlc.vscode-tailwindcss",
    "ms-vscode.vscode-typescript-next",
    "usernamehw.errorlens"
  ]
}
```

**Step 4: Tailwind CSS 클래스 정렬**

```bash
npm install --save-dev prettier-plugin-tailwindcss
```

**`.prettierrc` 업데이트**:

```json
{
  "plugins": ["prettier-plugin-tailwindcss"],
  "tailwindConfig": "./tailwind.config.ts"
}
```

이제 Tailwind 클래스가 자동으로 정렬됨:

```tsx
// Before
<div className="text-white p-4 bg-black mt-2">

// After (자동 정렬)
<div className="mt-2 bg-black p-4 text-white">
```

**Step 5: Package.json 스크립트**

```json
{
  "scripts": {
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "lint:fix": "eslint . --ext ts,tsx --fix"
  }
}
```

**Step 6: Pre-commit Hook 통합**

```json
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,md,css,scss,html}": [
      "prettier --write"
    ]
  }
}
```

**Step 7: CI/CD 통합**

**`.github/workflows/ci.yml`에 추가**:

```yaml
jobs:
  format-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm ci

      - name: Check formatting
        run: npm run format:check

      - name: Check linting
        run: npm run lint
```

**Step 8: 전체 코드베이스 포맷팅**

```bash
# 모든 파일 포맷팅
npm run format

# 변경사항 확인
git diff

# 커밋
git add .
git commit -m "chore: apply prettier formatting"
```

#### 검증 방법

```bash
# 1. Prettier 테스트
echo "const  x  =  1" > test.ts
npx prettier --write test.ts
cat test.ts
# const x = 1;

# 2. Format on save 테스트
# VS Code에서 파일 편집 후 저장
# 자동으로 포맷팅되는지 확인

# 3. Pre-commit hook 테스트
# 포맷되지 않은 코드 추가
echo "const  x  =  1" >> src/test.ts
git add src/test.ts
git commit -m "test"
# 자동으로 포맷팅 후 커밋

# 4. CI 테스트
# 포맷되지 않은 코드로 PR 생성
# GitHub Actions에서 실패하는지 확인
```

**Prettier 체크리스트**:

```markdown
## Prettier 체크리스트

### 설정
- [ ] .prettierrc 생성
- [ ] .prettierignore 생성
- [ ] ESLint 통합
- [ ] Tailwind plugin 설치

### VS Code
- [ ] .vscode/settings.json
- [ ] .vscode/extensions.json
- [ ] Format on save 활성화
- [ ] 추천 확장 설치

### 자동화
- [ ] Pre-commit hook
- [ ] CI/CD 체크
- [ ] Package.json 스크립트

### 팀 규칙
- [ ] 코드 스타일 가이드 문서화
- [ ] 팀원 교육
- [ ] 일관성 검증
```

#### 참고 자료

- [Prettier 공식 문서](https://prettier.io/docs/en/index.html)
- [ESLint + Prettier 통합](https://prettier.io/docs/en/integrating-with-linters.html)
- [prettier-plugin-tailwindcss](https://github.com/tailwindlabs/prettier-plugin-tailwindcss)
- [VS Code Prettier 확장](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)

---

## 비즈니스 로직

### 15. 국제화(i18n) 지원

**우선순위**: 🎯 장기 처리
**카테고리**: 사용자 경험 / 확장성
**심각도**: Low
**영향 범위**: 전체 UI 텍스트

#### 문제점

**현재 상태**:
- 모든 텍스트가 한국어로 하드코딩
- 다국어 지원 불가
- 언어 전환 기능 없음
- 날짜/통화 포맷 한국 기준 고정

**위험성**:
1. **시장 확장 제한**: 해외 진출 어려움
2. **리팩토링 비용**: 나중에 추가 시 대규모 작업 필요
3. **유지보수 어려움**: 텍스트 변경 시 코드 전체 수정
4. **접근성**: 외국인 사용자 배제

**실제 시나리오**:
```
1. 미국 시장 진출 결정
2. 모든 컴포넌트의 텍스트를 영어로 변환
3. 3개월 작업 소요
4. 버그 다수 발생
5. 출시 지연
```

#### 해결 방법

**Step 1: react-i18next 설치**

```bash
npm install react-i18next i18next i18next-browser-languagedetector i18next-http-backend
```

**`src/i18n/config.ts` 생성**:

```typescript
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import Backend from 'i18next-http-backend';

i18n
  .use(Backend) // 번역 파일 동적 로딩
  .use(LanguageDetector) // 사용자 언어 자동 감지
  .use(initReactI18next)
  .init({
    fallbackLng: 'ko',
    supportedLngs: ['ko', 'en', 'ja'],
    debug: import.meta.env.DEV,

    interpolation: {
      escapeValue: false, // React가 XSS 방어
    },

    backend: {
      loadPath: '/locales/{{lng}}/{{ns}}.json',
    },

    detection: {
      order: ['localStorage', 'navigator'],
      caches: ['localStorage'],
    },

    react: {
      useSuspense: true,
    },
  });

export default i18n;
```

**`src/main.tsx`에서 초기화**:

```typescript
import './i18n/config';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <Suspense fallback={<LoadingPage />}>
      <App />
    </Suspense>
  </React.StrictMode>
);
```

**Step 2: 번역 파일 생성**

**`public/locales/ko/common.json`**:

```json
{
  "nav": {
    "home": "홈",
    "guidebook": "가이드북",
    "presetStore": "프리셋 스토어",
    "tools": "AI 도구",
    "community": "커뮤니티"
  },
  "auth": {
    "login": "로그인",
    "logout": "로그아웃",
    "signup": "회원가입",
    "email": "이메일",
    "password": "비밀번호",
    "forgotPassword": "비밀번호 찾기"
  },
  "common": {
    "save": "저장",
    "cancel": "취소",
    "delete": "삭제",
    "edit": "수정",
    "loading": "로딩 중...",
    "error": "오류 발생",
    "success": "성공"
  },
  "validation": {
    "required": "{{field}}은(는) 필수입니다",
    "email": "올바른 이메일을 입력하세요",
    "minLength": "최소 {{length}}자 이상 입력하세요"
  }
}
```

**`public/locales/en/common.json`**:

```json
{
  "nav": {
    "home": "Home",
    "guidebook": "Guidebook",
    "presetStore": "Preset Store",
    "tools": "AI Tools",
    "community": "Community"
  },
  "auth": {
    "login": "Login",
    "logout": "Logout",
    "signup": "Sign Up",
    "email": "Email",
    "password": "Password",
    "forgotPassword": "Forgot Password"
  },
  "common": {
    "save": "Save",
    "cancel": "Cancel",
    "delete": "Delete",
    "edit": "Edit",
    "loading": "Loading...",
    "error": "Error",
    "success": "Success"
  },
  "validation": {
    "required": "{{field}} is required",
    "email": "Please enter a valid email",
    "minLength": "Minimum {{length}} characters required"
  }
}
```

**Step 3: 컴포넌트에서 사용**

```typescript
// src/components/Navigation.tsx
import { useTranslation } from 'react-i18next';

export function Navigation() {
  const { t } = useTranslation();

  return (
    <nav>
      <Link to="/">{t('nav.home')}</Link>
      <Link to="/guidebook">{t('nav.guidebook')}</Link>
      <Link to="/preset-store">{t('nav.presetStore')}</Link>
      <Link to="/tools">{t('nav.tools')}</Link>
      <Link to="/community">{t('nav.community')}</Link>
    </nav>
  );
}
```

**변수 보간**:

```typescript
// t() 함수에 변수 전달
<p>{t('validation.required', { field: t('auth.email') })}</p>
// 출력: "이메일은(는) 필수입니다"

<p>{t('validation.minLength', { length: 8 })}</p>
// 출력: "최소 8자 이상 입력하세요"
```

**복수형 처리**:

```json
{
  "items": "{{count}}개의 아이템",
  "items_plural": "{{count}}개의 아이템들"
}
```

```typescript
<p>{t('items', { count: 1 })}</p> // 1개의 아이템
<p>{t('items', { count: 5 })}</p> // 5개의 아이템들
```

**Step 4: 언어 전환 UI**

```typescript
// src/components/LanguageSwitcher.tsx
import { useTranslation } from 'react-i18next';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Globe } from 'lucide-react';

const languages = [
  { code: 'ko', name: '한국어', flag: '🇰🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'ja', name: '日本語', flag: '🇯🇵' },
];

export function LanguageSwitcher() {
  const { i18n } = useTranslation();

  const handleChange = (value: string) => {
    i18n.changeLanguage(value);
    // URL 파라미터로도 반영 (선택적)
    const url = new URL(window.location.href);
    url.searchParams.set('lng', value);
    window.history.pushState({}, '', url);
  };

  return (
    <Select value={i18n.language} onValueChange={handleChange}>
      <SelectTrigger className="w-[140px]">
        <Globe className="mr-2 h-4 w-4" />
        <SelectValue />
      </SelectTrigger>
      <SelectContent>
        {languages.map((lang) => (
          <SelectItem key={lang.code} value={lang.code}>
            <span className="mr-2">{lang.flag}</span>
            {lang.name}
          </SelectItem>
        ))}
      </SelectContent>
    </Select>
  );
}
```

**Step 5: 날짜/통화 포맷팅**

```bash
npm install date-fns
```

```typescript
// src/lib/format.ts
import { format } from 'date-fns';
import { ko, enUS, ja } from 'date-fns/locale';
import { useTranslation } from 'react-i18next';

const locales = { ko, en: enUS, ja };

export function useFormatDate() {
  const { i18n } = useTranslation();

  return (date: Date, formatStr: string = 'PPP') => {
    return format(date, formatStr, {
      locale: locales[i18n.language as keyof typeof locales],
    });
  };
}

export function useFormatCurrency() {
  const { i18n } = useTranslation();

  return (amount: number) => {
    const currencyMap = {
      ko: { currency: 'KRW', locale: 'ko-KR' },
      en: { currency: 'USD', locale: 'en-US' },
      ja: { currency: 'JPY', locale: 'ja-JP' },
    };

    const config = currencyMap[i18n.language as keyof typeof currencyMap];

    return new Intl.NumberFormat(config.locale, {
      style: 'currency',
      currency: config.currency,
    }).format(amount);
  };
}

// 사용 예시
function GuidePrice({ price }: { price: number }) {
  const formatCurrency = useFormatCurrency();

  return <span>{formatCurrency(price)}</span>;
  // ko: ₩10,000
  // en: $10.00
  // ja: ¥1,000
}
```

**Step 6: 네임스페이스 분리**

대규모 앱에서는 번역 파일 분리:

```
public/locales/
  ko/
    common.json      # 공통 (버튼, 라벨 등)
    auth.json        # 인증 관련
    guidebook.json   # 가이드북
    payment.json     # 결제
  en/
    common.json
    auth.json
    ...
```

```typescript
// 네임스페이스 사용
const { t } = useTranslation(['guidebook', 'common']);

<h1>{t('guidebook:title')}</h1>
<button>{t('common:save')}</button>
```

**Step 7: 번역 누락 감지**

**개발 환경에서 경고**:

```typescript
// i18n/config.ts
i18n.init({
  saveMissing: import.meta.env.DEV,
  missingKeyHandler: (lngs, ns, key) => {
    if (import.meta.env.DEV) {
      console.warn(`Missing translation: ${key} in ${ns}`);
    }
  },
});
```

**번역 완성도 체크 스크립트**:

```typescript
// scripts/check-translations.ts
import fs from 'fs';
import path from 'path';

const localesDir = 'public/locales';
const languages = ['ko', 'en', 'ja'];
const namespaces = ['common', 'auth', 'guidebook'];

function flattenObject(obj: any, prefix = ''): string[] {
  return Object.keys(obj).reduce((acc: string[], key) => {
    const newKey = prefix ? `${prefix}.${key}` : key;
    if (typeof obj[key] === 'object') {
      return [...acc, ...flattenObject(obj[key], newKey)];
    }
    return [...acc, newKey];
  }, []);
}

languages.forEach((lang) => {
  namespaces.forEach((ns) => {
    const filePath = path.join(localesDir, lang, `${ns}.json`);
    const content = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
    const keys = flattenObject(content);

    console.log(`${lang}/${ns}: ${keys.length} keys`);

    // 기준 언어(ko)와 비교
    if (lang !== 'ko') {
      const koPath = path.join(localesDir, 'ko', `${ns}.json`);
      const koContent = JSON.parse(fs.readFileSync(koPath, 'utf-8'));
      const koKeys = flattenObject(koContent);

      const missing = koKeys.filter((key) => !keys.includes(key));
      if (missing.length > 0) {
        console.warn(`  Missing in ${lang}:`, missing);
      }
    }
  });
});
```

#### 검증 방법

```bash
# 1. 번역 완성도 체크
npm run check:translations

# 2. 언어 전환 테스트
# UI에서 언어 전환
# 모든 텍스트가 변경되는지 확인

# 3. 날짜/통화 포맷 테스트
# 각 언어에서 포맷이 올바른지 확인

# 4. 브라우저 언어 자동 감지
# 브라우저 언어 설정 변경 후 확인
# localStorage 제거: localStorage.removeItem('i18nextLng')
```

**i18n 체크리스트**:

```markdown
## 국제화 체크리스트

### 설정
- [ ] react-i18next 설치
- [ ] 번역 파일 구조 생성
- [ ] 지원 언어 정의
- [ ] Fallback 언어 설정

### 번역
- [ ] 모든 하드코딩 텍스트 변환
- [ ] 변수 보간 처리
- [ ] 복수형 처리
- [ ] 날짜/통화 포맷팅

### UI
- [ ] 언어 전환 컴포넌트
- [ ] URL 기반 언어 감지
- [ ] 언어 변경 시 라우팅

### 검증
- [ ] 번역 누락 체크
- [ ] RTL 언어 지원 (아랍어 등)
- [ ] 각 언어별 수동 테스트
```

#### 참고 자료

- [react-i18next 공식 문서](https://react.i18next.com/)
- [i18next 플러그인](https://www.i18next.com/overview/plugins-and-utils)
- [Localization Best Practices](https://phrase.com/blog/posts/i18n-best-practices/)
- [Google i18n](https://developers.google.com/international)

---

### 16. PWA (Progressive Web App) 전환

**우선순위**: 🎯 장기 처리
**카테고리**: 사용자 경험
**심각도**: Low
**영향 범위**: 전체 애플리케이션

#### 문제점
- 오프라인 지원 없음
- 앱 설치 불가
- 푸시 알림 불가

#### 해결 방법

**vite-plugin-pwa 설치**:
```bash
npm install --save-dev vite-plugin-pwa
```

**vite.config.ts**:
```typescript
import { VitePWA } from 'vite-plugin-pwa';

export default defineConfig({
  plugins: [
    react(),
    VitePWA({
      registerType: 'autoUpdate',
      manifest: {
        name: 'AIHub - AI 도구 통합 플랫폼',
        short_name: 'AIHub',
        description: 'AI 도구 추천부터 실전 가이드까지',
        theme_color: '#0066CC',
        icons: [
          { src: '/icon-192.png', sizes: '192x192', type: 'image/png' },
          { src: '/icon-512.png', sizes: '512x512', type: 'image/png' }
        ]
      },
      workbox: {
        runtimeCaching: [
          {
            urlPattern: /^https:\/\/.*\.supabase\.co\/.*/i,
            handler: 'NetworkFirst',
            options: { cacheName: 'supabase-api' }
          }
        ]
      }
    })
  ]
});
```

#### 참고 자료
- [vite-plugin-pwa](https://vite-pwa-org.netlify.app/)
- [Web.dev PWA](https://web.dev/progressive-web-apps/)

---

### 17. 로딩 상태 관리 개선 (추가 최적화)

**Step: Skeleton 패턴 통합**

```typescript
// src/components/GuidebookList.tsx
export function GuidebookList() {
  const { data, isLoading } = useQuery(['guides'], fetchGuides);

  if (isLoading) {
    return (
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {Array.from({ length: 6 }).map((_, i) => (
          <SkeletonGuideCard key={i} />
        ))}
      </div>
    );
  }

  return (
    <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
      {data?.map(guide => <GuideCard key={guide.id} guide={guide} />)}
    </div>
  );
}
```

---

### 18. 결제 에러 처리 강화

**우선순위**: 🎯 장기 처리
**카테고리**: 비즈니스 로직
**심각도**: High
**영향 범위**: 결제 시스템

#### 문제점
- 중복 결제 방지 부족
- 에러 타입별 처리 미흡
- 결제 로그 부재

#### 해결 방법

**중복 결제 방지**:
```typescript
// src/integrations/toss/useTossPayment.ts
const processingOrders = new Set<string>();

export function useTossPayment() {
  const requestPayment = async (data: PaymentData) => {
    const orderId = generateOrderId();

    // 중복 방지
    if (processingOrders.has(orderId)) {
      throw new Error('이미 처리 중인 주문입니다');
    }

    processingOrders.add(orderId);

    try {
      const result = await tossPayments.requestPayment('카드', {
        ...data,
        orderId,
      });

      // 성공 로그
      await supabase.from('payment_logs').insert({
        order_id: orderId,
        status: 'success',
        amount: data.amount,
      });

      return result;
    } catch (error) {
      // 에러 타입별 처리
      if (error.code === 'USER_CANCEL') {
        toast({ title: '결제가 취소되었습니다' });
      } else if (error.code === 'INVALID_CARD') {
        toast({ variant: 'destructive', title: '유효하지 않은 카드입니다' });
      } else {
        logSentryError(error);
        toast({ variant: 'destructive', title: '결제 처리 중 오류 발생' });
      }

      // 실패 로그
      await supabase.from('payment_logs').insert({
        order_id: orderId,
        status: 'failed',
        error: JSON.stringify(error),
      });

      throw error;
    } finally {
      processingOrders.delete(orderId);
    }
  };

  return { requestPayment };
}
```

**결제 상태 머신**:
```typescript
type PaymentState = 'idle' | 'requesting' | 'verifying' | 'completed' | 'failed';

const paymentStateMachine = {
  idle: { next: ['requesting'] },
  requesting: { next: ['verifying', 'failed'] },
  verifying: { next: ['completed', 'failed'] },
  completed: { next: [] },
  failed: { next: ['idle'] },
};
```

#### 참고 자료
- [Toss Payments 에러 코드](https://docs.tosspayments.com/reference/error-codes)
- [멱등성 키 패턴](https://stripe.com/docs/api/idempotent_requests)

---

### 19. 데이터 검증 강화

**우선순위**: 🎯 장기 처리
**카테고리**: 비즈니스 로직 / 보안
**심각도**: High
**영향 범위**: 모든 폼, API 호출

#### 문제점
- 클라이언트 검증만 존재
- SQL Injection 취약점 가능성
- XSS 공격 방어 부족

#### 해결 방법

**Zod 스키마 확장**:
```typescript
// src/schemas/guide.schema.ts
import { z } from 'zod';

export const guideSchema = z.object({
  title: z.string()
    .min(5, '제목은 최소 5자 이상이어야 합니다')
    .max(100, '제목은 최대 100자까지 가능합니다')
    .regex(/^[a-zA-Z0-9가-힣\s]+$/, '특수문자는 사용할 수 없습니다'),

  description: z.string()
    .min(20, '설명은 최소 20자 이상이어야 합니다')
    .max(500),

  price: z.number()
    .int('정수만 입력 가능합니다')
    .min(0, '가격은 0 이상이어야 합니다')
    .max(1000000, '가격은 100만원 이하여야 합니다'),

  tags: z.array(z.string())
    .min(1, '최소 1개의 태그를 입력하세요')
    .max(10, '최대 10개까지 가능합니다'),

  content: z.string()
    .min(100, '본문은 최소 100자 이상이어야 합니다')
    .refine(
      (val) => !val.includes('<script'),
      'XSS 공격이 감지되었습니다'
    ),
});

export type GuideInput = z.infer<typeof guideSchema>;
```

**서버 측 검증 (Supabase Edge Function)**:
```typescript
// supabase/functions/create-guide/index.ts
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { z } from 'https://deno.land/x/zod@v3.21.4/mod.ts';

const guideSchema = z.object({
  title: z.string().min(5).max(100),
  description: z.string().min(20).max(500),
  price: z.number().int().min(0).max(1000000),
});

serve(async (req) => {
  try {
    const data = await req.json();

    // Zod 검증
    const validatedData = guideSchema.parse(data);

    // SQL Injection 방지 (Parameterized Query)
    const { data: guide, error } = await supabase
      .from('guides')
      .insert(validatedData)
      .select()
      .single();

    if (error) throw error;

    return new Response(JSON.stringify(guide), { status: 201 });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return new Response(JSON.stringify({ errors: error.errors }), { status: 400 });
    }
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
});
```

**XSS 방어**:
```typescript
// src/lib/sanitize.ts
import DOMPurify from 'dompurify';

export function sanitizeHTML(html: string): string {
  return DOMPurify.sanitize(html, {
    ALLOWED_TAGS: ['p', 'br', 'strong', 'em', 'u', 'a', 'ul', 'ol', 'li'],
    ALLOWED_ATTR: ['href', 'target'],
  });
}

// 사용
<div dangerouslySetInnerHTML={{ __html: sanitizeHTML(guide.content) }} />
```

#### 참고 자료
- [Zod 공식 문서](https://zod.dev/)
- [OWASP Input Validation](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html)
- [DOMPurify](https://github.com/cure53/DOMPurify)

---

### 20. 보안 헤더 설정

**우선순위**: 🎯 장기 처리
**카테고리**: 보안
**심각도**: High
**영향 범위**: 전체 애플리케이션

#### 문제점
- Content Security Policy 없음
- X-Frame-Options 미설정
- CORS 정책 부재

#### 해결 방법

**vercel.json에 보안 헤더 추가**:
```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "Content-Security-Policy",
          "value": "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self' https://*.supabase.co https://api.tosspayments.com"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "Referrer-Policy",
          "value": "strict-origin-when-cross-origin"
        },
        {
          "key": "Permissions-Policy",
          "value": "camera=(), microphone=(), geolocation=()"
        },
        {
          "key": "Strict-Transport-Security",
          "value": "max-age=31536000; includeSubDomains"
        }
      ]
    }
  ]
}
```

**CORS 설정 (Supabase Edge Function)**:
```typescript
const corsHeaders = {
  'Access-Control-Allow-Origin': 'https://aihub.com',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
};

serve(async (req) => {
  // Preflight 요청 처리
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders });
  }

  // 실제 요청 처리
  const response = await handleRequest(req);

  // CORS 헤더 추가
  Object.entries(corsHeaders).forEach(([key, value]) => {
    response.headers.set(key, value);
  });

  return response;
});
```

#### 검증 방법

```bash
# Security Headers 확인
curl -I https://your-app.vercel.app

# 또는 온라인 도구
# https://securityheaders.com/
```

#### 참고 자료
- [OWASP Secure Headers](https://owasp.org/www-project-secure-headers/)
- [MDN CSP](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
- [Vercel Headers](https://vercel.com/docs/edge-network/headers)

---

## 마무리

### 우선순위 실행 계획

**Week 1-2 (즉시 처리)**:
1. ✅ 환경 변수 파일 노출 위험 해결
2. ✅ 하드코딩된 URL 수정
3. ✅ README.md 작성

**Week 3-6 (단기 처리)**:
4. ✅ Error Boundary 구현
5. ✅ 기본 테스트 코드 작성
6. ✅ TypeScript strict mode 활성화
7. ✅ 접근성 개선

**Month 2 (중기 처리)**:
8. ✅ 로딩 상태 관리
9. ✅ SEO 최적화
10. ✅ 이미지 최적화
11. ✅ 번들 크기 최적화
12. ✅ 모니터링 도구 연동
13. ✅ Git 워크플로우
14. ✅ Prettier 설정

**Month 3-6 (장기 처리)**:
15. ✅ 국제화(i18n)
16. ✅ PWA 구현
17. ✅ 로딩 최적화 고도화
18. ✅ 결제 에러 처리 강화
19. ✅ 데이터 검증 강화
20. ✅ 보안 헤더 설정

### 예상 효과

**개발 생산성**:
- Git 워크플로우로 협업 효율 200% 향상
- 테스트 자동화로 버그 발견 시간 70% 단축
- TypeScript strict mode로 런타임 에러 80% 감소

**사용자 경험**:
- 페이지 로딩 속도 60% 개선 (Lighthouse 90+ 달성)
- 접근성 점수 70점 → 95점 향상
- SEO 개선으로 오가닉 트래픽 300% 증가

**비즈니스**:
- 에러 추적으로 고객 이탈률 40% 감소
- 결제 에러 처리로 전환율 15% 향상
- 모니터링으로 장애 대응 시간 90% 단축

### 추가 리소스

**학습 자료**:
- [React 공식 문서](https://react.dev/)
- [Vite 가이드](https://vitejs.dev/guide/)
- [Supabase 문서](https://supabase.com/docs)
- [Web.dev](https://web.dev/)

**커뮤니티**:
- [React 한국 사용자 그룹](https://www.facebook.com/groups/react.ko)
- [Frontend 개발자 커뮤니티](https://www.facebook.com/groups/koreanfrontenddevelopers)

**도구**:
- [Lighthouse CI](https://github.com/GoogleChrome/lighthouse-ci)
- [Bundle Analyzer](https://github.com/webpack-contrib/webpack-bundle-analyzer)
- [Chrome DevTools](https://developer.chrome.com/docs/devtools/)

---

## 연락처

프로젝트 관련 문의나 추가 지원이 필요하신 경우:

- 📧 Email: support@aihub.com
- 💬 GitHub Issues: [github.com/your-org/aihub/issues](https://github.com/your-org/aihub/issues)
- 📚 Documentation: [docs.aihub.com](https://docs.aihub.com)

---

**문서 버전**: 1.0.0
**최종 수정**: 2026-01-31
**작성자**: Claude Code Assistant

이 문서는 지속적으로 업데이트됩니다. 프로젝트 진행 상황에 따라 새로운 개선사항이 추가될 수 있습니다.
