control 'microsoft-365-foundations-5.1.2.2' do
  title 'Ensure third party integrated applications are not allowed'
  desc 'App registration allows users to register custom-developed applications for use within the directory.'

  desc 'check',
       'To audit using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Users select Users settings.
        3. Verify Users can register applications is set to No.
        To audit using PowerShell:
        1. Connect to Microsoft Graph using Connect-MgGraph -Scopes "Policy.Read.All"
        2. Run the following command:
            (Get-MgPolicyAuthorizationPolicy).DefaultUserRolePermissions | fl AllowedToCreateApps
        3. Ensure the returned value is False.'

  desc 'fix',
       'To remediate using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Users select Users settings.
        3. Set Users can register applications to No.
        4. Click Save.
    To remediate using PowerShell:
        1. Connect to Microsoft Graph using Connect-MgGraph -Scopes "Policy.ReadWrite.Authorization"
        2. Run the following commands:
            $param = @{ AllowedToCreateApps = "$false" }
            Update-MgPolicyAuthorizationPolicy -DefaultUserRolePermissions $param'

  desc 'rationale',
       'Third-party integrated applications connection to services should be disabled unless
        there is a very clear value and robust security controls are in place. While there are
        legitimate uses, attackers can grant access from breached accounts to third party
        applications to exfiltrate data from your tenancy without having to maintain the breached
        account.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['2.5'] }, { '7' => ['18.4'] }]
  tag default_value: 'Yes (Users can register applications.)'
  tag nist: ['CM-7(5)', 'CM-10']

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/develop/active-directory-how-applications-are-added'

  ensure_third_party_apps_not_allowed_script = %{
  $appName = 'cisBenchmarkL512'
  $client_id = '#{input('client_id')}'
  $tenantid = '#{input('tenant_id')}'
  $clientSecret = '#{input('client_secret')}' #This should not be stored inside of any script; supplied to transmit detail
  import-module microsoft.graph
  $password = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
  $ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential($client_id,$password)
  Connect-MgGraph -TenantId "$tenantid" -ClientSecretCredential $ClientSecretCredential -NoWelcome
  Connect-MgGraph -Scopes "Policy.Read.All" -NoWelcome
  $thirdPartyAllowance = (Get-MgPolicyAuthorizationPolicy).DefaultUserRolePermissions
  Write-Output $thirdPartyAllowance.AllowedToCreateApps
  }

  powershell_output = powershell(ensure_third_party_apps_not_allowed_script)
  describe 'Ensure DefaultUserRolePermissions.AllowedToCreateApps' do
    subject { powershell_output.stdout.strip }
    it 'is set to false' do
      expect(subject).to eq('False')
    end
  end
end
