control "microsoft-365-foundations-2.1.10" do
  title "Ensure DMARC Records for all Exchange Online domains are published"
  desc "DMARC, or Domain-based Message Authentication, Reporting, and Conformance, assists recipient mail systems in determining the appropriate action to take when messages from a domain fail to meet SPF or DKIM authentication criteria."

  desc "check",
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

  desc "fix",
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

  impact 0.5
  tag severity: "medium"
  tag cis_controls: [{ "8" => ["9.5"] }, { "7" => ["7.8"] }]

  ref "https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/email-authentication-dmarc-configure?view=o365-worldwide"
  ref "https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/step-by-step-guides/how-to-enable-dmarc-reporting-for-microsoft-online-email-routing-address-moera-and-parked-domains?view=o365-worldwide"

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
