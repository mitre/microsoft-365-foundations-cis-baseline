control 'microsoft-365-foundations-5.2.2.1' do
    title 'Ensure multifactor authentication is enabled for all users in administrative roles'
    desc 'Multifactor authentication is a process that requires an additional form of identification during the sign-in process, such as a code from a mobile device or a fingerprint scan, to enhance security.
        Ensure users in administrator roles have MFA capabilities enabled.'
    
    desc 'check'
    'To audit using the UI:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click to expand Protection > Conditional Access select Policies.
        3. Review the list of policies and ensure that there is a policy meeting at least the following criteria:
            o Users: Include: Directory roles specific to administrators are selected.
            o Target resources: All cloud apps.
            o Grant: Grant access with Require multifactor authentication checked.
        4. Ensure Enable policy is set to On.
    To audit using SecureScore:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2. Select Secure score.
        3. Select Recommended actions.
        4. Click on Ensure multifactor authentication is enabled for all users in administrative roles.
        5. Review the number of Admin users who do not have MFA configured.
    This information is also available via the Microsoft Graph Security API: 
        GET https://graph.microsoft.com/beta/security/secureScores
    Note: A list of required Directory roles can be found in the Remediation section.'

    desc 'fix'
    "To remediate using the UI:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click expand Protection > Conditional Access select Policies.
        3. Click New policy.
        4. Go to Assignments > Users and groups > Include > Select users and groups > check Directory roles.
        5. At a minimum, select the Directory roles listed below in this section of the document.
        6. Go to Cloud apps or actions > Cloud apps > Include > select All cloud apps (and don't exclude any apps).
        7. Under Access controls > Grant > select Grant access > check Require multi-factor authentication.
        8. Set Enable policy to Report-only or On.
        9. Create.
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
        • User administrator
    Note: Report-only is an acceptable first stage when introducing any CA policy. The control, however, is not complete until the policy is on."

    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['6.5'] }, { '7' => ['16.3'] }]

    ref 'https://learn.microsoft.com/en-us/graph/api/resources/security-api-overview?view=graph-rest-beta'

    describe 'manual' do
        skip 'manual'
    end
end
    