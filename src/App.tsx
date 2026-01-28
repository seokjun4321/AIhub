import { Routes, Route } from "react-router-dom";
import NewHome from './pages/NewHome';
import Guides from './pages/Guides';
import GuideDetail from './pages/GuideDetail';
import Community from './pages/Community';
import PostDetail from './pages/PostDetail';
import NewPost from './pages/NewPost';
import EditPost from './pages/EditPost';
import Bookmarks from './pages/Bookmarks';
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
import AdminRoute from './components/ui/admin-route';
import PresetStore from "./pages/PresetStore";
import SuggestTool from "./pages/SuggestTool";
import ToolProposals from "./pages/admin/ToolProposals";
import MyTools from "./pages/MyTools";
import FeedbackDashboard from "./pages/admin/FeedbackDashboard";
import SubmissionList from "./pages/admin/SubmissionList";
import SubmissionDetail from "./pages/admin/SubmissionDetail";
import GuideSubmissionList from "./pages/admin/GuideSubmissionList"; // Import added
import GuideSubmissionDetail from "./pages/admin/GuideSubmissionDetail"; // Import added
import PaymentSuccess from "./pages/payment/PaymentSuccess";
import PaymentFail from "./pages/payment/PaymentFail";

import AdminHub from "./pages/admin/AdminHub";
import WorkflowDetail from "./pages/WorkflowDetail";
import SellPreset from "./pages/SellPreset";
import GuideBuilderLayout from './components/guide-builder/GuideBuilderLayout';
import { Toaster } from "@/components/ui/toaster";
import { ChatbotProvider } from "./contexts/ChatbotContext";
import { FloatingActionGroup } from "./components/layout/FloatingActionGroup";




function App() {
  return (
    <ChatbotProvider>
      {/* <ScrollToTop /> - Now inside FloatingActionGroup */}
      <Routes>
        <Route path="/" element={<NewHome />} />
        <Route path="/guides" element={<Guides />} />
        <Route path="/guides/:id" element={<GuideDetail />} />
        {/* Guidebook 라우팅 (Tools/ToolDetail/GuideDetail 재사용) */}
        <Route path="/guidebook" element={<Tools />} />
        <Route path="/guidebook/:id" element={<ToolDetail />} />
        <Route path="/guidebook/:toolId/:id" element={<GuideDetail />} />

        {/* 새로운 가이드북 디자인 라우트 */}
        <Route path="/guide/new" element={<AdminRoute><GuideBuilderLayout /></AdminRoute>} />

        <Route path="/payment/success" element={<PaymentSuccess />} />
        <Route path="/payment/fail" element={<PaymentFail />} />

        <Route path="/workflows/:id" element={<WorkflowDetail />} />
        <Route path="/presets" element={<PresetStore />} />
        <Route path="/sell-preset" element={<SellPreset />} />
        <Route path="/community" element={<Community />} />
        <Route path="/community/:id" element={<PostDetail />} />
        <Route path="/community/new" element={<ProtectedRoute><NewPost /></ProtectedRoute>} />
        <Route path="/community/edit/:id" element={<ProtectedRoute><EditPost /></ProtectedRoute>} />
        <Route path="/bookmarks" element={<ProtectedRoute><Bookmarks /></ProtectedRoute>} />
        {/* <Route path="/recommend" element={<Recommend />} />  Removed as per request */}
        <Route path="/prompt-engineering" element={<PromptEngineering />} />
        <Route path="/tools" element={<Tools />} />
        <Route path="/tools/suggest" element={<ProtectedRoute><SuggestTool /></ProtectedRoute>} />
        <Route path="/admin" element={<AdminRoute><AdminHub /></AdminRoute>} />
        <Route path="/admin/proposals" element={<AdminRoute><ToolProposals /></AdminRoute>} />
        <Route path="/admin/feedback" element={<AdminRoute><FeedbackDashboard /></AdminRoute>} />
        <Route path="/admin/submissions" element={<AdminRoute><SubmissionList /></AdminRoute>} />
        <Route path="/admin/submissions/:id" element={<AdminRoute><SubmissionDetail /></AdminRoute>} />
        <Route path="/admin/guide-submissions" element={<AdminRoute><GuideSubmissionList /></AdminRoute>} /> {/* New Route */}
        <Route path="/admin/guide-submissions/:id" element={<AdminRoute><GuideSubmissionDetail /></AdminRoute>} /> {/* New Route */}
        <Route path="/my-tools" element={<ProtectedRoute><MyTools /></ProtectedRoute>} />
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
      <FloatingActionGroup />
      <Toaster />
    </ChatbotProvider>
  );
}

export default App;