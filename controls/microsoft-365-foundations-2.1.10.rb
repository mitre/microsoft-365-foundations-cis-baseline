control 'microsoft-365-foundations-2.1.10' do
  title 'Ensure DMARC Records for all Exchange Online domains are published'
  desc 'DMARC, or Domain-based Message Authentication, Reporting, and Conformance, assists recipient mail systems in determining the appropriate action to take when messages from a domain fail to meet SPF or DKIM authentication criteria.'

  desc 'check',
       "Ensure DMARC Records for all Exchange Online domains are published:
        1.Open a command prompt.
        2.For each of the Accepted Domains in Exchange Online run the following in PowerShell:
            Resolve-DnsName _dmarc.[domain1.com] txt
        3.Ensure that the record exists and has at minimum the following flags defined as follows: v=DMARC1; (p=quarantine OR p=reject), pct=100, rua=mailto:<reporting email address> and ruf=mailto:<reporting email address>
    The below example records would pass as they contain a policy that would either quarantine or reject messages failing DMARC, the policy affects 100% of mail pct=100 as well as containing valid reporting addresses:
            v=DMARC1; p=reject; pct=100; rua=mailto:rua@contoso.com;
            ruf=mailto:ruf@contoso.com; fo=1
            v=DMARC1; p=reject; pct=100; fo=1; ri=3600; rua=mailto:rua@contoso.com;
            ruf=mailto:ruf@contoso.com
            v=DMARC1; p=quarantine; pct=100; sp=none; fo=1; ri=3600; rua=mailto:rua@contoso.com;
            ruf=ruf@contoso.com;
        4.Ensure the Microsoft MOERA domain is also configured.
            Resolve-DnsName _dmarc.[tenant].onmicrosoft.com txt
        5.Ensure the record meets the same criteria listed in step #3."

  desc 'fix',
       "To add DMARC records, use the following steps:
        1.For each Exchange Online Accepted Domain, add the following record to DNS: Record: _dmarc.domain1.com Type: TXT Value: v=DMARC1; p=none; rua=mailto:<rua-report@example.com>; ruf=mailto:<ruf-report@example.com>
        2.This will create a basic DMARC policy that will allow the organization to start monitoring message statistics.
        3.The next steps will involve first implementing quarantine and next a reject policy with 100 percent of email is affected. Microsoft has a list of best practices for implementing DMARC that cover these steps in detail.
    To establish a DMARC record for the MOERA domain:
        1.Navigate to the Microsoft 365 admin center https://admin.microsoft.com/
        2.Expand Settings and select Domains.
        3.Select your tenant domain (for example, contoso.onmicrosoft.com).
        4.Select DNS records and click + Add record.
        5.Add a new record with the TXT name of _dmarc with the appropriate values outlined above.
    Note: The remediation portion involves a multi-staged approach over a period of time. First, a baseline of the current state of email will be established with p=none and rua and ruf. Once the environment is better understood and reports have been analyzed an organization will move to the final state with dmarc record values as outlined in the audit section."

  desc 'rationale',
       "DMARC strengthens the trustworthiness of messages sent from an organization's
        domain to destination email systems. By integrating DMARC with SPF (Sender Policy
        Framework) and DKIM (DomainKeys Identified Mail), organizations can significantly
        enhance their defenses against email spoofing and phishing attempts."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['9.5'] }, { '7' => ['7.8'] }]
  tag nist: ['SC-7']

  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/email-authentication-dmarc-configure?view=o365-worldwide'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/step-by-step-guides/how-to-enable-dmarc-reporting-for-microsoft-online-email-routing-address-moera-and-parked-domains?view=o365-worldwide'

  # This does not work on Mac - need to find a different way to test. Additionally, CIS Benchmark says manual
  domain_list = input('dmarc_domains')
  domain_list.each do |domain|
    check_dmarc_domain_script = %{
      $client_id = '#{input('client_id')}'
      $certificate_password = '#{input('certificate_password')}'
      $certificate_path = '#{input('certificate_path')}'
      $organization = '#{input('organization')}'
      Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
      import-module exchangeonlinemanagement
      Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
      Import-Module DNSClient
      Resolve-DnsName _dmarc.#{domain} txt
    }
    describe "Ensure the following DMARC domain (#{domain})" do
      subject { powershell(check_dmarc_domain_script).stdout.strip }
      it %{should contain all parts following string: v=DMARC1; (p=quarantine OR p=reject), pct=100, rua=mailto:#{input('reporting_mail_address')} and ruf=mailto:#{input('reporting_mail_address')}} do
        expect(subject).to match %{v=DMARC1;.*p=(quarantine|reject);.*pct=100;.*rua=mailto:.*ruf=mailto:#{input('reporting_mail_address')}}
      end
    end
  end
  domain_list_moera = input('moera_domains')
  domain_list_moera.each do |domain|
    check_moera_domain_script = %{
      $client_id = '#{input('client_id')}'
      $certificate_password = '#{input('certificate_password')}'
      $certificate_path = '#{input('certificate_path')}'
      $organization = '#{input('organization')}'
      import-module exchangeonlinemanagement
      Connect-ExchangeOnline -CertificateFilePath $certificate_path -CertificatePassword (ConvertTo-SecureString -String $certificate_password -AsPlainText -Force)  -AppID $client_id -Organization $organization -ShowBanner:$false
      Import-Module DNSClient
      Resolve-DnsName _dmarc.#{domain}.onmicrosoft.com txt
    }
    describe "Ensure the following MOERA domain (#{domain})" do
      subject { powershell(check_moera_domain_script).stdout.strip }
      it %{should contain all parts following string: v=DMARC1; (p=quarantine OR p=reject), pct=100, rua=mailto:#{input('reporting_mail_address')} and ruf=mailto:#{input('reporting_mail_address')}} do
        expect(subject).to match %{v=DMARC1;.*p=(quarantine|reject);.*pct=100;.*rua=mailto:.*ruf=mailto:#{input('reporting_mail_address')}}
      end
    end
  end
end
