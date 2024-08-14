control 'microsoft-365-foundations-7.2.9' do
  title 'Ensure guest access to a site or OneDrive will expire automatically'
  desc "This policy setting configures the expiration time for each guest that is invited to the SharePoint site or with whom users share individual files and folders with.
        The recommended state is 30 or less."

  desc 'check',
       "To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Scroll to and expand More external sharing settings.
        4. Ensure Guest access to a site or OneDrive will expire automatically after this many days is checked and set to 30 or less.
    To audit using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following cmdlet:
            Get-SPOTenant | fl ExternalUserExpirationRequired,ExternalUserExpireInDays
        3. Ensure the following values are returned:
            o ExternalUserExpirationRequired is True.
            o ExternalUserExpireInDays is 30 or less."

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Scroll to and expand More external sharing settings.
        4. Set Guest access to a site or OneDrive will expire automatically after this many days to 30
    To remediate using PowerShell:
        1. Connect to SharePoint Online service using Connect-SPOService.
        2. Run the following cmdlet:
            Set-SPOTenant -ExternalUserExpireInDays 30 -ExternalUserExpirationRequired $True"

  desc 'rationale',
       'This setting ensures that guests who no longer need access to the site or link no longer
        have access after a set period of time. Allowing guest access for an indefinite amount of
        time could lead to loss of data confidentiality and oversight.
        Note: Guest membership applies at the Microsoft 365 group level. Guests who have
        permission to view a SharePoint site or use a sharing link may also have access to a
        Microsoft Teams team or security group.'

  impact 0.5
  tag severity: 'medium'
  tag default_value: 'ExternalUserExpirationRequired $false
                      ExternalUserExpireInDays 60 days'
  tag cis_controls: [{ '8' => ['untracked'] }, { '7' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-US/sharepoint/turn-external-sharing-on-or-off?WT.mc_id=365AdminCSH_spo#change-the-organization-level-external-sharing-setting'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/community/sharepoint-security-a-team-effort'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
