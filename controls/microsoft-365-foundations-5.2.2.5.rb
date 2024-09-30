control 'microsoft-365-foundations-5.2.2.5' do
  title "Ensure 'Phishing-resistant MFA strength' is required for Administrators"
  desc "Authentication strength is a Conditional Access control that allows administrators to specify which combination of authentication methods can be used to access a resource. For example, they can make only phishing-resistant authentication methods available to access a sensitive resource. But to access a non-sensitive resource, they can allow less secure multifactor authentication (MFA) combinations, such as password + SMS.
        Microsoft has 3 built-in authentication strengths. MFA strength, Passwordless MFA strength, and Phishing-resistant MFA strength. Ensure administrator roles are using a CA policy with Phishing-resistant MFA strength.
        Administrators can then enroll using one of 3 methods:
            • FIDO2 Security Key
            • Windows Hello for Business
            • Certificate-based authentication (Multi-Factor)
        Note: Additional steps to configure methods such as FIDO2 keys are not covered here but can be found in related MS articles in the references section. The Conditional Access policy only ensures 1 of the 3 methods is used.
        Warning: Administrators should be pre-registered for a strong authentication mechanism before this Conditional Access Policy is enforced. Additionally, as stated elsewhere in the CIS Benchmark a break-glass administrator account should be excluded from this policy to ensure unfettered access in the case of an emergency."

  desc 'check',
       "To audit using the UI:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click expand Protection > Conditional Access select Policies.
        3. Review the list of policies and ensure that there is a policy with the Grant access control set to Require authentication strength (Preview): Phishing-resistant MFA
        4. Ensure the above policy conforms to these settings:
            o Users > Include > Select users and groups > Directory Roles to include at minimum the roles listed in the remediation section.
            o Cloud apps or actions > All cloud apps
            o Grant > Grant Access with Require authentication strength (Preview): Phishing-resistant MFA set.
        5. The policy is set to On."

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click expand Protection > Conditional Access select Policies.
        3. Click New policy.
        4. Go to Users > Users and groups > Include > Select users and groups > Directory roles
        5. Add at least the Directory roles listed after these steps.
        6. Select Cloud apps or actions > All cloud apps (and don't exclude any apps).
        7. Grant > Grant Access with Require authentication strength (Preview): Phishing-resistant MFA
        8. Click `Select'
        9. Set Enable policy to Report-only and click Create
    At minimum these directory roles should be included for the policy:
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
        • User administrator
    Warning: Ensure administrators are pre-registered with strong authentication before enforcing the policy. After which the policy must be set to On."

  desc 'rationale',
       'Sophisticated attacks targeting MFA are more prevalent as the use of it becomes more
        widespread. These 3 methods are considered phishing-resistant as they remove
        passwords from the login workflow. It also ensures that public/private key exchange can
        only happen between the devices and a registered provider which prevents login to fake
        or phishing websites.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['6.5'] }]
  tag nist: ['IA-2(1)']

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-authentication-passwordless#fido2-security-keys'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/authentication/howto-authentication-passwordless-security-key'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-authentication-strengths'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/identity-protection/howto-identity-protection-configure-mfa-policy'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
