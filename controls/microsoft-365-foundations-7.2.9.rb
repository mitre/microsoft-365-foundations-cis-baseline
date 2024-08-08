control 'microsoft-365-foundations-7.2.9' do
    title 'Ensure guest access to a site or OneDrive will expire automatically'
    desc 'This policy setting configures the expiration time for each guest that is invited to the SharePoint site or with whom users share individual files and folders with.
        The recommended state is 30 or less.'
    
    desc 'check'
    'To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Scroll to and expand More external sharing settings.
        4. Ensure Guest access to a site or OneDrive will expire automatically after this many days is checked and set to 30 or less.
    To audit using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following cmdlet: 
            Get-SPOTenant | fl ExternalUserExpirationRequired,ExternalUserExpireInDays
        3. Ensure the following values are returned:
            o ExternalUserExpirationRequired is True.
            o ExternalUserExpireInDays is 30 or less.'
    
    desc 'fix'
    'To remediate using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Scroll to and expand More external sharing settings.
        4. Set Guest access to a site or OneDrive will expire automatically after this many days to 30
    To remediate using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following cmdlet: 
            Set-SPOTenant -ExternalUserExpireInDays 30 -ExternalUserExpirationRequired $True'
    
    impact 0.5
    tag severity: 'medium'

    ref 'https://learn.microsoft.com/en-US/sharepoint/turn-external-sharing-on-or-off?WT.mc_id=365AdminCSH_spo#change-the-organization-level-external-sharing-setting'
    ref 'https://learn.microsoft.com/en-us/microsoft-365/community/sharepoint-security-a-team-effort'
end
