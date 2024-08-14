control 'microsoft-365-foundations-7.3.3' do
  title 'Ensure custom script execution is restricted on personal sites'
  desc "This setting controls custom script execution on OneDrive or user-created sites.
        Custom scripts can allow users to change the look, feel and behavior of sites and pages. Every script that runs in a SharePoint page (whether it's an HTML page in a document library or a JavaScript in a Script Editor Web Part) always runs in the context of the user visiting the page and the SharePoint application. This means:
            • Scripts have access to everything the user has access to.
            • Scripts can access content across several Microsoft 365 services and even beyond with Microsoft Graph integration.
        The recommended state is Prevent users from running custom script on personal sites and Prevent users from running custom script on self-service created sites"

  desc 'check',
       "To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Select Settings.
        3. At the bottom of the page click the classic settings page hyperlink.
        4. Scroll to locate the Custom Script section. On the right ensure the following:
            o Verify Prevent users from running custom script on personal sites is set.
            o Verify Prevent users from running custom script on self-service created sites is set."

  desc 'fix',
       "To remediate using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Select Settings.
        3. At the bottom of the page click the classic settings page hyperlink.
        4. Scroll to locate the Custom Script section. On the right set the following:
            o Select Prevent users from running custom script on personal sites.
            o Select Prevent users from running custom script on self-service created sites."

  desc 'rationale',
       "Custom scripts could contain malicious instructions unknown to the user or
        administrator. When users are allowed to run custom script, the organization can no
        longer enforce governance, scope the capabilities of inserted code, block specific parts
        of code, or block all custom code that has been deployed. If scripting is allowed the
        following things can't be audited:
          • What code has been inserted
          • Where the code has been inserted
          • Who inserted the code
        Note: Microsoft recommends using the SharePoint Framework instead of custom
        scripts."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['2.7'] }]
  tag default_value: 'Selected Prevent users from running custom script on personal sites
                      Selected Prevent users from running custom script on self-service created
                      sites'
  tag nist: ['CM-7', 'CM-7(1)', 'SI-7', 'SI-7(1)']

  ref 'https://learn.microsoft.com/en-us/sharepoint/allow-or-prevent-custom-script'
  ref 'https://learn.microsoft.com/en-us/sharepoint/security-considerations-of-allowing-custom-script'
  ref 'https://learn.microsoft.com/en-us/powershell/module/sharepoint-online/set-sposite?view=sharepoint-ps'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
