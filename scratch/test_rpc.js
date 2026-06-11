const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
    "https://ouuhirckiavcvgqlpriw.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA"
);

async function run() {
    console.log("Checking if RPC functions exist...");
    
    // Call the RPC with a test inquiry ID
    const testInquiryId = "9138a931-505d-4574-8897-5115f89c3c7a";
    const { data, error } = await supabase.rpc('sync_client_measurements', {
        p_inquiry_id: testInquiryId,
        p_garment_type: 'Shirt',
        p_measurements: {
            "Shirt": {
                "Shoulder": "15",
                "Chest": "38",
                "Length": "28"
            }
        }
    });

    if (error) {
        console.error("RPC execution error:", error);
    } else {
        console.log("RPC executed successfully! Result client ID:", data);
    }
}

run();
