control 'microsoft-365-foundations-5.2.6.1' do
  title "Ensure the Azure AD 'Risky sign-ins' report is reviewed at least weekly"
  desc "This report contains records of accounts that have had activity that could indicate they are compromised, such as accounts that have:
        • Successfully signed in after multiple failures, which is an indication that the accounts have cracked passwords.
        • Signed in to tenant from a client IP address that has been recognized by Microsoft as an anonymous proxy IP address (such as a TOR network).
        • Successful sign-ins from users where two sign-ins appeared to originate from different regions and the time between sign-ins makes it impossible for the user to have traveled between those regions."

  desc 'check',
       'To verify the report is being reviewed at least weekly, confirm that the necessary procedures are in place and being followed.'

  desc 'fix',
       "To review the 'Risky sign-ins' report:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click expand Protection select Risky activities.
        3. Under Report click on Risky sign-ins.
        4. Review by Risk level (aggregate)."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['8.11'] }, { '7' => ['6.2'] }]

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/identity-protection/overview-identity-protection'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/identity-protection/howto-identity-protection-remediate-unblock'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
