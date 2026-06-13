$URL = "https://nbksbimxyssfbgfxzcnc.supabase.co"
$KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ia3NiaW14eXNzZmJnZnh6Y25jIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjQ4MDEwMiwiZXhwIjoyMDgyMDU2MTAyfQ.K0ZYLQ5lMstENBkfO3jOKDSuTqReGaRJybinr_17CTE"

$headers = @{
    "apikey"        = $KEY
    "Authorization" = "Bearer $KEY"
    "Content-Type"  = "application/json"
}

$body = @{
    id        = "9dc3cdf6-608f-4caa-b0a0-a38eb2b04e91"
    full_name = "Shop Admin"
    role      = "owner"
    shop_id   = $null
} | ConvertTo-Json

Write-Host "Attempting to create profile for UID 9dc3cdf6..."
try {
    $response = Invoke-RestMethod -Uri "$URL/rest/v1/user_profiles" -Headers $headers -Method Post -Body $body -ErrorAction Stop
    Write-Host "✅ Profile created successfully!"
} catch {
    Write-Host "❌ Error creating profile: $_"
}
