control 'microsoft-365-foundations-1.1.4' do
    title 'Ensure Guest Users are reviewed at least biweekly'
    desc 'Guest users can be set up for those users not in the organization to still be granted access to resources. It is important to maintain visibility for what guest users are established in the tenant.
        Ensure Guest Users are reviewed no less frequently than biweekly.
        Note: With the E5 license an access review can be configured to review guest accounts automatically on a reoccurring basis. This is the preferred method if the licensing is available.'

    desc 'check'
    'To verify the report is being reviewed at least biweekly, confirm that the necessary procedures are in place and being followed.'

    desc 'fix'
    'To review guest users in the UI:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com/.
        2. Click to expand Users and select Guest Users.
        3. Review the list of users.
    To verify Microsoft 365 audit log search is enabled using Microsoft Graph PowerShell:
        1. Connect using Connect-MgGraph -Scopes "User.Read.All"
        2. Run the following PowerShell command: 
            Get-MgUser -All -Property UserType,UserPrincipalName | Where {$_.UserType -ne "Member"} | Format-Table UserPrincipalName, UserType
        3. Review the list of users. If nothing is returned then there are no guest users.'
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['5.1'] }, {'8' => ['5.3']}, { '7' => ['6.2'] }, {'7' => ['16.6']}]

    describe 'manual' do
        skip 'manual'
