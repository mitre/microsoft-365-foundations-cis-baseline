control 'microsoft-365-foundations-9.1.1' do
  title 'Ensure guest user access is restricted'
  desc "This setting allows business-to-business (B2B) guests access to Microsoft Fabric, and contents that they have permissions to. With the setting turned off, B2B guest users receive an error when trying to access Power BI.
        The recommended state is Enabled for a subset of the organization or Disabled."

  desc 'check',
       "Ensure guest user access is restricted:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Ensure that Guest users can access Microsoft Fabric adheres to one of these states:
            o State 1: Disabled
            o State 2: Enabled with Specific security groups selected and defined.
    Important: If the organization doesn't actively use this feature it is recommended to keep it Disabled."

  desc 'fix',
       "Restrict guest user access:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Set Guest users can access Microsoft Fabric to one of these states:
            o State 1: Disabled
            o State 2: Enabled with Specific security groups selected and defined.
    Important: If the organization doesn't actively use this feature it is recommended to keep it Disabled."

  desc 'rationale',
       'Establishing and enforcing a dedicated security group prevents unauthorized access to
        Microsoft Fabric for guests collaborating in Azure that are new or assigned guest status
        from other applications. This upholds the principle of least privilege and uses role-based
        access control (RBAC). These security groups can also be used for tasks like
        conditional access, enhancing risk management and user accountability across the
        organization.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['3.3'] }, { '8' => ['6.8'] }]
  tag default_value: 'Enabled for Entire Organization'
  tag nist: ['AC-3', 'AC-5', 'AC-6', 'MP-2', 'AC-2', 'AC-6(1)', 'AC-6(7)', 'AU-9(4)']

  ref 'https://learn.microsoft.com/en-us/power-bi/admin/service-admin-portal-export-sharing'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
