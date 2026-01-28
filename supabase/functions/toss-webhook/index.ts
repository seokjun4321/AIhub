
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

const TOSS_SECRET_KEY = Deno.env.get("TOSS_SECRET_KEY") || "test_sk_AQ92ymxN34dxXX1NKR0v3ajRKXvd";
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

serve(async (req) => {
    try {
        // 1. Security Verification: Check Authorization Header
        // Toss sends "Basic base64(SECRET_KEY:)"
        const authHeader = req.headers.get("Authorization");
        const expectedAuth = `Basic ${btoa(TOSS_SECRET_KEY + ":")}`;

        if (authHeader !== expectedAuth) {
            console.error("Unauthorized Webhook Attempt");
            return new Response("Unauthorized", { status: 401 });
        }

        // 2. Parse Body
        const body = await req.json();
        const { eventType, data } = body;
        /*
          Example Body:
          {
            "eventType": "PAYMENT_STATUS_CHANGED",
            "createdAt": "2022-01-01T00:00:00.000000",
            "data": {
              "paymentKey": "...",
              "orderId": "...",
              "status": "DONE", 
               ...
            }
          }
        */

        console.log(`Webhook Event: ${eventType}`, data.orderId);

        if (eventType === "PAYMENT_STATUS_CHANGED") {
            const { status, paymentKey, orderId, amount, method, receipt } = data;

            if (status === "DONE" || status === "CANCELED") {
                const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

                // Note: In Webhook, we might not know 'item_type' or 'item_id' if it wasn't in DB yet.
                // If the client closed browser BEFORE verify-payment, we might have a gap.
                // However, Toss allows `metadata` in the initial requestPayment.
                // If we sent it, it comes back in `data.metadata`.
                // Let's assume we send metadata from frontend.

                const metadata = data.metadata || {};
                const itemType = metadata.itemType || "preset"; // fallback
                const itemId = metadata.itemId; // might be undefined if not sent

                // If itemId is missing, we might need to look it up from a pre-created 'orders' table 
                // OR we just record what we have (raw_response) and let admin fix it.
                // But our `purchases` table requires `item_id`.
                // Critical: Frontend MUST send metadata.

                // If itemId is null, we can't insert into `purchases` nicely if it's NOT NULL.
                // But we must handle this.
                // Logic: Try insert.

                const { error } = await supabase.rpc("handle_new_purchase", {
                    p_user_id: metadata.userId || null, // Can we pass userId in metadata? Yes.
                    p_order_id: orderId,
                    p_item_type: itemType,
                    p_item_id: itemId || "00000000-0000-0000-0000-000000000000", // Fallback UUID if missing
                    p_amount: amount,
                    p_payment_key: paymentKey,
                    p_payment_method: method,
                    p_receipt_url: receipt?.url || null,
                    p_raw_response: data
                });

                if (error) {
                    console.error("Webhook RPC Error:", error);
                    return new Response("Error recording purchase", { status: 500 });
                }
            }
        }

        return new Response(JSON.stringify({ received: true }), {
            headers: { "Content-Type": "application/json" },
        });

    } catch (error) {
        console.error("Webhook Error:", error);
        return new Response(
            JSON.stringify({ error: error.message }),
            { status: 500, headers: { "Content-Type": "application/json" } }
        );
    }
});
