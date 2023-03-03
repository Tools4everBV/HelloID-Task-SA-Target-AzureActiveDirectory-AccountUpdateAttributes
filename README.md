
# HelloID-Task-SA-Target-AzureActiveDirectory-AccountUpdateAttributes

## Prerequisites

Before using this snippet, verify you've met with the following requirements:

- [ ] AzureAD app registration
- [ ] The correct app permissions for the app registration
- [ ] User defined variables: `AADTenantID`, `AADAppID` and `AADAppSecret` created in your HelloID portal.

## Description

This code snippet executes the following tasks:

1. Define a hash table `$formObject`. The keys of the hash table represent the properties necessary to create a new user within `Azure Active Directory`, while the values represent the values entered in the form.

> To view an example of the form output, please refer to the JSON code pasted below.

```json
{
    "id": "",
    "UserType": "",
    "DisplayName": "",
    "UserPrincipalName": "",
    "GivenName": "",
    "SurName": "",
    "Mail": "",
    "Department": "",
    "JobTitle": "",
    "MailNickName": "",
    "ShowInAddressList": "",
    "Password": "",
    "ForceChangePasswordNextSignIn": "",
    "AccountEnabled": ""
}
```

> :exclamation: It is important to note that the names of your form fields might differ. Ensure that the `$formObject` hashtable is appropriately adjusted to match your form fields.

2. Receive a bearer token by making a POST request to: `https://login.microsoftonline.com/$AADTenantID/oauth2/token`, where `$AADTenantID` is the ID of your Azure Active Directory tenant.

3. Update a user by using the: `Invoke-RestMethod` cmdlet. The hash table called: `$formObject` is passed to the body of the: `Invoke-RestMethod` cmdlet as a JSON object.

> Its important to note that this snippet handles a `Microsoft.PowerShell.Commands.HttpResponseException` which is only available when using the Service-Automation cloud agent. If you want to use the Service-Automation on-premises agent, make sure to change this to: `System.Net.WebException`.

