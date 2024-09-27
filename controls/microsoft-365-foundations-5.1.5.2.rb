control 'microsoft-365-foundations-5.1.5.2' do
  title 'Ensure user consent to apps accessing company data on their behalf is not allowed'
  desc "Control when end users and group owners are allowed to grant consent to applications, and when they will be required to request administrator review and approval. Allowing users to grant apps access to data helps them acquire useful applications and be productive but can represent a risk in some situations if it's not monitored and controlled carefully."

  desc 'check',
       'To audit using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Applications select Enterprise applications.
        3. Under Security select Consent and permissions > User consent settings.
        4. Verify User consent for applications is set to Do not allow user consent.
    To audit using PowerShell:
        1. Connect to Microsoft Graph using Connect-MgGraph -Scopes "Policy.Read.All"
        2. Run the following command:
            (Get-MgPolicyAuthorizationPolicy).DefaultUserRolePermissions | Select-Object -ExpandProperty PermissionGrantPoliciesAssigned
        3. Ensure ManagePermissionGrantsForSelf.microsoft-user-default-low is not present OR that nothing is returned.'

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Applications select Enterprise applications.
        3. Under Security select Consent and permissions > User consent settings.
        4. Under User consent for applications select Do not allow user consent.
        5. Click the Save option at the top of the window."

  desc 'rationale',
       'Attackers commonly use custom applications to trick users into granting them access to
        company data. Disabling future user consent operations setting mitigates this risk, and
        helps to reduce the threat-surface. If user consent is disabled previous consent grants
        will still be honored but all future consent operations must be performed by an
        administrator.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['3.3'] }, { '7' => ['14.6'] }]
  tag nist: ['AC-3', 'AC-5', 'AC-6', 'MP-2', 'AT-2']

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/manage-apps/configure-user-consent?tabs=azure-portal&pivots=portal'

  ensure_user_cant_access_company_data_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $clientSecret = '#{input('client_secret')}'
    Install-Module -Name Microsoft.Graph -Force -AllowClobber
    import-module microsoft.graph
    $password = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
    $ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential($client_id,$password)
    Connect-MgGraph -TenantId "$tenantid" -ClientSecretCredential $ClientSecretCredential -NoWelcome
    (Get-MgPolicyAuthorizationPolicy).DefaultUserRolePermissions | Select-Object -ExpandProperty PermissionGrantPoliciesAssigned
}

  powershell_output = powershell(ensure_user_cant_access_company_data_script)

  describe.one do
    describe powershell_output do
      its('stdout.strip') { should_not include('ManagePermissionGrantsForSelf.microsoft-user-default-low') }
    end

    describe powershell_output do
      its('stdout.strip') { should be_empty }
    end
  end
end
