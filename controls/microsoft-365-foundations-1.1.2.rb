control 'microsoft-365-foundations-1.1.2' do
  title 'Ensure two emergency access accounts have been defined'
  desc 'Emergency access or "break glass" accounts are limited for emergency scenarios where normal administrative accounts are unavailable. They are not assigned to a specific user and will have a combination of physical and technical controls to prevent them from being accessed outside a true emergency. These emergencies could be due to several things, including:
        - Technical failures of a cellular provider or Microsoft related service such as MFA.
        - The last remaining Global Administrator account is inaccessible.
        - Ensure two Emergency Access accounts have been defined.
        - Note: Microsoft provides several recommendations for these accounts and how to configure them. For more information on this, please refer to the references section. The CIS Benchmark outlines the more critical things to consider.'
  desc 'check',
       "Step 1 - Ensure a policy and procedure is in place at the organization:
          - In order for accounts to be effectively used in a break-glass situation the proper policies and procedures must be authorized and distributed by senior management.
          - FIDO2 Security Keys, if used, should be locked in a secure separate fireproof location.
          - Passwords should be at least 16 characters, randomly generated and MAY be separated in multiple pieces to be joined on emergency.
        Step 2 - Ensure two emergency access accounts are defined:
            1. Navigate to Microsoft 365 admin center https://admin.microsoft.com
            2. Expand Users > Active Users
            3. Inspect the designated emergency access accounts and ensure the following:
              - The accounts are named correctly, and do NOT identify with a particular person.
              - The accounts use the default .onmicrosoft.com domain and not the organization's.
              - The accounts are cloud-only.
              - The accounts are unlicensed.
              - The accounts are assigned the Global Administrator directory role.
        Step 3 - Ensure at least one account is excluded from all conditional access rules:
        1. Navigate Microsoft Entra admin center https://entra.microsoft.com/
        2. Expand Protection > Conditional Access.
        3. Inspect the conditional access rules.
        4. Ensure one of the emergency access accounts is excluded from all rules."
  desc 'fix',
       "Step 1 - Create two emergency access accounts:
            1. Navigate to Microsoft 365 admin center https://admin.microsoft.com
            2. Expand Users > Active Users
            3. Click Add user and create a new user with this criteria:
              - Name the account in a way that does NOT identify it with a particular person.
              - Assign the account to the default .onmicrosoft.com domain and not the organization's.
              - The password must be at least 16 characters and generated randomly.
              - Do not assign a license.
              - Assign the user the Global Administrator role.
            4. Repeat the above steps for the second account.
        Step 2 - Exclude at least one account from conditional access policies:
            1. Navigate Microsoft Entra admin center https://entra.microsoft.com/
            2. Expand Protection > Conditional Access.
            3. Inspect the conditional access policies.
            4. For each rule add an exclusion for at least one of the emergency access accounts.
            5. Users > Exclude > Users and groups and select one emergency access account.
        Step 3 - Ensure the necessary procedures and policies are in place:
            * In order for accounts to be effectively used in a break glass situation the proper policies and procedures must be authorized and distributed by senior management.
            * FIDO2 Security Keys, if used, should be locked in a secure separate fireproof location.
            * Passwords should be at least 16 characters, randomly generated and MAY be separated in multiple pieces to be joined on emergency.
        Note: Additional suggestions for emergency account management:
            * Create access reviews for these users.
            * Exclude users from conditional access rules.
        Warning: If CA (conditional access) exclusion is managed by a group, this group should be added to PIM for groups (licensing required) or be created as a role-assignable group. If it is a regular security group, then users with the Group Administrators role are able to bypass CA entirely."

  desc 'rationale',
       'Multi-factor authentication requires an individual to present a minimum of two separate forms of authentication before access is granted. Multi-factor authentication provides additional assurance that the individual attempting to gain access is who they claim to be. With multi-factor authentication, an attacker would need to compromise at least two different authentication mechanisms, increasing the difficulty of compromise and thus reducing the risk.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['5.1'] }]
  tag nist: ['AC-2']

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/roles/security-planning#stage-1-critical-items-to-do-right-now'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/roles/security-emergency-access'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
