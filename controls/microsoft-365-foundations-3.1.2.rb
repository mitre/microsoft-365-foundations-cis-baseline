control 'microsoft-365-foundations-3.1.2' do
  title 'Ensure user role group changes are reviewed at least weekly'
  desc 'Role-Based Access Control allows for permissions to be assigned to users based on their roles within an organization. It is a more manageable form of access control that is less prone to errors. These user roles can be audited inside of Microsoft Purview to provide a security auditor insight into user privilege change.'

  desc 'check',
       'To verify user role group changes are being reviewed at least weekly, confirm that the necessary procedures are in place and being followed.'

  desc 'fix',
       'To review user role group changes:
        1. Navigate to Microsoft Purview https://compliance.microsoft.com/.
        2. Under Solutions click on Audit then select New Search.
        3. In Activities find Added member to Role under the Role administration activities section and select it.
        4. Set a valid Start Date and End Date within the last week.
        5. Click Search.
        6. Review once the search is completed.
    To review user role group changes using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline
        2. Run the following Exchange Online PowerShell command:
            $startDate = ((Get-date).AddDays(-7)).ToShortDateString()
            $endDate = (Get-date).ToShortDateString()
            Search-UnifiedAuditLog -StartDate $startDate -EndDate $endDate -RecordType
            AzureActiveDirectory -Operations "Add member to role."
        3. Review the output.'

  desc 'rationale',
       'Weekly reviews provide an opportunity to identify rights changes in an organization and
        are a large part of maintaining Least Privilege and preventing Privilege creep. Insider
        Threats, either intentional or unintentional, can occur when a user has higher than
        needed privileges. Maintaining accountability of role membership will keep insiders and
        malicious actors limited in the scope of potential damaging activities.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['8.11'] }, { '7' => ['6.2'] }]
  tag nist: ['AU-6', 'AU-6(1)', 'AU-7(1)', 'AC-1', 'AC-2', 'AC-2(1)']

  ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/search-unifiedauditlog?view=exchange-ps'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
