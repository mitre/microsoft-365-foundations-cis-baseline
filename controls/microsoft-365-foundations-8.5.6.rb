control 'microsoft-365-foundations-8.5.6' do
  title 'Ensure only organizers and co-organizers can present'
  desc "This policy setting controls who can present in a Teams meeting.
        Note: Organizers and co-organizers can change this setting when the meeting is set up."

  desc 'check',
       "To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under content sharing verify Who can present is set to Only organizers and co-organizers.
    To audit using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to verify the recommended state:
            Get-CsTeamsMeetingPolicy -Identity Global | fl DesignatedPresenterRoleMode
        3. Ensure the returned value is OrganizerOnlyUserOverride."

  desc 'fix',
       'To remediate using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under content sharing set Who can present to Only organizers and co-organizers.
    To remediate using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to set the recommended state:
            Set-CsTeamsMeetingPolicy -Identity Global -DesignatedPresenterRoleMode "OrganizerOnlyUserOverride"'

  desc 'rationale',
       'Ensuring that only authorized individuals are able to present reduces the risk that a
        malicious user can inadvertently show content that is not appropriate.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }, { '7' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-US/microsoftteams/meeting-who-present-request-control'
  ref 'https://learn.microsoft.com/en-us/microsoftteams/meeting-who-present-request-control#manage-who-can-present'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/step-by-step-guides/reducing-attack-surface-in-microsoft-teams?view=o365-worldwide#configure-meeting-settings-restrict-presenters'
  ref 'https://learn.microsoft.com/en-us/powershell/module/skype/set-csteamsmeetingpolicy?view=skype-ps'

  ensure_organizers_only_can_present_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2('#{input('certificate_path')}','#{input('certificate_password')}')
    import-module MicrosoftTeams
    Connect-MicrosoftTeams -Certificate $cert -ApplicationId $client_id -TenantId $tenantid > $null
    Write-Output (Get-CsTeamsMeetingPolicy -Identity Global).DesignatedPresenterRoleMode
  }

  powershell_output = powershell(ensure_organizers_only_can_present_script)
  describe 'Ensure that the DesignatedPresenterRoleMode state' do
    subject { powershell_output.stdout.strip }
    it 'is set to OrganizerOnlyUserOverride' do
      expect(subject).to eq('OrganizerOnlyUserOverride')
    end
  end
end
