control 'microsoft-365-foundations-8.6.1' do
  title 'Ensure users can report security concerns in Teams'
  desc "User reporting settings allow a user to report a message as malicious for further analysis. This recommendation is composed of 3 different settings and all be configured to pass:
        • In the Teams admin center: On by default and controls whether users are able to report messages from Teams. When this setting is turned off, users can't report messages within Teams, so the corresponding setting in the Microsoft 365 Defender portal is irrelevant.
        • In the Microsoft 365 Defender portal: On by default for new tenants. Existing tenants need to enable it. If user reporting of messages is turned on in the Teams admin center, it also needs to be turned on the Defender portal for user reported messages to show up correctly on the User reported tab on the Submissions page.
        • Defender - Report message destinations: This applies to more than just Microsoft Teams and allows for an organization to keep their reports contained. Due to how the parameters are configured on the backend it is included in this assessment as a requirement."

  desc 'check',
       "To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Messaging select Messaging policies.
        3. Click Global (Org-wide default).
        4. Ensure Report a security concern is On.
        5. Next, navigate to Microsoft 365 Defender https://security.microsoft.com/
        6. Click on Settings > Email & collaboration > User reported settings.
        7. Scroll to Microsoft Teams.
        8. Ensure Monitor reported messages in Microsoft Teams is checked.
        9. Ensure Send reported messages to: is set to My reporting mailbox only with report email addresses defined for authorized staff.
    To audit using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Connect to Exchange Online PowerShell using Connect-ExchangeOnline.
        3. Run the following cmdlet for to assess Teams:
            Get-CsTeamsMessagingPolicy -Identity Global | fl AllowSecurityEndUserReporting
        4. Ensure the value returned is True.
        5. Run this cmdlet to assess Defender:
            Get-ReportSubmissionPolicy | fl Report*
        6. Ensure the output matches the following values with organization specific email addresses:
            ReportJunkToCustomizedAddress : True
            ReportNotJunkToCustomizedAddress : True
            ReportPhishToCustomizedAddress : True
            ReportJunkAddresses : {SOC@contoso.com}
            ReportNotJunkAddresses : {SOC@contoso.com}
            ReportPhishAddresses : {SOC@contoso.com}
            ReportChatMessageEnabled : False
            ReportChatMessageToCustomizedAddressEnabled : True"

  desc 'fix',
       'To remediate using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Messaging select Messaging policies.
        3. Click Global (Org-wide default).
        4. Set Report a security concern to On.
        5. Next, navigate to Microsoft 365 Defender https://security.microsoft.com/
        6. Click on Settings > Email & collaboration > User reported settings.
        7. Scroll to Microsoft Teams.
        8. Check Monitor reported messages in Microsoft Teams and Save.
        9. Set Send reported messages to: to My reporting mailbox only with reports configured to be sent to authorized staff.
    To remediate using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Connect to Exchange Online PowerShell using Connect-ExchangeOnline.
        3. Run the following cmdlet:
            Set-CsTeamsMessagingPolicy -Identity Global -AllowSecurityEndUserReporting $true
        4. To configure the Defender reporting policies, edit and run this script:
            $usersub = "userreportedmessages@fabrikam.com" # Change this.
            $params = @{ Identity = "DefaultReportSubmissionPolicy" EnableReportToMicrosoft = $false ReportChatMessageEnabled = $false ReportChatMessageToCustomizedAddressEnabled = $true ReportJunkToCustomizedAddress = $true ReportNotJunkToCustomizedAddress = $true ReportPhishToCustomizedAddress = $true ReportJunkAddresses = $usersub ReportNotJunkAddresses = $usersub ReportPhishAddresses = $usersub }
            Set-ReportSubmissionPolicy @params
            New-ReportSubmissionRule -Name DefaultReportSubmissionRule -ReportSubmissionPolicy DefaultReportSubmissionPolicy -SentTo $usersub'

  impact 0.5
  tag severity: 'medium'

  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/submissions-teams?view=o365-worldwide'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
