control "microsoft-365-foundations-6.5.2" do
  title "Ensure MailTips are enabled for end users"
  desc "MailTips are informative messages displayed to users while they're composing a message. While a new message is open and being composed, Exchange analyzes the message (including recipients). If a potential problem is detected, the user is notified with a MailTip prior to sending the message. Using the information in the MailTip, the user can adjust the message to avoid undesirable situations or non-delivery reports (also known as NDRs or bounce messages)."

  desc "check",
       "To audit using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            Get-OrganizationConfig | fl MailTips*
        3. Verify the values for MailTipsAllTipsEnabled, MailTipsExternalRecipientsTipsEnabled, and MailTipsGroupMetricsEnabled are set to True and MailTipsLargeAudienceThreshold is set to an acceptable value; 25 is the default value."

  desc "fix",
       "To remediate using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            $TipsParams = @{ MailTipsAllTipsEnabled = $true MailTipsExternalRecipientsTipsEnabled = $true MailTipsGroupMetricsEnabled = $true MailTipsLargeAudienceThreshold = '25' }
            Set-OrganizationConfig @TipsParams"

  impact 0.5
  tag severity: "medium"

  ref "https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/mailtips/mailtips"
  ref "https://learn.microsoft.com/en-us/powershell/module/exchange/set-organizationconfig?view=exchange-ps"

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
