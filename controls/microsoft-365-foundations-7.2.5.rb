control 'microsoft-365-foundations-7.2.5' do
    title "Ensure that SharePoint guest users cannot share items they don't own"
    desc 'SharePoint gives users the ability to share files, folders, and site collections. Internal users can share with external collaborators, and with the right permissions could share to other external parties.'
    
    desc 'check'
    "To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies then select Sharing.
        3. Expand More external sharing settings, verify that Allow guests to share items they don't own is unchecked.
    To audit using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following SharePoint Online PowerShell command: 
            Get-SPOTenant | ft PreventExternalUsersFromResharing
        3. Ensure the returned value is True."
    
    desc 'fix'
    "To remediate using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies then select Sharing.
        3. Expand More external sharing settings, uncheck Allow guests to share items they don't own.
        4. Click Save.
    To remediate using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following SharePoint Online PowerShell command: 
            Set-SPOTenant -PreventExternalUsersFromResharing $True"
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['3.3'] }, { '7' => ['14.6'] }]

    ref 'https://learn.microsoft.com/en-us/sharepoint/turn-external-sharing-on-or-off'
    ref 'https://learn.microsoft.com/en-us/sharepoint/external-sharing-overview'
