control 'microsoft-365-foundations-7.2.1' do
  title 'Ensure modern authentication for SharePoint applications is required'
  desc 'Modern authentication in Microsoft 365 enables authentication features like multifactor authentication (MFA) using smart cards, certificate-based authentication (CBA), and third-party SAML identity providers.'

  desc 'check',
       "To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint.
        2. Click to expand Policies select Access control.
        3. Select Apps that don't use modern authentication and ensure that it is set to Block access.
    To audit using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService -Url https://tenant-admin.sharepoint.com replacing tenant with your value.
        2. Run the following SharePoint Online PowerShell command:
            Get-SPOTenant | ft LegacyAuthProtocolsEnabled
        3. Ensure the returned value is False."

  desc 'fix',
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

  desc 'rationale',
       'Strong authentication controls, such as the use of multifactor authentication, may be
        circumvented if basic authentication is used by SharePoint applications. Requiring
        modern authentication for SharePoint applications ensures strong authentication
        mechanisms are used when establishing sessions between these applications,
        SharePoint, and connecting users.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['3.10'] }, { '7' => ['16.3'] }]
  tag default_value: "True (Apps that don't use modern authentication are allowed)"
  tag nist: ['AC-17(2)', 'IA-5', 'IA-5(1)', 'SC-8', 'SC-8(1)', 'SI-2']

  ref 'https://learn.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenant?view=sharepoint-ps'

  ensure_modern_authentication_spo_applications_required_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $clientSecret = '#{input('client_secret')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $sharepoint_admin_url = '#{input('sharepoint_admin_url')}'
    import-module pnp.powershell
    $password = (ConvertTo-SecureString -AsPlainText $certificate_password -Force)
    Connect-PnPOnline -Url $sharepoint_admin_url -ClientId $client_id -CertificatePath $certificate_path -CertificatePassword $password  -Tenant $tenantid
	(Get-PnPTenant).LegacyAuthProtocolsEnabled
  }
  powershell_output = powershell(ensure_modern_authentication_spo_applications_required_script).stdout.strip
  describe 'Ensure the LegacyAuthProtocolsEnabled option for SharePoint' do
    subject { powershell_output }
    it 'is set to False' do
      expect(subject).to eq('False')
    end
  end
end
