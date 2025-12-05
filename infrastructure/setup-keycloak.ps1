# Wait for Keycloak to be ready
Write-Host "Waiting for Keycloak to be ready..."
$ready = $false
for ($i = 1; $i -le 30; $i++) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:9080/admin" -ErrorAction Stop
        Write-Host "Keycloak is ready!"
        $ready = $true
        break
    } catch {
        Write-Host "Attempt $i : Waiting for Keycloak..."
        Start-Sleep -Seconds 2
    }
}

if (-not $ready) {
    Write-Host "Keycloak failed to start. Exiting."
    exit 1
}

# Get admin token
Write-Host "Getting admin token..."
$tokenResponse = Invoke-RestMethod -Method POST `
    -Uri "http://localhost:9080/realms/master/protocol/openid-connect/token" `
    -Body @{
        client_id = "admin-cli"
        username = "admin"
        password = "admin"
        grant_type = "password"
    }

$ADMIN_TOKEN = $tokenResponse.access_token
Write-Host "Admin token obtained"

# Create realm
Write-Host "Creating realm 'planify'..."
try {
    Invoke-RestMethod -Method POST `
        -Uri "http://localhost:9080/admin/realms" `
        -Headers @{"Authorization" = "Bearer $ADMIN_TOKEN"; "Content-Type" = "application/json"} `
        -Body @{
            realm = "planify"
            enabled = $true
            displayName = "Planify"
            accessTokenLifespan = 3600
        } | ConvertTo-Json | Out-Null
    Write-Host "Realm created"
} catch {
    Write-Host "Realm might already exist: $($_.Exception.Message)"
}

# Create client for user-service
Write-Host "Creating client 'user-service'..."
$clientResponse = Invoke-RestMethod -Method POST `
    -Uri "http://localhost:9080/admin/realms/planify/clients" `
    -Headers @{"Authorization" = "Bearer $ADMIN_TOKEN"; "Content-Type" = "application/json"} `
    -Body @{
        clientId = "user-service"
        enabled = $true
        publicClient = $false
        directAccessGrantsEnabled = $true
        standardFlowEnabled = $true
        implicitFlowEnabled = $true
        serviceAccountsEnabled = $true
        validRedirectUris = @("http://localhost:8082/*")
        webOrigins = @("http://localhost:8082")
    } | ConvertTo-Json

$CLIENT_ID = ($clientResponse | ConvertFrom-Json).id
Write-Host "Client created with ID: $CLIENT_ID"

# Get client secret
Write-Host "Getting client secret..."
$secretResponse = Invoke-RestMethod -Method Get `
    -Uri "http://localhost:9080/admin/realms/planify/clients/$CLIENT_ID/client-secret" `
    -Headers @{"Authorization" = "Bearer $ADMIN_TOKEN"}

$CLIENT_SECRET = $secretResponse.value
Write-Host "Client secret obtained"

# Create a test user
Write-Host "Creating test user..."
try {
    Invoke-RestMethod -Method POST `
        -Uri "http://localhost:9080/admin/realms/planify/users" `
        -Headers @{"Authorization" = "Bearer $ADMIN_TOKEN"; "Content-Type" = "application/json"} `
        -Body @{
            username = "testuser"
            email = "testuser@example.com"
            firstName = "Test"
            lastName = "User"
            enabled = $true
            credentials = @(@{
                type = "password"
                value = "password123"
                temporary = $false
            })
        } | ConvertTo-Json | Out-Null
    Write-Host "Test user created (username: testuser, password: password123)"
} catch {
    Write-Host "User might already exist: $($_.Exception.Message)"
}

Write-Host ""
Write-Host "========================================"
Write-Host "Keycloak setup complete!"
Write-Host "========================================"
Write-Host "Keycloak URL: http://localhost:9080"
Write-Host "Admin Console: http://localhost:9080/admin"
Write-Host "Admin Credentials: admin / admin"
Write-Host "Realm: planify"
Write-Host "Client ID: user-service"
Write-Host "Client Secret: $CLIENT_SECRET"
Write-Host "Test User: testuser / password123"
Write-Host "========================================"
