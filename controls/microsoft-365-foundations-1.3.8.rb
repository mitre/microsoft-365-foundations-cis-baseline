control 'microsoft-365-foundations-1.3.8' do
  title 'Ensure that Sways cannot be shared with people outside of your organization'
  desc "Third-party storage can be enabled for users in Microsoft 365, allowing them to store and share documents using services such as Dropbox, alongside OneDrive and team sites.
        Ensure Microsoft 365 on the web third-party storage services are restricted."

  desc 'check',
       "Ensure that Sways cannot be shared with people outside of your organization:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com.
        2. Click to expand Settings then select Org settings.
        3. Under Services select Sway.
        4. Confirm that under Sharing the following is not checked
            o Option: Let people in your organization share their sways with people outside your organization."

  desc 'fix',
       "To ensure Sways cannot be viewed outside of your organization:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com.
        2. Click to expand Settings then select Org settings.
        3. Under Services select Sway
            o Uncheck: Let people in your organization share their sways with people outside your organization.
        4. Click Save."

  desc 'rationale',
       'Disable external sharing of Sway documents that can contain sensitive information to prevent accidental or arbitrary data leaks.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['4.8'] }, { '7' => ['13.1'] }]
  tag default_value: 'Let people in your organization share their sways with people outside your organization - Enabled'
  tag nist: ['CM-6', 'CM-7']

  ref 'https://support.microsoft.com/en-us/office/administrator-settings-for-sway-d298e79b-b6ab-44c6-9239-aa312f5784d4'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
