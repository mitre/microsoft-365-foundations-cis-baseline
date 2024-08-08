control "microsoft-365-foundations-9.1.7" do
  title "Ensure shareable links are restricted"
  desc "Creating a shareable link allows a user to create a link to a report or dashboard, then add that link to an email or another messaging application.
        There are 3 options that can be selected when creating a shareable link:
            • People in your organization
            • People with existing access
            • Specific people
        This setting solely deals with restrictions to People in the organization. External users by default are not included in any of these categories, and therefore cannot use any of these links regardless of the state of this setting.
        The recommended state is Enabled for a subset of the organization or Disabled."

  desc "check",
       "Ensure shareable links are restricted:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Ensure that Allow shareable links to grant access to everyone in your organization adheres to one of these states:
            o State 1: Disabled
            o State 2: Enabled with Specific security groups selected and defined.
    Important: If the organization doesn't actively use this feature it is recommended to keep it Disabled."

  desc "fix",
       "Restrict shareable links:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Set Allow shareable links to grant access to everyone in your organization to one of these states:
            o State 1: Disabled
            o State 2: Enabled with Specific security groups selected and defined.
    Important: If the organization doesn't actively use this feature it is recommended to keep it Disabled."

  impact 0.5
  tag severity: "medium"
  tag cis_controls: [{ "8" => ["3.3"] }]

  ref "https://learn.microsoft.com/en-us/power-bi/collaborate-share/service-share-dashboards?wt.mc_id=powerbi_inproduct_sharedialog#link-settings"
  ref "https://learn.microsoft.com/en-us/power-bi/admin/service-admin-portal-export-sharing"

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
