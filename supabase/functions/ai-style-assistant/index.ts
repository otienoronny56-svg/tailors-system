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
    let inventoryContext = "";

    if (supabaseUrl && supabaseKey) {
        const supabase = createClient(supabaseUrl, supabaseKey);
        const { data: listings } = await supabase
            .from('marketplace_listings')
            .select('id, title, category, target_audience, price, image_urls, image_url')
            .eq('status', 'active')
            .limit(40);

        if (listings && listings.length > 0) {
            inventoryContext = `\n\nCURRENT AVAILABLE INVENTORY IN THE DB:\n` +
                listings.map(l => {
                    let imgUrl = "https://images.unsplash.com/photo-1593032465175-481ac7f401a0?auto=format&fit=crop&q=80&w=400";
                    if (l.image_urls) {
                        try {
                            const arr = typeof l.image_urls === 'string' ? JSON.parse(l.image_urls) : l.image_urls;
                            if (arr && arr.length > 0) imgUrl = arr[0];
                        } catch(e){}
                    } else if (l.image_url) {
                        imgUrl = l.image_url;
                    }
                    if (imgUrl && !imgUrl.startsWith('http')) {
                        imgUrl = "https://ouuhirckiavcvgqlpriw.supabase.co/storage/v1/object/public/marketplace-assets/" + imgUrl;
                    }
                    return `- ID: ${l.id} | Title: ${l.title} | Category: ${l.category} | Price: Ksh ${l.price} | Img: ${imgUrl}`;
                }).join('\n');
        }
    }

    const systemInstruction = `
      You are an expert fashion stylist for a high-end tailored clothing marketplace in Kenya.
      CRITICAL INSTRUCTIONS:
      1. Keep your responses EXTREMELY short, punchy, and conversational (1-3 sentences max).
      2. DO NOT over-explain. Just answer the question directly.
      3. If the user asks for recommendations, you MUST look at the CURRENT AVAILABLE INVENTORY below.
      4. To recommend an item from the inventory, output EXACTLY this HTML snippet (replace ID, IMG_URL, and TITLE):
         <div style="margin: 10px 0; display: inline-block; background: rgba(17,34,64,0.5); padding: 8px; border-radius: 8px; border: 1px solid rgba(212,175,55,0.2);"><a href="#" onclick="window.closeListingModal(); setTimeout(()=>window.openListingModal('ID_HERE'), 100); return false;" style="color:#10b981; font-weight:bold; text-decoration:none;"><img src="IMG_URL_HERE" style="width:140px; height:140px; object-fit:cover; border-radius:6px; display:block; margin-bottom:6px;">TITLE_HERE</a></div>
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
          temperature: 0.7,
      }
    };

    const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${GEMINI_API_KEY}`, {
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
