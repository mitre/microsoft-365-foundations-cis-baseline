control 'microsoft-365-foundations-7.3.4' do
  title 'Ensure custom script execution is restricted on site collections'
  desc "This setting controls custom script execution on a particular site (previously called \"site collection\").
        Custom scripts can allow users to change the look, feel and behavior of sites and pages. Every script that runs in a SharePoint page (whether it's an HTML page in a document library or a JavaScript in a Script Editor Web Part) always runs in the context of the user visiting the page and the SharePoint application. This means:
            • Scripts have access to everything the user has access to.
            • Scripts can access content across several Microsoft 365 services and even beyond with Microsoft Graph integration.
        The recommended state is DenyAddAndCustomizePages set to $true."

  desc 'check',
       'To audit using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService.
        2. Run the following PowerShell command to show non-compliant results:
            Get-SPOSite | Where-Object { $_.DenyAddAndCustomizePages -eq "Disabled" ` -and $_.Url -notlike "*-my.sharepoint.com/" } | ft Title, Url, DenyAddAndCustomizePages
        3. Ensure the returned value is for DenyAddAndCustomizePages is Enabled for each site.
    Note: The property DenyAddAndCustomizePages cannot be set on the MySite host, which is displayed with a URL like https://tenant id-my.sharepoint.com/'

  desc 'fix',
       "To remediate using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService.
        2. Edit the below and run for each site as needf8ed:
            Set-SPOSite -Identity <SiteUrl> -DenyAddAndCustomizePages $true
        Note: The property DenyAddAndCustomizePages cannot be set on the MySite host, which is displayed with a URL like https://tenant id-my.sharepoint.com/"

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['2.7'] }]

  ref 'https://learn.microsoft.com/en-us/sharepoint/allow-or-prevent-custom-script'
  ref 'https://learn.microsoft.com/en-us/sharepoint/security-considerations-of-allowing-custom-script'
  ref 'https://learn.microsoft.com/en-us/powershell/module/sharepoint-online/set-sposite?view=sharepoint-ps'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
