# HelloID-Task-SA-Target-AzureActiveDirectory-AccountUpdateAttributes
#####################################################################
# Form mapping
$formObject = @{
    userType          = $form.UserType
    displayName       = $form.DisplayName
    userPrincipalName = $form.UserPrincipalName
    givenName         = $form.GivenName
    surName           = $form.SurName
    mail              = $form.Mail
    department        = $form.Department
    jobTitle          = $form.JobTitle
    companyName       = $form.CompanyName
    mailNickName      = $form.MailNickName
    showInAddressList = [bool]$form.ShowInAddressList
}

try {
    Write-Information "Executing AzureActiveDirectory action: [UpdateAccount] for: [$($formObject.UserPrincipalName)]"
    Write-Information "Retrieving Microsoft Graph AccessToken for tenant: [$AADTenantID]"
    $splatTokenParams = @{
        Uri         = "https://login.microsoftonline.com/$AADTenantID/oauth2/token"
        ContentType = 'application/x-www-form-urlencoded'
        Method      = 'POST'
        Verbose     = $false
        Body = @{
            grant_type    = 'client_credentials'
            client_id     = $AADAppID
            client_secret = $AADAppSecret
            resource      = 'https://graph.microsoft.com'
        }
    }
    $accessToken = (Invoke-RestMethod @splatTokenParams).access_token

    $accountBody = @{}
    foreach ($key in $formObject.Keys) {
        if ($formObject[$key] -ne "") {
            $accountBody[$key] = $formObject[$key]
        }
    }

    $splatCreateUserParams = @{
        Uri     = "https://graph.microsoft.com/v1.0/users/$($formObject.userPrincipalName)"
        Method  = 'PATCH'
        Body    = $accountBody | ConvertTo-Json -Depth 10
        Verbose = $false
        Headers = @{
            Authorization  = "Bearer $accessToken"
            Accept         = 'application/json'
            'Content-Type' = 'application/json'
        }
    }
    $null = Invoke-RestMethod @splatCreateUserParams
    $auditLog = @{
        Action            = 'UpdateAccount'
        System            = 'AzureActiveDirectory'
        TargetIdentifier  = $form.userIdentity
        TargetDisplayName = $formObject.userPrincipalName
        Message           = "AzureActiveDirectory action: [UpdateAccount] for: [$($formObject.UserPrincipalName)] executed successfully"
        IsError           = $false
    }
    Write-Information -Tags 'Audit' -MessageData $auditLog
    Write-Information "AzureActiveDirectory action: [UpdateAccount] for: [$($formObject.UserPrincipalName)] executed successfully"
} catch {
    $ex = $_
    $auditLog = @{
        Action            = 'UpdateAccount'
        System            = 'AzureActiveDirectory'
        TargetIdentifier  = ''
        TargetDisplayName = $formObject.userPrincipalName
        Message           = "Could not execute AzureActiveDirectory action: [UpdateAccount] for: [$($formObject.UserPrincipalName)], error: $($ex.Exception.Message)"
        IsError           = $true
    }
    if ($($ex.Exception.GetType().FullName -eq 'Microsoft.PowerShell.Commands.HttpResponseException')){
        $auditLog.Message = "Could not execute AzureActiveDirectory action: [UpdateAccount] for: [$($formObject.UserPrincipalName)]"
        Write-Error "Could not execute AzureActiveDirectory action: [UpdateAccount] for: [$($formObject.UserPrincipalName)], error: $($ex.ErrorDetails)"
    }
    Write-Information -Tags "Audit" -MessageData $auditLog
    Write-Error "Could not execute AzureActiveDirectory action: [UpdateAccount] for: [$($formObject.UserPrincipalName)], error: $($ex.Exception.Message)"
}
#####################################################################
