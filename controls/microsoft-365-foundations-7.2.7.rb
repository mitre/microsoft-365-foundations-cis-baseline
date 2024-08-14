control 'microsoft-365-foundations-7.2.7' do
  title 'Ensure link sharing is restricted in SharePoint and OneDrive'
  desc "This setting sets the default link type that a user will see when sharing content in OneDrive or SharePoint. It does not restrict or exclude any other options.
        The recommended state is Specific people (only the people the user specifies)"

  desc 'check',
       "To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Scroll to File and folder links.
        4. Ensure that the setting Choose the type of link that's selected by default when users share files and folders in SharePoint and OneDrive is set to Specific people (only the people the user specifies)
    To audit using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService.
        2. Run the following PowerShell command:
            Get-SPOTenant | fl DefaultSharingLinkType
        3. Ensure the returned value is Direct."

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Scroll to File and folder links.
        4. Set Choose the type of link that's selected by default when users share files and folders in SharePoint and OneDrive to Specific people (only the people the user specifies)
    To remediate using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService.
        2. Run the following PowerShell command:
            Set-SPOTenant -DefaultSharingLinkType Direct"

  desc 'rationale',
       'By defaulting to specific people, the user will first need to consider whether or not the
        content being shared should be accessible by the entire organization versus select
        individuals. This aids in reinforcing the concept of least privilege.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['3.3'] }]
  tag default_value: 'Only people in your organization (Internal)'
  tag nist: ['AC-3', 'AC-5', 'AC-6', 'MP-2']

  ref 'https://learn.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenant?view=sharepoint-ps'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
