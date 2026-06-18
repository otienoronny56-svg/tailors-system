import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

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
      // Fallback to your testing email because Resend free tier requires a verified domain to send to arbitrary emails
      clientEmail = record.customer_email || record.email || "otienoronny56@gmail.com"; 
      clientName = record.customer_name || "Valued Customer";

      const STATUS_MAP: Record<number, string> = {
          1: 'In Progress',
          2: 'Fitting',
          3: 'Ready',
          4: 'Completed',
          5: 'Cancelled'
      };
      
      // Fallback to the raw value if not found in the map
      const statusText = STATUS_MAP[Number(newStatus)] || String(newStatus);

      // Prepare Notification Message
      textMessage = `Hello ${clientName}, this is an update regarding your order #${String(orderId).slice(0, 6)}. Your order status is now: ${statusText.toUpperCase()}. Thank you for choosing us!`;
      emailSubject = `Order Update: #${String(orderId).slice(0, 6)}`;
      emailHtml = `<h3>Hello ${clientName},</h3><p>Your order <strong>#${String(orderId).slice(0, 6)}</strong> status has been updated to: <strong style="color: #10b981;">${statusText.toUpperCase()}</strong>.</p><p>Thank you for choosing us!</p>`;
    } 
    // 2. New Tailor Registration (Pending)
    else if (table === 'user_profiles' && (type === 'INSERT' || type === 'UPDATE')) {
      if (record.status === 'Pending' && (!old_record || old_record.status !== 'Pending') && (record.role === 'owner' || record.role === 'tailor')) {
          clientPhone = Deno.env.get("ADMIN_PHONE") || "+254712345678"; // Admin's phone number
          clientEmail = Deno.env.get("ADMIN_EMAIL") || "otienoronny56@gmail.com"; // Admin's email
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
          from: "onboarding@resend.dev", // Uses Resend's default test email (Can only send to the email you used to register Resend)
          to: clientEmail,
          subject: emailSubject,
          html: emailHtml,
        }),
      });
      results.push({ channel: "Email", status: emailRes.status, ok: emailRes.ok });
    }

    return new Response(JSON.stringify({ success: true, results }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    });

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    });
  }
});
