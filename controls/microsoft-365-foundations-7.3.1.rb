control 'microsoft-365-foundations-7.3.1' do
  title 'Ensure Office 365 SharePoint infected files are disallowed for download'
  desc 'By default, SharePoint online allows files that Defender for Office 365 has detected as infected to be downloaded.'

  desc 'check',
       'To audit using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService -Url https://tenant-admin.sharepoint.com, replacing "tenant" with the appropriate value.
        2. Run the following PowerShell command:
            Get-SPOTenant | Select-Object DisallowInfectedFileDownload
        3. Ensure the value for DisallowInfectedFileDownload is set to True.
    Note: According to Microsoft, SharePoint cannot be accessed through PowerShell by users with the Global Reader role. For further information, please refer to the reference section.'

  desc 'fix',
       'To remediate using PowerShell:
        1. Connect to SharePoint Online using Connect-SPOService -Url https://tenant-admin.sharepoint.com, replacing "tenant" with the appropriate value.
        2. Run the following PowerShell command to set the recommended value:
            Set-SPOTenant –DisallowInfectedFileDownload $true
    Note: The Global Reader role cannot access SharePoint using PowerShell according to Microsoft. See the reference section for more information.'

  desc 'rationale',
       "Defender for Office 365 for SharePoint, OneDrive, and Microsoft Teams protects your
        organization from inadvertently sharing malicious files. When an infected file is detected
        that file is blocked so that no one can open, copy, move, or share it until further actions
        are taken by the organization's security team."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [
    { '8' => ['10.1'] },
    { '7' => ['7.10'] },
    { '7' => ['8.1'] }
  ]
  tag nist: ['SI-3', 'AU-1', 'AU-2']

  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/safe-attachments-for-spo-odfb-teams-configure?view=o365-worldwide'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/anti-malware-protection-for-spo-odfb-teams-about?view=o365-worldwide'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/roles/permissions-reference#global-reader'

  ensure_office_m365spo_infected_files_disallowed_download_script = %{
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
	  (Get-PnPTenant).DisallowInfectedFileDownload
  }

  powershell_output = powershell(ensure_office_m365spo_infected_files_disallowed_download_script).stdout.strip
  describe 'Ensure the DisallowInfectedFileDownload option for Office 365 SharePoint' do
    subject { powershell_output }
    it 'is set to True' do
      expect(subject).to eq('True')
    end
  end
end
