control "microsoft-365-foundations-9.1.9" do
  title "Ensure 'Block ResourceKey Authentication' is 'Enabled'"
  desc "This setting blocks the use of resource key based authentication. The Block ResourceKey Authentication setting applies to streaming and PUSH datasets. If blocked users will not be allowed send data to streaming and PUSH datasets using the API with a resource key.
        The recommended state is Enabled."

  desc "check",
       "Ensure ResourceKey Authentication is Enabled:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Developer settings.
        4. Ensure that Block ResourceKey Authentication is Enabled"

  desc "fix",
       "Ensure ResourceKey Authentication is Enabled:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Developer settings.
        4. Set Block ResourceKey Authentication to Enabled"

  impact 0.5
  tag severity: "medium"
  tag cis_controls: [{ "8" => ["4.8"] }]

  ref "https://learn.microsoft.com/en-us/power-bi/admin/service-admin-portal-developer"
  ref "https://learn.microsoft.com/en-us/power-bi/connect-data/service-real-time-streaming"

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
