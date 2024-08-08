control 'microsoft-365-foundations-6.5.1' do
    title 'Ensure modern authentication for Exchange Online is enabled'
    desc 'Modern authentication in Microsoft 365 enables authentication features like multifactor authentication (MFA) using smart cards, certificate-based authentication (CBA), and third-party SAML identity providers. When you enable modern authentication in Exchange Online, Outlook 2016 and Outlook 2013 use modern authentication to log in to Microsoft 365 mailboxes. When you disable modern authentication in Exchange Online, Outlook 2016 and Outlook 2013 use basic authentication to log in to Microsoft 365 mailboxes.
        When users initially configure certain email clients, like Outlook 2013 and Outlook 2016, they may be required to authenticate using enhanced authentication mechanisms, such as multifactor authentication. Other Outlook clients that are available in Microsoft 365 (for example, Outlook Mobile and Outlook for Mac 2016) always use modern authentication to log in to Microsoft 365 mailboxes.'

    desc 'check'
    'To audit using PowerShell:
        1. Run the Microsoft Exchange Online PowerShell Module.
        2. Connect to Exchange Online using Connect-ExchangeOnline.
        3. Run the following PowerShell command: 
            Get-OrganizationConfig | Format-Table -Auto Name, OAuth*
        4. Verify OAuth2ClientProfileEnabled is True.'
    
    desc 'fix'
    'To remediate using PowerShell:
        1. Run the Microsoft Exchange Online PowerShell Module.
        2. Connect to Exchange Online using Connect-ExchangeOnline.
        3. Run the following PowerShell command: 
            Set-OrganizationConfig -OAuth2ClientProfileEnabled $True'
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['3.10'] }, { '7' => ['16.3'] }, { '7' => ['16.5'] }]

    ref 'https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/enable-or-disable-modern-authentication-in-exchange-online'
end
    