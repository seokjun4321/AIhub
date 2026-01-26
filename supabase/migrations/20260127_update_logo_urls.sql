-- Update logo_urls for AI models to point to local assets in /logos/
-- Includes fixes for Krea, Wolfram, Vellum, Quizlet, Lindy, Opus Clip

UPDATE ai_models
SET logo_url = CASE 
    -- User requested specifics
    WHEN name IN ('Krea', 'Krea AI') THEN '/logos/krea.webp'
    WHEN name IN ('Wolfram', 'WolframAlpha', 'Wolfram Alpha') THEN '/logos/wolfram.jpeg'
    WHEN name IN ('Vellum', 'Vellum AI', 'Velluma') THEN '/logos/velluma.png'
    WHEN name IN ('Quizlet') THEN '/logos/quizlet.jpeg'
    WHEN name IN ('Lindy', 'Lindy AI') THEN '/logos/lindy.jpeg'
    WHEN name IN ('Opus Clip', 'OpusClip') THEN '/logos/opus clip.png'

    -- Creating comprehensive mapping for all likely models based on file list
    
    -- Scholar Batch
    WHEN name = 'ScholarAI' THEN '/logos/ScholarAI.webp'
    WHEN name = 'NotebookLM' THEN '/logos/notebooklm.webp'
    WHEN name = 'Consensus' THEN '/logos/consensus.avif'
    WHEN name = 'Elicit' THEN '/logos/elicit.jpeg'
    WHEN name IN ('ResearchRabbit', 'Research Rabbit') THEN '/logos/researchrabit.jpg' -- Typo in file
    WHEN name = 'Semantic Scholar' THEN '/logos/semantic.png'
    
    -- Set 3
    WHEN name = 'ChatGPT' THEN '/logos/openai.png'
    WHEN name = 'Claude' THEN '/logos/claude.png'
    WHEN name = 'Gemini' THEN '/logos/gemini.png'
    WHEN name = 'Perplexity' THEN '/logos/perplexity.png'
    WHEN name = 'Jasper' THEN '/logos/jasper.png'
    WHEN name = 'Copy.ai' THEN '/logos/copyai.png'

    -- Set 4
    WHEN name = 'Midjourney' THEN '/logos/midjourney.png'
    WHEN name = 'Ideogram' THEN '/logos/ideogram.png'
    WHEN name = 'Runway' THEN '/logos/runway.png'
    WHEN name IN ('Stable Diffusion', 'Stability AI') THEN '/logos/stabilityai.png'

    -- Set 5
    WHEN name = 'Suno' THEN '/logos/suno.png'
    WHEN name = 'Udio' THEN '/logos/udio.ico'
    WHEN name = 'ElevenLabs' THEN '/logos/elevenlabs.svg'
    WHEN name = 'Murf AI' THEN '/logos/murf.png'
    WHEN name = 'Synthesia' THEN '/logos/synthesia.png'
    WHEN name = 'HeyGen' THEN '/logos/heygen.jpeg'

    -- Set 6
    WHEN name = 'Canva' THEN '/logos/canva.jpeg'
    WHEN name = 'Gamma' THEN '/logos/gamma.png'
    WHEN name = 'Tome' THEN '/logos/tome.png'
    WHEN name = 'Luma Dream Machine' THEN '/logos/luma.jpeg'

    -- Set 7
    WHEN name = 'Descript' THEN '/logos/descript.jpeg'
    WHEN name = 'Windsurf' THEN '/logos/windsurf.jpeg'
    WHEN name = 'Manus' THEN '/logos/manus.png'
    WHEN name = 'Bolt.new' THEN '/logos/bolt.png'
    WHEN name = 'Lovable' THEN '/logos/lovable.jpeg'
    WHEN name = 'Hugging Face' THEN '/logos/huggingface.png'

    -- Set 8
    WHEN name = 'Pinecone' THEN '/logos/pinecone.png'
    WHEN name = 'LangSmith' THEN '/logos/langsmith.png'
    WHEN name = 'Phind' THEN '/logos/phind.png'
    WHEN name = 'Agent Factory' THEN '/logos/factory.png'
    WHEN name = 'AutoDev' THEN '/logos/autodev.png'
    WHEN name = 'Teal' THEN '/logos/teal.jpeg'

    -- Set 9
    WHEN name = 'Kickresume' THEN '/logos/kickresume.jpeg'
    WHEN name = 'Shortwave' THEN '/logos/shortwave.png'
    WHEN name = 'Superhuman' THEN '/logos/superhuman.webp'
    WHEN name = 'Monica' THEN '/logos/monica.jpeg'
    WHEN name = 'Genspark' THEN '/logos/genspark-ai-icon.webp'
    WHEN name = 'Captions' THEN '/logos/captions.png'

    -- Set 10
    WHEN name = 'Motion' THEN '/logos/motion.jpg'
    WHEN name = 'Beautiful.ai' THEN '/logos/beautiful.png'
    WHEN name IN ('Autoppt', 'AutoPPT') THEN '/logos/autoppt.jpeg'
    WHEN name = 'DeepSeek' THEN '/logos/deepseek.png'

    -- Set 11
    WHEN name = 'Grok' THEN '/logos/grok.jpeg'
    -- Mistral file missing, skipping
    WHEN name = 'Microsoft Copilot' THEN '/logos/copilot.jpeg'
    WHEN name = 'Hume AI' THEN '/logos/hume-ai.webp'

    -- Extras & Variants
    WHEN name = 'AdCreative.ai' THEN '/logos/adcreative.jpeg'
    WHEN name = 'Bardeen' THEN '/logos/bardeen.jpeg'
    WHEN name = 'Brandmark' THEN '/logos/brandmark.png'
    WHEN name = 'CapCut' THEN '/logos/capcut.png'
    WHEN name = 'ChatPDF' THEN '/logos/chatpdf.jpeg'
    WHEN name = 'Clova Note' THEN '/logos/clova_note.png'
    WHEN name = 'Coefficient' THEN '/logos/coefficient.png'
    WHEN name = 'Copykiller' THEN '/logos/copykiller.png'
    WHEN name = 'DeepL' THEN '/logos/deepl.png'
    WHEN name = 'ELSA Speak' THEN '/logos/elsa_speak.jpg'
    WHEN name = 'Fathom' THEN '/logos/fathom.png'
    WHEN name = 'Fireflies.ai' THEN '/logos/fireflies.png'
    WHEN name = 'Grammarly' THEN '/logos/grammarly.svg'
    WHEN name IN ('Granola', 'Granola AI') THEN '/logos/granola ai.jpeg'
    WHEN name = 'Julius AI' THEN '/logos/julius.png'
    WHEN name = 'Kling AI' THEN '/logos/kling ai.jpeg'
    WHEN name = 'Lindy' THEN '/logos/lindy.jpeg' -- Reinforced
    WHEN name = 'Liner' THEN '/logos/liner.png'
    WHEN name = 'Looka' THEN '/logos/looka.png'
    WHEN name = 'Make' THEN '/logos/make.png'
    WHEN name = 'Mindgrasp' THEN '/logos/mindgrasp.jpeg'
    WHEN name = 'MyMap' THEN '/logos/mymap.jpeg'
    WHEN name = 'Otter.ai' THEN '/logos/otter ai.jpeg'
    WHEN name = 'Photomath' THEN '/logos/photomath.png'
    WHEN name = 'QuillBot' THEN '/logos/quillbot.png'
    WHEN name = 'Replit' THEN '/logos/replit.png'
    WHEN name = 'Speak' THEN '/logos/speak.jpeg'
    WHEN name = 'Tabnine' THEN '/logos/tabnine.png'
    WHEN name = 'UPDF' THEN '/logos/updf.jpeg'
    WHEN name = 'Vrew' THEN '/logos/vrew.jpg'
    WHEN name = 'Whimsical' THEN '/logos/whimsical.png'
    WHEN name = 'Wrtn' THEN '/logos/wrtn.jpeg'
    WHEN name = 'Zapier' THEN '/logos/zapier.svg'

    ELSE logo_url
END
WHERE name IN (
    'Krea', 'Krea AI', 'Wolfram', 'WolframAlpha', 'Wolfram Alpha', 'Vellum', 'Vellum AI', 'Velluma',
    'Quizlet', 'Lindy', 'Lindy AI', 'Opus Clip', 'OpusClip',
    'ScholarAI', 'NotebookLM', 'Consensus', 'Elicit', 'ResearchRabbit', 'Research Rabbit', 'Semantic Scholar',
    'ChatGPT', 'Claude', 'Gemini', 'Perplexity', 'Jasper', 'Copy.ai',
    'Midjourney', 'Ideogram', 'Runway', 'Stable Diffusion', 'Stability AI',
    'Suno', 'Udio', 'ElevenLabs', 'Murf AI', 'Synthesia', 'HeyGen',
    'Canva', 'Gamma', 'Tome', 'Luma Dream Machine',
    'Descript', 'Windsurf', 'Manus', 'Bolt.new', 'Lovable', 'Hugging Face',
    'Pinecone', 'LangSmith', 'Phind', 'Agent Factory', 'AutoDev', 'Teal',
    'Kickresume', 'Shortwave', 'Superhuman', 'Monica', 'Genspark', 'Captions',
    'Motion', 'Beautiful.ai', 'Autoppt', 'AutoPPT', 'DeepSeek',
    'Grok', 'Microsoft Copilot', 'Hume AI',
    'AdCreative.ai', 'Bardeen', 'Brandmark', 'CapCut', 'ChatPDF', 'Clova Note', 'Coefficient',
    'Copykiller', 'DeepL', 'ELSA Speak', 'Fathom', 'Fireflies.ai', 'Grammarly', 'Granola', 'Granola AI',
    'Julius AI', 'Kling AI', 'Liner', 'Looka', 'Make', 'Mindgrasp', 'MyMap',
    'Otter.ai', 'Photomath', 'QuillBot', 'Replit', 'Speak', 'Tabnine',
    'UPDF', 'Vrew', 'Whimsical', 'Wrtn', 'Zapier'
);
