control "microsoft-365-foundations-5.2.2.7" do
  title "Enable Azure AD Identity Protection sign-in risk policies"
  desc 'Microsoft Entra ID Protection sign-in risk detects risks in real-time and offline. A risky sign-in is an indicator for a sign-in attempt that might not have been performed by the legitimate owner of a user account.
        Note: While Identity Protection also provides two risk policies with limited conditions, Microsoft highly recommends setting up risk-based policies in Conditional Access as opposed to the "legacy method" for the following benefits:
            • Enhanced diagnostic data
            • Report-only mode integration
            • Graph API support
            • Use more Conditional Access attributes like sign-in frequency in the policy'

  desc "check",
       "To ensure Sign-In a risk policy is enabled:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click expand Protection > Conditional Access select Policies.
        3. Ensure that a policy exist with the following characteristics and is set to On:
            o Under Users or workload identities choose All users
            o Under Cloud apps or actions choose All cloud apps
            o Under Conditions choose Sign-in risk then Yes ensuring High and Medium are selected.
            o Under Access Controls select Grant then in the right pane click Grant access then select Require multifactor authentication.
            o Under Session select Sign-in Frequency is set to Every time."

  desc "fix",
       "To configure a Sign-In risk policy, use the following steps:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click expand Protection > Conditional Access select Policies.
        3. Create a new policy by selecting New policy.
        4. Set the following conditions within the policy.
            o Under Users or workload identities choose All users
            o Under Cloud apps or actions choose All cloud apps
            o Under Conditions choose Sign-in risk then Yes and check the risk level boxes High and Medium
            o Under Access Controls select Grant then in the right pane click Grant access then select Require multifactor authentication.
            o Under Session select Sign-in Frequency and set to Every time.
        5. Click Select
        6. You may opt to begin in a state of Report Only as you step through implementation however, the policy will need to be set to On to be in effect.
        7. Click Create
    NOTE: for more information regarding risk levels refer to Microsoft's Identity Protection & Risk Doc"

  impact 0.5
  tag severity: "medium"
  tag cis_controls: [{ "8" => ["13.3"] }, { "7" => ["16.13"] }]

  ref "https://learn.microsoft.com/en-us/azure/active-directory/identity-protection/howto-identity-protection-risk-feedback"
  ref "https://learn.microsoft.com/en-us/azure/active-directory/identity-protection/concept-identity-protection-risks"

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
