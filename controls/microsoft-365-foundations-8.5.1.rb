control 'microsoft-365-foundations-8.5.1' do
    title "Ensure anonymous users can't join a meeting"
    desc 'This policy setting can prevent anyone other than invited attendees (people directly invited by the organizer, or to whom an invitation was forwarded) from bypassing the lobby and entering the meeting.
        For more information on how to setup a sensitive meeting, please visit Configure Teams meetings with protection for sensitive data - Microsoft Teams: https://learn.microsoft.com/en-us/MicrosoftTeams/configure-meetings-sensitive-protection'

    desc 'check'
    'To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under meeting join & lobby verify that Anonymous users can join a meeting is set to Off.
    To audit using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to verify the recommended state: 
            Get-CsTeamsMeetingPolicy -Identity Global | fl AllowAnonymousUsersToJoinMeeting
        3. Ensure the returned value is False.'
    
    desc 'fix'
    'To remediate using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default)
        4. Under meeting join & lobby set Anonymous users can join a meeting to Off.
    To remediate using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams
        2. Run the following command to set the recommended state: 
            Set-CsTeamsMeetingPolicy -Identity Global -AllowAnonymousUsersToJoinMeeting $false'
    
    impact 0.5
    tag severity: 'medium'

    ref 'https://learn.microsoft.com/en-us/MicrosoftTeams/configure-meetings-sensitive-protection'