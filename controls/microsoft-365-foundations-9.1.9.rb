control 'microsoft-365-foundations-9.1.9' do
  title "Ensure 'Block ResourceKey Authentication' is 'Enabled'"
  desc "This setting blocks the use of resource key based authentication. The Block ResourceKey Authentication setting applies to streaming and PUSH datasets. If blocked users will not be allowed send data to streaming and PUSH datasets using the API with a resource key.
        The recommended state is Enabled."

  desc 'check',
       "Ensure ResourceKey Authentication is Enabled:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Developer settings.
        4. Ensure that Block ResourceKey Authentication is Enabled"

  desc 'fix',
       "Ensure ResourceKey Authentication is Enabled:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Developer settings.
        4. Set Block ResourceKey Authentication to Enabled"

  desc 'rationale',
       "Resource keys are a form of authentication that allows users to access Power BI
        resources (such as reports, dashboards, and datasets) without requiring individual user
        accounts. While convenient, this method bypasses the organization's centralized
        identity and access management controls. Enabling ensures that access to Power BI
        resources is tied to the organization's authentication mechanisms, providing a more
        secure and controlled environment."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['4.8'] }]
  tag nist: ['CM-6', 'CM-7']

  ref 'https://learn.microsoft.com/en-us/power-bi/admin/service-admin-portal-developer'
  ref 'https://learn.microsoft.com/en-us/power-bi/connect-data/service-real-time-streaming'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
