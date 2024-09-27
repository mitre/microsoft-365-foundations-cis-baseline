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

  desc 'rationale',
       "Custom scripts could contain malicious instructions unknown to the user or
        administrator. When users are allowed to run custom script, the organization can no
        longer enforce governance, scope the capabilities of inserted code, block specific parts
        of code, or block all custom code that has been deployed. If scripting is allowed the
        following things can't be audited:
          • What code has been inserted
          • Where the code has been inserted
          • Who inserted the code
        Note: Microsoft recommends using the SharePoint Framework instead of custom
        scripts."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['2.7'] }]
  tag nist: ['CM-7', 'CM-7(1)', 'SI-7', 'SI-7(1)']

  ref 'https://learn.microsoft.com/en-us/sharepoint/allow-or-prevent-custom-script'
  ref 'https://learn.microsoft.com/en-us/sharepoint/security-considerations-of-allowing-custom-script'
  ref 'https://learn.microsoft.com/en-us/powershell/module/sharepoint-online/set-sposite?view=sharepoint-ps'

  ensure_spo_guest_users_cannot_share_items_dont_own_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $clientSecret = '#{input('client_secret')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $sharepoint_admin_url = '#{input('sharepoint_admin_url')}'
    Install-Module -Name PnP.PowerShell -Force -AllowClobber
    import-module pnp.powershell
    $password = (ConvertTo-SecureString -AsPlainText $certificate_password -Force)
    Connect-PnPOnline -Url $sharepoint_admin_url -ClientId $client_id -CertificatePath $certificate_path -CertificatePassword $password  -Tenant $tenantid
	  Get-PnPTenantSite | Where-Object { $_.DenyAddAndCustomizePages -eq "Disabled" -and $_.Url -notlike "*-my.sharepoint.com/" } | Select-Object -ExpandProperty Url
  }
  powershell_output = powershell(ensure_spo_guest_users_cannot_share_items_dont_own_script).stdout.strip
  disabled_urls = powershell_output.split("\n") unless powershell_output.empty?
  describe 'Ensure the number of sites with DenyAddAndCustomizePages setting as Disabled' do
    subject { powershell_output }
    it 'is 0' do
      failure_message = "URLS with DenyAddAndCustomizePages setting as Disabled: #{disabled_urls}"
      expect(subject).to be_empty, failure_message
    end
  end
end
