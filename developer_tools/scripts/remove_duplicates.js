const fs = require('fs');
const configContent = fs.readFileSync('../../js/core/config.js', 'utf8');
const keyMatch = configContent.match(/serviceRoleKey:\s*"([^"]+)"/);
const urlMatch = configContent.match(/supabaseUrl:\s*"([^"]+)"/);
const { createClient } = require('@supabase/supabase-js');
const supabase = createClient(urlMatch[1], keyMatch[1], { auth: { persistSession: false } });

async function removeDuplicates() {
    // Get all inquiries ordered by created_at
    const { data: inquiries, error } = await supabase
        .from('marketplace_inquiries')
        .select('id, client_email, shop_id, listing_id, created_at')
        .order('created_at', { ascending: true });

    if (error) { console.error('Error fetching inquiries:', error); return; }

    console.log(`Total inquiries: ${inquiries.length}`);

    // Group by client_email + shop_id + listing_id - keep FIRST (oldest), delete rest
    const seen = new Map();
    const toDelete = [];

    for (const inq of inquiries) {
        const key = `${inq.client_email}__${inq.shop_id}__${inq.listing_id}`;
        if (seen.has(key)) {
            toDelete.push(inq.id);
            console.log(`Duplicate found: ${inq.id} (${inq.client_email}) at ${inq.created_at}`);
        } else {
            seen.set(key, inq.id);
        }
    }

    if (toDelete.length === 0) {
        console.log('No duplicates found!');
        return;
    }

    console.log(`\nDeleting ${toDelete.length} duplicate(s): ${toDelete.join(', ')}`);
    const { error: delError } = await supabase
        .from('marketplace_inquiries')
        .delete()
        .in('id', toDelete);

    if (delError) {
        console.error('Error deleting duplicates:', delError);
    } else {
        console.log(`Successfully deleted ${toDelete.length} duplicate inquiry/inquiries!`);
    }
}

removeDuplicates();
