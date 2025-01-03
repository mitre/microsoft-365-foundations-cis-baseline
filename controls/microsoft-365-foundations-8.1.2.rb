control 'microsoft-365-foundations-8.1.2' do
  title "Ensure users can't send emails to a channel email address"
  desc 'Teams channel email addresses are an optional feature that allows users to email the Teams channel directly.'

  desc 'check',
       "To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Teams select Teams settings.
        3. Under email integration verify that Users can send emails to a channel email address is Off.
    To audit using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to verify the recommended state:
            Get-CsTeamsClientConfiguration -Identity Global | fl AllowEmailIntoChannel
        3. Ensure the returned value is False."

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Teams select Teams settings.
        3. Under email integration set Users can send emails to a channel email address to Off.
    To remediate using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams.
        2. Run the following command to set the recommended state:
            Set-CsTeamsClientConfiguration -Identity Global -AllowEmailIntoChannel $false"

  desc 'rationale',
       'Channel email addresses are not under the tenant’s domain and organizations do not
        have control over the security settings for this email address. An attacker could email
        channels directly if they discover the channel email address.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }, { '7' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/step-by-step-guides/reducing-attack-surface-in-microsoft-teams?view=o365-worldwide#restricting-channel-email-messages-to-approved-domains'
  ref 'https://learn.microsoft.com/en-us/powershell/module/skype/set-csteamsclientconfiguration?view=skype-ps'

  ensure_users_cant_send_emails_script = %{
     Write-Output (Get-CsTeamsClientConfiguration -Identity Global).AllowEmailIntoChannel
  }

  powershell_output = pwsh_single_session_executor(ensure_users_cant_send_emails_script).run_script_in_teams_pnp
  raise Inspec::Error, "The powershell output returned the following error:  #{powershell_output.stderr}" if powershell_output.exit_status != 0

  describe 'Ensure that AllowEmailIntoChannel state' do
    subject { powershell_output.stdout.strip }
    it 'is set to False' do
      expect(subject).to eq('False')
    end
  end
end
