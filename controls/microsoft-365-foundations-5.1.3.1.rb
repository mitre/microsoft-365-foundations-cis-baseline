control 'microsoft-365-foundations-5.1.3.1' do
  title 'Ensure a dynamic group for guest users is created'
  desc "A dynamic group is a dynamic configuration of security group membership for Microsoft Entra ID. Administrators can set rules to populate groups that are created in Entra ID based on user attributes (such as userType, department, or country/region). Members can be automatically added to or removed from a security group based on their attributes.
        The recommended state is to create a dynamic group that includes guest accounts."

  desc 'check',
       'Ensure a dynamic guest group is created:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Groups select All groups.
        3. On the right of the search field click Add filter.
        4. Set Filter to Membership type and Value to Dynamic then apply.
        5. Identify a dynamic group and select it.
        6. Under manage, select Dynamic membership rules and ensure the rule syntax contains (user.userType -eq "Guest")
        7. If necessary, inspect other dynamic groups for the value above.
    Using PowerShell:
        1. Connect to Microsoft Graph using Connect-MgGraph -Scopes "Group.Read.All"
        2. Run the following commands:
            $groups = Get-MgGroup | Where-Object { $_.GroupTypes -contains "DynamicMembership" }
            $groups | ft DisplayName,GroupTypes,MembershipRule
        3. Look for a dynamic group containing the rule (user.userType -eq "Guest")'

  desc 'fix',
       %q{Create a dynamic guest group:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Groups select All groups.
        3. Select New group and assign the following values:
            o Group type: Security
            o Microsoft Entra roles can be assigned to the group: No
            o Membership type: Dynamic User
        4. Select Add dynamic query.
        5. Above the Rule syntax text box, select Edit.
        6. Place the following expression in the box:
            (user.userType -eq "Guest")
        7. Select OK and Save
    Using PowerShell:
        1. Connect to Microsoft Graph using Connect-MgGraph -Scopes "Group.ReadWrite.All"
        2. In the script below edit DisplayName and MailNickname as needed and run:
            $params = @{ DisplayName = "Dynamic Test Group" MailNickname = "DynGuestUsers" MailEnabled = $false SecurityEnabled = $true GroupTypes = "DynamicMembership" MembershipRule = '(user.userType -eq "Guest")' MembershipRuleProcessingState = "On" } New-MgGroup @params}

  desc 'rationale',
       'Dynamic groups allow for an automated method to assign group membership.
        Guest user accounts will be automatically added to this group and through this existing
        conditional access rules, access controls and other security measures will ensure that
        new guest accounts are restricted in the same manner as existing guest accounts.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['3.3'] }]
  tag nist: ['AC-3', 'AC-5', 'AC-6', 'MP-2']

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/enterprise-users/groups-create-rule'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/enterprise-users/groups-dynamic-membership'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/external-identities/use-dynamic-groups'

  ensure_dynamic_group_for_guest_users_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $clientSecret = '#{input('client_secret')}'
    import-module microsoft.graph
    $password = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
    $ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential($client_id,$password)
    Connect-MgGraph -TenantId "$tenantid" -ClientSecretCredential $ClientSecretCredential -NoWelcome
    $groups = Get-MgGroup | Where-Object { $_.GroupTypes -contains "DynamicMembership" -and $_.MembershipRule -notmatch '(user.userType -eq "guest")'}
    $groups | ft DisplayName
  }

  powershell_output = powershell(ensure_dynamic_group_for_guest_users_script).stdout.strip.split("\n").drop(2).count
  describe 'Ensure the number of dyanmic groups without guests' do
    subject { powershell_output }
    it 'should be 0' do
      expect(subject).to eq 0
    end
  end
end
