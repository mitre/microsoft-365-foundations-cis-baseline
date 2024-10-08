control 'microsoft-365-foundations-1.1.1' do
  title 'Ensure Administrative accounts are separate and cloud-only'
  desc "Administrative accounts are special privileged accounts that could have varying levels of access to data, users, and settings. Regular user accounts should never be utilized for administrative tasks and care should be taken, in the case of a hybrid environment, to keep Administrative accounts separated from on-prem accounts. Administrative accounts should not have applications assigned so that they have no access to potentially vulnerable services (EX. email, Teams, SharePoint, etc.) and only access to perform tasks as needed for administrative purposes.
          Ensure administrative accounts are licensed without attached applications and cloud-only."

  desc 'check',
       "Ensure Administrative accounts are separate and cloud-only:
        1.Navigate to Microsoft 365 admin center https://admin.microsoft.com.
        2.Click to expand Users select Active users.
        3.Sort by the Licenses column.
        4.For each user account in an administrative role verify the following:
          - The account is Cloud only (not synced)
          - The account is assigned a license that is not associated with applications i.e. (Microsoft Entra ID P1, Microsoft Entra ID P2)"

  desc 'fix',
       "To created licensed, separate Administrative accounts for Administrative users:
        1.Navigate to Microsoft 365 admin center https://admin.microsoft.com.
        2.Click to expand Users select Active users
        3.Click Add a user.
        4.Fill out the appropriate fields for Name, user, etc.
        5.When prompted to assign licenses select as needed Microsoft Entra ID P1 or Microsoft Entra ID P2, then click Next.
        6.Under the Option settings screen you may choose from several types of Administrative access roles. Choose Admin center access followed by the appropriate role then click"

  desc 'rationale',
       "Security defaults provide secure default settings that we manage on behalf of organizations to keep customers safe until they are ready to manage their own identity security settings.
        For example, doing the following:
          • Requiring all users and admins to register for MFA.
          • Challenging users with MFA - when necessary, based on factors such as location, device, role, and task.
          • Disabling authentication from legacy authentication clients, which can’t do MFA."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['5.4'] }, { '7' => ['4.1'] }]
  tag nist: ['AC-6(2)', 'CM-1', 'CM-2', 'CM-6', 'CM-7', 'CM-7(1)', 'CM-9', 'SA-3', 'SA-8', 'SA-10']

  ref 'https://learn.microsoft.com/en-us/microsoft-365/admin/add-users/add-users?view=o365-worldwide'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/enterprise/protect-your-global-administrator-accounts?view=o365-worldwide'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/roles/best-practices#9-use-cloud-native-accounts-for-azure-ad-roles'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/whatis'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
