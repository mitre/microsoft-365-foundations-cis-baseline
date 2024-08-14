control 'microsoft-365-foundations-3.2.1' do
  title 'Ensure DLP policies are enabled'
  desc 'Data Loss Prevention (DLP) policies allow Exchange Online and SharePoint Online content to be scanned for specific types of data like social security numbers, credit card numbers, or passwords.'

  desc 'check',
       "Ensure DLP policies are enabled:
        1. Navigate to Microsoft Purview https://compliance.microsoft.com.
        2. Under Solutions select Data loss prevention then Policies.
        3. Verify that policies exist and are enabled."

  desc 'fix',
       "To enable DLP policies:
        1. Navigate to Microsoft Purview https://compliance.microsoft.com.
        2. Under Solutions select Data loss prevention then Policies.
        3. Click Create policy."

  desc 'rationale',
       'Enabling DLP policies alerts users and administrators that specific types of data should
        not be exposed, helping to protect the data from accidental exposure.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['3.1'] }, { '7' => ['13'] }, { '7' => ['14.7'] }]
  tag nist: ['AU-11', 'CM-12', 'SI-12', 'AT-2']

  ref 'https://learn.microsoft.com/en-us/microsoft-365/compliance/dlp-learn-about-dlp?view=o365-worldwide'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
