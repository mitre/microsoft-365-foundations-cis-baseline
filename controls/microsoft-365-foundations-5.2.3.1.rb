control 'microsoft-365-foundations-5.2.3.1' do
  title 'Ensure Microsoft Authenticator is configured to protect against MFA fatigue'
  desc "Microsoft has released additional settings to enhance the configuration of the Microsoft Authenticator application. These settings provide additional information and context to users who receive MFA passwordless and push requests, such as geographic location the request came from, the requesting application and requiring a number match.
        Ensure the following are Enabled.
            • Require number matching for push notifications
            • Show application name in push and passwordless notifications
            • Show geographic location in push and passwordless notifications
        NOTE: On February 27, 2023 Microsoft started enforcing number matching tenant-wide for all users using Microsoft Authenticator."

  desc 'check',
       "To audit using the UI:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click to expand Protection > Authentication methods select Policies.
        3. Under Method select Microsoft Authenticator.
        4. Under Enable and Target verify the setting is set to Enable.
        5. In the Include tab ensure All users is selected.
        6. In the Exclude tab ensure only valid groups are present (i.e. Break Glass accounts).
        7. Select Configure
        8. Verify the following Microsoft Authenticator settings:
            o Require number matching for push notifications Status is set to Enabled, Target All users
            o Show application name in push and passwordless notifications is set to Enabled, Target All users
            o Show geographic location in push and passwordless notifications is set to Enabled, Target All users
        9. In each setting select Exclude and verify only groups are present (i.e. Break Glass accounts)."

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click to expand Protection > Authentication methods select Policies.
        3. Select Microsoft Authenticator
        4. Under Enable and Target ensure the setting is set to Enable.
        5. Select Configure
        6. Set the following Microsoft Authenticator settings:
            o Require number matching for push notifications Status is set to Enabled, Target All users
            o Show application name in push and passwordless notifications is set to Enabled, Target All users
            o Show geographic location in push and passwordless notifications is set to Enabled, Target All users
        Note: Valid groups such as break glass accounts can be excluded per organization policy."

  desc 'rationale',
       "As the use of strong authentication has become more widespread, attackers have
        started to exploit the tendency of users to experience \"MFA fatigue.\" This occurs when
        users are repeatedly asked to provide additional forms of identification, leading them to
        eventually approve requests without fully verifying the source. To counteract this,
        number matching can be employed to ensure the security of the authentication process.
        With this method, users are prompted to confirm a number displayed on their original
        device and enter it into the device being used for MFA. Additionally, other information
        such as geolocation and application details are displayed to enhance the end user's
        awareness. Among these 3 options, number matching provides the strongest net
        security gain."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['6.4'] }]
  tag default_value: 'Microsoft-managed'
  tag nist: ['AC-19', 'IA-2(1)']

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/authentication/concept-authentication-default-enablement'
  ref 'https://techcommunity.microsoft.com/t5/microsoft-entra-azure-ad-blog/defend-your-users-from-mfa-fatigue-attacks/ba-p/2365677'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/authentication/how-to-mfa-number-match'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
