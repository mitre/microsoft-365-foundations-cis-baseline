control 'microsoft-365-foundations-8.5.7' do
    title "Ensure external participants can't give or request control"
    desc 'This policy setting allows control of who can present in meetings and who can request control of the presentation while a meeting is underway.'

    desc 'check'
    'To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under content sharing verify that External participants can give or request control is Off.
    To audit using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to verify the recommended state: 
            Get-CsTeamsMeetingPolicy -Identity Global | fl AllowExternalParticipantGiveRequestControl
        3. Ensure the returned value is False.'
    
    desc 'fix'
    'To remediate using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under content sharing set External participants can give or request control to Off.
    To remediate using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to set the recommended state: 
            Set-CsTeamsMeetingPolicy -Identity Global -AllowExternalParticipantGiveRequestControl $false'

    impact 0.5
    tag severity: 'medium'

    ref 'https://learn.microsoft.com/en-us/microsoftteams/meeting-who-present-request-control'
    ref 'https://learn.microsoft.com/en-us/powershell/module/skype/set-csteamsmeetingpolicy?view=skype-ps'
    