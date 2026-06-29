import os
import glob

files_to_fix = [
    'views/admin/admin-inventory.html',
    'views/admin/admin-listings.html',
    'views/admin/admin-messages.html',
    'views/admin/admin-order-details.html',
    'views/manager/all-orders.html',
    'views/manager/expenses.html',
    'views/manager/manager-blog.html',
    'views/manager/manager-messages.html',
    'views/manager/order-details.html',
    'views/manager/order-form.html',
    'views/manager/shop.html',
    'views/superadmin/superadmin-blog.html',
    'views/superadmin/superadmin-users.html',
    'views/worker/worker-assignments.html'
]

toggle_btn = '''
                    <button onclick="toggleTheme()" class="top-right-theme-toggle" title="Toggle Dark Mode"
                        style="background: transparent; border: 1px solid var(--glass-border, #e2e8f0); color: var(--brand-slate, #475569); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; box-shadow: 0 2px 4px rgba(0,0,0,0.05); transition: all 0.2s; display: inline-flex; align-items: center; justify-content: center; font-size: 1.1em;"
                        onmouseover="this.style.background='var(--card-bg, #f8fafc)'; this.style.transform='translateY(-1px)'"
                        onmouseout="this.style.background='transparent'; this.style.transform='translateY(0)'">
                        <i class="fa-solid fa-moon theme-toggle-icon"></i>
                    </button>
'''

for file in files_to_fix:
    if not os.path.exists(file):
        continue
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()
        
    if 'toggleTheme()' in content or 'toggleDarkMode()' in content:
        continue
        
    header_start = content.find('<header')
    if header_start == -1:
        continue
    header_end = content.find('</header>', header_start)
    
    actions_div = content.find('top-header-actions', header_start, header_end)
    
    if actions_div != -1:
        div_end = content.find('>', actions_div)
        content = content[:div_end+1] + toggle_btn + content[div_end+1:]
    else:
        actions_block = f'''
                <div class="top-header-actions" style="display: flex; gap: 10px; align-items: center;">
{toggle_btn}
                </div>
'''
        content = content[:header_end] + actions_block + content[header_end:]
        
    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f'Added toggle to {file}')
