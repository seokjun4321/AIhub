
import { useEffect, useState, useRef } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Loader2, CheckCircle2, XCircle } from "lucide-react";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";

const PaymentSuccess = () => {
    const [searchParams] = useSearchParams();
    const navigate = useNavigate();
    const [status, setStatus] = useState<"loading" | "success" | "error">("loading");
    const [message, setMessage] = useState("결제를 확인하고 있습니다...");

    const isVerifying = useRef(false);

    useEffect(() => {
        const verify = async () => {
            const paymentKey = searchParams.get("paymentKey");
            const orderId = searchParams.get("orderId");
            const amount = searchParams.get("amount");
            const itemId = searchParams.get("itemId");
            const itemType = searchParams.get("itemType");

            if (!paymentKey || !orderId || !amount || !itemId) {
                setStatus("error");
                setMessage("결제 정보가 올바르지 않습니다.");
                console.error("Missing Params:", { paymentKey, orderId, amount, itemId });
                return;
            }

            // Prevent double-firing
            if (isVerifying.current) return;
            isVerifying.current = true;

            try {
                // Call Supabase Edge Function to verify
                const { data, error } = await supabase.functions.invoke("verify-payment", {
                    body: {
                        paymentKey,
                        orderId,
                        amount: Number(amount),
                        itemId,
                        itemType: itemType || 'preset',
                    },
                });

                if (error) throw error;
                if (data.error) throw new Error(data.error);

                setStatus("success");
                setMessage("결제가 성공적으로 완료되었습니다!");
            } catch (err: any) {
                console.error("Verification Error:", err);
                setStatus("error");
                setMessage(err.message || "결제 확인 중 오류가 발생했습니다.");
            } finally {
                // Optional: reset if you want to allow retrying on error, but usually for success we don't reset.
                // isVerifying.current = false; 
            }
        };

        verify();
    }, [searchParams]);

    return (
        <div className="min-h-screen flex flex-col">
            <Navbar />
            <main className="flex-1 flex items-center justify-center p-4">
                <Card className="w-full max-w-md">
                    <CardHeader className="text-center">
                        <div className="flex justify-center mb-4">
                            {status === "loading" && <Loader2 className="h-12 w-12 animate-spin text-primary" />}
                            {status === "success" && <CheckCircle2 className="h-12 w-12 text-green-500" />}
                            {status === "error" && <XCircle className="h-12 w-12 text-red-500" />}
                        </div>
                        <CardTitle>
                            {status === "loading" && "결제 확인 중"}
                            {status === "success" && "결제 성공"}
                            {status === "error" && "결제 실패"}
                        </CardTitle>
                        <CardDescription>{message}</CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-4">
                        {status === "success" && (
                            <p className="text-sm text-center text-muted-foreground">
                                구매하신 프리셋은 '내 라이브러리' 혹은 해당 프리셋 페이지에서 바로 확인하실 수 있습니다.
                            </p>
                        )}
                        {status === "error" && (
                            <p className="text-sm text-center text-muted-foreground">
                                문제가 지속되면 고객센터로 문의해주세요.
                            </p>
                        )}
                    </CardContent>
                    <CardFooter className="flex justify-center">
                        <Button onClick={() => navigate("/presets")}>
                            스토어로 돌아가기
                        </Button>
                    </CardFooter>
                </Card>
            </main>
            <Footer />
        </div>
    );
};

export default PaymentSuccess;
