import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

// Utility for CORS
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const body = await req.json();
    console.log("🔔 Webhook Payload Received:", JSON.stringify(body, null, 2));
    
    // Webhook payload typically includes: { type, table, record, old_record }
    const { type, table, record, old_record } = body;

    let clientPhone = "";
    let clientEmail = "";
    let clientName = "";
    let textMessage = "";
    let emailSubject = "";
    let emailHtml = "";

    // Initialize Supabase Client for DB lookups
    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
    
    let supabase = null;
    if (supabaseUrl && supabaseServiceKey) {
        supabase = createClient(supabaseUrl, supabaseServiceKey);
    }

    // 1. Order Status Update
    if (table === 'orders' && type === 'UPDATE') {
      // Only send notification if the status actually changed
      if (record.status === old_record.status) {
         return new Response(JSON.stringify({ message: "Ignored: Status did not change." }), {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200,
        });
      }

      const orderId = record.order_id || record.id;
      const newStatus = record.status;
      clientPhone = record.customer_phone || record.phone_number;
      clientEmail = record.customer_email || record.email || "otienoronny56@gmail.com"; 
      clientName = record.customer_name || "Valued Customer";

      const STATUS_MAP: Record<number, string> = {
          1: 'Assigned',
          2: 'In Progress',
          3: 'QA Check',
          4: 'Ready',
          5: 'Collected',
          6: 'Closed'
      };
      
      const statusText = STATUS_MAP[Number(newStatus)] || String(newStatus);

      textMessage = `Hello ${clientName}, this is an update regarding your order #${String(orderId).slice(0, 6)}. Your order status is now: ${statusText.toUpperCase()}. Thank you for choosing us!`;
      emailSubject = `Order Update: #${String(orderId).slice(0, 6)}`;
      emailHtml = `<h3>Hello ${clientName},</h3><p>Your order <strong>#${String(orderId).slice(0, 6)}</strong> status has been updated to: <strong style="color: #10b981;">${statusText.toUpperCase()}</strong>.</p><p>Thank you for choosing us!</p>`;
    } 
    // 2. New Tailor Registration (Pending)
    else if (table === 'user_profiles' && (type === 'INSERT' || type === 'UPDATE')) {
      if (record.status === 'Pending' && (!old_record || old_record.status !== 'Pending') && (record.role === 'owner' || record.role === 'tailor')) {
          clientPhone = Deno.env.get("ADMIN_PHONE") || "+254712345678"; 
          clientEmail = Deno.env.get("ADMIN_EMAIL") || "otienoronny56@gmail.com"; 
          clientName = "System Administrator";

          const tailorName = record.full_name || "A new tailor";
          const tailorEmail = record.email || "No email provided";

          textMessage = `Admin Alert: A new tailor (${tailorName}) has registered and is awaiting approval. Please log in to review.`;
          emailSubject = `New Tailor Registration: ${tailorName}`;
          emailHtml = `<h3>Hello Admin,</h3><p>A new tailor has registered and is awaiting approval.</p><ul><li><strong>Name:</strong> ${tailorName}</li><li><strong>Email:</strong> ${tailorEmail}</li></ul><p>Please log in to the admin dashboard to review.</p>`;
      } else {
        return new Response(JSON.stringify({ message: "Ignored: Not a new pending tailor." }), {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200,
        });
      }
    } 
    // 3. Organization Suspension
    else if (table === 'organizations' && type === 'UPDATE') {
      if (record.subscription_status === 'Suspended' && (!old_record || old_record.subscription_status !== 'Suspended')) {
          clientPhone = record.phone || "";
          clientEmail = record.email || "otienoronny56@gmail.com"; 
          clientName = record.name || "Organization Owner";

          textMessage = `Alert: Your workspace "${clientName}" has been suspended. Please contact platform administration to reactivate your workspace.`;
          emailSubject = `Action Required: Workspace Suspended - ${clientName}`;
          emailHtml = `<h3>Hello,</h3><p>Your workspace/organization <strong>${clientName}</strong> has been suspended.</p><p>Please contact the system administrator to resolve this issue and reactivate your account.</p>`;
      } else {
        return new Response(JSON.stringify({ message: "Ignored: Not a suspension update." }), {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200,
        });
      }
    }
    // 4. NEW: Chat Message Notifications
    else if (table === 'messages' && type === 'INSERT') {
      if (!supabase) {
        throw new Error("Supabase client not initialized for messages lookup");
      }

      // Fetch the inquiry to get client and shop info
      const { data: inquiry } = await supabase
        .from('marketplace_inquiries')
        .select('*')
        .eq('id', record.inquiry_id)
        .single();
        
      if (!inquiry) {
         console.log("Ignored: Inquiry not found for ID", record.inquiry_id);
         return new Response(JSON.stringify({ message: "Ignored: Inquiry not found." }), { status: 200 });
      }

      // Get the sender's details
      const { data: sender } = await supabase
        .from('user_profiles')
        .select('*')
        .eq('id', record.sender_id)
        .single();
        
      const senderName = sender ? sender.full_name : "Someone";
      const domain = "https://tailors.co.ke";

      // If sender is the client, notify the shop owner
      if (record.sender_id === inquiry.client_user_id || inquiry.client_email === sender?.email) {
        // Find the owner of the shop
        const { data: shop } = await supabase
          .from('shops')
          .select('organization_id, name')
          .eq('id', inquiry.shop_id)
          .single();
          
        if (shop) {
           const { data: owner } = await supabase
             .from('user_profiles')
             .select('email, full_name, phone')
             .eq('organization_id', shop.organization_id)
             .eq('role', 'owner')
             .single();
             
           if (owner) {
             clientEmail = owner.email || "otienoronny56@gmail.com";
             clientName = owner.full_name || "Admin";
             clientPhone = owner.phone || "";
             console.log(`Notifying shop owner: ${clientEmail}`);
             
             textMessage = `New message from ${senderName} regarding an inquiry. Log in to your dashboard to reply.`;
             emailSubject = `New Message from ${senderName}`;
             emailHtml = `<h3>Hello ${clientName},</h3>
                          <p>You have received a new message from <strong>${senderName}</strong>.</p>
                          <p><em>"${(record.message_text || '').length > 50 ? (record.message_text || '').substring(0, 50) + '...' : (record.message_text || '')}"</em></p>
                          <a href="${domain}/views/admin/admin-messages.html" style="display:inline-block; padding:10px 15px; background-color:#1e293b; color:white; text-decoration:none; border-radius:5px;">View Message in Dashboard</a>`;
           } else {
             console.log("Could not find shop owner for org:", shop.organization_id);
           }
        } else {
          console.log("Could not find shop:", inquiry.shop_id);
        }
      } 
      // If sender is NOT the client (meaning it's the admin/manager), notify the client
      else {
         // Use client_email directly from the inquiry record
         const clientEmailFromInquiry = inquiry.client_email;
         const clientNameFromInquiry = inquiry.client_name || "Valued Client";
         
         if (clientEmailFromInquiry) {
           clientEmail = clientEmailFromInquiry;
           clientName = clientNameFromInquiry;
           console.log(`Notifying client: ${clientEmail}`);
           
           // Find shop name
           const { data: shopInfo } = await supabase
             .from('shops')
             .select('name')
             .eq('id', inquiry.shop_id)
             .single();
             
           const shopDisplayName = shopInfo ? shopInfo.name : "Your Tailor";
           
           textMessage = `New message from ${shopDisplayName}. Log in to your dashboard to reply.`;
           emailSubject = `New Message from ${shopDisplayName}`;
           emailHtml = `<h3>Hello ${clientName},</h3>
                        <p>You have received a new message from <strong>${shopDisplayName}</strong> regarding your inquiry.</p>
                        <p><em>"${(record.message_text || '').length > 50 ? (record.message_text || '').substring(0, 50) + '...' : (record.message_text || '')}"</em></p>
                        <a href="${domain}/views/client/client-dashboard.html" style="display:inline-block; padding:10px 15px; background-color:#1e293b; color:white; text-decoration:none; border-radius:5px;">View Message in Dashboard</a>`;
         } else {
           console.log("No client email found on inquiry:", inquiry.id);
         }
      }
      
      // If we didn't find anyone to notify, just exit
      if (!clientEmail) {
         console.log("Ignored: Could not determine recipient email.");
         return new Response(JSON.stringify({ message: "Ignored: Could not determine recipient email." }), { status: 200 });
      }
      console.log(`Determined recipient email: ${clientEmail} (Name: ${clientName})`);
    }
    // Other unsupported triggers
    else {
      return new Response(JSON.stringify({ message: "Ignored: Unsupported event." }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      });
    }

    const results = [];

    // 1. Send SMS via Twilio
    const twilioSid = Deno.env.get("TWILIO_ACCOUNT_SID");
    const twilioAuth = Deno.env.get("TWILIO_AUTH_TOKEN");
    const twilioPhone = Deno.env.get("TWILIO_PHONE_NUMBER");

    if (twilioSid && twilioAuth && twilioPhone && clientPhone) {
      // Format phone number to E.164 (Assuming Kenya +254 for numbers starting with 07 or 01)
      let formattedPhone = clientPhone.trim();
      if (formattedPhone.startsWith('0')) {
          formattedPhone = '+254' + formattedPhone.slice(1);
      } else if (!formattedPhone.startsWith('+')) {
          formattedPhone = '+' + formattedPhone;
      }

      const twilioUrl = `https://api.twilio.com/2010-04-01/Accounts/${twilioSid}/Messages.json`;
      const smsBody = new URLSearchParams({
        To: formattedPhone,
        From: twilioPhone,
        Body: textMessage
      });

      const smsRes = await fetch(twilioUrl, {
        method: "POST",
        headers: {
          "Authorization": `Basic ${btoa(`${twilioSid}:${twilioAuth}`)}`,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: smsBody.toString(),
      });
      
      const responseText = await smsRes.text();
      console.log(`Twilio Response: ${smsRes.status} - ${responseText}`);
      results.push({ channel: "SMS", status: smsRes.status, ok: smsRes.ok, response: responseText });
    }

    // 2. Send Email via Resend
    const resendApiKey = Deno.env.get("RESEND_API_KEY");
    if (resendApiKey && clientEmail) {
      const emailRes = await fetch("https://api.resend.com/emails", {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${resendApiKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          from: "onboarding@resend.dev", // Uses Resend's default test email
          to: clientEmail,
          subject: emailSubject,
          html: emailHtml,
        }),
      });
      const resendResponseText = await emailRes.text();
      console.log(`Email Send Attempt to ${clientEmail}: Status ${emailRes.status}, Response: ${resendResponseText}`);
      results.push({ channel: "Email", status: emailRes.status, ok: emailRes.ok, response: resendResponseText });
    }

    return new Response(JSON.stringify({ success: true, results }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    });

  } catch (error) {
    console.error("Webhook Execution Error:", error);
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    });
  }
});
