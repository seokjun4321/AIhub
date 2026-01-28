
import { loadTossPayments } from "@tosspayments/payment-sdk";

const TOSS_CLIENT_KEY = import.meta.env.VITE_TOSS_CLIENT_KEY as string;

export const useTossPayment = () => {
    const requestPayment = async (
        method: "카드" | "계좌이체" | "가상계좌" | "휴대폰" | "도서문화상품권" | "게임문화상품권" | "문화상품권",
        options: {
            amount: number;
            orderId: string;
            orderName: string;
            customerName: string;
            successUrl: string;
            failUrl: string;
            customerEmail?: string;
        }
    ) => {
        try {
            const tossPayments = await loadTossPayments(TOSS_CLIENT_KEY);
            await tossPayments.requestPayment(method, options);
        } catch (error: any) {
            console.error("Payment Error:", error);
            throw error;
        }
    };

    return { requestPayment };
};
