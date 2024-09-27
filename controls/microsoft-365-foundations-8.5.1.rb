control 'microsoft-365-foundations-8.5.1' do
  title "Ensure anonymous users can't join a meeting"
  desc "This policy setting can prevent anyone other than invited attendees (people directly invited by the organizer, or to whom an invitation was forwarded) from bypassing the lobby and entering the meeting.
        For more information on how to setup a sensitive meeting, please visit Configure Teams meetings with protection for sensitive data - Microsoft Teams: https://learn.microsoft.com/en-us/MicrosoftTeams/configure-meetings-sensitive-protection"

  desc 'check',
       "To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default).
        4. Under meeting join & lobby verify that Anonymous users can join a meeting is set to Off.
    To audit using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to verify the recommended state:
            Get-CsTeamsMeetingPolicy -Identity Global | fl AllowAnonymousUsersToJoinMeeting
        3. Ensure the returned value is False."

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Meetings select Meeting policies.
        3. Click Global (Org-wide default)
        4. Under meeting join & lobby set Anonymous users can join a meeting to Off.
    To remediate using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams
        2. Run the following command to set the recommended state:
            Set-CsTeamsMeetingPolicy -Identity Global -AllowAnonymousUsersToJoinMeeting $false"

  desc 'rationale',
       "For meetings that could contain sensitive information, it is best to allow the meeting
        organizer to vet anyone not directly sent an invite before admitting them to the meeting.
        This will also prevent the anonymous user from using the meeting link to have meetings
        at unscheduled times.
        Note: Those companies that don't normally operate at a Level 2 environment, but do
        deal with sensitive information, may want to consider this policy setting."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }, { '7' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-us/MicrosoftTeams/configure-meetings-sensitive-protection'

  ensure_anonymous_users_cant_join_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2('#{input('certificate_path')}','#{input('certificate_password')}')
    Install-Module -Name MicrosoftTeams -Force -AllowClobber
    import-module MicrosoftTeams
    Connect-MicrosoftTeams -Certificate $cert -ApplicationId $client_id -TenantId $tenantid > $null
    Write-Output (Get-CsTeamsMeetingPolicy -Identity Global).AllowAnonymousUsersToJoinMeeting
  }
  powershell_output = powershell(ensure_anonymous_users_cant_join_script)
  describe 'Ensure that AllowAnonymousUsersToJoinMeeting state' do
    subject { powershell_output.stdout.strip }
    it 'is set to False' do
      expect(subject).to eq('False')
    end
  end
end
