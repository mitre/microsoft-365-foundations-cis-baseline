control 'microsoft-365-foundations-6.1.4' do
  title "Ensure 'AuditBypassEnabled' is not enabled on mailboxes"
  desc "When configuring a user or computer account to bypass mailbox audit logging, the system will not record any access, or actions performed by the said user or computer account on any mailbox. Administratively this was introduced to reduce the volume of entries in the mailbox audit logs on trusted user or computer accounts.
        Ensure AuditBypassEnabled is not enabled on accounts without a written exception."

  desc 'check',
       "Ensure Audit Bypass is not enabled using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            $MBX = Get-MailboxAuditBypassAssociation -ResultSize unlimited
            $MBX | where {$_.AuditBypassEnabled -eq $true} | Format-Table Name,AuditBypassEnabled
        3. If nothing is returned, then there are no accounts with Audit Bypass enabled."

  desc 'fix',
       'Disable Audit Bypass on all mailboxes using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. The following example PowerShell script will disable AuditBypass for all mailboxes which currently have it enabled:

            # Get mailboxes with AuditBypassEnabled set to $true
            $MBXAudit = Get-MailboxAuditBypassAssociation -ResultSize unlimited | Where-Object { $_.AuditBypassEnabled -eq $true }
            foreach ($mailbox in $MBXAudit) {
                $mailboxName = $mailbox.Name
                Set-MailboxAuditBypassAssociation -Identity $mailboxName -AuditBypassEnabled $false
                Write-Host "Audit Bypass disabled for mailbox Identity: $mailboxName" -ForegroundColor Green
            }'

  desc 'rationale',
       'If a mailbox audit bypass association is added for an account, the account can access
        any mailbox in the organization to which it has been assigned access permissions,
        without generating any mailbox audit logging entries for such access or recording any
        actions taken, such as message deletions.
        Enabling this parameter, whether intentionally or unintentionally, could allow insiders or
        malicious actors to conceal their activity on specific mailboxes. Ensuring proper logging
        of user actions and mailbox operations in the audit log will enable comprehensive
        incident response and forensics.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['8.5'] }]
  tag nist: ['AU-3', 'AU-3(1)', 'AU-7', 'AU-12']

  ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/get-mailboxauditbypassassociation?view=exchange-ps'

  ensure_auditbybass_not_enabled_mailbox_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    $MBX = Get-MailboxAuditBypassAssociation -ResultSize unlimited
    $MBX | where {$_.AuditBypassEnabled -eq $true} | Select-Object Name, AuditBypassEnabled | ConvertTo-Json
 }

  powershell_output = powershell(ensure_auditbybass_not_enabled_mailbox_script).stdout.strip
  mailboxes_with_true = JSON.parse(powershell_output) unless powershell_output.empty?
  describe 'Ensure the number of mailboxes with the AuditBypassEnabled state set to True' do
    subject { powershell_output }
    it 'is 0' do
      failure_message = "Mailboxes that failed: #{JSON.pretty_generate(mailboxes_with_true)}"
      expect(subject).to be_empty, failure_message
    end
  end
end
