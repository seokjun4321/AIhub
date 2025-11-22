import { Routes, Route } from "react-router-dom";
import ScrollToTop from './components/ui/ScrollToTop';
import Index from './pages/Index';
import Guides from './pages/Guides';
import GuideDetail from './pages/GuideDetail';
import Community from './pages/Community';
import PostDetail from './pages/PostDetail';
import NewPost from './pages/NewPost';
import EditPost from './pages/EditPost';
import Bookmarks from './pages/Bookmarks';
import Recommend from './pages/Recommend';
import PromptEngineering from './pages/PromptEngineering';
import Tools from './pages/Tools';
import ToolDetail from './pages/ToolDetail';
import ToolCompare from './pages/ToolCompare';
import Auth from './pages/Auth';
import Profile from './pages/Profile';
import About from './pages/About';
import Team from './pages/Team';
import Careers from './pages/Careers';
import Contact from './pages/Contact';
import NotFound from './pages/NotFound';
import ProtectedRoute from './components/ui/protected-route';

function App() {
  return (
    <>
      <ScrollToTop />
      <Routes>
        <Route path="/" element={<Index />} />
        <Route path="/guides" element={<Guides />} />
        <Route path="/guides/:id" element={<GuideDetail />} />
        {/* Guidebook 라우팅 (Tools/ToolDetail/GuideDetail 재사용) */}
        <Route path="/guidebook" element={<Tools />} />
        <Route path="/guidebook/:id" element={<ToolDetail />} />
        <Route path="/guidebook/:toolId/:id" element={<GuideDetail />} />
        <Route path="/community" element={<Community />} />
        <Route path="/community/:id" element={<PostDetail />} />
        <Route path="/community/new" element={<ProtectedRoute><NewPost /></ProtectedRoute>} />
        <Route path="/community/edit/:id" element={<ProtectedRoute><EditPost /></ProtectedRoute>} />
        <Route path="/bookmarks" element={<ProtectedRoute><Bookmarks /></ProtectedRoute>} />
        <Route path="/recommend" element={<Recommend />} />
        <Route path="/prompt-engineering" element={<PromptEngineering />} />
        <Route path="/tools" element={<Tools />} />
        <Route path="/tools/:id" element={<ToolDetail />} />
        <Route path="/tools/compare" element={<ToolCompare />} />
        <Route path="/auth" element={<Auth />} />
        <Route path="/profile" element={<ProtectedRoute><Profile /></ProtectedRoute>} />
        <Route path="/about" element={<About />} />
        <Route path="/team" element={<Team />} />
        <Route path="/careers" element={<Careers />} />
        <Route path="/contact" element={<Contact />} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </>
  );
}

export default App;