control 'microsoft-365-foundations-2.1.6' do
  title 'Ensure Exchange Online Spam Policies are set to notify administrators'
  desc "In Microsoft 365 organizations with mailboxes in Exchange Online or standalone Exchange Online Protection (EOP) organizations without Exchange Online mailboxes, email messages are automatically protected against spam (junk email) by EOP.
        Configure Exchange Online Spam Policies to copy emails and notify someone when a sender in the organization has been blocked for sending spam emails."

  desc 'check',
       "Ensure Exchange Online Spam Policies are set to notify administrators:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2. Click to expand Email & collaboration select Policies & rules > Threat policies.
        3. Under Policies select Anti-spam.
        4. Click on the Anti-spam outbound policy (default).
        5. Verify that Send a copy of outbound messages that exceed these limits to these users and groups is set to On, ensure the email address is correct.
    To verify the Exchange Online Spam Policies are set correctly using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            Get-HostedOutboundSpamFilterPolicy | Select-Object Bcc*, Notify*
        3. Verify both BccSuspiciousOutboundMail and NotifyOutboundSpam are set to True and the email addresses to be notified are correct.
    Note: Audit and Remediation guidance may focus on the Default policy however, if a Custom Policy exists in the organization's tenant then ensure the setting is set as outlined in the highest priority policy listed."

  desc 'fix',
       "To set the Exchange Online Spam Policies:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2. Click to expand Email & collaboration select Policies & rules> Threat policies.
        3. Under Policies select Anti-spam.
        4. Click on the Anti-spam outbound policy (default).
        5. Select Edit protection settings then under Notifications
        6. Check Send a copy of outbound messages that exceed these limits to these users and groups then enter the desired email addresses.
        7. Check Notify these users and groups if a sender is blocked due to sending outbound spam then enter the desired email addresses.
        8. Click Save.
    To set the Exchange Online Spam Policies correctly using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            $BccEmailAddress = @(\"<INSERT-EMAIL>\")
            $NotifyEmailAddress = @(\"<INSERT-EMAIL>\")
            Set-HostedOutboundSpamFilterPolicy -Identity Default -
            BccSuspiciousOutboundAdditionalRecipients $BccEmailAddress -
            BccSuspiciousOutboundMail $true -NotifyOutboundSpam $true -
            NotifyOutboundSpamRecipients $NotifyEmailAddress
    Note: Audit and Remediation guidance may focus on the Default policy however, if a Custom Policy exists in the organization's tenant then ensure the setting is set as outlined in the highest priority policy listed."

  desc 'rationale',
       'A blocked account is a good indication that the account in question has been breached and an attacker is using it to send spam emails to other people.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [
    { '8' => ['17.5'] },
    { '7' => ['7.9'] },
    { '7' => ['7.10'] }
  ]
  tag nist: ['IR-1', 'IR-8']
  notify_outbound_spam_recipients_list = %("#{input('notify_outbound_spam_recipients').sort.join('", "')}")
  bcc_suspicious_outbound_additional_recipients_list = %("#{input('bcc_suspicious_outbound_additional_recipients').sort.join('", "')}")
  ensure_exchange_online_spam_policies_set_to_notify_admins_script = %{
    $notify_outbound_spam_recipients_list = @(#{notify_outbound_spam_recipients_list})
    $bcc_suspicious_outbound_additional_recipients_list = @(#{bcc_suspicious_outbound_additional_recipients_list})
    $policies = Get-HostedOutboundSpamFilterPolicy | Select-Object Name, BccSuspiciousOutboundMail, NotifyOutboundSpam, NotifyOutboundSpamRecipients, BccSuspiciousOutboundAdditionalRecipients
    foreach ($policy in $policies) {
        $failedConditions = @()

        if ($policy.BccSuspiciousOutboundMail -eq $false) {
            $failedConditions += "BccSuspiciousOutboundMail"
        }
        if ($policy.NotifyOutboundSpam -eq $false) {
            $failedConditions += "NotifyOutboundSpam"
        }
        if (($notify_outbound_spam_recipients_list | Sort-Object ) -ne ($policy.NotifyOutboundSpamRecipients.ToArray() | Sort-Object)) {
            $failedConditions += "NotifyOutboundSpamRecipients"
        }
        if (($bcc_suspicious_outbound_additional_recipients_list | Sort-Object ) -ne ($policy.BccSuspiciousOutboundAdditionalRecipients.ToArray() | Sort-Object)) {
            $failedConditions += "BccSuspiciousOutboundAdditionalRecipients"
        }

        if ($failedConditions.Count -gt 0) {
            Write-Output "Policy Name: $($policy.Name), Failed Conditions = [$($failedConditions -join ', ')]"
        }
    }
  }

  powershell_output = pwsh_single_session_executor(ensure_exchange_online_spam_policies_set_to_notify_admins_script).run_script_in_graph_exchange

  describe 'Ensure the number of Exchange Online Spam Policies that have the settings BccSuspiciousOutboundMail as False, NotifyOutboundSpam as False, NotifyOutboundSpamRecipients set to an incorrect email address, or BccSuspiciousOutboundAdditionalRecipients set to an incorrect email addresses' do
    subject { powershell_output.stdout.strip }
    it 'is 0' do
      failure_message = "The following Exchange Online Spam Policies have failed along with conditions they have failed on: #{powershell_output.stdout.strip.split("\n").join(',')}"
      expect(subject).to be_empty, failure_message
    end
  end
end
