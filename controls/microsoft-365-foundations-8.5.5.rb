control 'microsoft-365-foundations-8.5.5' do
  title 'Ensure meeting chat does not allow anonymous users'
  desc 'This policy setting controls who has access to read and write chat messages during a meeting.'

  desc 'check',
       "To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under meeting engagement verify that Meeting chat is set to On for everyone but anonymous users.
    To audit using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to verify the recommended state:
            Get-CsTeamsMeetingPolicy -Identity Global | fl MeetingChatEnabledType
        3. Ensure the returned value is EnabledExceptAnonymous."

  desc 'fix',
       'To remediate using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under meeting engagement set Meeting chat to On for everyone but anonymous users.
    To remediate using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to set the recommended state:
            Set-CsTeamsMeetingPolicy -Identity Global -MeetingChatEnabledType "EnabledExceptAnonymous"'

  impact 0.5
  tag severity: 'medium'

  ref 'https://learn.microsoft.com/en-us/powershell/module/skype/set-csteamsmeetingpolicy?view=skype-ps#-meetingchatenabledtype'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
