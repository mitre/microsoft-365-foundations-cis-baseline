control 'microsoft-365-foundations-9.1.4' do
  title "Ensure 'Publish to web' is restricted"
  desc "Power BI enables users to share reports and materials directly on the internet from both the application's desktop version and its web user interface. This functionality generates a publicly reachable web link that doesn't necessitate authentication or the need to be an AAD user in order to access and view it.
        The recommended state is Enabled for a subset of the organization or Disabled."

  desc 'check',
       "Ensure Publish to web is restricted:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Ensure that Publish to web adheres to one of these states:
            o State 1: Disabled
            o State 2: Enabled with Choose how embed codes work set to Only allow existing codes AND Specific security groups selected and defined
        Important: If the organization doesn't actively use this feature it is recommended to keep it Disabled."

  desc 'fix',
       "Restrict Publish to web:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Set Publish to web to one of these states:
            o State 1: Disabled
            o State 2: Enabled with Choose how embed codes work set to Only allow existing codes AND Specific security groups selected and defined
        Important: If the organization doesn't actively use this feature it is recommended to keep it Disabled."

  desc 'rationale',
       'When using Publish to Web anyone on the Internet can view a published report or
        visual. Viewing requires no authentication. It includes viewing detail-level data that your
        reports aggregate. By disabling the feature, restricting access to certain users and
        allowing existing embed codes organizations can mitigate the exposure of confidential
        or proprietary information.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['16.10'] }]
  tag default_value: 'Enabled for the entire organization
                      Only allow existing codes'
  tag nist: ['PL-8', 'SA-8']

  ref 'https://learn.microsoft.com/en-us/power-bi/collaborate-share/service-publish-to-web'
  ref 'https://learn.microsoft.com/en-us/power-bi/admin/service-admin-portal-export-sharing#publish-to-web'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
