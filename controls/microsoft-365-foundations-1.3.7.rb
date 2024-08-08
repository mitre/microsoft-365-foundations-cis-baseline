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

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [
    { '8' => ['3.3'] },
    { '7' => ['13.1'] },
    { '7' => ['13.4'] }
  ]

  ref 'https://learn.microsoft.com/en-us/microsoft-365/admin/setup/set-up-file-storage-and-sharing?view=o365-worldwide#enable-or-disable-third-party-storage-services'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
