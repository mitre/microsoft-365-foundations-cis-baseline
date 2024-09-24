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

  ensure_link_sharing_restricted_spo_od_script = %{
    $appName = 'cisBenchmarkL512'
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $clientSecret = '#{input('client_secret')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $sharepoint_admin_url = '#{input('sharepoint_admin_url')}'
    import-module pnp.powershell
    $password = (ConvertTo-SecureString -AsPlainText $certificate_password -Force)
    Connect-PnPOnline -Url $sharepoint_admin_url -ClientId $client_id -CertificatePath $certificate_path -CertificatePassword $password  -Tenant $tenantid
	  (Get-PnPTenant).DefaultSharingLinkType
  }
  powershell_output = powershell(ensure_link_sharing_restricted_spo_od_script).stdout.strip
  describe 'Ensure the DefaultSharingLinkType option for SharePoint' do
    subject { powershell_output }
    it 'is set to Direct' do
      expect(subject).to eq('Direct')
    end
  end
end
