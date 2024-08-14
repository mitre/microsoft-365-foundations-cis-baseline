control 'microsoft-365-foundations-8.4.1' do
  title 'Ensure app permission policies are configured'
  desc 'This policy setting controls which class of apps are available for users to install.'

  desc 'check',
       "To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Teams apps select Manage apps.
        3. In the upper right click Actions > Org-wide app settings.
        4. For Microsoft apps verify that Let users install and use available apps by default is On or less permissive.
        5. For Third-party apps verify Let users install and use available apps by default is Off.
        6. For Custom apps verify Let users install and use available apps by default is Off.
        7. For Custom apps verify Upload custom apps for personal use is Off.
    Note: The Global Reader role is not able to view the Teams apps blade, Teams Administrator or higher is required."

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Teams apps select Manage apps.
        3. In the upper right click Actions > Org-wide app settings.
        4. For Microsoft apps set Let users install and use available apps by default to On or less permissive.
        5. For Third-party apps set Let users install and use available apps by default to Off.
        6. For Custom apps set Let users install and use available apps by default to Off.
        7. For Custom apps set Upload custom apps for personal use to Off."

  desc 'rationale',
       'Allowing users to install third-party or unverified apps poses a potential risk of
        introducing malicious software to the environment.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['2.5'] }, { '7' => ['2.7'] }]
  tag default_value: 'Microsoft apps: On
                      Third-party apps: On
                      Custom apps: On'
  tag nist: ['CM-7(5)', 'CM-10', 'CM-7', 'CM-7(1)', 'SI-7', 'SI-7(1)']

  ref 'https://learn.microsoft.com/en-us/microsoftteams/app-centric-management'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/step-by-step-guides/reducing-attack-surface-in-microsoft-teams?view=o365-worldwide#disabling-third-party--custom-apps'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
