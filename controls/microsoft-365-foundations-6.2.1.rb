control 'microsoft-365-foundations-6.2.1' do
  title 'Ensure all forms of mail forwarding are blocked and/or disabled'
  desc "Exchange Online offers several methods of managing the flow of email messages. These are Remote domain, Transport Rules, and Anti-spam outbound policies. These methods work together to provide comprehensive coverage for potential automatic forwarding channels:
            • Outlook forwarding using inbox rules.
            • Outlook forwarding configured using OOF rule.
            • OWA forwarding setting (ForwardingSmtpAddress).
            • Forwarding set by the admin using EAC (ForwardingAddress).
            • Forwarding using Power Automate / Flow.
        Ensure a Transport rule and Anti-spam outbound policy are used to block mail forwarding.
        NOTE: Any exclusions should be implemented based on organizational policy."

  desc 'check',
       "Note: Audit is a two step procedure as follows:
        STEP 1: Transport rules To verify the mail transport rules do not forward email to external domains using the UI:
                1. Select Exchange to open the Exchange admin center.
                2. Select Mail Flow then Rules.
                3. Review the rules and verify that none of them are forwards or redirects e-mail to external domains.
            To audit using PowerShell:
                1. Connect to Exchange online using Connect-ExchangeOnline.
                2. Run the following PowerShell command to review the Transport Rules that are redirecting email:
                    Get-TransportRule | Where-Object {$_.RedirectMessageTo -ne $null} | ft Name,RedirectMessageTo
                3. Verify that none of the addresses listed belong to external domains outside of the organization. If nothing returns then there are no transport rules set to redirect messages.
        STEP 2: Anti-spam outbound policy Ensure an anti-spam outbound policy is properly configured using the UI:
                1. Navigate to Microsoft 365 Defender https://security.microsoft.com/
                2. Expand E-mail & collaboration then select Policies & rules.
                3. Select Threat policies > Anti-spam.
                4. Inspect Anti-spam outbound policy (default) and ensure Automatic forwarding is set to Off - Forwarding is disabled
                5. Inspect any additional custom outbound policies and ensure Automatic forwarding is set to Off - Forwarding is disabled, in accordance with the organization's exclusion policies.
            To audit using PowerShell:
                1. Connect to Exchange online using Connect-ExchangeOnline.
                2. Run the following PowerShell cmdlet:
                    Get-HostedOutboundSpamFilterPolicy | ft Name, AutoForwardingMode
                3. In each outbound policy verify AutoForwardingMode is Off.
            Note: According to Microsoft if a recipient is defined in multiple policies of the same type (anti-spam, anti-phishing, etc.), only the policy with the highest priority is applied to the recipient. Any remaining policies of that type are not evaluated for the recipient (including the default policy). However, it is our recommendation to audit the default policy as well in the case a higher priority custom policy is removed. This will keep the organization's security posture strong."

  desc 'fix',
       "Note: Remediation is a two step procedure as follows: STEP 1: Transport rules To alter the mail transport rules so they do not forward email to external domains using the UI:
            1. Select Exchange to open the Exchange admin center.
            2. Select Mail Flow then Rules.
            3. For each rule that redirects email to external domains, select the rule and click the 'Delete' icon.
        To remediate using PowerShell:
            1. Connect to Exchange Online using Connect-ExchangeOnline.
            2. Run the following PowerShell command:
                Remove-TransportRule {RuleName}
    STEP 2: Anti-spam outbound policy To configure an anti-spam outbound policy using the UI:
            1. Navigate to Microsoft 365 Defender https://security.microsoft.com/
            2. Expand E-mail & collaboration then select Policies & rules.
            3. Select Threat policies > Anti-spam.
            4. Select Anti-spam outbound policy (default)
            5. Click Edit protection settings
            6. Set Automatic forwarding rules dropdown to Off - Forwarding is disabled and click Save
            7. Repeat steps 4-6 for any additional higher priority, custom policies.
        To remediate using PowerShell:
            1. Connect to Exchange Online using Connect-ExchangeOnline.
            2. Run the following PowerShell command: Set-HostedOutboundSpamFilterPolicy -Identity {policyName} -AutoForwardingMode Off
            3. To remove AutoForwarding from all outbound policies you can also run: Get-HostedOutboundSpamFilterPolicy | Set-HostedOutboundSpamFilterPolicy -AutoForwardingMode Off"

  desc 'rationale',
       'Attackers often create these rules to exfiltrate data from your tenancy, this could be
        accomplished via access to an end-user account or otherwise. An insider could also use
        one of these methods as a secondary channel to exfiltrate sensitive data.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-us/exchange/policy-and-compliance/mail-flow-rules/mail-flow-rule-procedures?view=exchserver-2019'
  ref 'https://techcommunity.microsoft.com/t5/exchange-team-blog/all-you-need-to-know-about-automatic-email-forwarding-in/ba-p/2074888#:~:text=%20%20%20Automatic%20forwarding%20option%20%20,%'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/outbound-spam-policies-external-email-forwarding?view=o365-worldwide'
  ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/Remove-TransportRule?view=exchange-ps'

  ensure_no_external_address_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    Get-TransportRule | Where-Object {
    $_.RedirectMessageTo -ne $null -and
    $_.RedirectMessageTo -notmatch '#{input('internal_domains_transport_rule').join('|')}'
  } | Select-Object -ExpandProperty Name
 }
  powershell_output_address = powershell(ensure_no_external_address_script).stdout.strip
  external_rules = powershell_output_address.split("\n") unless powershell_output_address.empty?
  describe 'Ensure only internal domains' do
    subject { powershell_output_address }
    it 'are present in transport rules' do
      failure_message = "Rules with external domains present: #{external_rules}"
      expect(subject).to be_empty, failure_message
    end
  end

  ensure_all_mail_forwarding_blocked_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    Get-HostedOutboundSpamFilterPolicy | Where-Object { $_.AutoForwardingMode -ne "Off" } | Select-Object Name, AutoForwardingMode | ConvertTo-Json
 }

  powershell_output = powershell(ensure_all_mail_forwarding_blocked_script).stdout.strip
  mailboxes_without_off = JSON.parse(powershell_output) unless powershell_output.empty?
  describe 'Ensure the number of mailboxes with the AutoForwardingMode state not set to Off' do
    subject { powershell_output }
    it 'is 0' do
      failure_message = "Mailboxes that failed: #{JSON.pretty_generate(mailboxes_without_off)}"
      expect(subject).to be_empty, failure_message
    end
  end
end
