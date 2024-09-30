control 'microsoft-365-foundations-5.2.2.8' do
  title 'Ensure admin center access is limited to administrative roles'
  desc "When a Conditional Access policy targets the Microsoft Admin Portals cloud app, the policy is enforced for tokens issued to application IDs of the following Microsoft administrative portals:
            • Azure portal
            • Exchange admin center
            • Microsoft 365 admin center
            • Microsoft 365 Defender portal
            • Microsoft Entra admin center
            • Microsoft Intune admin center
            • Microsoft Purview compliance portal
            • Power Platform admin center
            • SharePoint admin center
            • Microsoft Teams admin center
        Microsoft Admin Portals should be restricted to specific pre-determined administrative roles."

  desc 'check',
       "To audit using the UI:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click expand Protection > Conditional Access select Policies.
        3. Inspect and identify existing policies for the parameters below:
            o Users set to Include All Users
            o Users > Exclude Verify Guest or external users and Users and groups contain only a group of PIM eligible users.
            o Users > Exclude Verify Directory Roles only contains administrative roles. See below for details on roles.
            o Target resources Cloud apps Includes Select apps Microsoft Admin Portals.
            o Grant is equal to Block Access
            o Enable policy is set to On
        4. If any of these conditions are not met, then the audit fails.

        In Directory roles > Exclude the role Global Administrator at a minimum should be selected to avoid I.T. being locked out. The organization should pre-determine roles in the exclusion list as there is not a one size fits all. Auditors and system administrators should exercise due diligence balancing operation while exercising least privilege. As the size of the organization increases so will the number of roles being utilized. A an example starting list of Administrator roles can be found under Additional Information
        Note: In order for PIM to function a group of users eligible for PIM roles must be excluded from the policy.

        Additional Information:

        Below is an example list of Administrator roles that could be excluded
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

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click expand Protection > Conditional Access select Policies.
        3. Click New Policy and then name the policy.
        4. Select Users > Include > All Users
        5. Select Users > Exclude > Directory roles and select only administrative roles and a group of PIM eligible users.
        6. Select Target resources select Cloud apps > Select apps then select Microsoft Admin Portals on the right.
        7. Confirm by clicking Select.
        8. Select Grant > Block access and click Select.
        9. Ensure Enable Policy is On or Report-only then click Create.
    Warning: Exclude Global Administrator at a minimum to avoid being locked out. Report-only is a good option to use when testing any Conditional Access policy for the first time. Note: In order for PIM to function a group of users eligible for PIM roles must be excluded from the policy."

  desc 'rationale',
       'By default, users can sign into the various portals but are restricted by what they can
        view. Blocking sign-in to Microsoft Admin Portals enhances security of sensitive data by
        restricting access to privileged users. This mitigates potential exposure due to
        administrative errors or software vulnerabilities introduced by a CSP, as well as acting
        as a defense in depth measure against security breaches.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-cloud-apps#microsoft-admin-portals'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
