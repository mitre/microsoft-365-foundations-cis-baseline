control 'microsoft-365-foundations-5.2.4.2' do
    title 'Ensure the self-service password reset activity report is reviewed at least weekly'
    desc 'The Microsoft 365 platform allows users to reset their password in the event they forget it. The self-service password reset activity report logs each time a user successfully resets their password this way. The self-service password reset activity report should be reviewed at least weekly.'

    desc 'check'
    'To verify the report is being reviewed at least weekly, confirm that the necessary procedures are in place and being followed.'

    desc 'fix'
    'To review the self-service password reset activity report:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Protection > Password reset select Audit logs.
        3. Review the list of users who have reset their passwords by setting the Date to Last 7 days and Service to Self-service Password Management'
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['8.11'] }, { '7' => ['6.2'] }]

    ref 'https://learn.microsoft.com/en-us/azure/active-directory/authentication/howto-sspr-reporting'
    ref 'https://learn.microsoft.com/en-us/azure/active-directory/authentication/troubleshoot-sspr'

    describe 'manual' do
        skip 'manual'