control 'microsoft-365-foundations-8.5.4' do
  title "Ensure users dialing in can't bypass the lobby"
  desc 'This policy setting controls if users who dial in by phone can join the meeting directly or must wait in the lobby. Admittance to the meeting from the lobby is authorized by the meeting organizer, co-organizer, or presenter of the meeting.'

  desc 'check',
       "To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under meeting join & lobby verify that People dialing in can bypass the lobby is set to Off.
    To audit using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to verify the recommended state:
            Get-CsTeamsMeetingPolicy -Identity Global | fl AllowPSTNUsersToBypassLobby
        3. Ensure the value is False."

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under meeting join & lobby set People dialing in can bypass the lobby to Off.
    To remediate using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to set the recommended state:
            Set-CsTeamsMeetingPolicy -Identity Global -AllowPSTNUsersToBypassLobby $false"

  desc 'rationale',
       'For meetings that could contain sensitive information, it is best to allow the meeting
        organizer to vet anyone not directly from the organization.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }, { '7' => ['untracked'] }]
  tag default_value: 'Off (False)'
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-US/microsoftteams/who-can-bypass-meeting-lobby?WT.mc_id=TeamsAdminCenterCSH#choose-who-can-bypass-the-lobby-in-meetings-hosted-by-your-organization'
  ref 'https://learn.microsoft.com/en-us/powershell/module/skype/set-csteamsmeetingpolicy?view=skype-ps'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
