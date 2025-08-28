# 🧠 AIHub: The Navigator for the AI Era
AIHub is a practical navigation platform designed to guide users through the overwhelming landscape of AI tools. We recommend the optimal AI solutions for specific problems and provide practical, community-verified guides on how to use them effectively. Think of it as "The Netflix for AI."

# 🎯 The Problem
The AI market is exploding. While this rapid growth is exciting, it has created a "paradox of choice" for users. Beginners and even experts struggle to answer a fundamental question: "Which AI tool is right for my specific task, and how do I use it to get the best results?" Existing information is often fragmented, overly technical, or lacks practical, real-world application.

# ✨ Our Solution
AIHub aims to be the definitive guide in the age of AI. We provide a centralized platform offering three core values:

Curated AI Recommendations: Get tailored suggestions for the best AI tools based on your specific needs and goals.

Practical "How-To" Guides: Access a library of step-by-step tutorials and playbooks that show you how to use these tools effectively.

Experience-Driven Community: Engage with a community of users to share tips, ask questions, and learn from the collective experience of others.

# 🚀 Key Features (Current MVP)
This repository contains the source code for the AIHub MVP, which includes the following implemented features:

Full User Authentication: Secure user signup, login, and logout functionality powered by Supabase Auth.

Profile Management: Users can update their personal information (username, full name) and manage their profile pictures.

Avatar Upload & Cropping: A complete avatar management system featuring image uploads to Supabase Storage, a cropping tool (react-image-crop) for a perfect fit, and image removal.

Guidebook Section: A fully functional section to read comprehensive guides.

Guide List: Fetches and displays all available guides from the Supabase database.

Guide Detail Page: Dynamically renders the full content for each individual guide.

Interactive Community Forum: A complete, data-driven community section for user engagement.

Post & Comment System: Users can create new posts, view post details, and engage in discussions by adding comments.

Real-time Data: All posts and comments are fetched live from the Supabase database.

User Association: Posts and comments are correctly linked to the user profiles who created them.

# 🛠️ Tech Stack
AIHub is built with a modern, scalable, and efficient technology stack:

Frontend: React (with Vite)

Language: TypeScript

Backend & Database: Supabase (Database, Authentication, Storage)

Styling: Tailwind CSS

UI Components: shadcn/ui

Data Fetching & State Management: TanStack React Query

Routing: React Router DOM

Notifications: Sonner

# 🏁 Getting Started
Follow these instructions to get the project up and running on your local machine.

1. Prerequisites
Node.js (v18 or higher recommended)

npm or yarn

A Supabase account (free tier is sufficient)

2. Installation & Setup
Clone the repository:

Bash

git clone https://github.com/your-username/aihub.git
cd aihub
Install dependencies:

Bash

npm install
Set up Supabase:

Create a new project on Supabase.

Go to the SQL Editor and run the SQL scripts found in the supabase/migrations folder to create the profiles, guides, posts, and comments tables and their relationships.

Set up Storage by creating a public bucket named avatars and applying the necessary RLS policies for uploads and access.

Configure Environment Variables:

Create a .env file in the root of the project by copying the example:

Bash

cp .env.example .env
Go to Project Settings > API in your Supabase dashboard.

Fill in the .env file with your Project URL and anon public key.

You will also need the service_role secret key for the seeding script.

Your .env file should look like this:

코드 스니펫

VITE_SUPABASE_URL="YOUR_SUPABASE_URL"
VITE_SUPABASE_PUBLISHABLE_KEY="YOUR_SUPABASE_ANON_KEY"
SUPABASE_SERVICE_KEY="YOUR_SUPABASE_SERVICE_ROLE_KEY"
Generate Supabase Types:
Update the TypeScript types to match your database schema.

Bash

npm run supabase:types
3. Running the Development Server
Seed the database (optional):
To populate the database with initial test data, first sign up at least one user in the application. Then, run the seed script:

Bash

node seed.js
Start the development server:

Bash

npm run dev
The application should now be running on http://localhost:8080.