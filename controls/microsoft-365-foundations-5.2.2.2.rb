control 'microsoft-365-foundations-5.2.2.2' do
  title 'Ensure multifactor authentication is enabled for all users'
  desc 'Enable multifactor authentication for all users in the Microsoft 365 tenant. Users will be prompted to authenticate with a second factor upon logging in to Microsoft 365 services. The second factor is most commonly a text message to a registered mobile phone number where they type in an authorization code, or with a mobile application like Microsoft Authenticator.'

  desc 'check',
       "To audit using the UI:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click expand Protection > Conditional Access select Policies.
        3. Review the list of policies and ensure that there is a policy meeting at least the following criteria:
            o Users: Include: All users.
            o Target resources: All cloud apps.
            o Grant: Grant access with Require multifactor authentication checked.
        4. Ensure Enable policy is set to On.
    To audit using SecureScore:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2. Select Secure score.
        3. Select Recommended actions.
        4. Click on Ensure multifactor authentication is enabled for all users.
        5. Review the list of users who do not have MFA configured."

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click expand Protection > Conditional Access select Policies.
        3. Click New policy.
        4. Go to Assignments > Users and groups > Include > select All users (and do not exclude any user).
        5. Select Cloud apps or actions > All cloud apps (and don't exclude any apps).
        6. Access Controls > Grant > Require multi-factor authentication.
        7. Set Enable policy to Report-only or On.
        8. Create.
    Note: Report-only is an acceptable first stage when introducing any CA policy. The control, however, is not complete until the policy is on."

  desc 'rationale',
       'Multifactor authentication requires an individual to present a minimum of two separate
        forms of authentication before access is granted. Multifactor authentication provides
        additional assurance that the individual attempting to gain access is who they claim to
        be. With multifactor authentication, an attacker would need to compromise at least two
        different authentication mechanisms, increasing the difficulty of compromise and thus
        reducing the risk.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['6.3'] }, { '7' => ['16.3'] }]
  tag nist: ['IA-2(1)', 'IA-2(2)', 'SI-2']

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/conditional-access/howto-conditional-access-policy-all-users-mfa'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
