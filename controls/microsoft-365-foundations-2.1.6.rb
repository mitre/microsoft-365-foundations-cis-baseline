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

  ensure_exchange_online_spam_policies_set_to_notify_admins_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    Get-HostedOutboundSpamFilterPolicy | Select-Object Name, Bcc*, Notify* | ConvertTo-Json
  }
  powershell_output = powershell(ensure_exchange_online_spam_policies_set_to_notify_admins_script).stdout.strip
  powershell_data = JSON.parse(powershell_output) unless powershell_output.empty?
  case powershell_data
  when Hash
    describe "Ensure the following Exchange Online Spam Policy (#{powershell_data['Name']})" do
      it 'should have BccSuspiciousOutboundMail set to True' do
        expect(powershell_data['BccSuspiciousOutboundMail']).to eq(true)
      end
      it 'should have NotifyOutboundSpam set to True' do
        expect(powershell_data['NotifyOutboundSpam']).to eq(true)
      end
      it 'should have NotifyOutboundSpamRecipients set to correct email address' do
        expect(powershell_data['NotifyOutboundSpamRecipients']).to eq(input('notify_outbound_spam_recipients'))
      end
      it 'should have BccSuspiciousOutboundAdditionalRecipients set to correct email address' do
        expect(powershell_data['BccSuspiciousOutboundAdditionalRecipients']).to eq(input('bcc_suspicious_outbound_additional_recipients'))
      end
    end
  when Array
    powershell_data.each do |policy|
      describe %(Ensure the following Exchange Online Spam Policy #{policy['Name']}) do
        it 'should have BccSuspiciousOutboundMail set to True' do
          expect(policy['BccSuspiciousOutboundMail']).to eq(true)
        end
        it 'should have NotifyOutboundSpam set to True' do
          expect(policy['NotifyOutboundSpam']).to eq(true)
        end
        it 'should have NotifyOutboundSpamRecipients set to correct email address' do
          expect(policy['NotifyOutboundSpamRecipients'].sort).to match_array(input('notify_outbound_spam_recipients').sort)
        end
        it 'should have BccSuspiciousOutboundAdditionalRecipients set to correct email address' do
          expect(policy['BccSuspiciousOutboundAdditionalRecipients'].sort).to match_array(input('bcc_suspicious_outbound_additional_recipients').sort)
        end
      end
    end
  end
end
