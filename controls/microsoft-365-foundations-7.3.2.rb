control 'microsoft-365-foundations-7.3.2' do
  title 'Ensure OneDrive sync is restricted for unmanaged devices'
  desc "Microsoft OneDrive allows users to sign in their cloud tenant account and begin syncing select folders or the entire contents of OneDrive to a local computer. By default, this includes any computer with OneDrive already installed, whether it is Azure Domain Joined or Active Directory Domain joined.
        The recommended state for this setting is Allow syncing only on computers joined to specific domains Enabled: Specify the AD domain GUID(s)"

  desc 'check',
       'To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click Settings followed by OneDrive - Sync
        3. Verify that Allow syncing only on computers joined to specific domains is checked.
        4. Verify that the Active Directory domain GUIDS are listed in the box.
            o Use the Get-ADDomain PowerShell command on the on-premises server to obtain the GUID for each on-premises domain.
    To audit using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService -Url https://tenant-admin.sharepoint.com, replacing "tenant" with the appropriate value.
        2. Run the following PowerShell command:
            Get-SPOTenantSyncClientRestriction | fl TenantRestrictionEnabled,AllowedDomainList
        3. Ensure TenantRestrictionEnabled is set to True and AllowedDomainList contains the trusted domains GUIDs from the on premises environment.'

  desc 'fix',
       'To remediate using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click Settings then select OneDrive - Sync.
        3. Check the Allow syncing only on computers joined to specific domains.
        4. Use the Get-ADDomain PowerShell command on the on-premises server to obtain the GUID for each on-premises domain.
        5. Click Save.
    To remediate using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService
        2. Run the following PowerShell command and provide the DomainGuids from the Get-AADomain command:
            Set-SPOTenantSyncClientRestriction -Enable -DomainGuids "786548DD-877B-4760-A749-6B1EFBC1190A; 877564FF-877B-4760-A749-6B1EFBC1190A"
        Note: Utilize the -BlockMacSync:$true parameter if you are not using conditional access to ensure Macs cannot sync.'

  desc 'rationale',
       'Unmanaged devices pose a risk, since their security cannot be verified through existing
        security policies, brokers or endpoint protection. Allowing users to sync data to these
        devices takes that data out of the control of the organization. This increases the risk of
        the data either being intentionally or accidentally leaked.
        Note: This setting is only applicable to Active Directory domains when operating in a
        hybrid configuration. It does not apply to Entra ID domains. If there are devices which
        are only Entra ID joined, consider using a Conditional Access Policy instead.'

  impact 0.5
  tag severity: 'medium'
  tag default_value: 'By default there are no restrictions applied to the syncing of OneDrive.
                      TenantRestrictionEnabled : False
                      AllowedDomainList : {}'
  tag cis_controls: [{ '8' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-US/sharepoint/allow-syncing-only-on-specific-domains?WT.mc_id=365AdminCSH_spo'
  ref 'https://learn.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenantsyncclientrestriction?view=sharepoint-ps'

  tenantrestrictionenabled_script = %{
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
	  (Get-PnPTenantSyncClientRestriction).TenantRestrictionEnabled
  }
  powershell_output_tenant = powershell(tenantrestrictionenabled_script).stdout.strip
  describe 'Ensure the TenantRestrictionEnabled option for SharePoint/OneDrive Sync' do
    subject { powershell_output_tenant }
    it 'is set to True' do
      expect(subject).to eq('True')
    end
  end

  trusted_domains = input('trusted_domains_guids')
  domain_pattern = trusted_domains.map { |domain| "'#{domain}'" }.join(', ')
  ensure_trusted_domains_guids = %{
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
    $allowedDomains = (Get-PnPTenant).AllowedDomainList
    $trustedDomains = @(#{domain_pattern})
    $domainList = $domain_data -split ' '
    $untrustedDomains = $allowedDomains | Where-Object { -not ($trustedDomains -contains $_) }
    if ($untrustedDomains.Count -gt 0) {
        Write-Output "Some domains are not in the list of trusted domains: $($untrustedDomains -join ', ')"
    }
  }
  powershell_output_domains = powershell(ensure_trusted_domains_guids).stdout.strip
  describe 'Ensure the number of domains GUIDs not trusted from AllowedDomainList option on SharePoint' do
    subject { powershell_output_domains }
    failure_message = "Failure: #{powershell_output_domains}"
    it 'is 0' do
      expect(subject).to be_empty, failure_message
    end
  end
end
