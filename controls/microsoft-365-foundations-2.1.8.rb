control 'microsoft-365-foundations-2.1.8' do
  title 'Ensure that SPF records are published for all Exchange Domains'
  desc 'For each domain that is configured in Exchange, a corresponding Sender Policy Framework (SPF) record should be created.'

  desc 'check',
       "Ensure that SPF records are published for all Exchange Domains:
        1.Open a command prompt.
        2.Type the following command in PowerShell:
            Resolve-DnsName [domain1.com] txt | fl
        3.Ensure that a value exists and that it includes v=spf1 include:spf.protection.outlook.com. This designates Exchange Online as a designated sender.
    To verify the SPF records are published, use the REST API for each domain: https://graph.microsoft.com/v1.0/domains/[DOMAIN.COM]/serviceConfigurationRecords
        1.Ensure that a value exists that includes v=spf1 include:spf.protection.outlook.com. This designates Exchange Online as a designated sender."

  desc 'fix',
       "To setup SPF records for Exchange Online accepted domains, perform the following steps:
        1.If all email in your domain is sent from and received by Exchange Online, add the following TXT record for each Accepted Domain:
            v=spf1 include:spf.protection.outlook.com -all
        2.If there are other systems that send email in the environment, refer to this article for the proper SPF configuration: https://docs.microsoft.com/en-us/office365/SecurityCompliance/set-up-spf-in-office-365-to-help-prevent-spoofing."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['9.5'] }, { '7' => ['7.8'] }]

  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/email-authentication-spf-configure?view=o365-worldwide'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
