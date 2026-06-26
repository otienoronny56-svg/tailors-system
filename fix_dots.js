const fs = require('fs');
const path = require('path');

function processFile(filePath, userType) {
    let content = fs.readFileSync(filePath, 'utf8');

    // 1. Inject the logic to count unread inquiries in loadInquiries
    const searchString1 = `                msgs.forEach(msg => {
                    // Find which unified group this message belongs to
                    const parentInq = unifiedInquiries.find(i => i.all_inquiry_ids.includes(msg.inquiry_id));
                    if (!parentInq) return;

                    if (!msg.is_read && msg.recipient_id === USER_PROFILE.id && !nuclearReadIds.includes(msg.id)) {
                        unreadMap[parentInq.id] = (unreadMap[parentInq.id] || 0) + 1;
                        totalUnread++;
                    }
                    if (!lastMsgMap[parentInq.id] || new Date(msg.created_at) > new Date(lastMsgMap[parentInq.id].created_at)) {
                        lastMsgMap[parentInq.id] = msg;
                    }
                });`;
    
    const replaceString1 = searchString1 + `

                // Add unread count for raw inquiries that have no messages yet
                unifiedInquiries.forEach(inq => {
                    if (!lastMsgMap[inq.id]) {
                        const isSent = inq.client_email === USER_PROFILE.email;
                        if (!isSent && !nuclearReadIds.includes('inq_' + inq.id)) {
                            unreadMap[inq.id] = (unreadMap[inq.id] || 0) + 1;
                            totalUnread++;
                        }
                    }
                });`;

    content = content.replace(searchString1, replaceString1);

    // 2. Modify fetchMessageLogs to clear the 'inq_' read flag
    const searchString2 = `                // Mark any unread messages as read
                const unreadIds = messages
                    .filter(m => m.recipient_id === USER_PROFILE.id && !m.is_read)
                    .map(m => m.id);
                
                if (unreadIds.length > 0) {
                    // Nuclear Frontend Bypass
                    const nuclearReadIds = JSON.parse(localStorage.getItem('tailors_nuclear_read_msgs_${userType}_' + USER_PROFILE.id) || '[]');
                    unreadIds.forEach(id => {
                        if (!nuclearReadIds.includes(id)) nuclearReadIds.push(id);
                    });
                    localStorage.setItem('tailors_nuclear_read_msgs_${userType}_' + USER_PROFILE.id, JSON.stringify(nuclearReadIds));

                    // update database
                    const { error: updateErr } = await supabaseClient.from('messages').update({ is_read: true }).in('id', unreadIds);
                    if (updateErr) console.error("Could not update read status:", updateErr);
                    
                    // mark local as read
                    messages.forEach(m => {
                        if (unreadIds.includes(m.id)) m.is_read = true;
                    });
                }`;

    const replaceString2 = `                // Mark any unread messages as read
                const unreadIds = messages
                    .filter(m => m.recipient_id === USER_PROFILE.id && !m.is_read)
                    .map(m => m.id);
                
                const nuclearReadIds = JSON.parse(localStorage.getItem('tailors_nuclear_read_msgs_${userType}_' + USER_PROFILE.id) || '[]');
                let hasNuclearChanges = false;
                
                if (!nuclearReadIds.includes('inq_' + threadContext.id)) {
                    nuclearReadIds.push('inq_' + threadContext.id);
                    hasNuclearChanges = true;
                }

                if (unreadIds.length > 0) {
                    unreadIds.forEach(id => {
                        if (!nuclearReadIds.includes(id)) {
                            nuclearReadIds.push(id);
                            hasNuclearChanges = true;
                        }
                    });

                    // update database
                    const { error: updateErr } = await supabaseClient.from('messages').update({ is_read: true }).in('id', unreadIds);
                    if (updateErr) console.error("Could not update read status:", updateErr);
                    
                    // mark local as read
                    messages.forEach(m => {
                        if (unreadIds.includes(m.id)) m.is_read = true;
                    });
                }
                
                if (hasNuclearChanges) {
                    localStorage.setItem('tailors_nuclear_read_msgs_${userType}_' + USER_PROFILE.id, JSON.stringify(nuclearReadIds));
                }`;

    content = content.replace(searchString2, replaceString2);
    
    fs.writeFileSync(filePath, content);
}

processFile('C:/Users/ronny/Desktop/tailors project/views/admin/admin-messages.html', 'admin');
processFile('C:/Users/ronny/Desktop/tailors project/views/manager/manager-messages.html', 'manager');
console.log('Fixed unread dots logic');
