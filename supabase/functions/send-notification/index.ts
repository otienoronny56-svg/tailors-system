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

    // Only proceed if this is an order status update
    if (table !== 'orders' || type !== 'UPDATE') {
      return new Response(JSON.stringify({ message: "Ignored: Not an order update." }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      });
    }

    // Only send notification if the status actually changed
    if (record.status === old_record.status) {
       return new Response(JSON.stringify({ message: "Ignored: Status did not change." }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      });
    }

    const orderId = record.order_id || record.id;
    const newStatus = record.status;
    const clientPhone = record.customer_phone || record.phone_number;
    // Fallback to your testing email because Resend free tier requires a verified domain to send to arbitrary emails
    const clientEmail = record.customer_email || record.email || "otienoronny56@gmail.com"; 
    const clientName = record.customer_name || "Valued Customer";

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
    const textMessage = `Hello ${clientName}, this is an update regarding your order #${String(orderId).slice(0, 6)}. Your order status is now: ${statusText.toUpperCase()}. Thank you for choosing us!`;
    const emailSubject = `Order Update: #${String(orderId).slice(0, 6)}`;
    const emailHtml = `<h3>Hello ${clientName},</h3><p>Your order <strong>#${String(orderId).slice(0, 6)}</strong> status has been updated to: <strong style="color: #10b981;">${statusText.toUpperCase()}</strong>.</p><p>Thank you for choosing us!</p>`;

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
