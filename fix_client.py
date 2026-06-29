import re
file = 'views/manager/clients.html'
with open(file, 'r', encoding='utf-8') as f:
    content = f.read()

changed = False

header_start = content.find('<header')
if header_start != -1:
    header_end = content.find('</header>', header_start)
    
    h1_start = content.find('<h1', header_start, header_end)
    if h1_start != -1:
        h1_tag_end = content.find('>', h1_start)
        h1_tag = content[h1_start:h1_tag_end+1]
        
        if 'dashboard-main-title' not in h1_tag:
            if 'class="' in h1_tag:
                new_h1 = h1_tag.replace('class="', 'class="dashboard-main-title ', 1)
            else:
                new_h1 = h1_tag.replace('<h1', '<h1 class="dashboard-main-title"', 1)
            content = content[:h1_start] + new_h1 + content[h1_tag_end+1:]
            header_end += len(new_h1) - len(h1_tag)
            changed = True
            
    toggle_idx = content.find('toggleTheme()', header_start, header_end)
    if toggle_idx == -1:
        toggle_idx = content.find('handleLogout()', header_start, header_end)
        
    if toggle_idx != -1:
        div_start = content.rfind('<div', header_start, toggle_idx)
        if div_start != -1:
            div_tag_end = content.find('>', div_start)
            div_tag = content[div_start:div_tag_end+1]
            if 'top-header-actions' not in div_tag:
                if 'class="' in div_tag:
                    new_div = div_tag.replace('class="', 'class="top-header-actions ', 1)
                else:
                    new_div = div_tag.replace('<div', '<div class="top-header-actions"', 1)
                content = content[:div_start] + new_div + content[div_tag_end+1:]
                changed = True

if changed:
    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)
    print('Fixed manager/clients.html')
