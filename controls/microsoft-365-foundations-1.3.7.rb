control 'microsoft-365-foundations-1.3.7' do
  title "Ensure 'third-party storage services' are restricted in 'Microsoft 365 on the web'"
  desc "Third-party storage can be enabled for users in Microsoft 365, allowing them to store and share documents using services such as Dropbox, alongside OneDrive and team sites.
        Ensure Microsoft 365 on the web third-party storage services are restricted."

  desc 'check',
       "Ensure Microsoft 365 on the web is restricted:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com
        2. Go to Settings > Org Settings > Services > Microsoft 365 on the web
        3. Ensure Let users open files stored in third-party storage services in Microsoft 365 on the web is not checked."

  desc 'fix',
       "To restrict Microsoft 365 on the web:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com
        2. Go to Settings > Org Settings > Services > Microsoft 365 on the web
        3. Uncheck Let users open files stored in third-party storage services in Microsoft 365 on the web"

  desc 'rationale',
       'By using external storage services an organization may increase the risk of data breaches and unauthorized access to confidential information. Additionally, third-party services may not adhere to the same security standards as the organization, making it difficult to maintain data privacy and security.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [
    { '8' => ['3.3'] },
    { '7' => ['13.1'] },
    { '7' => ['13.4'] }
  ]
  tag nist: ['AC-3', 'AC-5', 'AC-6', 'MP-2', 'AU-6(1)', 'AU-7', 'IR-4(1)', 'SI-4(2)', 'SI-4(5)', 'CA-9', 'SC-7']

  ref 'https://learn.microsoft.com/en-us/microsoft-365/admin/setup/set-up-file-storage-and-sharing?view=o365-worldwide#enable-or-disable-third-party-storage-services'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
