control "microsoft-365-foundations-9.1.5" do
  title "Ensure 'Interact with and share R and Python' visuals is 'Disabled'"
  desc "Power BI allows the integration of R and Python scripts directly into visuals. This feature allows data visualizations by incorporating custom calculations, statistical analyses, machine learning models, and more using R or Python scripts. Custom visuals can be created by embedding them directly into Power BI reports. Users can then interact with these visuals and see the results of the custom code within the Power BI interface."

  desc "check",
       "Ensure the recommended state is configured:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to R and Python visuals settings.
        4. Ensure that Interact with and share R and Python visuals is Disabled"

  desc "fix",
       "Configure the recommended state:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to R and Python visuals settings.
        4. Set Interact with and share R and Python visuals to Disabled"

  impact 0.5
  tag severity: "medium"
  tag cis_controls: [{ "8" => ["4.8"] }]

  ref "https://learn.microsoft.com/en-us/power-bi/admin/service-admin-portal-r-python-visuals"
  ref "https://learn.microsoft.com/en-us/power-bi/visuals/service-r-visuals"
  ref "https://www.r-project.org/"

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
