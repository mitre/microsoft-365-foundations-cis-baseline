control 'microsoft-365-foundations-8.5.2' do
    title "Ensure anonymous users and dial-in callers can't start a meeting"
    desc 'This policy setting controls if an anonymous participant can start a Microsoft Teams meeting without someone in attendance. Anonymous users and dial-in callers must wait in the lobby until the meeting is started by someone in the organization or an external user from a trusted organization.
        Anonymous participants are classified as:
            • Participants who are not logged in to Teams with a work or school account.
            • Participants from non-trusted organizations (as configured in external access).
            • Participants from organizations where there is not mutual trust.
        Note: This setting only applies when Who can bypass the lobby is set to Everyone. If the anonymous users can join a meeting organization-level setting or meeting policy is Off, this setting only applies to dial-in callers.'

    desc 'check'
    'To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under meeting join & lobby verify that Anonymous users and dial-in callers can start a meeting is set to Off.
    To audit using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to verify the recommended state: 
            Get-CsTeamsMeetingPolicy -Identity Global | fl AllowAnonymousUsersToStartMeeting
        3. Ensure the returned value is False.'
    
    desc 'fix'
    'To remediate using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under meeting join & lobby set Anonymous users and dial-in callers can start a meeting to Off.
    To remediate using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to set the recommended state: 
            Set-CsTeamsMeetingPolicy -Identity Global -AllowAnonymousUsersToStartMeeting $false'
    
    impact 0.5
    tag severity: 'medium'

    ref 'https://learn.microsoft.com/en-us/microsoftteams/anonymous-users-in-meetings'
    ref 'https://learn.microsoft.com/en-US/microsoftteams/who-can-bypass-meeting-lobby?WT.mc_id=TeamsAdminCenterCSH#overview-of-lobby-settings-and-policies'
end