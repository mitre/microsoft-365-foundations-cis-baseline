control 'microsoft-365-foundations-5.1.8.1' do
  title 'Ensure that password hash sync is enabled for hybrid deployments'
  desc "Password hash synchronization is one of the sign-in methods used to accomplish hybrid identity synchronization. Microsoft Entra Connect synchronizes a hash, of the hash, of a user's password from an on-premises Active Directory instance to a cloud-based Entra ID instance.
        Note: Audit and remediation procedures in this recommendation only apply to Microsoft 365 tenants operating in a hybrid configuration using Entra Connect sync."

  desc 'check',
       'To audit using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Hybrid management > Microsoft Entra Connect.
        3. Select Connect Sync
        4. Under Microsoft Entra Connect sync, verify Password Hash Sync is Enabled.
    To audit for the on-prem tool:
        1. Log in to the server that hosts the Microsoft Entra Connect tool.
        2. Run Azure AD Connect, and then click Configure and View or export current configuration.
        3. Determine whether PASSWORD HASH SYNCHRONIZATION is enabled on your tenant.
    This information is also available via the Microsoft Graph Security API:
        GET https://graph.microsoft.com/beta/security/secureScores
    To audit using PowerShell:
        1. Connect to the Microsoft Graph service using Connect-MgGraph -Scopes "Organization.Read.All".
        2. Run the following Microsoft Graph PowerShell command:
            Get-MgOrganization | ft OnPremisesSyncEnabled
        3. If nothing returns then password sync is not enabled for the on premises AD.'

  desc 'fix',
       "To setup Password Hash Sync, use the following steps:
        1. Log in to the on premises server that hosts the Microsoft Entra Connect tool
        2. Double-click the Azure AD Connect icon that was created on the desktop
        3. Click Configure.
        4. On the Additional tasks page, select Customize synchronization options and click Next.
        5. Enter the username and password for your global administrator.
        6. On the Connect your directories screen, click Next.
        7. On the Domain and OU filtering screen, click Next.
        8. On the Optional features screen, check Password hash synchronization and click Next.
        9. On the Ready to configure screen click Configure.
        10. Once the configuration completes, click Exit."

  desc 'rationale',
       "Password hash synchronization helps by reducing the number of passwords your users
        need to maintain to just one and enables leaked credential detection for your hybrid
        accounts. Leaked credential protection is leveraged through Entra ID Protection and is a
        subset of that feature which can help identify if an organization's user account
        passwords have appeared on the dark web or public spaces.
        Using other options for your directory synchronization may be less resilient as Microsoft
        can still process sign-ins to 365 with Hash Sync even if a network connection to your
        on-premises environment is not available."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['6.7'] }, { '7' => ['16.4'] }]
  tag nist: ['AC-2(1)', 'AC-3', 'CM-8']

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/hybrid/whatis-phs'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/identity-protection/concept-identity-protection-risks#user-linked-detections'
  ref 'https://www.microsoft.com/en-us/download/details.aspx?id=47594'

  ensure_password_hash_enabled_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $clientSecret = '#{input('client_secret')}'
    Install-Module -Name Microsoft.Graph -Force -AllowClobber
    import-module microsoft.graph
    $password = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
    $ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential($client_id,$password)
    Connect-MgGraph -TenantId $tenantid -ClientSecretCredential $ClientSecretCredential -NoWelcome
    $onPremisesSyncEnabled = (Get-MgOrganization).OnPremisesSyncEnabled
    Write-Output $onPremisesSyncEnabled
  }

  powershell_output = powershell(ensure_password_hash_enabled_script)
  describe 'Ensure OnPremisesSyncEnabled count' do
    subject { powershell_output.stdout.strip }
    it 'should not be empty' do
      expect(subject).not_to be_empty
    end
  end
end
