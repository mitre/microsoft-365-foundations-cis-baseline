control 'microsoft-365-foundations-7.2.3' do
  title 'Ensure external content sharing is restricted'
  desc "The external sharing settings govern sharing for the organization overall. Each site has its own sharing setting that can be set independently, though it must be at the same or more restrictive setting as the organization.
        The new and existing guests option requires people who have received invitations to sign in with their work or school account (if their organization uses Microsoft 365) or a Microsoft account, or to provide a code to verify their identity. Users can share with guests already in your organization's directory, and they can send invitations to people who will be added to the directory if they sign in.
        The recommended state is New and existing guests or less permissive."

  desc 'check',
       "To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Locate the External sharing section.
        4. Under SharePoint, ensure the slider bar is set to New and existing guests or a less permissive level.
    To audit using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following cmdlet:
            Get-SPOTenant | fl SharingCapability
        3. Ensure SharingCapability is set to one of the following values:
            o Value1: ExternalUserSharingOnly
            o Value2: ExistingExternalUserSharingOnly
            o Value3: Disabled"

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Locate the External sharing section.
        4. Under SharePoint, move the slider bar to New and existing guests or a less permissive level.
            o OneDrive will also be moved to the same level and can never be more permissive than SharePoint.
    To remediate using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following cmdlet to establish the minimum recommended state: Set-SPOTenant -SharingCapability ExternalUserSharingOnly
    Note: Other acceptable values for this parameter that are more restrictive include: Disabled and ExistingExternalUserSharingOnly."

  desc 'rationale',
       "Forcing guest authentication on the organization's tenant enables the implementation of
        controls and oversight over external file sharing. When a guest is registered with the
        organization, they now have an identity which can be accounted for. This identity can
        also have other restrictions applied to it through group membership and conditional
        access rules."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['3.3'] }]
  tag default_value: 'Anyone (ExternalUserAndGuestSharing)'
  tag nist: ['AC-3', 'AC-5', 'AC-6', 'MP-2']

  ref 'https://learn.microsoft.com/en-US/sharepoint/turn-external-sharing-on-or-off?WT.mc_id=365AdminCSH_spo'
  ref 'https://learn.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenant?view=sharepoint-ps'

  acceptable_values = [
    'ExternalUserSharingOnly',
    'ExistingExternalUserSharingOnly',
    'Disabled'
  ]
  ensure_external_content_sharing_restricted_script = %{
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
	  (Get-PnPTenant).SharingCapability
  }
  powershell_output = powershell(ensure_external_content_sharing_restricted_script).stdout.strip
  describe 'Ensure the SharingCapability option for SharePoint' do
    subject { powershell_output }
    it 'is set to either ExternalUserSharingOnly, ExistingExternalUserSharingOnly, or Disabled' do
      expect(acceptable_values).to include(powershell_output)
    end
  end
end
