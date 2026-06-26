import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY');
    if (!GEMINI_API_KEY) {
      throw new Error('GEMINI_API_KEY is not set');
    }

    const body = await req.json();
    const { history, message } = body;

    if (!message) {
      throw new Error('message is required');
    }

    // Initialize Supabase to fetch inventory
    const supabaseUrl = Deno.env.get('SUPABASE_URL') || "https://ouuhirckiavcvgqlpriw.supabase.co";
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') || Deno.env.get('SUPABASE_ANON_KEY');
    
    if (!supabaseKey) {
        throw new Error('Supabase client key is not set');
    }
    
    const supabase = createClient(supabaseUrl, supabaseKey);

    // 1. Generate Embedding for the user's message
    const embeddingResponse = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=${GEMINI_API_KEY}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            content: { parts: [{ text: message }] }
        })
    });

    if (!embeddingResponse.ok) {
        const errText = await embeddingResponse.text();
        throw new Error(`Gemini Embedding API responded with status ${embeddingResponse.status}: ${errText}`);
    }

    const embeddingData = await embeddingResponse.json();
    const queryEmbedding = embeddingData.embedding?.values;

    if (!queryEmbedding || !Array.isArray(queryEmbedding) || queryEmbedding.length !== 3072) {
        throw new Error(`Failed to retrieve valid 3072-dimension embedding values from Gemini.`);
    }

    // 2. Query Postgres pgvector RPC function match_listings
    const { data: matchedListings, error: searchErr } = await supabase.rpc('match_listings', {
        query_embedding: queryEmbedding,
        match_threshold: 0.1, // lower threshold to ensure we get *some* context if they are just chatting, though the model will ignore it if irrelevant
        match_count: 5 // Get top 5 most relevant items
    });

    if (searchErr) {
        throw new Error(`Postgres similarity query failed: ${searchErr.message}`);
    }

    let inventoryContext = "";
    if (matchedListings && matchedListings.length > 0) {
        inventoryContext = `\n\nCURRENT AVAILABLE INVENTORY IN THE DB:\n` +
            matchedListings.map((l: any) => {
                return `- ID: ${l.id} | Title: ${l.title} | Category: ${l.category} | Price: Ksh ${l.price} | Target: ${l.target_audience}`;
            }).join('\n');
    } else {
        inventoryContext = `\n\nCURRENT AVAILABLE INVENTORY IN THE DB:\n(No relevant items found for this query.)`;
    }

    const systemInstruction = `
      You are an expert fashion stylist for a high-end tailored clothing marketplace in Kenya.
      CRITICAL INSTRUCTIONS:
      1. Keep your responses conversational, friendly, and short.
      2. If you recommend items, you MUST ONLY USE the items listed in the "CURRENT AVAILABLE INVENTORY" below.
      3. NEVER invent, guess, or make up items. If the inventory below does not match what the user is asking for, politely inform them that we don't have exactly that, but you can suggest something else or they can request a custom tailored order.
      4. To recommend an item, you MUST output a markdown link pointing to its ID. Format the link exactly like this:
         [Exact Item Title](#listing-ID_HERE)
         For example, if the ID is 123 and Title is Red Dress, output: [Red Dress](#listing-123).
      5. Max 3 recommendations per response.
      ${inventoryContext}
    `;

    // Format chat history for Gemini
    const contents = [];
    
    if (history && Array.isArray(history)) {
      for (const msg of history) {
        if (msg.role === 'user') {
          contents.push({ role: 'user', parts: [{ text: msg.text }] });
        } else if (msg.role === 'model' || msg.role === 'assistant') {
          contents.push({ role: 'model', parts: [{ text: msg.text }] });
        }
      }
    }

    // Add current message
    contents.push({ role: 'user', parts: [{ text: message }] });

    const payload = {
      system_instruction: {
        parts: [{ text: systemInstruction }]
      },
      contents: contents,
      generationConfig: {
          temperature: 0.1,
      }
    };

    const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload)
    });

    if (!response.ok) {
      const errText = await response.text();
      console.error("Gemini API Error:", errText);
      throw new Error(`Gemini API responded with status ${response.status}: ${errText}`);
    }

    const data = await response.json();
    let textResult = data.candidates?.[0]?.content?.parts?.[0]?.text || "Sorry, I couldn't generate a response.";
    
    console.log("Raw AI response:", textResult);

    return new Response(
      JSON.stringify({ reply: textResult }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error("Style Assistant Error:", error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
    )
  }
})
