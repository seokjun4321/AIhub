import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import Hero from "@/components/home/Hero";
import CoreFeatures from "@/components/home/CoreFeatures";
import ToolDirectory from "@/components/home/ToolDirectory";
import TrendingTools from "@/components/home/TrendingTools";
import Guidebook from "@/components/home/Guidebook";
import PresetStore from "@/components/home/PresetStore";
import CommunityActivity from "@/components/home/CommunityActivity";
import FooterCTA from "@/components/home/FooterCTA";

const Index = () => {
  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main>
        <Hero />
        <CoreFeatures />
        <ToolDirectory />
        <TrendingTools />
        <Guidebook />
        <PresetStore />
        <CommunityActivity />
        <FooterCTA />
      </main>
      <Footer />
    </div>
  );
};

export default Index;