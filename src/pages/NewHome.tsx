import { useEffect, useRef, useState } from 'react';
import { Link } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { supabase } from '@/integrations/supabase/client';
import Navbar from '@/components/ui/navbar';
import Footer from '@/components/ui/footer';
import '../styles/newHome.css';
import {
    logos,
    guidebooks as dummyGuidebooks,
    presets,
    tools as dummyTools,
    communityQuestions,
    solvedProblems,
    type Guidebook,
    type Preset,
    type Tool,
    type CommunityItem
} from '../data/homeData';

// Fetch recent guides from Supabase
// Fetch recent guides from Supabase
const fetchRecentGuides = async () => {
    console.log('Fetching guides...');
    // Debug: Simple query first to check access
    const { data, error } = await supabase
        .from('guides')
        .select(`
            id,
            title,
            description,
            difficulty_level,
            estimated_time,
            view_count
        `)
        .order('created_at', { ascending: false })
        .limit(6);

    if (error) {
        console.error('❌ 가이드북 가져오기 에러 (Detail):', error);
        console.error('Error hint:', error.hint);
        console.error('Error message:', error.message);
        return [];
    }

    console.log('✅ 가이드북 데이터 수신 성공:', data);
    return data || [];
};

// Fetch AI tools from Supabase
const fetchAITools = async () => {
    const { data, error } = await supabase
        .from('ai_models')
        .select('id, name, description, logo_url')
        .order('name')
        .limit(40);

    if (error) {
        console.error('❌ AI 도구 가져오기 에러:', error);
        return [];
    }

    return data || [];
};

// Fetch resolved community posts from Supabase
const fetchResolvedPosts = async () => {
    const { data, error } = await supabase
        .from('posts')
        .select(`
            id,
            title,
            created_at,
            profiles:author_id (
                id,
                username,
                avatar_url
            ),
            post_tags (
                tags (
                    name,
                    color
                )
            )
        `)
        .order('created_at', { ascending: false })
        .limit(3);

    if (error) {
        console.error('❌ 해결된 게시물 가져오기 에러:', error);
        return [];
    }

    return data || [];
};

// Map difficulty level to Korean tag
const getLevelTag = (level: string | null): string => {
    const levelMap: Record<string, string> = {
        'beginner': '초급',
        'intermediate': '중급',
        'advanced': '고급'
    };
    return level ? levelMap[level.toLowerCase()] || level : '';
};

// Map category to icon
const getCategoryIcon = (categoryName: string | null): string => {
    const iconMap: Record<string, string> = {
        // 실제 DB 카테고리명
        '창업 & 비즈니스': '📈',
        '개발 & 코딩': '💻',
        '취업 준비': '🎓',
        '연구 & 학습': '🔍',
        'AI 기초 입문': '🤖',

        // 기존 매핑 (호환성 유지)
        '프롬프트 엔지니어링': '⚡',
        '학업/취업': '🎓',
        '학업': '📚',
        '취업': '💼',
        '비즈니스': '📈',
        '개발/자동화': '🔧',
        '개발': '💻',
        '자동화': '⚙️',
        '콘텐츠 제작': '🎨',
        '데이터/분석': '📊',
        '데이터': '📊',
        '분석': '🔍',
        '마케팅': '📣',
        '디자인': '🎨',
        '글쓰기': '✍️',
        '이미지': '🖼️',
        '영상': '🎥'
    };
    return categoryName ? iconMap[categoryName] || '📝' : '📝';
};

// Map tool name to icon
const getToolIcon = (toolName: string): string => {
    const toolMap: Record<string, string> = {
        'ChatGPT': '💬',
        'Claude': '🤖',
        'Gemini': '✨',
        'Perplexity': '🔍',
        'Midjourney': '🎨',
        'DALL-E': '🖼️',
        'Stable Diffusion': '🎭',
        'GitHub Copilot': '🐙',
        'Cursor': '💻',
        'Notion AI': '📓',
        'Jasper': '💎',
        'Copy.ai': '✍️',
        'Otter.ai': '🎙️',
        'Synthesia': '👤',
        'Descript': '🎥',
        'Fireflies': '🧚',
        'Gamma': '📊',
        'Luma AI': '🧊'
    };

    // 부분 매칭: toolName에 키워드가 포함되어 있으면 해당 아이콘 반환
    for (const [key, icon] of Object.entries(toolMap)) {
        if (toolName.includes(key)) {
            return icon;
        }
    }

    return '🔧'; // 기본 아이콘
};

// Format time ago (e.g., "4개월 전")
const formatTimeAgo = (dateString: string): string => {
    const date = new Date(dateString);
    const now = new Date();
    const diffMs = now.getTime() - date.getTime();
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMs / 3600000);
    const diffDays = Math.floor(diffMs / 86400000);
    const diffMonths = Math.floor(diffDays / 30);
    const diffYears = Math.floor(diffDays / 365);

    if (diffMins < 1) return '방금 전';
    if (diffMins < 60) return `${diffMins}분 전`;
    if (diffHours < 24) return `${diffHours}시간 전`;
    if (diffDays < 30) return `${diffDays}일 전`;
    if (diffMonths < 12) return `${diffMonths}개월 전`;
    return `${diffYears}년 전`;
};


function NewHome() {
    const [demoExpanded, setDemoExpanded] = useState(false);
    const [modalOpen, setModalOpen] = useState(false);
    const [userMessage, setUserMessage] = useState('');
    const [modalMessages, setModalMessages] = useState<Array<{ type: 'ai' | 'user'; text: string }>>([
        { type: 'ai', text: '안녕하세요! 무엇을 도와드릴까요?' }
    ]);

    const heroTextAreaRef = useRef<HTMLTextAreaElement>(null);
    const canvasRef = useRef<HTMLCanvasElement>(null);

    // Fetch guides from Supabase
    const { data: guidesData, isLoading: guidesLoading } = useQuery({
        queryKey: ['recentGuides'],
        queryFn: fetchRecentGuides
    });

    // Fetch AI tools from Supabase
    const { data: aiToolsData, isLoading: toolsLoading } = useQuery({
        queryKey: ['aiTools'],
        queryFn: fetchAITools
    });

    // Fetch resolved community posts from Supabase
    const { data: resolvedPostsData, isLoading: postsLoading } = useQuery({
        queryKey: ['resolvedPosts'],
        queryFn: fetchResolvedPosts
    });


    // Map Supabase data to Guidebook format
    const guidebooks: Guidebook[] = guidesData?.map((guide: any) => {
        const categoryName = (guide.categories as any)?.name || '기타';
        const icon = getCategoryIcon(categoryName);

        // Debug: log category and icon
        console.log('Guide:', guide.title, '| Category:', categoryName, '| Icon:', icon);

        return {
            id: guide.id,
            title: guide.title,
            desc: guide.description || '',
            icon: icon,
            tags: [
                categoryName,
                getLevelTag(guide.difficulty_level)
            ].filter(Boolean)
        };
    }) || dummyGuidebooks;

    // Map AI tools data to Tool format
    const tools: Tool[] = aiToolsData?.map((model: any) => ({
        name: model.name,
        desc: '', // 상세설명 제거
        icon: model.logo_url || getToolIcon(model.name) // 실제 로고 URL 사용
    })) || dummyTools;

    // Debug: log the number of tools
    console.log('🔧 Total AI tools loaded:', tools.length, tools);



    // Initialize particles on component mount
    useEffect(() => {
        if (canvasRef.current) {
            initParticles(canvasRef.current);
        }
    }, []);

    // Scroll reveal observer
    useEffect(() => {
        const observer = new IntersectionObserver(
            (entries) => {
                entries.forEach((entry) => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('active');
                    }
                });
            },
            { threshold: 0.1 }
        );

        document.querySelectorAll('.reveal').forEach((el) => observer.observe(el));

        return () => observer.disconnect();
    }, []);

    // Fill marquee tracks
    useEffect(() => {
        fillTrack('logo-marquee', [...logos, ...logos, ...logos], renderLogo);
        fillTrack('guidebook-track', guidebooks, (item) => renderCard(item, 'guidebook'));
        fillTrack('guidebook-track-2', guidebooks, (item) => renderCard(item, 'guidebook'));
        fillTrack('preset-track', presets, (item) => renderCard(item, 'preset'));
        fillTrack('preset-track-2', presets, (item) => renderCard(item, 'preset'));

        // AI 도구 마키 효과 - 두 개의 열로 분리
        const halfLength = Math.ceil(tools.length / 2);
        const topRowTools = tools.slice(0, halfLength);
        const bottomRowTools = tools.slice(halfLength);

        fillTrack('tool-track-1', [...topRowTools, ...topRowTools], renderToolPill);
        fillTrack('tool-track-2', [...bottomRowTools, ...bottomRowTools], renderToolPill);
    }, [guidebooks, tools]);

    const fillTrack = (trackId: string, items: any[], renderer: (item: any) => HTMLElement) => {
        const track = document.getElementById(trackId);
        if (!track) return;
        track.innerHTML = '';
        items.forEach((item) => {
            const element = renderer(item);
            track.appendChild(element);
        });
    };

    const renderLogo = (name: string): HTMLElement => {
        const div = document.createElement('div');
        div.className = 'logo-item';
        div.textContent = name;
        return div;
    };

    const renderCard = (item: Guidebook | Preset, type: 'guidebook' | 'preset'): HTMLElement => {
        const div = document.createElement('div');
        div.className = 'info-card';

        let html = '';
        if (type === 'guidebook') {
            const guidebookItem = item as Guidebook & { id?: string };
            // Find level tag (초급, 중급, 고급) or use the first tag
            const levelTags = ['초급', '중급', '고급'];
            const levelTag = guidebookItem.tags.find(t => levelTags.includes(t)) || guidebookItem.tags[0] || '초급';

            html = `
        <div style="flex:1; display:flex; flex-direction:column; height:100%;">
          <!-- Header: Icon Left, Tag Right -->
          <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:1rem;">
            <div style="width:40px; height:40px; background:#F3F4F6; border-radius:8px; display:flex; align-items:center; justify-content:center; color:#374151;">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20"/></svg>
            </div>
            <span class="card-badge badge-green" style="margin:0;">${levelTag}</span>
          </div>
          
          <!-- Body: Title & Desc -->
          <div style="flex:1; margin-bottom:1rem;">
            <h3 style="font-size:1.1rem; font-weight:700; line-height:1.4; margin:0 0 0.5rem 0; word-break: keep-all; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">${guidebookItem.title}</h3>
            <p class="guide-desc" style="-webkit-line-clamp: 3;">${guidebookItem.desc || '단계별로 따라하며 배우는 실전 AI 가이드입니다.'}</p>
          </div>
          
          <!-- Footer: Read Count (Dummy) -->
          <div style="border-top:1px solid #F3F4F6; padding-top:0.75rem; margin-top:auto; font-size:0.8rem; color:#9CA3AF; display:flex; align-items:center;">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right:4px;"><path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></svg>
            <span>${Math.floor(Math.random() * 500)}명이 읽었어요</span>
          </div>
        </div>
      `;

            // Add click event to navigate to guide detail page
            if (guidebookItem.id) {
                div.style.cursor = 'pointer';
                div.addEventListener('click', () => {
                    window.location.href = `/guides/${guidebookItem.id}`;
                });
            }
        } else if (type === 'preset') {
            const presetItem = item as Preset;
            html = `
        <div>
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;">
            <span class="card-badge badge-yellow" style="font-size:0.85rem;">${presetItem.tool}과 함께</span>
          </div>
          <h3>${presetItem.title}</h3>
          <p>${presetItem.desc}</p>
        </div>
        <div class="preset-actions">
          <button class="btn-copy">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>
            복사하고 툴 열기
          </button>
          <button class="btn-preview">미리보기</button>
        </div>
      `;
        }

        div.innerHTML = html;
        return div;
    };

    const renderToolPill = (item: Tool): HTMLElement => {
        const div = document.createElement('div');
        div.className = 'tool-pill';

        // icon이 URL인지 확인 (http로 시작하면 이미지 URL)
        const isImageUrl = item.icon && (item.icon.startsWith('http') || item.icon.startsWith('/'));

        div.innerHTML = `
      ${isImageUrl
                ? `<img src="${item.icon}" alt="${item.name}" style="width:2rem; height:2rem; object-fit:contain; border-radius:0.25rem;" />`
                : `<span style="font-size:1.2rem;">${item.icon}</span>`
            }
      <span style="font-weight:700; font-size:0.9rem; margin-left: 0.5rem;">${item.name}</span>
    `;
        return div;
    };

    const renderCommunityItem = (item: CommunityItem): HTMLElement => {
        const div = document.createElement('div');
        div.className = 'list-item';
        div.style.alignItems = 'flex-start';
        div.style.gap = '1rem';

        const tagsHtml = item.tags
            .map((t) => `<span style="background:#F3F4F6; padding:2px 6px; border-radius:4px; font-size:0.75rem; color:#4B5563;">${t}</span>`)
            .join('');

        div.innerHTML = `
      <div style="font-size:2rem; padding-top:4px;">${item.icon}</div>
      <div style="flex:1;">
        <div style="display:flex; gap:0.5rem; font-size:0.8rem; color:#6B7280; margin-bottom:0.25rem;">
          <span style="font-weight:600; color:#374151;">${item.title}</span>
          <span>•</span>
          <span>${item.time}</span>
        </div>
        <h4 style="font-size:1rem; font-weight:600; margin-bottom:0.5rem; color:#111827;">${item.text}</h4>
        <div style="display:flex; gap:0.5rem;">${tagsHtml}</div>
      </div>
      <div style="display:flex; align-items:center; gap:4px; color:#9CA3AF; font-size:0.8rem;">
        <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
        ${item.comments}
      </div>
    `;
        return div;
    };

    const initParticles = (canvas: HTMLCanvasElement) => {
        const ctx = canvas.getContext('2d');
        if (!ctx) return;

        let width: number, height: number;
        const particles: Particle[] = [];
        const particleCount = 60;

        const resize = () => {
            width = canvas.width = canvas.offsetWidth;
            height = canvas.height = canvas.offsetHeight;
        };

        class Particle {
            x: number;
            y: number;
            vx: number;
            vy: number;
            size: number;
            alpha: number;

            constructor() {
                this.x = Math.random() * width;
                this.y = Math.random() * height;
                this.vx = (Math.random() - 0.5) * 0.5;
                this.vy = (Math.random() - 0.5) * 0.5;
                this.size = Math.random() * 2 + 1;
                this.alpha = Math.random() * 0.5 + 0.1;
            }

            update() {
                this.x += this.vx;
                this.y += this.vy;

                if (this.x < 0 || this.x > width) this.vx *= -1;
                if (this.y < 0 || this.y > height) this.vy *= -1;
            }

            draw() {
                ctx.fillStyle = `rgba(0, 0, 0, ${this.alpha * 0.4})`;
                ctx.beginPath();
                ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
                ctx.fill();
            }
        }

        const init = () => {
            particles.length = 0;
            for (let i = 0; i < particleCount; i++) {
                particles.push(new Particle());
            }
        };

        const animate = () => {
            ctx.clearRect(0, 0, width, height);
            particles.forEach((p) => {
                p.update();
                p.draw();
            });
            requestAnimationFrame(animate);
        };

        window.addEventListener('resize', () => {
            resize();
            init();
        });

        resize();
        init();
        animate();
    };

    const handleOpenModal = () => {
        const initialText = heroTextAreaRef.current?.value.trim() || '';
        if (initialText) {
            setModalMessages((prev) => [...prev, { type: 'user', text: initialText }]);
            if (heroTextAreaRef.current) heroTextAreaRef.current.value = '';
        }
        setModalOpen(true);
    };

    const handleCloseModal = () => {
        setModalOpen(false);
    };

    const handleSendMessage = () => {
        if (userMessage.trim()) {
            setModalMessages((prev) => [...prev, { type: 'user', text: userMessage }]);
            setUserMessage('');
        }
    };

    return (
        <div className="min-h-screen bg-background">
            <Navbar />

            <main>
                {/* MVP Announcement Banner */}
                <div className="mvp-banner">
                    <span>🚀</span>
                    현재 MVP 단계입니다. 조만간 모든 기능을 업데이트할 예정이므로 많은 기대 부탁드립니다.
                </div>

                {/* Hero Section */}
                <header className="hero">
                    <canvas ref={canvasRef} id="hero-particles"></canvas>
                    <div className="new-home-container hero-container">
                        <div className="hero-left reveal">
                            <h1 className="hero-title">AIHub</h1>
                            <p className="hero-subtitle">
                                상황을 입력하면 필요한 AI 도구·가이드북·프리셋을
                                <br />
                                한 번에 연결합니다.
                            </p>
                        </div>

                        <div className="hero-right reveal" style={{ transitionDelay: '100ms' }}>
                            <div className="chatbot-card">
                                <div className="shine-border"></div>
                                <div className="card-inner-content">
                                    <div className="chat-header">
                                        <h2>AI 추천 어시스턴트</h2>
                                    </div>

                                    <div className="chat-body">
                                        <div className="suggestion-chips">
                                            <button className="chip" onClick={handleOpenModal}>🚀 생산성 높이기</button>
                                            <button className="chip" onClick={handleOpenModal}>🎨 이미지 생성</button>
                                            <button className="chip" onClick={handleOpenModal}>📝 글쓰기 작성</button>
                                            <button className="chip" onClick={handleOpenModal}>📊 데이터 분석</button>
                                        </div>
                                    </div>

                                    <div className="chat-input-area">
                                        <textarea ref={heroTextAreaRef} placeholder="무엇을 도와드릴까요?" onKeyDown={(e) => {
                                            if (e.key === 'Enter' && !e.shiftKey) {
                                                e.preventDefault();
                                                handleOpenModal();
                                            }
                                        }}></textarea>
                                        <button className="send-btn" aria-label="Send" onClick={handleOpenModal}>
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                                <line x1="22" y1="2" x2="11" y2="13"></line>
                                                <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                                            </svg>
                                        </button>
                                    </div>

                                    <div className="mini-demo">
                                        <div className="demo-header" onClick={() => setDemoExpanded(!demoExpanded)}>
                                            <span className="demo-text">💡 예시: "블로그 글 자동화하고 싶어요"</span>
                                            <button className="demo-toggle">{demoExpanded ? '접기' : '보기'}</button>
                                        </div>
                                        <div className={`demo-content ${demoExpanded ? 'expanded' : ''}`}>
                                            <div className="result-chips">
                                                <span className="result-chip tool">도구: Claude</span>
                                                <span className="result-chip guide">가이드북: AI 블로그 자동화</span>
                                                <span className="result-chip preset">프리셋: 블로그 글 프롬프트</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </header>

                {/* Logo Marquee Strip */}
                <section className="logo-marquee-section">
                    <div className="marquee-fade-top"></div>
                    <div className="marquee-track" id="logo-marquee"></div>
                </section>

                {/* Guidebook Section */}
                <section id="guidebook" className="section reveal">
                    <div className="new-home-container text-center">
                        <h2 className="section-title">가이드북</h2>
                        <p className="section-subtitle">따라하면 결과가 나오는 단계별 AI 활용 레시피</p>

                        <Link to="/guides" className="view-all-btn">
                            가이드북 전체 보기
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <path d="M5 12h14"></path>
                                <path d="M12 5l7 7-7 7"></path>
                            </svg>
                        </Link>

                        <div className="features-row green">
                            <span>⚡ 단계별로 따라하면 바로 결과물 완성</span>
                            <span>⚙️ 실무에 바로 적용 가능한 실전 레시피</span>
                            <span>💡 초보자도 쉽게 이해하는 상세 설명</span>
                        </div>
                    </div>

                    <div className="marquee-container left-scroll">
                        <div className="card-track" id="guidebook-track"></div>
                        <div className="card-track" id="guidebook-track-2" aria-hidden="true"></div>
                    </div>
                </section>

                {/* Preset Section */}
                <section id="presets" className="section reveal">
                    <div className="new-home-container text-center">
                        <h2 className="section-title">프리셋</h2>
                        <p className="section-subtitle">복사해서 바로 쓰는 프롬프트·자동화·템플릿</p>

                        <Link to="/presets" className="view-all-btn">
                            프리셋 전체 보기
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <path d="M5 12h14"></path>
                                <path d="M12 5l7 7-7 7"></path>
                            </svg>
                        </Link>

                        <div className="features-row purple">
                            <span>🚀 복사 한 번으로 즉시 사용 가능</span>
                            <span>🕒 시간 절약, 검증된 템플릿</span>
                            <span>🎯 전문가가 만든 최적화 프리셋</span>
                        </div>

                        <div className="process-steps">
                            <div className="step-item">
                                <div className="step-circle">1</div>
                                <div className="step-text">
                                    <strong>Copy</strong>
                                    <br />
                                    프리셋 복사
                                </div>
                            </div>
                            <div className="step-line"></div>
                            <div className="step-item">
                                <div className="step-circle">2</div>
                                <div className="step-text">
                                    <strong>Paste</strong>
                                    <br />
                                    도구에 붙여넣기
                                </div>
                            </div>
                            <div className="step-line"></div>
                            <div className="step-item">
                                <div className="step-circle">3</div>
                                <div className="step-text">
                                    <strong>Run</strong>
                                    <br />
                                    실행하고 완료!
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="marquee-container right-scroll">
                        <div className="card-track" id="preset-track"></div>
                        <div className="card-track" id="preset-track-2" aria-hidden="true"></div>
                    </div>
                </section>

                {/* AI Tool Directory Section */}
                <section id="tools" className="section reveal">
                    <div className="new-home-container text-center">
                        <h2 className="section-title">AI 도구 디렉토리</h2>
                        <p className="section-subtitle">필터로 찾고, 비교로 결정하세요</p>
                    </div>

                    <div className="directory-marquee-wrapper">
                        <div className="directory-track row-1" id="tool-track-1"></div>
                        <div className="directory-track row-2" id="tool-track-2" style={{ marginTop: '1rem' }}></div>
                    </div>

                </section>

                {/* Community Section */}
                <section id="community" className="section reveal">
                    <div className="new-home-container">
                        <div className="community-header-center">
                            <h2 className="section-title">커뮤니티 활동</h2>
                            <p className="section-subtitle">다른 사용자들과 지식을 공유하고 함께 성장하세요</p>
                        </div>

                        <div className="community-grid">
                            {/* 최근 질문 */}
                            <div className="comm-col">
                                <h3 className="col-header question-header">최근 질문</h3>
                                <div className="empty-state">
                                    아직 등록된 질문이 없습니다.
                                </div>
                            </div>

                            {/* 최근 해결된 문제 */}
                            <div className="comm-col">
                                <h3 className="col-header resolved-header">최근 해결된 문제</h3>
                                {postsLoading ? (
                                    <div className="empty-state">로딩 중...</div>
                                ) : resolvedPostsData && resolvedPostsData.length > 0 ? (
                                    resolvedPostsData.map((post: any) => (
                                        <div key={post.id} className="post-card">
                                            <div className="post-card-header">
                                                <div className="post-avatar">
                                                    {post.profiles?.avatar_url ? (
                                                        <img src={post.profiles.avatar_url} alt={post.profiles.username || 'User'} />
                                                    ) : (
                                                        <span>{(post.profiles?.username || 'U')[0].toUpperCase()}</span>
                                                    )}
                                                </div>
                                                <div style={{ flex: 1 }}>
                                                    <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                                                        <span className="post-username">{post.profiles?.username || '익명'}</span>
                                                        <span className="post-badge">해결완료</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <h4 className="post-title">{post.title}</h4>
                                            {post.post_tags && post.post_tags.length > 0 && (
                                                <div className="post-tags">
                                                    {post.post_tags.map((pt: any, idx: number) => (
                                                        pt.tags && (
                                                            <span key={idx} className="post-tag" style={{ color: pt.tags.color || '#6B7280' }}>
                                                                {pt.tags.name}
                                                            </span>
                                                        )
                                                    ))}
                                                </div>
                                            )}
                                            <div className="post-time">{formatTimeAgo(post.created_at)}</div>
                                        </div>
                                    ))
                                ) : (
                                    <div className="empty-state">해결된 문제가 없습니다.</div>
                                )}
                            </div>
                        </div>

                        <div className="community-footer">
                            <Link to="/community">
                                <button className="cta-btn">커뮤니티 참여하기</button>
                            </Link>
                        </div>
                    </div>
                </section>
                {/* CTA Section */}
                <section className="section reveal">
                    <div className="new-home-container text-center">
                        <span className="card-badge badge-green" style={{ marginBottom: '1rem', fontSize: '0.9rem' }}>✨ 지금 바로 시작하세요</span>
                        <h2 className="section-title" style={{ marginBottom: '1rem' }}>AI 활용, 더 이상 어렵지 않습니다</h2>
                        <p className="section-subtitle" style={{ maxWidth: '600px', margin: '0 auto 2rem auto' }}>
                            AIHub와 함께라면 누구나 쉽게 AI를 업무와 일상에 활용할 수 있습니다.
                            <br />
                            지금 무료로 시작해보세요.
                        </p>

                        <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center', marginBottom: '1rem' }}>
                            <button className="cta-btn" onClick={handleOpenModal}>
                                무료로 시작하기
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ display: 'inline-block', marginLeft: '0.5rem', verticalAlign: 'middle' }}>
                                    <path d="M5 12h14"></path>
                                    <path d="M12 5l7 7-7 7"></path>
                                </svg>
                            </button>
                            <button className="cta-btn secondary">자세히 알아보기</button>
                        </div>

                        <p style={{ fontSize: '0.85rem', color: '#9CA3AF' }}>신용카드 등록 불필요 • 언제든지 무료로 시작</p>
                    </div>
                </section>
            </main>

            {/* Footer */}
            <Footer />

            {/* Chat Modal */}
            {modalOpen && (
                <div id="chat-modal" className="modal open" onClick={(e) => e.target === e.currentTarget && handleCloseModal()}>
                    <div className="modal-card-wrapper">
                        <div className="card-inner-content" style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
                            <div className="modal-header">
                                <h3>AI 어시스턴트</h3>
                                <button className="close-modal" onClick={handleCloseModal}>&times;</button>
                            </div>
                            <div className="modal-body">
                                {modalMessages.map((msg, idx) => (
                                    <div key={idx} className={`message ${msg.type}`}>
                                        {msg.text}
                                    </div>
                                ))}
                            </div>
                            <div className="modal-input">
                                <input
                                    type="text"
                                    placeholder="메시지를 입력하세요..."
                                    value={userMessage}
                                    onChange={(e) => setUserMessage(e.target.value)}
                                    onKeyDown={(e) => {
                                        if (e.key === 'Enter') {
                                            e.preventDefault();
                                            handleSendMessage();
                                        }
                                    }}
                                />
                                <button onClick={handleSendMessage}>전송</button>
                            </div>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}

export default NewHome;
