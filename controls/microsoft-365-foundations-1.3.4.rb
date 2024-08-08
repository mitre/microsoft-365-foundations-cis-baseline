control 'microsoft-365-foundations-1.3.4' do
  title "Ensure 'User owned apps and services' is restricted"
  desc "By default, users can install add-ins in their Microsoft Word, Excel, and PowerPoint applications, allowing data access within the application.
        Do not allow users to install add-ins in Word, Excel, or PowerPoint."

  desc 'check',
       "Ensure users installing Office Store add-ins, and enabling 365 trials is not allowed:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com.
        2. Click to expand Settings Select Org settings.
        3. Under Services select User owned apps and services.
        4. Verify Let users access the Office Store and Let users start trials on behalf of your organization are Not Checked."

  desc 'fix',
       "To prohibit users installing Office Store add-ins and starting 365 trials:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com.
        2. Click to expand Settings Select `Org settings'.
        3. Under Services select User owned apps and services.
        4. Uncheck Let users access the Office Store and Let users start trials on behalf of your organization.
        5. Click Save."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['4.8'] }, { '7' => ['5.1'] }]

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
