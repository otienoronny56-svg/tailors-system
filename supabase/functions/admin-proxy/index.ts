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
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      throw new Error('No authorization header')
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL') || "https://ouuhirckiavcvgqlpriw.supabase.co"
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
    
    if (!serviceRoleKey) {
      throw new Error('Supabase service role key is not configured')
    }

    // 1. Verify the caller using their auth token
    const anonClient = createClient(supabaseUrl, Deno.env.get('SUPABASE_ANON_KEY') ?? '')
    const { data: { user }, error: authErr } = await anonClient.auth.getUser(authHeader.replace('Bearer ', ''))
    
    if (authErr || !user) {
      throw new Error('Unauthorized request: Invalid token')
    }

    // 2. Initialize the admin client to do the actual work
    const adminClient = createClient(supabaseUrl, serviceRoleKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      }
    })

    // 3. Optional: Verify they are an admin or owner. 
    // We check their user profile role in the DB using the adminClient.
    const { data: callerProfile, error: profileErr } = await adminClient
      .from('user_profiles')
      .select('role')
      .eq('id', user.id)
      .single();

    if (profileErr || !callerProfile) {
      throw new Error('Could not verify user role');
    }

    if (callerProfile.role !== 'owner' && callerProfile.role !== 'admin') {
      throw new Error(`Unauthorized: Role '${callerProfile.role}' cannot perform admin actions`);
    }

    // 4. Parse request and execute
    const body = await req.json()
    const { action, payload } = body

    if (!action) {
      throw new Error('Missing action parameter')
    }

    let resultData = null;

    if (action === 'createUser') {
      const { data, error } = await adminClient.auth.admin.createUser(payload);
      if (error) throw new Error(error.message);
      resultData = data;
    } else if (action === 'deleteUser') {
      const { id } = payload;
      if (!id) throw new Error('Missing user id for deletion');
      const { data, error } = await adminClient.auth.admin.deleteUser(id);
      if (error) throw new Error(error.message);
      resultData = data;
    } else if (action === 'updateUserById') {
      const { id, ...updates } = payload;
      if (!id) throw new Error('Missing id for updateUserById');
      const { data, error } = await adminClient.auth.admin.updateUserById(id, updates);
      if (error) throw new Error(error.message);
      resultData = data;
    } else if (action === 'listUsers') {
      const { data, error } = await adminClient.auth.admin.listUsers();
      if (error) throw new Error(error.message);
      resultData = data;
    } else if (action === 'getUserById') {
      const { id } = payload;
      if (!id) throw new Error('Missing id for getUserById');
      const { data, error } = await adminClient.auth.admin.getUserById(id);
      if (error) throw new Error(error.message);
      resultData = data;
    } else {
      throw new Error(`Unknown action: ${action}`);
    }

    return new Response(
      JSON.stringify({ data: resultData }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
    )

  } catch (error) {
    console.error("Admin Proxy Error:", error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
    )
  }
})
