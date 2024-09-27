control 'microsoft-365-foundations-8.5.7' do
  title "Ensure external participants can't give or request control"
  desc 'This policy setting allows control of who can present in meetings and who can request control of the presentation while a meeting is underway.'

  desc 'check',
       "To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under content sharing verify that External participants can give or request control is Off.
    To audit using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to verify the recommended state:
            Get-CsTeamsMeetingPolicy -Identity Global | fl AllowExternalParticipantGiveRequestControl
        3. Ensure the returned value is False."

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under content sharing set External participants can give or request control to Off.
    To remediate using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to set the recommended state:
            Set-CsTeamsMeetingPolicy -Identity Global -AllowExternalParticipantGiveRequestControl $false"

  desc 'rationale',
       'Ensuring that only authorized individuals and not external participants are able to
        present and request control reduces the risk that a malicious user can inadvertently
        show content that is not appropriate.
        External participants are categorized as follows: external users, guests, and anonymous
        users.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }, { '7' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-us/microsoftteams/meeting-who-present-request-control'
  ref 'https://learn.microsoft.com/en-us/powershell/module/skype/set-csteamsmeetingpolicy?view=skype-ps'

  ensure_organizers_only_can_present_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2('#{input('certificate_path')}','#{input('certificate_password')}')
    import-module MicrosoftTeams
    Connect-MicrosoftTeams -Certificate $cert -ApplicationId $client_id -TenantId $tenantid > $null
    Write-Output (Get-CsTeamsMeetingPolicy -Identity Global).AllowExternalParticipantGiveRequestControl
  }

  powershell_output = powershell(ensure_organizers_only_can_present_script)
  describe 'Ensure that the AllowExternalParticipantGiveRequestControl state' do
    subject { powershell_output.stdout.strip }
    it 'is set to False' do
      expect(subject).to eq('False')
    end
  end
end
