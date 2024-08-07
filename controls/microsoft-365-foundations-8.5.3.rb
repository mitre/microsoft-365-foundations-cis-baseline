control 'microsoft-365-foundations-8.5.3' do
    title 'Ensure only people in my org can bypass the lobby'
    desc "This policy setting controls who can join a meeting directly and who must wait in the lobby until they're admitted by an organizer, co-organizer, or presenter of the meeting."

    desc 'check'
    'To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under meeting join & lobby verify Who can bypass the lobby is set to People in my org.
    To audit using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to verify the recommended state: 
            Get-CsTeamsMeetingPolicy -Identity Global | fl AutoAdmittedUsers
        3. Ensure the returned value is EveryoneInCompanyExcludingGuests'
    
    desc 'fix'
    'To remediate using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under meeting join & lobby set Who can bypass the lobby to People in my org.
    To remediate using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to set the recommended state: 
            Set-CsTeamsMeetingPolicy -Identity Global -AutoAdmittedUsers "EveryoneInCompanyExcludingGuests"'
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['6.8'] }]

    ref 'https://learn.microsoft.com/en-US/microsoftteams/who-can-bypass-meeting-lobby?WT.mc_id=TeamsAdminCenterCSH'
    ref 'https://learn.microsoft.com/en-us/powershell/module/skype/set-csteamsmeetingpolicy?view=skype-ps'