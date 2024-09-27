control 'microsoft-365-foundations-7.2.6' do
  title 'Ensure SharePoint external sharing is managed through domain whitelist/blacklists'
  desc 'Control sharing of documents to external domains by either blocking domains or only allowing sharing with specific named domains.'

  desc 'check',
       "To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Expand Policies then click Sharing.
        3. Expand More external sharing settings and confirm that Limit external sharing by domain is checked.
        4. Verify that an accurate list of allowed domains is listed.
    To audit using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService.
        2. Run the following PowerShell command:
            Get-SPOTenant | fl SharingDomainRestrictionMode,SharingAllowedDomainList
        3. Ensure that SharingDomainRestrictionMode is set to AllowList and SharingAllowedDomainList contains domains trusted by the organization for external sharing."

  desc 'fix',
       'To remediate using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint.
        2. Expand Policies then click Sharing.
        3. Expand More external sharing settings and check Limit external sharing by domain.
        4. Select Add domains to add a list of approved domains.
        5. Click Save at the bottom of the page.
    To remediate using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService.
        2. Run the following PowerShell command:
            Set-SPOTenant -SharingDomainRestrictionMode AllowList -SharingAllowedDomainList "domain1.com domain2.com"'

  desc 'rationale',
       'Attackers will often attempt to expose sensitive information to external entities through
        sharing, and restricting the domains that users can share documents with will reduce
        that surface area.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [
    { '8' => ['3.3'] },
    { '7' => ['13.4'] },
    { '7' => ['14.6'] }
  ]
  tag nist: ['AC-3', 'AC-5', 'AC-6', 'MP-2', 'CA-9', 'SC-7', 'AT-2']

  ensure_sharingdomainrestriction_set_to_allowlist_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $clientSecret = '#{input('client_secret')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $sharepoint_admin_url = '#{input('sharepoint_admin_url')}'
    import-module pnp.powershell
    $password = (ConvertTo-SecureString -AsPlainText $certificate_password -Force)
    Connect-PnPOnline -Url $sharepoint_admin_url -ClientId $client_id -CertificatePath $certificate_path -CertificatePassword $password  -Tenant $tenantid
	  (Get-PnPTenant).SharingDomainRestrictionMode
  }
  powershell_output_allowlist = powershell(ensure_sharingdomainrestriction_set_to_allowlist_script).stdout.strip
  describe 'Ensure the SharingDomainRestrictionMode option for SharePoint' do
    subject { powershell_output_allowlist }
    it 'is set to AllowList' do
      expect(subject).to eq('AllowList')
    end
  end

  trusted_domains = input('domains_trusted_by_organization')
  domain_pattern = trusted_domains.map { |domain| "'#{domain}'" }.join(', ')
  ensure_trusted_domains_allowed_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $clientSecret = '#{input('client_secret')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $sharepoint_admin_url = '#{input('sharepoint_admin_url')}'
    import-module pnp.powershell
    $password = (ConvertTo-SecureString -AsPlainText $certificate_password -Force)
    Connect-PnPOnline -Url $sharepoint_admin_url -ClientId $client_id -CertificatePath $certificate_path -CertificatePassword $password  -Tenant $tenantid
    $trustedDomains = @("trusted.com", "example.com", "secure.org")
    $domain_data = (Get-PnPTenant).SharingAllowedDomainList
    $trustedDomains = @(#{domain_pattern})
    $domainList = $domain_data -split ' '
    $untrustedDomains = $domainList | Where-Object { -not ($trustedDomains -contains $_) }
    if ($untrustedDomains.Count -gt 0) {
        Write-Output "Some domains are not in the list of trusted domains: $($untrustedDomains -join ', ')"
    }
  }
  powershell_output_domains = powershell(ensure_trusted_domains_allowed_script).stdout.strip
  describe 'Ensure the number of domains not trusted by the organization outputted by SharingAllowedDomainList option on SharePoint' do
    subject { powershell_output_domains }
    failure_message = "Failure: #{powershell_output_domains}"
    it 'is 0' do
      expect(subject).to be_empty, failure_message
    end
  end
end
