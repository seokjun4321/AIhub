import { Routes, Route } from "react-router-dom";
import ScrollToTop from './components/ui/ScrollToTop';
import Index from './pages/Index';
import Guides from './pages/Guides';
import GuideDetail from './pages/GuideDetail';
import Community from './pages/Community';
import PostDetail from './pages/PostDetail';
import NewPost from './pages/NewPost';
import Recommend from './pages/Recommend';
import Auth from './pages/Auth';
import Profile from './pages/Profile';
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
        <Route path="/community" element={<Community />} />
        <Route path="/community/:id" element={<PostDetail />} />
        <Route path="/community/new" element={<ProtectedRoute><NewPost /></ProtectedRoute>} />
        <Route path="/recommend" element={<Recommend />} />
        <Route path="/auth" element={<Auth />} />
        <Route path="/profile" element={<ProtectedRoute><Profile /></ProtectedRoute>} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </>
  );
}

export default App;