control 'microsoft-365-foundations-1.2.1' do
  title 'Ensure that only organizationally managed/approved public groups exist'
  desc 'Microsoft 365 Groups is the foundational membership service that drives all teamwork across Microsoft 365. With Microsoft 365 Groups, you can give a group of people access to a collection of shared resources. While there are several different group types this recommendation concerns Microsoft 365 Groups.
        In the Administration panel, when a group is created, the default privacy value is "Public".'

  desc 'check',
       'Ensure only organizationally managed/approved public groups exist:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com.
        2. Click to expand Teams & groups select Active teams & groups.
        3. On the Active teams and groups page, check that no groups have the status \'Public\' in the privacy column.
    Using the Microsoft Graph PowerShell module:
        1. Connect to the Microsoft Graph service using Connect-MgGraph -Scopes "Group.Read.All".
        2. Run the following Microsoft Graph PowerShell command:
            Get-MgGroup | where {$_.Visibility -eq "Public"} | select DisplayName,Visibility
        3. Ensure Visibility is Private for each group.'

  desc 'fix',
       "To enable only organizationally managed/approved public groups exist:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com.
        2. Click to expand Teams & groups select Active teams & groups..
        3. On the Active teams and groups page, select the group's name that is public.
        4. On the popup groups name page, Select Settings.
        5. Under Privacy, select Private."

  desc 'rationale',
       'Defining trusted source IP addresses or ranges helps organizations create and enforce Conditional Access policies around those trusted or untrusted IP addresses and ranges. Users authenticating from trusted IP addresses and/or ranges may have less access restrictions or access requirements when compared to users that try to authenticate to Microsoft Entra ID from untrusted locations or untrusted source IP addresses/ranges.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['3.3'] }, { '7' => ['13.1'] }]
  tag nist: ['AC-3', 'AC-5', 'AC-6', 'MP-2', 'AU-6(1)', 'AU-7', 'IR-4(1)', 'SI-4(2)', 'SI-4(5)']

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/enterprise-users/groups-self-service-management'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/admin/create-groups/compare-groups?view=o365-worldwide'

  all_groups_private_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $clientSecret = '#{input('client_secret')}'
    Install-Module -Name Microsoft.Graph -Force -AllowClobber
    import-module microsoft.graph
    $password = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
    $ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential($client_id,$password)
    Connect-MgGraph -TenantId "$tenantid" -ClientSecretCredential $ClientSecretCredential -NoWelcome
    # Determine Id of role using the immutable RoleTemplateId value.
    Write-Host (Get-MgGroup | where {$_.Visibility -eq "Public"} | select DisplayName,Visibility).Count
  }

  powershell_output = powershell(all_groups_private_script)
  describe 'Public groups count' do
    subject { powershell_output.stdout.to_i }
    it 'should be 0' do
      expect(subject).to cmp(0)
    end
  end
end
