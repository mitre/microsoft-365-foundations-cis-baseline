control 'microsoft-365-foundations-7.2.2' do
  title 'Ensure SharePoint and OneDrive integration with Azure AD B2B is enabled'
  desc "Entra ID B2B provides authentication and management of guests. Authentication happens via one-time passcode when they don't already have a work or school account or a Microsoft account. Integration with SharePoint and OneDrive allows for more granular control of how guest user accounts are managed in the organization's AAD, unifying a similar guest experience already deployed in other Microsoft 365 services such as Teams.
        Note: Global Reader role currently can't access SharePoint using PowerShell."

  desc 'check',
       "To audit using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService
        2. Run the following command:
            Get-SPOTenant | ft EnableAzureADB2BIntegration
        3. Ensure the returned value is True."

  desc 'fix',
       "To remediate using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService
        2. Run the following command:
            Set-SPOTenant -EnableAzureADB2BIntegration $true"

  desc 'rationale',
       "External users assigned guest accounts will be subject to Entra ID access policies, such
        as multi-factor authentication. This provides a way to manage guest identities and
        control access to SharePoint and OneDrive resources. Without this integration, files can
        be shared without account registration, making it more challenging to audit and manage
        who has access to the organization's data."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-us/sharepoint/sharepoint-azureb2b-integration#enabling-the-integration'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/external-identities/what-is-b2b'
  ref 'https://learn.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenant?view=sharepoint-ps'

  ensure_spo_od_integration_with_azure_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $clientSecret = '#{input('client_secret')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $sharepoint_admin_url = '#{input('sharepoint_admin_url')}'
    import-module pnp.powershell
    $password = (ConvertTo-SecureString -AsPlainText $certificate_password -Force)
    Connect-PnPOnline -Url $sharepoint_admin_url -ClientId $client_id -CertificatePath $certificate_path -CertificatePassword $password  -Tenant $tenantid
	  (Get-PnPTenant).EnableAzureADB2BIntegration
  }
  powershell_output = powershell(ensure_spo_od_integration_with_azure_script).stdout.strip
  describe 'Ensure the EnableAzureADB2BIntegration option for SharePoint' do
    subject { powershell_output }
    it 'is set to True' do
      expect(subject).to eq('True')
    end
  end
end
