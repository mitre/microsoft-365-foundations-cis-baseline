control 'microsoft-365-foundations-7.2.1' do
    title 'Ensure modern authentication for SharePoint applications is required'
    desc 'Modern authentication in Microsoft 365 enables authentication features like multifactor authentication (MFA) using smart cards, certificate-based authentication (CBA), and third-party SAML identity providers.'

    desc 'check'
    "To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint.
        2. Click to expand Policies select Access control.
        3. Select Apps that don't use modern authentication and ensure that it is set to Block access.
    To audit using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService -Url https://tenant-admin.sharepoint.com replacing tenant with your value.
        2. Run the following SharePoint Online PowerShell command: 
            Get-SPOTenant | ft LegacyAuthProtocolsEnabled
        3. Ensure the returned value is False."

    desc 'fix'
    "To remediate using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint.
        2. Click to expand Policies select Access control.
        3. Select Apps that don't use modern authentication.
        4. Select the radio button for Block access.
        5. Click Save.
    To remediate using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService -Url https://tenant-admin.sharepoint.com replacing tenant with your value.
        2. Run the following SharePoint Online PowerShell command: 
            Set-SPOTenant -LegacyAuthProtocolsEnabled $false"
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['3.10'] }, { '7' => ['16.3'] }]

    ref 'https://learn.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenant?view=sharepoint-ps'
end
    