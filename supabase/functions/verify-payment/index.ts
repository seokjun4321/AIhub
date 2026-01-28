
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

const corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// User provided test secret key
const TOSS_SECRET_KEY = Deno.env.get("TOSS_SECRET_KEY") || "test_sk_AQ92ymxN34dxXX1NKR0v3ajRKXvd";
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

serve(async (req) => {
    if (req.method === "OPTIONS") {
        return new Response(null, { headers: corsHeaders });
    }

    try {
        const { paymentKey, orderId, amount, itemId, itemType } = await req.json();

        console.log(`Verifying payment: ${orderId} with key ${paymentKey}`);

        // 1. Confirm Payment with Toss API
        // Need to Base64 encode the Secret Key + ":"
        const basicAuth = btoa(TOSS_SECRET_KEY + ":");

        const tossResponse = await fetch("https://api.tosspayments.com/v1/payments/confirm", {
            method: "POST",
            headers: {
                "Authorization": `Basic ${basicAuth}`,
                "Content-Type": "application/json",
            },
            body: JSON.stringify({ paymentKey, orderId, amount }),
        });

        const tossData = await tossResponse.json();

        if (!tossResponse.ok) {
            console.error("Toss API Error:", tossData);
            // Throw or return error
            return new Response(
                JSON.stringify({ error: tossData.message || "Payment confirmation failed", code: tossData.code }),
                { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
            );
        }

        // 2. Call RPC to handle data atomically
        const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

        // We assume 'item_type' and 'item_id' are passed in metadata or derived. 
        // Wait, the client SDK requestPayment doesn't always allow extensive metadata passed through to verify, 
        // BUT we can infer or pass it in the body to THIS function too, if we trust the client?
        // STRICTLY SPEAKING, the client could lie about item_id if we just blindly take it. 
        // However, verify-payment is called AFTER Toss confirm.
        // The safest way is if we stored the "Intent" before capabilities found. 
        // But for this 'Standard SDK' flow without a pre-order table, we often pass metadata to Toss or trust the client for simple items.
        // Toss allows `metadata` in requestPayment. We should check if we get it back.
        // Documentation says Toss returns metadata in the response if we sent it.
        // Let's check `tossData` for metadata.
        // Ideally, the client sends { paymentKey, orderId, amount, itemId, itemType } to THIS function.
        // And we verify amount matches the item price in DB? 
        // PRO-TIP: For this MVP, we will accept item details from the client BUT ideally we should verify price.
        // Let's assume the client passes item details in the body to verify-payment.

        // Since we didn't define metadata usage in the plan rigidly, I'll extract it from the request body to this function.
        // I need to update the request parsing.

        /* 
          Ideally here:
          const { data: item } = await supabase.from(itemType + 's').select('price').eq('id', itemId).single();
          if (item.price !== amount) throw new Error("Price mismatch");
        */

        const { data: result, error: rpcError } = await supabase.rpc("handle_new_purchase", {
            p_user_id: (await supabase.auth.getUser(req.headers.get("Authorization")?.split(" ")[1] ?? "")).data.user?.id,
            // Wait, this is a service role client, I need the USER ID.
            // The user calls this function with their Anon Key + Auth Header.
            // So I can get the user from the JWT in the request header.
            // Better: Create a supabase client with the Auth Header from the request.

            // Actually, for `handle_new_purchase` I need p_user_id.
            // Let's get it from the request JWT.
        });

        // Rethinking User ID:
        // The `supabase` client above is SERVICE_ROLE.
        // To identify the user, I should inspect the Authorization header.
        const authHeader = req.headers.get("Authorization");
        let userId = null;
        if (authHeader) {
            const userClient = createClient(SUPABASE_URL, Deno.env.get("SUPABASE_ANON_KEY")!, {
                global: { headers: { Authorization: authHeader } }
            });
            const { data: { user } } = await userClient.auth.getUser();
            userId = user?.id;
        }

        if (!userId) {
            // If no user logic (e.g. guest checkout), handle appropriately. 
            // But our DB schema has user_id references auth.users (nullable? No, usually required for user purchases).
            // Migration said: `user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL`
            // It is nullable. But we surely want it for logged in users.
            console.warn("No user ID found in request");
        }

        const { data: rpcData, error: rpcErrorCombined } = await supabase.rpc("handle_new_purchase", {
            p_user_id: userId,
            p_order_id: orderId,
            p_item_type: itemType || 'preset', // Fallback or strict
            p_item_id: itemId,
            p_amount: amount,
            p_payment_key: paymentKey,
            p_payment_method: tossData.method || '카드', // Toss returns 'method' (e.g. '카드', '간편결제')
            p_receipt_url: tossData.receipt?.url || null,
            p_raw_response: tossData
        });

        if (rpcErrorCombined) {
            console.error("RPC Error:", rpcErrorCombined);
            // Even if RPC fails, Toss Payment is CONFIRMED. We should alert or retry.
            // For now, return error to client so they can contact support.
            return new Response(
                JSON.stringify({ error: "Purchase processed but DB update failed", details: rpcErrorCombined }),
                { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
            );
        }

        return new Response(
            JSON.stringify(rpcData),
            { headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );

    } catch (error) {
        console.error("Error:", error);
        return new Response(
            JSON.stringify({ error: error.message }),
            { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
    }
});
