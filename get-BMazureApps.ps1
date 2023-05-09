# "get-BMazureApps.ps1"
# 14:51 09/05/2023
<#
Register an Application with a Secret and configure it with Read.All permissions.
Need to enter the GUID values of the TenantID, ClientID and ClientSecret from the Test tenant
Next step - prompt for them (look mynotes had the primary domain query)
To list the services available in your Azure Microsoft licensed product by using the `Get-MgSubscribedSku` cmdlet
#>
$ClientID = "****************************"
# $TenantID = "YOUR_TENANT_ID"
$TenantID = "*****************************"
# $ClientSecret = "YOUR_CLIENT_SECRET"
$ClientSecret = "************************************"

$Body = @{
    'tenant' = $TenantID
    'client_id' = $ClientID
    'scope' = 'https://graph.microsoft.com/.default'
    'client_secret' = $ClientSecret
    'grant_type' = 'client_credentials'
}

$Params = @{
    'Uri' = "https://login.microsoftonline.com/$TenantID/oauth2/v2.0/token"
    'Method' = 'Post'
    'Body' = $Body
    'ContentType' = 'application/x-www-form-urlencoded'
}

$AuthResponse = Invoke-RestMethod @Params

# Connect-MgGraph -AccessToken $AuthResponse.access_token

Connect-MgGraph -AccessToken $AuthResponse.access_token # -Scopes 'Organization.Read.All'
$allSKUs = Get-MgSubscribedSku -Property SkuPartNumber, ServicePlans
$allSKUs
start-sleep 5
$allSKUs | ForEach-Object {
    Write-Host "Service Plan:" $_.SkuPartNumber
    $_.ServicePlans | ForEach-Object {$_}
}
