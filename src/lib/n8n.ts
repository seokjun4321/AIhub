
/**
 * Sends a message to the n8n webhook via Vite proxy.
 * Proxy Target: VITE_N8N_API_URL (defined in .env)
 * 
 * @param userId - The ID of the user sending the message
 * @param userQuery - The message content
 * @returns The answer from n8n workflow
 */
export const sendMessageToN8n = async (userId: string, userQuery: string) => {
    // Use relative path for proxy
    // Local: http://localhost:8080/api/n8n/webhook/aihub/recommend
    // -> Vite Proxy -> https://{ngrok-domain}/webhook/aihub/recommend
    const endpoint = '/api/n8n/webhook/aihub/recommend';

    try {
        const res = await fetch(endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                user_id: userId,
                user_query: userQuery
            })
        });

        if (!res.ok) {
            const errorText = await res.text();
            throw new Error(`Network response was not ok: ${res.status} ${errorText}`);
        }

        let data = await res.json();

        // Safety check: n8n might return stringified JSON
        if (typeof data === 'string') {
            try {
                data = JSON.parse(data);
            } catch (e) {
                // If parsing fails, it might be just a string response, keep as is or log
                console.warn('Failed to parse double-encoded JSON', e);
            }
        }

        return data; // Expected: { answer: "..." }

    } catch (error) {
        console.error('Failed to send message to n8n:', error);
        throw error;
    }
};
