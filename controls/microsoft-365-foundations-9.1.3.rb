control 'microsoft-365-foundations-9.1.3' do
  title 'Ensure guest access to content is restricted'
  desc "This setting allows Microsoft Entra B2B guest users to have full access to the browsing experience using the left-hand navigation pane in the organization. Guest users who have been assigned workspace roles or specific item permissions will continue to have those roles and/or permissions, even if this setting is disabled.
        The recommended state is Enabled for a subset of the organization or Disabled."

  desc 'check',
       "Ensure guest user content access is restricted:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Ensure that Guest users can browse and access Fabric content adheres to one of these states:
            o State 1: Disabled
            o State 2: Enabled with Specific security groups selected and defined.
    Important: If the organization doesn't actively use this feature it is recommended to keep it Disabled."

  desc 'fix',
       "Restrict guest user content access:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Set Guest users can browse and access Fabric content to one of these states:
            o State 1: Disabled
            o State 2: Enabled with Specific security groups selected and defined.
    Important: If the organization doesn't actively use this feature it is recommended to keep it Disabled."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['3.3'] }, { '7' => ['14.6'] }]

  ref 'https://learn.microsoft.com/en-us/power-bi/admin/service-admin-portal-export-sharing'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
