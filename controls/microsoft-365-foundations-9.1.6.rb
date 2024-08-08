control "microsoft-365-foundations-9.1.6" do
  title "Ensure 'Allow users to apply sensitivity labels for content' is 'Enabled'"
  desc 'Information protection tenant settings help to protect sensitive information in the Power BI tenant. Allowing and applying sensitivity labels to content ensures that information is only seen and accessed by the appropriate users.
        The recommended state is Enabled or Enabled for a subset of the organization.
        Note: Sensitivity labels and protection are only applied to files exported to Excel, PowerPoint, or PDF files, that are controlled by "Export to Excel" and "Export reports as PowerPoint presentation or PDF documents" settings. All other export and sharing options do not support the application of sensitivity labels and protection.
        Note 2: There are some prerequisite steps that need to be completed in order to fully utilize labeling. See here.'

  desc "check",
       "Ensure sensitivity labels are Enabled:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Information protection.
        4. Ensure that Allow users to apply sensitivity labels for content adheres to one of these states:
            o State 1: Enabled
            o State 2: Enabled with Specific security groups selected and defined."

  desc "fix",
       "Enable sensitivity labels:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Information protection.
        4. Set Allow users to apply sensitivity labels for content to one of these states:
            o State 1: Enabled
            o State 2: Enabled with Specific security groups selected and defined."

  impact 0.5
  tag severity: "medium"
  tag cis_controls: [{ "8" => ["3.2"] }, { "8" => ["3.7"] }]

  ref "https://learn.microsoft.com/en-us/power-bi/enterprise/service-security-enable-data-sensitivity-labels"
  ref "https://learn.microsoft.com/en-us/power-bi/enterprise/service-security-dlp-policies-for-power-bi-overview"
  ref "https://learn.microsoft.com/en-us/power-bi/enterprise/service-security-enable-data-sensitivity-labels#licensing-and-requirements"

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
