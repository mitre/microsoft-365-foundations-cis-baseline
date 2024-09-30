control 'microsoft-365-foundations-3.1.1' do
  title 'Ensure Microsoft 365 audit log search is Enabled'
  desc 'When audit log search is enabled in the Microsoft Purview compliance portal, user and admin activity within the organization is recorded in the audit log and retained for 90 days. However, some organizations may prefer to use a third-party security information and event management (SIEM) application to access their auditing data. In this scenario, a global admin can choose to turn off audit log search in Microsoft 365.'

  desc 'check',
       "Ensure Microsoft 365 audit log search is Enabled:
        1.Navigate to Microsoft Purview https://compliance.microsoft.com.
        2.Select Audit to open the audit search.
        3.Choose a date and time frame in the past 30 days.
        4.Verify search capabilities (e.g. try searching for Activities as Accessed file and results should be displayed).
    To verify audit log search is enabled using PowerShell:
        1.Connect to Exchange Online using Connect-ExchangeOnline.
        2.Run the following PowerShell command:
            Get-AdminAuditLogConfig | Select-Object UnifiedAuditLogIngestionEnabled
        3.Ensure UnifiedAuditLogIngestionEnabled is set to True."

  desc 'fix',
       "To enable Microsoft 365 audit log search:
        1.Navigate to Microsoft Purview https://compliance.microsoft.com.
        2.Select Audit to open the audit search.
        3.Click Start recording user and admin activity next to the information warning at the top.
        4.Click Yes on the dialog box to confirm.
    To enable Microsoft 365 audit log search using PowerShell:
        1.Connect to Exchange Online using Connect-ExchangeOnline.
        2.Run the following PowerShell command:
            Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true"

  desc 'rationale',
       'Enabling audit log search in the Microsoft Purview compliance portal can help
        organizations improve their security posture, meet regulatory compliance requirements,
        respond to security incidents, and gain valuable operational insights.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['8.2'] }, { '7' => ['6.2'] }]
  tag nist: ['AU-2', 'AU-7', 'AU-12', 'AC-1', 'AC-2', 'AC-2(1)']

  ref 'https://learn.microsoft.com/en-us/microsoft-365/compliance/audit-log-enable-disable?view=o365-worldwide'
  ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/set-adminauditlogconfig?view=exchange-ps'

  ensure_m365_audit_log_enabled_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    (Get-AdminAuditLogConfig | Select-Object -ExpandProperty UnifiedAuditLogIngestionEnabled)
 }

  powershell_output = powershell(ensure_m365_audit_log_enabled_script)
  describe 'Ensure the UnifiedAuditLogIngestionEnabled option for audit logs' do
    subject { powershell_output.stdout.strip }
    it 'is set to True' do
      expect(subject).to eq('True')
    end
  end
end
