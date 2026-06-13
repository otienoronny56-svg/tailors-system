$URL = "https://nbksbimxyssfbgfxzcnc.supabase.co"
$KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ia3NiaW14eXNzZmJnZnh6Y25jIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjQ4MDEwMiwiZXhwIjoyMDgyMDU2MTAyfQ.K0ZYLQ5lMstENBkfO3jOKDSuTqReGaRJybinr_17CTE"

$headers = @{
    "apikey"        = $KEY
    "Authorization" = "Bearer $KEY"
}

Write-Host "--- 1. Fetching Auth Users ---"
try {
    $users = Invoke-RestMethod -Uri "$URL/auth/v1/admin/users" -Headers $headers -Method Get
    Write-Host ($users | ConvertTo-Json -Depth 5)
} catch {
    Write-Host "Error fetching users: $_"
}

Write-Host "`n--- 2. Fetching user_profiles ---"
try {
    $profiles = Invoke-RestMethod -Uri "$URL/rest/v1/user_profiles?select=*" -Headers $headers -Method Get
    Write-Host ($profiles | ConvertTo-Json -Depth 5)
} catch {
    Write-Host "Error fetching profiles: $_"
}

Write-Host "`n--- 3. Fetching workers ---"
try {
    $workers = Invoke-RestMethod -Uri "$URL/rest/v1/workers?select=*" -Headers $headers -Method Get
    Write-Host ($workers | ConvertTo-Json -Depth 5)
} catch {
    Write-Host "Error fetching workers: $_"
}
