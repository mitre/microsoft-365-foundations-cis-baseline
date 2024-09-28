control 'microsoft-365-foundations-5.2.3.4' do
  title "Ensure all member users are 'MFA capable'"
  desc "Microsoft defines Multifactor authentication capable as being registered and enabled for a strong authentication method. The method must also be allowed by the authentication methods policy.
        Ensure all member users are MFA capable."

  desc 'check',
       'To audit using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Protection select Authentication methods.
        3. Select User registration details.
        4. Set the filter option Multifactor authentication capable to Not Capable.
        5. Review the non-guest users in this list.
        6. Excluding any exceptions users found in this report may require remediation.
    To audit using PowerShell:
        1. Connect to Graph using Connect-MgGraph -Scopes "UserAuthenticationMethod.Read.All,AuditLog.Read.All"
        2. Run the following:
            Get-MgReportAuthenticationMethodUserRegistrationDetail ` -Filter "IsMfaCapable eq false and UserType eq \'Member\'" | ft UserPrincipalName,IsMfaCapable,IsAdmin
        3. Ensure IsMfaCapable is set to True.
        4. Excluding any exceptions users found in this report may require remediation.
    Note: The CA rule must be in place for a successful deployment of Multifactor Authentication. This policy is outlined in the conditional access section 5.2.2
    Note 2: Possible exceptions include on-premises synchronization accounts.'

  desc 'fix',
       "Remediation steps will depend on the status of the personnel in question or configuration of Conditional Access policies and will not be covered in detail. Administrators should review each user identified on a case-by-case basis using the conditions below. User has never signed on:
        • Employment status should be reviewed, and appropriate action taken on the user account's roles, licensing and enablement.
    Conditional Access policy applicability:
        • Ensure a CA policy is in place requiring all users to use MFA.
        • Ensure the user is not excluded from the CA MFA policy.
        • Ensure the policy's state is set to On.
        • Use What if to determine applicable CA policies. (Protection > Conditional Access > Policies)
        • Review the user account in Sign-in logs. Under the Activity Details pane click the Conditional Access tab to view applied policies.
    Note: Conditional Access is covered step by step in section 5.2.2"

  desc 'rationale',
       'Multifactor authentication requires an individual to present a minimum of two separate
        forms of authentication before access is granted.
        Users who are not MFA Capable have never registered a strong authentication method
        for multifactor authentication that is within policy and may not be using MFA. This could
        be a result of having never signed in, exclusion from a Conditional Access (CA) policy
        requiring MFA, or a CA policy does not exist. Reviewing this list of users will help
        identify possible lapses in policy or procedure.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['6.3'] }, { '7' => ['16.3'] }]
  tag nist: ['IA-2(1)', 'IA-2(2)', 'SI-2']

  ref 'https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.reports/update-mgreportauthenticationmethoduserregistrationdetail?view=graph-powershell-1.0#-ismfacapable'
  ref 'https://learn.microsoft.com/en-us/entra/identity/monitoring-health/how-to-view-applied-conditional-access-policies'
  ref 'https://learn.microsoft.com/en-us/entra/identity/conditional-access/what-if-tool'
  ref 'https://learn.microsoft.com/en-us/entra/identity/authentication/howto-authentication-methods-activity'

  ensure_member_users_mfa_capable_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $clientSecret = '#{input('client_secret')}'
    Install-Module -Name Microsoft.Graph -Force -AllowClobber
    import-module microsoft.graph
    $password = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
    $ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential($client_id,$password)
    Connect-MgGraph -TenantId $tenantid -ClientSecretCredential $ClientSecretCredential -NoWelcome
    Connect-MgGraph -Scopes "UserAuthenticationMethod.Read.All,AuditLog.Read.All"
    $count = Get-MgReportAuthenticationMethodUserRegistrationDetail ` -Filter "IsMfaCapable eq false and UserType eq 'Member'" | Measure-Object
    Write-Output $count.Count
  }
  powershell_output = powershell(ensure_member_users_mfa_capable_script)
  describe 'Ensure count for IsMfaCapable equals false' do
    subject { powershell_output.stdout }
    it 'should be 0 for all member users' do
      expect(subject).to eq(0)
    end
  end
end
