import Navbar from "@/components/ui/navbar";
import HeroSection from "@/components/ui/hero-section";
import FeaturesSection from "@/components/ui/features-section";
import CTASection from "@/components/ui/cta-section";
import Footer from "@/components/ui/footer";

const Index = () => {
  return (
    <div className="min-h-screen">
      <Navbar />
      <main>
        <HeroSection />
        <FeaturesSection />
        <CTASection />
      </main>
      <Footer />
    </div>
  );
};

export default Index;