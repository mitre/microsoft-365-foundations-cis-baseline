control 'microsoft-365-foundations-5.2.2.4' do
  title 'Ensure Sign-in frequency is enabled and browser sessions are not persistent for Administrative users'
  desc 'In complex deployments, organizations might have a need to restrict authentication sessions. Conditional Access policies allow for the targeting of specific user accounts. Some scenarios might include:
            • Resource access from an unmanaged or shared device
            • Access to sensitive information from an external network
            • High-privileged users
            • Business-critical applications
        Ensure Sign-in frequency does not exceed 4 hours for E3 tenants, or 24 hours for E5 tenants using Privileged Identity Management.
        Ensure Persistent browser session is set to Never persist
        NOTE: This CA policy can be added to the previous CA policy in this benchmark "Ensure multifactor authentication is enabled for all users in administrative roles"'

  desc 'check',
       "Ensure Sign-in frequency is enabled and browser sessions are not persistent for Administrative users:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Protection > Conditional Access Select Policies.
        3. Review the list of policies and ensure that there is a policy that have Sign-in frequency set to the time determined by your organization and that Persistent browser session is set to Never persistent.
        4. Ensure Sign-in frequency does not exceed 4 hours for E3 tenants. E5 tenants using PIM may be set to a maximum of 24 hours.
            • A list of directory role applying to Administrators can be found in the remediation section."

  desc 'fix',
       "To configure Sign-in frequency and browser sessions persistence for Administrative users:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Protection > Conditional Access Select Policies.
        3. Click New policy
        4. Click Users and groups
        5. Under Include select Select users and groups and then select Directory roles.
        6. At a minimum, select the roles in the section below.
        7. Go to Cloud apps or actions > Cloud apps > Include > select All cloud apps (and don't exclude any apps).
        8. Under Access controls > Grant > select Grant access > check Require multi-factor authentication (and nothing else).
        9. Under Session select Sign-in frequency and set to at most 4 hours for E3 tenants. E5 tenants with PIM can be set to a maximum value of 24 hours.
        10. Check Persistent browser session then select Never persistent in the drop-down menu.
        11. For Enable Policy select On and click Save
    At minimum these directory roles should be included for MFA:
        • Application administrator
        • Authentication administrator
        • Billing administrator
        • Cloud application administrator
        • Conditional Access administrator
        • Exchange administrator
        • Global administrator
        • Global reader
        • Helpdesk administrator
        • Password administrator
        • Privileged authentication administrator
        • Privileged role administrator
        • Security administrator
        • SharePoint administrator
        • User administrator"

  desc 'rationale',
       'Forcing a time out for MFA will help ensure that sessions are not kept alive for an
        indefinite period of time, ensuring that browser sessions are not persistent will help in
        prevention of drive-by attacks in web browsers, this also prevents creation and saving of
        session cookies leaving nothing for an attacker to take.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['4.3'] }, { '7' => ['16.3'] }]
  tag default_value: 'The default configuration for user sign-in frequency is a rolling window of 90 days.'
  tag nist: ['AC-2(5)', 'AC-11', 'AC-11(1)', 'AC-12', 'SI-2']

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/conditional-access/howto-conditional-access-session-lifetime'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
