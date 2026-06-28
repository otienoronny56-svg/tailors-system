/**
 * Tenant Admin Settings Logic
 * Handles Organization Renaming and User Credential updates
 */

document.addEventListener('DOMContentLoaded', () => {
    initSettingsPage();
});

async function initSettingsPage() {
    if (!window.supabase) {
        console.error("Supabase client not found.");
        return;
    }
    
    // Load current organization name
    await loadCurrentOrgName();
    
    // Set up form listeners
    document.getElementById('rename-org-form').addEventListener('submit', handleRenameOrg);
    document.getElementById('update-security-form').addEventListener('submit', handleSecurityUpdate);
}

async function loadCurrentOrgName() {
    try {
        const orgId = window.globals?.userProfile?.organization_id;
        if (!orgId) return;
        
        const { data, error } = await window.supabase
            .from('organizations')
            .select('name')
            .eq('id', orgId)
            .single();
            
        if (error) throw error;
        
        if (data && data.name) {
            document.getElementById('current-org-name').textContent = data.name;
        }
    } catch (e) {
        console.error("Error loading org name:", e);
    }
}

async function handleRenameOrg(e) {
    e.preventDefault();
    const newName = document.getElementById('new-org-name').value.trim();
    if (!newName) return;
    
    const submitBtn = document.getElementById('rename-org-btn');
    const msgDiv = document.getElementById('rename-org-msg');
    
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
    
    try {
        const orgId = window.globals?.userProfile?.organization_id;
        const currentName = document.getElementById('current-org-name').textContent;
        
        if (!orgId) throw new Error("Organization ID not found.");
        
        // 1. Update Organization
        const { error } = await window.supabase
            .from('organizations')
            .update({ name: newName })
            .eq('id', orgId);
            
        if (error) throw error;
        
        // 2. Log to audit_logs
        await window.supabase
            .from('audit_logs')
            .insert([{
                organization_id: orgId,
                action: 'RENAME_ORGANIZATION',
                details: {
                    old_name: currentName,
                    new_name: newName
                }
            }]);
            
        msgDiv.textContent = "Organization successfully renamed!";
        msgDiv.style.color = "#10b981";
        
        // Refresh display
        await loadCurrentOrgName();
        document.getElementById('new-org-name').value = '';
        
    } catch (error) {
        console.error("Failed to rename:", error);
        msgDiv.textContent = error.message;
        msgDiv.style.color = "#ef4444";
    } finally {
        submitBtn.disabled = false;
        submitBtn.innerHTML = '<i class="fas fa-save"></i> Save New Name';
        setTimeout(() => msgDiv.textContent = '', 4000);
    }
}

async function handleSecurityUpdate(e) {
    e.preventDefault();
    
    const newEmail = document.getElementById('new-email').value.trim();
    const newPassword = document.getElementById('new-password').value;
    
    if (!newEmail && !newPassword) {
        alert("Please enter a new email or password to update.");
        return;
    }
    
    const submitBtn = document.getElementById('update-security-btn');
    const msgDiv = document.getElementById('security-msg');
    
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
    
    try {
        const updates = {};
        if (newEmail) updates.email = newEmail;
        if (newPassword) updates.password = newPassword;
        
        const { data, error } = await window.supabase.auth.updateUser(updates);
        
        if (error) throw error;
        
        // Log to audit_logs
        const orgId = window.globals?.userProfile?.organization_id;
        if (orgId) {
            await window.supabase.from('audit_logs').insert([{
                organization_id: orgId,
                action: 'SECURITY_UPDATE',
                details: {
                    email_updated: !!newEmail,
                    password_updated: !!newPassword
                }
            }]);
        }
        
        let msg = "Security updated successfully!";
        if (newEmail) {
            msg += " Please check your new email for a confirmation link.";
        }
        
        msgDiv.textContent = msg;
        msgDiv.style.color = "#10b981";
        
        document.getElementById('new-email').value = '';
        document.getElementById('new-password').value = '';
        
    } catch (error) {
        console.error("Failed to update security:", error);
        msgDiv.textContent = error.message;
        msgDiv.style.color = "#ef4444";
    } finally {
        submitBtn.disabled = false;
        submitBtn.innerHTML = '<i class="fas fa-shield-alt"></i> Update Security Credentials';
    }
}
