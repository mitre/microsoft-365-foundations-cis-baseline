control 'microsoft-365-foundations-8.5.8' do
  title 'Ensure external meeting chat is off'
  desc 'This meeting policy setting controls whether users can read or write messages in external meeting chats with untrusted organizations. If an external organization is on the list of trusted organizations this setting will be ignored.'

  desc 'check',
       "To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under meeting engagement verify that External meeting chat is set to Off.
    To audit using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to verify the recommended state:
            Get-CsTeamsMeetingPolicy -Identity Global | fl AllowExternalNonTrustedMeetingChat
        3. Ensure the returned value is False."

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under meeting engagement set External meeting chat to Off.
    To remediate using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to set the recommended state:
            Set-CsTeamsMeetingPolicy -Identity Global -AllowExternalNonTrustedMeetingChat $false"

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['16.10'] }]

  ref 'https://learn.microsoft.com/en-US/microsoftteams/settings-policies-reference?WT.mc_id=TeamsAdminCenterCSH#meeting-engagement'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
