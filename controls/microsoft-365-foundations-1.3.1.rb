control 'microsoft-365-foundations-1.3.1' do
  title "Ensure the 'Password expiration policy' is set to 'Set passwords to never expire (recommended)"
  desc 'Microsoft cloud-only accounts have a pre-defined password policy that cannot be changed. The only items that can change are the number of days until a password expires and whether or whether passwords expire at all.'

  desc 'check',
       'Ensure that Office 365 passwords are set to never expire:
            1. Navigate to Microsoft 365 admin center https://admin.microsoft.com.
            2. Click to expand Settings select Org Settings.
            3. Click on Security & privacy.
            4. Select Password expiration policy ensure that Set passwords to never expire (recommended) has been checked.
        To verify Office 365 Passwords Are Not Set to Expire, use the Microsoft Graph PowerShell module:
            1. Connect to the Microsoft Graph service using Connect-MgGraph -Scopes "Domain.Read.All".
            2. Run the following Microsoft Online PowerShell command:
                Get-MgDomain -DomainId <Domain Name> | ft PasswordValidityPeriodInDays'
  desc 'fix',
       'To set Office 365 passwords are set to never expire:
            1. Navigate to Microsoft 365 admin center https://admin.microsoft.com.
            2. Click to expand Settings select Org Settings.
            3. Click on Security & privacy.
            4. Check the Set passwords to never expire (recommended) box.
            5. Click Save.
        To set Office 365 Passwords Are Not Set to Expire, use the Microsoft Graph PowerShell module:
            1. Connect to the Microsoft Graph service using Connect-MgGraph -Scopes "Domain.ReadWrite.All".
            2. Run the following Microsoft Graph PowerShell command: Update-MgDomain -DomainId <Domain> -PasswordValidityPeriodInDays 2147483647 -PasswordNotificationWindowInDays 30'

  desc 'rationale',
       'Organizations such as NIST and Microsoft have updated their password policy recommendations to not arbitrarily require users to change their passwords after a specific amount of time, unless there is evidence that the password is compromised, or the user forgot it. They suggest this even for single factor (Password Only) use cases, with a reasoning that forcing arbitrary password changes on users actually make the passwords less secure. Other recommendations within this Benchmark suggest the use of MFA authentication for at least critical accounts (at minimum), which makes password expiration even less useful as well as password protection for Entra ID.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['5.2'] }, { '7' => ['4.4'] }]
  tag nist: ['IA-5(1)', 'CA-9', 'SC-7', 'SC-7(5)']

  ref 'https://pages.nist.gov/800-63-3/sp800-63b.html'
  ref 'https://www.cisecurity.org/insights/white-papers/cis-password-policy-guide'
  ref 'https://learn.microsoft.com/en-US/microsoft-365/admin/misc/password-policy-recommendations?view=o365-worldwide'

  password_expiration_days_script = %{
     $client_id = '#{input('client_id')}'
     $tenantid = '#{input('tenant_id')}'
     $clientSecret = '#{input('client_secret')}'
     $organization = '#{input('organization')}'
     Install-Module -Name Microsoft.Graph -Force -AllowClobber
     import-module microsoft.graph
     $password = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
     $ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential($client_id,$password)
     Connect-MgGraph -TenantId $tenantid -ClientSecretCredential $ClientSecretCredential -NoWelcome
     $passwordValidityPeriod = (Get-MgDomain -DomainId $organization).PasswordValidityPeriodInDays
     Write-Output $passwordValidityPeriod
  }
  puts('1.3.1')
  puts(powershell(password_expiration_days_script).stderr)
  puts(password_expiration_days_script)
  require 'pry'
  binding.pry

  powershell_output = powershell(password_expiration_days_script)
  describe 'The password validity period' do
    subject { powershell_output.stdout.to_i }
    it 'should be at integer max value' do
      expect(subject).to cmp(2_147_483_647)
    end
  end
end
