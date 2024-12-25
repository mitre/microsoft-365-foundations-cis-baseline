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

  desc 'rationale',
       "SPF records allow Exchange Online Protection and other mail systems to know where
        messages from domains are allowed to originate. This information can be used by that
        system to determine how to treat the message based on if it is being spoofed or is valid."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['9.5'] }, { '7' => ['7.8'] }]
  tag nist: ['SC-7']

  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/email-authentication-spf-configure?view=o365-worldwide'

  # This does not work on Mac - need to find a different way to test. Additionally, CIS Benchmark says manual
  domain_list = %("#{input('spf_domains').sort.join('", "')}")
  resolve_domain_script = %{
      $domain_list = @(#{domain_list})
      try{
        Import-Module DNSClient -ErrorAction Stop
      }
      catch{
      }
      try{
        foreach ($domain in $domain_list) {
          $txtRecords = Resolve-DnsName $domain -Type TXT | Select-Object -ExpandProperty Strings

          if ($txtRecords -and $txtRecords -contains "v=spf1 include:spf.protection.outlook.com") {
              Write-Output "Domain: $domain - SPF record is correct."
          } else {
              Write-Output "Domain: $domain - SPF record is missing or incorrect."
          }
        }
      }
      catch{
      }
    }
  powershell_output = pwsh_single_session_executor(resolve_domain_script).run_script_in_graph_exchange
  raise Inspec::Error, "The powershell output returned the following error:  #{powershell_output.stderr}" if powershell_output.exit_status != 0

  describe 'Ensure the number of Exchange domains that do not contain a SPF record or contain v=spf1 include:spf.protection.outlook.com in the SPF record' do
    subject { powershell_output.stdout.strip }
    it 'is 0' do
      failure_message = "The following Exchange domains have failed: #{powershell_output.stdout.strip.split("\n").join(',')}"
      expect(subject).to be_empty, failure_message
    end
  end
end
