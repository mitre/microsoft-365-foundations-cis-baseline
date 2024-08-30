control 'microsoft-365-foundations-1.3.5' do
  title 'Ensure internal phishing protection for Forms is enabled'
  desc 'Microsoft Forms can be used for phishing attacks by asking personal or sensitive information and collecting the results. Microsoft 365 has built-in protection that will proactively scan for phishing attempt in forms such personal information request.'

  desc 'check',
       "Ensure internal phishing protection for Forms is enabled:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com.
        2. Click to expand Settings then select Org settings.
        3. Under Services select Microsoft Forms.
        4. Ensure the checkbox labeled Add internal phishing protection is checked under Phishing protection."

  desc 'fix',
       "To enable internal phishing protection for Forms:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com.
        2. Click to expand Settings then select Org settings.
        3. Under Services select Microsoft Forms.
        4. Click the checkbox labeled Add internal phishing protection under Phishing protection.
        5. Click Save."

  desc 'rationale',
       'Enabling internal phishing protection for Microsoft Forms will prevent attackers using forms for phishing attacks by asking personal or other sensitive information and URLs.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['10.1'] }, { '8' => ['14.2'] }]
  tag default_value: 'Internal Phishing Protection is enabled.'
  tag nist: ['SI-3', 'AT-2(3)']

  ref 'https://learn.microsoft.com/en-US/microsoft-forms/administrator-settings-microsoft-forms'
  ref 'https://learn.microsoft.com/en-US/microsoft-forms/review-unblock-forms-users-detected-blocked-potential-phishing'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
