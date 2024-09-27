control 'microsoft-365-foundations-6.5.2' do
  title 'Ensure MailTips are enabled for end users'
  desc "MailTips are informative messages displayed to users while they're composing a message. While a new message is open and being composed, Exchange analyzes the message (including recipients). If a potential problem is detected, the user is notified with a MailTip prior to sending the message. Using the information in the MailTip, the user can adjust the message to avoid undesirable situations or non-delivery reports (also known as NDRs or bounce messages)."

  desc 'check',
       "To audit using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            Get-OrganizationConfig | fl MailTips*
        3. Verify the values for MailTipsAllTipsEnabled, MailTipsExternalRecipientsTipsEnabled, and MailTipsGroupMetricsEnabled are set to True and MailTipsLargeAudienceThreshold is set to an acceptable value; 25 is the default value."

  desc 'fix',
       "To remediate using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            $TipsParams = @{ MailTipsAllTipsEnabled = $true MailTipsExternalRecipientsTipsEnabled = $true MailTipsGroupMetricsEnabled = $true MailTipsLargeAudienceThreshold = '25' }
            Set-OrganizationConfig @TipsParams"

  desc 'rationale',
       'Setting up MailTips gives a visual aid to users when they send emails to large groups of
        recipients or send emails to recipients not within the tenant.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/mailtips/mailtips'
  ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/set-organizationconfig?view=exchange-ps'

  ensure_mailtip_enabled_for_end_users_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    Get-OrganizationConfig | Select-Object -Property MailTips* | ConvertTo-Json
 }
  powershell_output = powershell(ensure_mailtip_enabled_for_end_users_script).stdout.strip
  mailtips_settings = JSON.parse(powershell_output) unless powershell_output.empty?
  describe 'Ensure that the MailTip setting' do
    subject { mailtips_settings }
    it 'MailTipsAllTipsEnabled should be set to True' do
      expect(mailtips_settings['MailTipsAllTipsEnabled']).to eq(true)
    end
    it 'MailTipsExternalRecipientsTipsEnabled should be set to True' do
      expect(mailtips_settings['MailTipsExternalRecipientsTipsEnabled']).to eq(true)
    end
    it 'MailTipsGroupMetricsEnabled should be set to True' do
      expect(mailtips_settings['MailTipsGroupMetricsEnabled']).to eq(true)
    end
    it 'MailTipsLargeAudienceThreshold should be set to an acceptable value' do
      expect(mailtips_settings['MailTipsLargeAudienceThreshold']).to eq(input('mailtipslargeaudiencethreshold_value'))
    end
  end
end
