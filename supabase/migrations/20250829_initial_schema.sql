-- Initial schema migration for AIHub
-- Creates all basic tables needed for the application

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profiles table
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    username TEXT UNIQUE,
    email TEXT,
    bio TEXT,
    avatar_url TEXT,
    website TEXT,
    location TEXT,
    post_count INTEGER DEFAULT 0,
    comment_count INTEGER DEFAULT 0,
    reputation INTEGER DEFAULT 0,
    is_verified BOOLEAN DEFAULT FALSE,
    is_moderator BOOLEAN DEFAULT FALSE,
    last_seen_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- AI Models table
CREATE TABLE IF NOT EXISTS public.ai_models (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    provider TEXT,
    model_type TEXT,
    pricing_info TEXT,
    features TEXT[],
    use_cases TEXT[],
    limitations TEXT[],
    website_url TEXT,
    api_documentation_url TEXT,
    average_rating NUMERIC(3,2) DEFAULT 0,
    rating_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Categories table
CREATE TABLE IF NOT EXISTS public.categories (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Guides table
CREATE TABLE IF NOT EXISTS public.guides (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT,
    ai_model_id INTEGER REFERENCES public.ai_models(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES public.categories(id) ON DELETE SET NULL,
    author_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    difficulty_level TEXT DEFAULT 'beginner',
    estimated_time INTEGER, -- in minutes
    prerequisites TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Ratings table
CREATE TABLE IF NOT EXISTS public.ratings (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    ai_model_id INTEGER REFERENCES public.ai_models(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    review TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, ai_model_id)
);

-- Posts table
CREATE TABLE IF NOT EXISTS public.posts (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT,
    author_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    community_section_id INTEGER,
    category_id INTEGER,
    upvotes_count INTEGER DEFAULT 0,
    downvotes_count INTEGER DEFAULT 0,
    view_count INTEGER DEFAULT 0,
    comment_count INTEGER DEFAULT 0,
    is_pinned BOOLEAN DEFAULT FALSE,
    is_locked BOOLEAN DEFAULT FALSE,
    is_nsfw BOOLEAN DEFAULT FALSE,
    images TEXT[] DEFAULT '{}',
    last_activity_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comments table
CREATE TABLE IF NOT EXISTS public.comments (
    id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    author_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    post_id INTEGER REFERENCES public.posts(id) ON DELETE CASCADE,
    parent_comment_id INTEGER REFERENCES public.comments(id) ON DELETE CASCADE,
    upvotes_count INTEGER DEFAULT 0,
    downvotes_count INTEGER DEFAULT 0,
    is_edited BOOLEAN DEFAULT FALSE,
    edited_at TIMESTAMP WITH TIME ZONE,
    is_deleted BOOLEAN DEFAULT FALSE,
    images TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Use Cases table
CREATE TABLE IF NOT EXISTS public.use_cases (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    ai_model_id INTEGER REFERENCES public.ai_models(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES public.categories(id) ON DELETE SET NULL,
    difficulty_level TEXT DEFAULT 'beginner',
    estimated_time INTEGER, -- in minutes
    prerequisites TEXT[],
    steps TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Recommendations table
CREATE TABLE IF NOT EXISTS public.recommendations (
    id SERIAL PRIMARY KEY,
    use_case_id INTEGER REFERENCES public.use_cases(id) ON DELETE CASCADE,
    ai_model_id INTEGER REFERENCES public.ai_models(id) ON DELETE CASCADE,
    reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(use_case_id, ai_model_id)
);

-- RLS (Row Level Security) 활성화
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_models ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guides ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.use_cases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recommendations ENABLE ROW LEVEL SECURITY;

-- 기본 RLS 정책 설정
-- Profiles: 본인만 수정 가능, 모든 사용자가 읽기 가능
CREATE POLICY "Profiles are viewable by everyone" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- AI Models: 모든 사용자가 읽기 가능
CREATE POLICY "AI Models are viewable by everyone" ON public.ai_models FOR SELECT USING (true);

-- Categories: 모든 사용자가 읽기 가능
CREATE POLICY "Categories are viewable by everyone" ON public.categories FOR SELECT USING (true);

-- Guides: 모든 사용자가 읽기 가능
CREATE POLICY "Guides are viewable by everyone" ON public.guides FOR SELECT USING (true);

-- Ratings: 모든 사용자가 읽기 가능, 본인만 작성/수정 가능
CREATE POLICY "Ratings are viewable by everyone" ON public.ratings FOR SELECT USING (true);
CREATE POLICY "Users can manage own ratings" ON public.ratings FOR ALL USING (auth.uid() = user_id);

-- Posts: 모든 사용자가 읽기 가능, 본인만 작성/수정 가능
CREATE POLICY "Posts are viewable by everyone" ON public.posts FOR SELECT USING (true);
CREATE POLICY "Users can manage own posts" ON public.posts FOR ALL USING (auth.uid() = author_id);

-- Comments: 모든 사용자가 읽기 가능, 본인만 작성/수정 가능
CREATE POLICY "Comments are viewable by everyone" ON public.comments FOR SELECT USING (true);
CREATE POLICY "Users can manage own comments" ON public.comments FOR ALL USING (auth.uid() = author_id);

-- Use Cases: 모든 사용자가 읽기 가능
CREATE POLICY "Use Cases are viewable by everyone" ON public.use_cases FOR SELECT USING (true);

-- Recommendations: 모든 사용자가 읽기 가능
CREATE POLICY "Recommendations are viewable by everyone" ON public.recommendations FOR SELECT USING (true);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_posts_author ON public.posts(author_id);
CREATE INDEX IF NOT EXISTS idx_posts_created_at ON public.posts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_comments_post ON public.comments(post_id);
CREATE INDEX IF NOT EXISTS idx_comments_author ON public.comments(author_id);
CREATE INDEX IF NOT EXISTS idx_ratings_model ON public.ratings(ai_model_id);
CREATE INDEX IF NOT EXISTS idx_ratings_user ON public.ratings(user_id);
CREATE INDEX IF NOT EXISTS idx_guides_model ON public.guides(ai_model_id);
CREATE INDEX IF NOT EXISTS idx_guides_category ON public.guides(category_id);
