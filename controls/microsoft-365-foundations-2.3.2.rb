control 'microsoft-365-foundations-2.3.2' do
  title 'Ensure non-global administrator role group assignments are reviewed at least weekly'
  desc 'Non-global administrator role group assignments should be reviewed at least every week.'

  desc 'check',
       'To verify non-global administrator role group assignments are being reviewed at least weekly, confirm that the necessary procedures are in place and being followed.'

  desc 'fix',
       "To review non-global administrator role group assignments:
        1.Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2.Click on Audit.
        3.Set Added member to Role and Removed a user from a directory role for Activities.
        4.Set Start Date and End Date.
        5.Click Search.
        6.Review."

  desc 'rationale',
       'While these roles are less powerful than a global admin, they do grant special privileges
        that can be used illicitly. If unusual activity is detected, contact the user to confirm it is a
        legitimate need.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['8.11'] }, { '7' => ['6.2'] }]
  tag nist: ['AU-6', 'AU-6(1)', 'AU-7(1)', 'AC-1', 'AC-2', 'AC-2(1)']

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
