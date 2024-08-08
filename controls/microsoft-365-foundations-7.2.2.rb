control 'microsoft-365-foundations-7.2.2' do
    title 'Ensure SharePoint and OneDrive integration with Azure AD B2B is enabled'
    desc "Entra ID B2B provides authentication and management of guests. Authentication happens via one-time passcode when they don't already have a work or school account or a Microsoft account. Integration with SharePoint and OneDrive allows for more granular control of how guest user accounts are managed in the organization's AAD, unifying a similar guest experience already deployed in other Microsoft 365 services such as Teams.
        Note: Global Reader role currently can't access SharePoint using PowerShell."

    desc 'check'
    'To audit using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService
        2. Run the following command: 
            Get-SPOTenant | ft EnableAzureADB2BIntegration
        3. Ensure the returned value is True.'
    
    desc 'fix'
    'To remediate using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService
        2. Run the following command: 
            Set-SPOTenant -EnableAzureADB2BIntegration $true'
    
    impact 0.5
    tag severity: 'medium'

    ref 'https://learn.microsoft.com/en-us/sharepoint/sharepoint-azureb2b-integration#enabling-the-integration'
    ref 'https://learn.microsoft.com/en-us/azure/active-directory/external-identities/what-is-b2b'
    ref 'https://learn.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenant?view=sharepoint-ps'
end

    