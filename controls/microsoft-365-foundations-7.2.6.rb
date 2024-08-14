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
  tag default_value: 'Limit external sharing by domain is unchecked
                      SharingDomainRestrictionMode: None
                      SharingDomainRestrictionMode: <Undefined>'
  tag nist: ['AC-3', 'AC-5', 'AC-6', 'MP-2', 'CA-9', 'SC-7', 'AT-2']

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
