control 'microsoft-365-foundations-6.5.1' do
  title 'Ensure modern authentication for Exchange Online is enabled'
  desc "Modern authentication in Microsoft 365 enables authentication features like multifactor authentication (MFA) using smart cards, certificate-based authentication (CBA), and third-party SAML identity providers. When you enable modern authentication in Exchange Online, Outlook 2016 and Outlook 2013 use modern authentication to log in to Microsoft 365 mailboxes. When you disable modern authentication in Exchange Online, Outlook 2016 and Outlook 2013 use basic authentication to log in to Microsoft 365 mailboxes.
        When users initially configure certain email clients, like Outlook 2013 and Outlook 2016, they may be required to authenticate using enhanced authentication mechanisms, such as multifactor authentication. Other Outlook clients that are available in Microsoft 365 (for example, Outlook Mobile and Outlook for Mac 2016) always use modern authentication to log in to Microsoft 365 mailboxes."

  desc 'check',
       "To audit using PowerShell:
        1. Run the Microsoft Exchange Online PowerShell Module.
        2. Connect to Exchange Online using Connect-ExchangeOnline.
        3. Run the following PowerShell command:
            Get-OrganizationConfig | Format-Table -Auto Name, OAuth*
        4. Verify OAuth2ClientProfileEnabled is True."

  desc 'fix',
       "To remediate using PowerShell:
        1. Run the Microsoft Exchange Online PowerShell Module.
        2. Connect to Exchange Online using Connect-ExchangeOnline.
        3. Run the following PowerShell command:
            Set-OrganizationConfig -OAuth2ClientProfileEnabled $True"

  desc 'rationale',
       'Strong authentication controls, such as the use of multifactor authentication, may be
        circumvented if basic authentication is used by Exchange Online email clients such as
        Outlook 2016 and Outlook 2013. Enabling modern authentication for Exchange Online
        ensures strong authentication mechanisms are used when establishing sessions
        between email clients and Exchange Online.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [
    { '8' => ['3.10'] },
    { '7' => ['16.3'] },
    { '7' => ['16.5'] }
  ]
  tag nist: ['AC-17(2)', 'IA-5', 'IA-5(1)', 'SC-8', 'SC-8(1)', 'SI-2', 'SR-11']

  ref 'https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/enable-or-disable-modern-authentication-in-exchange-online'

  ensure_modern_authentication_for_exchange_enabled_script = %{
    $client_id = '#{input('client_id')}'
    $certificate_password = '#{input('certificate_password')}'
    $certificate_path = '#{input('certificate_path')}'
    $organization = '#{input('organization')}'
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
    import-module exchangeonlinemanagement
    Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
    (Get-OrganizationConfig).OAuth2ClientProfileEnabled
 }

  powershell_output = powershell(ensure_modern_authentication_for_exchange_enabled_script)
  describe 'Ensure the OAuth2ClientProfileEnabled state from Get-OrganizationConfig' do
    subject { powershell_output.stdout.strip }
    it 'is set to True' do
      expect(subject).to eq('True')
    end
  end
end
