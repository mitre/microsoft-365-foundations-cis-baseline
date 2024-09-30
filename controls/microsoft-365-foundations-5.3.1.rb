control 'microsoft-365-foundations-5.3.1' do
  title "Ensure 'Privileged Identity Management' is used to manage roles"
  desc 'Microsoft Entra Privileged Identity Management can be used to audit roles, allow just in time activation of roles and allow for periodic role attestation. Organizations should remove permanent members from privileged Office 365 roles and instead make them eligible, through a JIT activation workflow.'

  desc 'check',
       "To audit using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity Governance select Privileged Identity Management.
        3. Select Microsoft Entra Roles.
        4. Select Roles beneath Manage.
        5. Inspect at a minimum the following sensitive roles to ensure the members are Eligible and not Permanent:
            Application Administrator
            Authentication Administrator
            Billing Administrator
            Cloud Application Administrator
            Cloud Device Administrator
            Compliance Administrator
            Customer LockBox Access Approver
            Device Administrators
            Exchange Administrators
            Global Administrators
            HelpDesk Administrator
            Information Protection Administrator
            Intune Service Administrator
            Kaizala Administrator
            License Administrator
            Password Administrator
            PowerBI Service Administrator
            Privileged Authentication Administrator
            Privileged Role Administrator
            Security Administrator
            SharePoint Service Administrator
            Skype for Business Administrator
            Teams Service Administrator
            User Administrator"

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity Governance select Privileged Identity Management.
        3. Select Microsoft Entra Roles.
        4. Select Roles beneath Manage.
        5. Inspect at a minimum the following sensitive roles. For each of the members that have an ASSIGNMENT TYPE of Permanent, click on the ... and choose Make eligible:
            Application Administrator
            Authentication Administrator
            Billing Administrator
            Cloud Application Administrator
            Cloud Device Administrator
            Compliance Administrator
            Customer LockBox Access Approver
            Device Administrators
            Exchange Administrators
            Global Administrators
            HelpDesk Administrator
            Information Protection Administrator
            Intune Service Administrator
            Kaizala Administrator
            License Administrator
            Password Administrator
            PowerBI Service Administrator
            Privileged Authentication Administrator
            Privileged Role Administrator
            Security Administrator
            SharePoint Service Administrator
            Skype for Business Administrator
            Teams Service Administrator
            User Administrator"

  desc 'rationale',
       'Organizations want to minimize the number of people who have access to secure
        information or resources, because that reduces the chance of a malicious actor getting
        that access, or an authorized user inadvertently impacting a sensitive resource.
        However, users still need to carry out privileged operations in Entra ID. Organizations
        can give users just-in-time (JIT) privileged access to roles. There is a need for oversight
        for what those users are doing with their administrator privileges. PIM helps to mitigate
        the risk of excessive, unnecessary, or misused access rights.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['6.1'] }, { '8' => ['6.2'] }, { '7' => ['4.1'] }]
  tag nist: ['IA-4', 'IA-5', 'AC-1', 'AC-2', 'AC-2(1)', 'CM-1', 'CM-2', 'CM-6', 'CM-7', 'CM-7(1)', 'CM-9', 'SA-3', 'SA-8', 'SA-10']

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
