import os
import re

files_to_fix = [
    'views/admin/admin-analytics.html',
    'views/admin/admin-expenses.html',
    'views/admin/admin-transactions.html',
    'views/admin/financial-overview.html'
]

for file in files_to_fix:
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # We want to remove the <button ... onclick="toggleDarkMode()" ... >...</button>
    # The regex approach: find <button[^>]*onclick="toggleDarkMode()"[\s\S]*?</button>
    new_content = re.sub(r'<button[^>]*onclick="toggleDarkMode\(\)"[\s\S]*?</button>', '', content)
    
    # And optionally remove the comment <!-- Dark Mode Toggle -->
    new_content = new_content.replace('<!-- Dark Mode Toggle -->', '')
    
    with open(file, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print(f'Removed dup toggle from {file}')
