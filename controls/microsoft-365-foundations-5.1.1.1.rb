control 'microsoft-365-foundations-5.1.1.1' do
  title 'Ensure Security Defaults is disabled on Azure Active Directory'
  desc "Security defaults in Microsoft Entra ID make it easier to be secure and help protect the organization. Security defaults contain preconfigured security settings for common attacks.
        By default, Microsoft enables security defaults. The goal is to ensure that all organizations have a basic level of security enabled. The security default setting is manipulated in the Azure Portal.
        The use of security defaults, however, will prohibit custom settings which are being set with more advanced settings from this benchmark."

  desc 'check',
       'Ensure security defaults is disabled:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com.
        2. Click to expand Identity select Overview
        3. Click Properties.
        4. Review the section Security Defaults near the bottom
        5. If Manage security defaults appears clickable then proceed to the remediation section, otherwise read the note below.
    NOTE: If Manage Conditional Access appears in blue then Security defaults are already disabled, and CA is in use. The audit can be considered a Pass.
        To verify security defaults is disabled using Microsoft Graph PowerShell:
        1. Connect to the Microsoft Graph service using Connect-MgGraph -Scopes "Policy.Read.All".
        2. Run the following Microsoft Graph PowerShell command:
            Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy | ft IsEnabled
        3. If the value is false then Security Defaults is disabled.'

  desc 'fix',
       'To disable security defaults:
        1. Navigate to the Microsoft Entra admin center https://entra.microsoft.com.
        2. Click to expand Identity select Overview
        3. Click Properties.
        4. Click Manage security defaults.
        5. Set the Security defaults dropdown to Disabled.
        6. Select Save.
    To configure security defaults using Microsoft Graph PowerShell:
        1. Connect to the Microsoft Graph service using Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess".
        2. Run the following Microsoft Graph PowerShell command:
            $params = @{ IsEnabled = $false }
            Update-MgPolicyIdentitySecurityDefaultEnforcementPolicy -BodyParameter $params
    Warning: It is recommended not to disable security defaults until you are ready to implement conditional access rules in the benchmark. Rules such as requiring MFA for all users and blocking legacy protocols are required in CA to make up for the gap created by disabling defaults. Plan accordingly. See the reference section for more details on what coverage Security Defaults provide.'

  desc 'rationale',
       'Security defaults provide secure default settings that are managed on behalf of
        organizations to keep customers safe until they are ready to manage their own identity
        security settings.
        For example, doing the following:
          • Requiring all users and admins to register for MFA.
          • Challenging users with MFA - mostly when they show up on a new device or app,
        but more often for critical roles and tasks.
          • Disabling authentication from legacy authentication clients, which can’t do MFA.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['untracked'] }]
  tag nist: ['CM-6']

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/concept-fundamentals-security-defaults'
  ref 'https://techcommunity.microsoft.com/t5/azure-active-directory-identity/introducing-security-defaults/ba-p/1061414'

  ensure_security_defaults_disabled_script = %{
    $client_id = '#{input('client_id')}'
    $tenantid = '#{input('tenant_id')}'
    $clientSecret = '#{input('client_secret')}'
    Install-Module -Name Microsoft.Graph -Force -AllowClobber
    import-module microsoft.graph
    $password = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
    $ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential($client_id,$password)
    Connect-MgGraph -TenantId "$tenantid" -ClientSecretCredential $ClientSecretCredential -NoWelcome
    Connect-MgGraph -Scopes "Policy.Read.All" -NoWelcome
    Write-Output (Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy).IsEnabled
    }

  powershell_output = powershell(ensure_security_defaults_disabled_script)
  describe 'Ensure security defaults option MgPolicyIdentitySecurityDefaultEnforcementPolicy on Azure Active Directory' do
    subject { powershell_output.stdout.strip }
    it 'is disabled' do
      expect(subject).to eq('False')
    end
  end
end
