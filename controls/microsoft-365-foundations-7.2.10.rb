control 'microsoft-365-foundations-7.2.10' do
  title 'Ensure reauthentication with verification code is restricted'
  desc "This setting configures if guests who use a verification code to access the site or links are required to reauthenticate after a set number of days.
        The recommended state is 15 or less."

  desc 'check',
       "To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Scroll to and expand More external sharing settings.
        4. Ensure People who use a verification code must reauthenticate after this many days is set to 15 or less.
    To audit using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following cmdlet:
            Get-SPOTenant | fl EmailAttestationRequired,EmailAttestationReAuthDays
        3. Ensure the following values are returned:
            o EmailAttestationRequired True
            o EmailAttestationReAuthDays 15 or less days."

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Scroll to and expand More external sharing settings.
        4. Set People who use a verification code must reauthenticate after this many days to 15 or less.
    To remediate using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following cmdlet:
            Set-SPOTenant -EmailAttestationRequired $true -EmailAttestationReAuthDays 15"

  desc 'rationale',
       'By increasing the frequency of times guests need to reauthenticate this ensures guest
        user access to data is not prolonged beyond an acceptable amount of time.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }, { '7' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-US/sharepoint/what-s-new-in-sharing-in-targeted-release?WT.mc_id=365AdminCSH_spo'
  ref 'https://learn.microsoft.com/en-US/sharepoint/turn-external-sharing-on-or-off?WT.mc_id=365AdminCSH_spo#change-the-organization-level-external-sharing-setting'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/external-identities/one-time-passcode'

  ensure_reauth_with_verification_code_restricted = %(
	  Get-PnPTenant | Select-Object EmailAttestationRequired, EmailAttestationReAuthDays | ConvertTo-Json
  )

  powershell_output = pwsh_single_session_executor(ensure_reauth_with_verification_code_restricted).run_script_in_teams_pnp
  raise Inspec::Error, "The powershell output returned the following error:  #{powershell_output.stderr}" if powershell_output.exit_status != 0

  powershell_output = powershell_output.stdout.strip
  powershell_data = JSON.parse(powershell_output) unless powershell_output.empty?
  describe 'Ensure the following setting' do
    subject { powershell_data }
    its(['EmailAttestationRequired']) { should cmp true }
    its(['EmailAttestationReAuthDays']) { should be <= input('email_attestation_re_auth_days_spo_threshold') }
  end
end
