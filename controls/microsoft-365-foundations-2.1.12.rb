control 'microsoft-365-foundations-2.1.12' do
  title "Ensure the Restricted entities' report is reviewed weekly"
  desc 'Microsoft 365 Defender reviews of Restricted Entities will provide a list of user accounts restricted from sending e-mail. If a user exceeds one of the outbound sending limits as specified in the service limits or in outbound spam policies, the user is restricted from sending email, but they can still receive email.'

  desc 'check',
       'To verify the report is being reviewed at least weekly, confirm that the necessary procedures are in place and being followed.'

  desc 'fix',
       "To review the report of users who have had their email privileges restricted due to spamming:
        1.Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2.Under Email & collaboration navigate to Review.
        3.Click Restricted Entities.
        4.Review alerts and take appropriate action (unblocking) after account has been remediated.
    Review a list of users blocked from sending messages using PowerShell:
        1.Connect to Exchange Online using Connect-ExchangeOnline
        2.Run the following PowerShell command:
            Get-BlockedSenderAddress
        3.Review."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['8.11'] }, { '7' => ['6.2'] }]

  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/responding-to-a-compromised-email-account?view=o365-worldwide'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/removing-user-from-restricted-users-portal-after-spam?view=o365-worldwide'
  ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/get-blockedsenderaddress?view=exchange-ps'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
