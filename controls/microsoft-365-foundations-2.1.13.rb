control 'microsoft-365-foundations-2.1.13' do
  title 'Ensure malware trends are reviewed at least weekly'
  desc 'Threat explorer shows specific instances of Microsoft blocking a malware attachment from reaching users, phishing being blocked, impersonation attempts, etc. The report should be reviewed at least weekly.'

  desc 'check',
       'To verify the report is being reviewed at least weekly, confirm that the necessary procedures are in place and being followed.'

  desc 'fix',
       "To remediate using the UI:
        1.Navigate to Microsoft 365 Defender https://security.microsoft.com.
        2.Click to expand Email & collaboration select Review.
        3.Select Malware trends.
        4.On the Threat Explorer page, select each tab to review statistics"

  desc 'rationale',
       "While this report isn't strictly actionable, reviewing it will give a sense of the overall
        volume of various security threats targeting users, which may prompt adoption of more
        aggressive threat mitigations."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['8.11'] }, { '7' => ['6.2'] }]
  tag nist: ['AU-6', 'AU-6(1)', 'AU-7(1)', 'AC-1', 'AC-2', 'AC-2(1)']

  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/reports-email-security?view=o365-worldwide'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/threat-explorer-real-time-detections-about?view=o365-worldwide'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
