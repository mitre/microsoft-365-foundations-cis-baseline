control 'microsoft-365-foundations-6.2.2' do
  title 'Ensure mail transport rules do not whitelist specific domains'
  desc 'Mail flow rules (transport rules) in Exchange Online are used to identify and take action on messages that flow through the organization.'

  desc 'check',
       "Ensure mail transport rules do not whitelist specific domains:
        1. Navigate to Exchange admin center https://admin.exchange.microsoft.com..
        2. Click to expand Mail Flow and then select Rules.
        3. Review the rules and verify that none of them whitelist any specific domains.
    To verify that mail transport rules do not whitelist any domains using PowerShell:
        1. Connect to Exchange online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            Get-TransportRule | Where-Object {($_.setscl -eq -1 -and $_.SenderDomainIs -ne $null)} | ft Name,SenderDomainIs"

  desc 'fix',
       "To alter the mail transport rules so they do not whitelist any specific domains:
        1. Navigate to Exchange admin center https://admin.exchange.microsoft.com..
        2. Click to expand Mail Flow and then select Rules.
        3. For each rule that whitelists specific domains, select the rule and click the 'Delete' icon.
    To remove mail transport rules using PowerShell:
        1. Connect to Exchange online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            Remove-TransportRule {RuleName}
        3. Verify the rules no longer exists.
            Get-TransportRule | Where-Object {($_.setscl -eq -1 -and $_.SenderDomainIs -ne $null)} | ft Name,SenderDomainIs"

  desc 'rationale',
       'Whitelisting domains in transport rules bypasses regular malware and phishing
        scanning, which can enable an attacker to launch attacks against your users from a
        safe haven domain.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-us/exchange/security-and-compliance/mail-flow-rules/configuration-best-practices'
  ref 'https://learn.microsoft.com/en-us/exchange/security-and-compliance/mail-flow-rules/mail-flow-rules'

  ensure_mail_transport_rules_dont_whitelist_specific_domains_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    Get-TransportRule | Where-Object { ($_.SetScl -eq -1 -and $_.SenderDomainIs -ne $null) } | Select-Object -ExpandProperty Name
 }
  powershell_output = powershell(ensure_mail_transport_rules_dont_whitelist_specific_domains_script).stdout.strip
  whitelisted_domain_rules = powershell_output.split("\n") unless powershell_output.empty?
  describe 'Ensure the mail transport rules' do
    subject { powershell_output }
    it 'do not have specific domains whitelisted' do
      failure_message = "Rules with specific whitelisted domains: #{whitelisted_domain_rules}"
      expect(subject).to be_empty, failure_message
    end
  end
end
