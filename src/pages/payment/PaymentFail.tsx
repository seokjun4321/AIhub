
import { useEffect } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { XCircle } from "lucide-react";

const PaymentFail = () => {
    const [searchParams] = useSearchParams();
    const navigate = useNavigate();
    const message = searchParams.get("message") || "결제에 실패했습니다.";
    const code = searchParams.get("code");

    useEffect(() => {
        console.error(`Payment Failed: ${code} - ${message}`);
    }, [code, message]);

    return (
        <div className="flex flex-col items-center justify-center min-h-screen p-4">
            <XCircle className="w-16 h-16 text-red-500 mb-4" />
            <h1 className="text-2xl font-bold mb-2">결제 실패</h1>
            <p className="text-muted-foreground mb-6 text-center max-w-md">
                {message}
                <br />
                <span className="text-xs text-slate-400">({code})</span>
            </p>
            <div className="flex gap-3">
                <Button variant="outline" onClick={() => navigate(-1)}>
                    이전으로 돌아가기
                </Button>
                <Button onClick={() => navigate("/")}>
                    홈으로 가기
                </Button>
            </div>
        </div>
    );
};

export default PaymentFail;
