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
  tag default_value: 'EmailAttestationRequired : False
                      EmailAttestationReAuthDays : 30'
  tag cis_controls: [{ '8' => ['untracked'] }, { '7' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-US/sharepoint/what-s-new-in-sharing-in-targeted-release?WT.mc_id=365AdminCSH_spo'
  ref 'https://learn.microsoft.com/en-US/sharepoint/turn-external-sharing-on-or-off?WT.mc_id=365AdminCSH_spo#change-the-organization-level-external-sharing-setting'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/external-identities/one-time-passcode'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
