control 'microsoft-365-foundations-2.3.1' do
  title 'Ensure the Account Provisioning Activity report is reviewed at least weekly'
  desc 'The Account Provisioning Activity report details any account provisioning that was attempted by an external application'

  desc 'check',
       'To verify the report is being reviewed at least weekly, confirm that the necessary procedures are in place and being followed.'

  desc 'fix',
       'To review the Account Provisioning Activity report:
        1.Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2.Click on Audit.
        3.Set Activities to Added user for User administration activities.
        4.Set Start Date and End Date.
        5.Click Search.
        6.Review.
    To review Account Provisioning Activity report using PowerShell:
        1.Connect to Exchange Online using Connect-ExchangeOnline.
        2.Run the following Exchange Online PowerShell command:
            $startDate = ((Get-date).AddDays(-7)).ToShortDateString()
            $endDate = (Get-date).ToShortDateString()
            Search-UnifiedAuditLog -StartDate $startDate -EndDate $endDate | Where-Object
            { $_.Operations -eq "add user." }
        3.Review the output.'

  desc 'rationale',
       "If the organization doesn't usually use a third-party provider to manage accounts, any
        entry on the list is likely illicit. Otherwise, it is recommended to monitor transaction
        volumes and look for new or unusual third party applications that may be managing
        users. If anything unusual is observed, the provider should be contacted to determine
        the legitimacy of the action."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['8.11'] }, { '7' => ['6.2'] }]
  tag nist: ['AU-6', 'AU-6(1)', 'AU-7(1)', 'AC-1', 'AC-2', 'AC-2(1)']

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
