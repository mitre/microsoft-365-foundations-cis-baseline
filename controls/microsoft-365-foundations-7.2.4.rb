control 'microsoft-365-foundations-7.2.4' do
    title 'Ensure OneDrive content sharing is restricted'
    desc 'This setting governs the global permissiveness of OneDrive content sharing in the organization.
        OneDrive content sharing can be restricted independent of SharePoint but can never be more permissive than the level established with SharePoint.
        The recommended state is Only people in your organization'

    desc 'check'
    'To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Locate the External sharing section.
        4. Under OneDrive, ensure the slider bar is set to Only people in your organization.
    To audit using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following cmdlet: 
            Get-SPOTenant | fl OneDriveSharingCapability
        3. Ensure the returned value is Disabled.
    Alternative audit method using PowerShell:
        1. Connect to SharePoint Online.
        2. Use one of the following methods: 
            # Replace [tenant] with your tenant id 
            Get-SPOSite -Identity https://[tenant]-my.sharepoint.com/ | fl Url,SharingCapability 
            # Or run this to filter to the specific site without supplying the tenant name. 
            $OneDriveSite = Get-SPOSite -Filter { Url -like "*-my.sharepoint.com/" } 
            Get-SPOSite -Identity $OneDriveSite | fl Url,SharingCapability
        2. Ensure the returned value for SharingCapability is Disabled
    Note: As of March 2024, using Get-SPOSite with Where-Object or filtering against the entire site and then returning the SharingCapability parameter can result in a different value as opposed to running the cmdlet specifically against the OneDrive specific site using the -Identity switch as shown in the example. 
    Note 2: The parameter OneDriveSharingCapability may not be yet fully available in all tenants. It is demonstrated in official Microsoft documentation as linked in the references section but not in the Set-SPOTenant cmdlet itself. If the parameter is unavailable, then either use the UI method or alternative PowerShell audit method.'

    desc 'fix'
    'To remediate using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Locate the External sharing section.
        4. Under OneDrive, set the slider bar to Only people in your organization.
    To remediate using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following cmdlet: Set-SPOTenant -OneDriveSharingCapability Disabled
    Alternative remediation method using PowerShell:
        1. Connect to SharePoint Online.
        2. Run one of the following: 
            # Replace [tenant] with your tenant id 
            Set-SPOSite -Identity https://[tenant]-my.sharepoint.com/ -SharingCapability Disabled 
            # Or run this to filter to the specific site without supplying the tenant name. 
            $OneDriveSite = Get-SPOSite -Filter { Url -like "*-my.sharepoint.com/" } 
            Set-SPOSite -Identity $OneDriveSite -SharingCapability Disabled'
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['3.3'] }]

    ref 'https://learn.microsoft.com/en-us/sharepoint/dev/embedded/concepts/app-concepts/sharing-and-perm#container-partition'
end
        