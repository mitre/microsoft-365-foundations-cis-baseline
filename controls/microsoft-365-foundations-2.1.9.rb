control 'microsoft-365-foundations-2.1.9' do
    title 'Ensure that DKIM is enabled for all Exchange Online Domains'
    desc "DKIM is one of the trio of Authentication methods (SPF, DKIM and DMARC) that help prevent attackers from sending messages that look like they come from your domain.
        DKIM lets an organization add a digital signature to outbound email messages in the message header. When DKIM is configured, the organization authorizes it's domain to associate, or sign, its name to an email message using cryptographic authentication. Email systems that get email from this domain can use a digital signature to help verify whether incoming email is legitimate.
        Use of DKIM in addition to SPF and DMARC to help prevent malicious actors using spoofing techniques from sending messages that look like they are coming from your domain."
    
    desc 'check'
    "To ensure DKIM is enabled:
        1.Navigate to Microsoft 365 Defender https://security.microsoft.com/
        2.Expand Email & collaboration > Policies & rules > Threat policies.
        3.Under Rules section click Email authentication settings.
        4.Select DKIM
        5.Click on each domain and confirm that Sign messages for this domain with DKIM signatures is Enabled.
        6.A status of Not signing DKIM signatures for this domain is an audit fail.
    To verify DKIM is enabled, use the Exchange Online PowerShell Module:
        1.Connect to Exchange Online service using Connect-ExchangeOnline.
        2.Run the following Exchange Online PowerShell command: Get-DkimSigningConfig
        3.Verify Enabled is set to True"
    
    desc 'fix'
    "To setup DKIM records, first add the following records to your DNS system, for each domain in Exchange Online that you plan to use to send email with:
        1. For each accepted domain in Exchange Online, two DNS entries are required. 
        Host name: selector1._domainkey 
        Points to address or value: selector1-
        <domainGUID>._domainkey.<initialDomain> 
        TTL: 3600 
        Host name: selector2._domainkey 
        Points to address or value: selector2-
        <domainGUID>._domainkey.<initialDomain>
        TTL: 3600
    For Office 365, the selectors will always be selector1 or selector2. domainGUID is the same as the domainGUID in the customized MX record for your custom domain that appears before mail.protection.outlook.com. For example, in the following MX record for the domain contoso.com, the domainGUID is contoso-com: contoso.com. 3600 IN MX 5 contoso-com.mail.protection.outlook.com
    The initial domain is the domain that you used when you signed up for Office 365. Initial domains always end in on microsoft.com.
        1.After the DNS records are created, enable DKIM signing in Defender.
        2.Navigate to Microsoft 365 Defender https://security.microsoft.com/
        3.Expand Email & collaboration > Policies & rules > Threat policies.
        4.Under Rules section click Email authentication settings.
        5.Select DKIM
        6.Click on each domain and click Enable next to Sign messages for this domain with DKIM signature.
    To set DKIM is enabled, use the Exchange Online PowerShell Module:
        1.Connect to Exchange Online service using Connect-ExchangeOnline.
        2.Run the following Exchange Online PowerShell command: 
            Set-DkimSigningConfig -Identity < domainName > -Enabled $True"

    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['9.5'] }, {'7' => ['7.8']}]  

    ref 'https://learn.microsoft.com/en-us/defender-office-365/email-authentication-dkim-configure?view=o365-worldwide'
end