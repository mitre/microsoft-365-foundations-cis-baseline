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

  desc 'rationale',
       "Attackers commonly use vulnerable and custom-built add-ins to access data in user applications.
      While allowing users to install add-ins by themselves does allow them to easily acquire useful add-ins that integrate with Microsoft applications, it can represent a risk if not used and monitored carefully.
      Disable future user's ability to install add-ins in Microsoft Word, Excel, or PowerPoint helps reduce your threat-surface and mitigate this risk."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['4.8'] }, { '7' => ['5.1'] }]
  tag nist: ['CM-6', 'CM-7', 'AC-2']

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
