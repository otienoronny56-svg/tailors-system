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
    const { listingId } = body;

    if (!listingId) {
      throw new Error('listingId is required');
    }

    // Initialize Supabase Client with Service Role Key to bypass RLS for updating
    const supabaseUrl = Deno.env.get('SUPABASE_URL') || "https://ouuhirckiavcvgqlpriw.supabase.co";
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
    if (!supabaseKey) {
      throw new Error('SUPABASE_SERVICE_ROLE_KEY is not set');
    }

    const supabase = createClient(supabaseUrl, supabaseKey);

    // 1. Fetch listing details
    const { data: listing, error: fetchErr } = await supabase
      .from('marketplace_listings')
      .select('title, description, category')
      .eq('id', listingId)
      .single();

    if (fetchErr || !listing) {
      throw new Error(`Failed to fetch listing details: ${fetchErr?.message || 'Not found'}`);
    }

    // 2. Prepare text for embedding
    const textToEmbed = `Title: ${listing.title} | Category: ${listing.category} | Description: ${listing.description || ""}`;

    // 3. Request embedding from Gemini API
    const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=${GEMINI_API_KEY}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        content: {
          parts: [{ text: textToEmbed }]
        }
      })
    });

    if (!response.ok) {
      const errText = await response.text();
      throw new Error(`Gemini Embedding API responded with status ${response.status}: ${errText}`);
    }

    const data = await response.json();
    const embeddingValues = data.embedding?.values;

    if (!embeddingValues || !Array.isArray(embeddingValues) || embeddingValues.length !== 3072) {
      throw new Error(`Failed to retrieve valid 3072-dimension embedding values from Gemini. Got length: ${embeddingValues ? embeddingValues.length : 'null'}, raw: ${JSON.stringify(data)}`);
    }

    // 4. Save embedding values to the database
    const { error: updateErr } = await supabase
      .from('marketplace_listings')
      .update({ embedding: embeddingValues })
      .eq('id', listingId);

    if (updateErr) {
      throw new Error(`Failed to update listing embedding: ${updateErr.message}`);
    }

    return new Response(
      JSON.stringify({ success: true, message: "Embedding updated successfully!" }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error("Listing Embedding Generator Error:", error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
    )
  }
})
