import os
import glob
import re

files_to_fix = [
    'views/admin/admin-inventory.html',
    'views/admin/admin-listings.html',
    'views/manager/manager-inventory.html',
    'views/manager/manager-listings.html'
]

for file in files_to_fix:
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    header_start = content.find('<header')
    header_end = content.find('</header>', header_start)
    
    if header_start != -1 and header_end != -1:
        # Find the div containing the buttons (usually has style="display: flex; gap: 10px...")
        # Let's search for '<div style="display: flex; gap: 10px; align-items: center;">'
        div_start = content.find('<div style="display: flex; gap: 10px; align-items: center;">', header_start, header_end)
        if div_start != -1:
            div_tag = '<div style="display: flex; gap: 10px; align-items: center;">'
            new_div = '<div class="top-header-actions" style="display: flex; gap: 10px; align-items: center;">'
            content = content[:div_start] + new_div + content[div_start + len(div_tag):]
            
            with open(file, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f'Fixed {file}')
        else:
            print(f'Div not found in {file}')
