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

  desc 'rationale',
       'Ensuring that only authorized individuals can read and write chat messages during a
        meeting reduces the risk that a malicious user can inadvertently show content that is not
        appropriate or view sensitive information.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }, { '7' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-us/powershell/module/skype/set-csteamsmeetingpolicy?view=skype-ps#-meetingchatenabledtype'

  ensure_meeting_chat_not_allow_anon_users = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2('#{input('certificate_path')}','#{input('certificate_password')}')
    import-module MicrosoftTeams
    Connect-MicrosoftTeams -Certificate $cert -ApplicationId $client_id -TenantId $tenantid > $null
    Write-Output (Get-CsTeamsMeetingPolicy -Identity Global).MeetingChatEnabledType
  }

  powershell_output = powershell(ensure_meeting_chat_not_allow_anon_users)
  describe 'Ensure that the MeetingChatEnabledType state' do
    subject { powershell_output.stdout.strip }
    it 'is set to EnabledExceptAnonymous' do
      expect(subject).to eq('EnabledExceptAnonymous')
    end
  end
end
