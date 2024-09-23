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

  desc 'rationale',
       'Restricting access to chat in meetings hosted by external organizations limits the
        opportunity for an exploit like GIFShell or DarkGate malware from being delivered to
        users.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['16.10'] }]
  tag default_value: 'On(True)'
  tag nist: ['PL-8', 'SA-8']

  ref 'https://learn.microsoft.com/en-US/microsoftteams/settings-policies-reference?WT.mc_id=TeamsAdminCenterCSH#meeting-engagement'

  ensure_external_meeting_chat_off_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2('#{input('certificate_path')}','#{input('certificate_password')}')
    import-module MicrosoftTeams
    Connect-MicrosoftTeams -Certificate $cert -ApplicationId $client_id -TenantId $tenantid > $null
    Write-Output (Get-CsTeamsMeetingPolicy -Identity Global).AllowExternalNonTrustedMeetingChat
  }

  powershell_output = powershell(ensure_external_meeting_chat_off_script)
  describe 'Ensure that the AllowExternalNonTrustedMeetingChat state' do
    subject { powershell_output.stdout.strip }
    it 'is set to False' do
      expect(subject).to eq('False')
    end
  end
end
