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

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['5.2'] }, { '7' => ['4.4'] }]

  ref 'https://pages.nist.gov/800-63-3/sp800-63b.html'
  ref 'https://www.cisecurity.org/insights/white-papers/cis-password-policy-guide'
  ref 'https://learn.microsoft.com/en-US/microsoft-365/admin/misc/password-policy-recommendations?view=o365-worldwide'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
