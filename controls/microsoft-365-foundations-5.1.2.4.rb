control 'microsoft-365-foundations-5.1.2.4' do
  title "Ensure 'Restrict access to the Azure AD administration portal' is set to 'Yes'"
  desc "Restrict non-privileged users from signing into the Microsoft Entra admin center.
        Note: This recommendation only affects access to the web portal. It does not prevent privileged users from using other methods such as Rest API or PowerShell to obtain information. Those channels are addressed elsewhere in this document."

  desc 'check',
       "To audit using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/
        2. Click to expand Identity> Users > User settings.
        3. Verify under the Administration center section that Restrict access to Microsoft Entra admin center is set to Yes"

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/
        2. Click to expand Identity> Users > User settings.
        3. Set Restrict access to Microsoft Entra admin center to Yes then Save."

  desc 'rationale',
       "The Microsoft Entra admin center contains sensitive data and permission settings,
        which are still enforced based on the user's role. However, an end user may
        inadvertently change properties or account settings that could result in increased
        administrative overhead. Additionally, a compromised end user account could be used
        by a malicious attacker as a means to gather additional information and escalate an
        attack.
        Note: Users will still be able to sign into Microsoft Entra admin center but will be
        unable to see directory information."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }]
  tag default_value: 'No - Non-administrators can access the Microsoft Entra admin center.'
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/users-default-permissions#restrict-member-users-default-permissions'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
