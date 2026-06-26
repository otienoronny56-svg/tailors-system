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
    // 2. New User Registration — Welcome Emails
    else if (table === 'user_profiles' && (type === 'INSERT' || type === 'UPDATE')) {
      const newUserEmail = record.email;
      const newUserName = record.full_name || "there";
      const newUserRole = record.role;
      const domain = "https://tailors.co.ke";

      if (!newUserEmail) {
        return new Response(JSON.stringify({ message: "Ignored: No email on new user profile." }), { status: 200 });
      }

      // --- A: New Client Signup (only on INSERT) ---
      if (newUserRole === 'client' && type === 'INSERT') {
        clientEmail = newUserEmail;
        clientName = newUserName;
        emailSubject = `Welcome to Tailors.co.ke, ${newUserName}! 🎉`;
        emailHtml = `
          <div style="font-family: sans-serif; max-width: 600px; margin: auto;">
            <div style="background: #1e293b; padding: 24px; border-radius: 10px 10px 0 0; text-align:center;">
              <h1 style="color: #D4AF37; margin: 0;">Welcome to Tailors.co.ke!</h1>
            </div>
            <div style="background: #f8fafc; padding: 24px; border-radius: 0 0 10px 10px;">
              <p>Hi <strong>${newUserName}</strong>,</p>
              <p>Welcome aboard! Your account is all set up and ready to go. You can now browse our marketplace, inquire about listings, and track your orders — all in one place.</p>
              <a href="${domain}" style="display:inline-block; margin: 16px 0; padding:12px 24px; background-color:#1e293b; color:#D4AF37; text-decoration:none; border-radius:6px; font-weight:bold;">Explore the Marketplace →</a>
              <p style="color:#888; font-size:0.85em;">If you have any questions, just reply to this email or message a shop directly on the platform.</p>
              <p style="color:#888; font-size:0.85em;">— The Tailors.co.ke Team</p>
            </div>
          </div>`;

      // --- B: New Tailor / Shop Owner Registration ---
      // Trigger if it's an INSERT with status=Pending, OR an UPDATE where status changed to Pending
      } else if ((newUserRole === 'owner' || newUserRole === 'tailor') && record.status === 'Pending' && (!old_record || old_record.status !== 'Pending')) {
        const resendApiKey = Deno.env.get("RESEND_API_KEY");

        // 1. Send welcome email to the new tailor
        if (resendApiKey) {
          const tailorWelcomeHtml = `
            <div style="font-family: sans-serif; max-width: 600px; margin: auto;">
              <div style="background: #1e293b; padding: 24px; border-radius: 10px 10px 0 0; text-align:center;">
                <h1 style="color: #D4AF37; margin: 0;">Registration Received!</h1>
              </div>
              <div style="background: #f8fafc; padding: 24px; border-radius: 0 0 10px 10px;">
                <p>Hi <strong>${newUserName}</strong>,</p>
                <p>Thank you for registering your tailor shop on <strong>Tailors.co.ke</strong>! We've received your application and our team is currently reviewing it.</p>
                <p>You'll receive another email once your account has been <strong>approved</strong>. This usually takes less than 24 hours.</p>
                <p>In the meantime, if you have any questions, feel free to reach out to us.</p>
                <p style="color:#888; font-size:0.85em;">— The Tailors.co.ke Team</p>
              </div>
            </div>`;
          
          await fetch("https://api.resend.com/emails", {
            method: "POST",
            headers: { "Authorization": `Bearer ${resendApiKey}`, "Content-Type": "application/json" },
            body: JSON.stringify({
              from: "Tailors.co.ke <notifications@tailors.co.ke>",
              to: newUserEmail,
              subject: "Your Shop Registration is Under Review 🧵",
              html: tailorWelcomeHtml,
            }),
          });
          console.log(`Welcome email sent to new tailor: ${newUserEmail}`);
        }

        // 2. Also notify superadmins about the new pending tailor
        const { data: adminUsers } = await supabaseClient
          .from('user_profiles')
          .select('email')
          .eq('role', 'superadmin');

        if (adminUsers && adminUsers.length > 0 && resendApiKey) {
          const adminEmails = adminUsers.map(a => a.email).filter(Boolean);
          const adminHtml = `<h3>Hello Admin,</h3><p>A new tailor has registered and is awaiting approval.</p><ul><li><strong>Name:</strong> ${newUserName}</li><li><strong>Email:</strong> ${newUserEmail}</li></ul><p>Please log in to the admin dashboard to review.</p><a href="${domain}/views/admin/admin-dashboard.html" style="display:inline-block; padding:12px 20px; background-color:#1e293b; color:white; text-decoration:none; border-radius:6px;">Review in Dashboard →</a>`;

          if (adminEmails.length > 0) {
            await fetch("https://api.resend.com/emails", {
              method: "POST",
              headers: { "Authorization": `Bearer ${resendApiKey}`, "Content-Type": "application/json" },
              body: JSON.stringify({
                from: "Tailors.co.ke <notifications@tailors.co.ke>",
                to: adminEmails,
                subject: `New Tailor Registration: ${newUserName}`,
                html: adminHtml,
              }),
            });
            console.log(`Admin alert sent to superadmins: ${adminEmails.join(', ')}`);
          }
        }
        
        return new Response(JSON.stringify({ message: "Tailor welcome and admin alert emails sent." }), { status: 200 });

      // --- C: Tailor Approved (status changes from Pending to Active) ---
      } else if (type === 'UPDATE' && record.status === 'Active' && old_record && old_record.status === 'Pending' && (record.role === 'owner' || record.role === 'tailor')) {
        const domain = "https://tailors.co.ke";
        clientEmail = record.email;
        clientName = record.full_name || "there";
        emailSubject = `Your shop has been approved! 🎉`;
        emailHtml = `
          <div style="font-family: sans-serif; max-width: 600px; margin: auto;">
            <div style="background: #1e293b; padding: 24px; border-radius: 10px 10px 0 0; text-align:center;">
              <h1 style="color: #D4AF37; margin: 0;">You're Approved! 🎉</h1>
            </div>
            <div style="background: #f8fafc; padding: 24px; border-radius: 0 0 10px 10px;">
              <p>Hi <strong>${clientName}</strong>,</p>
              <p>Great news! Your tailor shop registration on <strong>Tailors.co.ke</strong> has been <strong style="color:#10b981;">approved</strong>. Your dashboard is now active and you can start receiving orders!</p>
              <a href="${domain}/views/admin/admin-dashboard.html" style="display:inline-block; margin: 16px 0; padding:12px 24px; background-color:#1e293b; color:#D4AF37; text-decoration:none; border-radius:6px; font-weight:bold;">Go to My Dashboard →</a>
              <p style="color:#888; font-size:0.85em;">— The Tailors.co.ke Team</p>
            </div>
          </div>`;
      } else {
        return new Response(JSON.stringify({ message: "Ignored: Role or status not handled for welcome email." }), { status: 200 });
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
        .select('full_name, email')
        .eq('id', record.sender_id)
        .single();
        
      const senderName = sender ? sender.full_name : "Someone";
      const domain = "https://tailors.co.ke";

      // SIMPLEST APPROACH: Look up the recipient directly by recipient_id on the message
      // This is 100% reliable — no need to guess owner/org relationships
      const { data: recipient } = await supabase
        .from('user_profiles')
        .select('email, full_name, role')
        .eq('id', record.recipient_id)
        .single();

      if (!recipient || !recipient.email) {
        console.log("Ignored: Could not find recipient profile for ID", record.recipient_id);
        return new Response(JSON.stringify({ message: "Ignored: Recipient not found." }), { status: 200 });
      }

      console.log(`Notifying recipient: ${recipient.email} (role: ${recipient.role})`);
      clientEmail = recipient.email;
      clientName = recipient.full_name || "There";

      // Determine the correct dashboard link based on who is being notified
      const isClientBeingNotified = recipient.role === 'client';
      const dashboardLink = isClientBeingNotified
        ? `${domain}/views/client/client-dashboard.html`
        : `${domain}/views/admin/admin-messages.html`;

      // Get shop name for the email body
      const { data: shopInfo } = await supabase
        .from('shops')
        .select('name')
        .eq('id', inquiry.shop_id)
        .single();
      const shopDisplayName = shopInfo ? shopInfo.name : "the tailor";

      const preview = (record.message_text || '').length > 50
        ? (record.message_text || '').substring(0, 50) + '...'
        : (record.message_text || '(media message)');

      textMessage = `New message from ${senderName}. Log in to reply.`;
      emailSubject = `New Message from ${senderName}`;
      emailHtml = `<h3>Hello ${clientName},</h3>
                   <p>You have received a new message from <strong>${senderName}</strong>.</p>
                   <p><em>"${preview}"</em></p>
                   <a href="${dashboardLink}" style="display:inline-block; padding:12px 20px; background-color:#1e293b; color:white; text-decoration:none; border-radius:6px; font-weight:bold;">View Message in Dashboard →</a>
                   <p style="color:#888; font-size:0.85em; margin-top:16px;">This notification was sent from ${shopDisplayName} via tailors.co.ke</p>`;
      
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
          from: "Tailors.co.ke <notifications@tailors.co.ke>",
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
