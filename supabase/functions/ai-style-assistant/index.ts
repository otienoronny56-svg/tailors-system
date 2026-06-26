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

    let listings: any[] | null = null;
    let listingsError: any = null;
    if (supabaseUrl && supabaseKey) {
        const supabase = createClient(supabaseUrl, supabaseKey);
        const { data, error } = await supabase
            .from('marketplace_listings')
            .select('id, title, category, target_audience, price, image_urls')
            .eq('status', 'active')
            .limit(100);
        listings = data;
        listingsError = error;

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
      1. Keep your responses conversational but short.
      2. If you recommend items, you MUST ONLY USE the items listed in the "CURRENT AVAILABLE INVENTORY" below.
      3. Do fuzzy/semantic matching: suggest items from the list that closely fit the user's intent. For example, if they ask for "dinner wear" or "dinner outfit", recommend items like "Dinner dress", "Dinner Tuxedo", or "Velvet Tuxedo" from the inventory below. If they ask for "suits", recommend any suit from the list.
      4. NEVER invent, guess, or make up items.
      5. To recommend an item, you MUST output a recommendation token on its own line exactly like this:
         • [RECOMMEND: ID_HERE]
         Replace ID_HERE with the exact ID of the item from the list below.
      6. You can provide brief descriptions or style advice, but any recommended product MUST be listed as a bullet point with the [RECOMMEND: ID_HERE] token. Do not write raw HTML links.
      7. Max 3 recommendations per response.
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

    const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=${GEMINI_API_KEY}`, {
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
    
    console.log("Supabase URL present:", !!supabaseUrl);
    console.log("Supabase Key present:", !!supabaseKey);
    console.log("Listings count:", listings ? listings.length : 0);
    console.log("Raw AI response:", textResult);

    // Process recommendation tokens with backend validation
    if (listings && listings.length > 0) {
      textResult = textResult.replace(/\[RECOMMEND:\s*([^\]]+)\]/gi, (match, itemIdentifier) => {
        const cleanId = itemIdentifier.trim().toLowerCase();
        
        // Find match using multiple matching strategies:
        const found = listings.find(l => {
          const idStr = String(l.id).trim().toLowerCase();
          const titleStr = String(l.title).trim().toLowerCase();
          
          // Strategy 1: Exact ID match
          if (idStr === cleanId) return true;
          
          // Strategy 2: Exact Title match
          if (titleStr === cleanId) return true;
          
          // Strategy 3: Slugified Title match (e.g., "dinner-tuxedo" vs "dinner tuxedo")
          const titleSlug = titleStr.replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');
          const cleanSlug = cleanId.replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');
          if (titleSlug === cleanSlug) return true;
          
          // Strategy 4: Substring match (e.g. "dinner dress" includes "dinner")
          if (titleStr.includes(cleanId) || cleanId.includes(titleStr)) return true;
          
          return false;
        });

        if (found) {
          console.log(`Matched token "${itemIdentifier}" to listing:`, found.title);
          return `<a href="#" onclick="window.closeListingModal(); setTimeout(()=>window.openListingModal('${found.id}'), 100); return false;" style="color:#10b981; font-weight:bold; text-decoration:underline;">${found.title}</a>`;
        }
        console.log(`No match found for token "${itemIdentifier}", marking for removal.`);
        return "REMOVE_LINE_TOKEN";
      });

      // Filter out any lines containing REMOVE_LINE_TOKEN (e.g. invalid bullet points)
      textResult = textResult
        .split('\n')
        .filter(line => !line.includes("REMOVE_LINE_TOKEN"))
        .join('\n');
    }

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
