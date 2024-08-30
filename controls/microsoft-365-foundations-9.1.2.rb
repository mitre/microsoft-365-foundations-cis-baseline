control 'microsoft-365-foundations-9.1.2' do
  title 'Ensure external user invitations are restricted'
  desc "This setting helps organizations choose whether new external users can be invited to the organization through Power BI sharing, permissions, and subscription experiences. This setting only controls the ability to invite through Power BI.
        The recommended state is Enabled for a subset of the organization or Disabled.
        Note: To invite external users to the organization, the user must also have the Microsoft Entra Guest Inviter role"

  desc 'check',
       "Ensure external user invitations are restricted:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Ensure that Users can invite guest users to collaborate through item sharing and permissions adheres to one of these states:
            o State 1: Disabled
            o State 2: Enabled with Specific security groups selected and defined.
    Important: If the organization doesn't actively use this feature it is recommended to keep it Disabled."

  desc 'fix',
       "Restrict external user invitations:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Set Users can invite guest users to collaborate through item sharing and permissions to one of these states:
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
  tag cis_controls: [{ '8' => ['6.8'] }]
  tag default_value: 'Enabled for the entire organization'
  tag nist: ['AC-5', 'AC-6', 'AC-6(1)', 'AC-6(7)', 'AU-9(4)']

  ref 'https://learn.microsoft.com/en-us/power-bi/admin/service-admin-portal-export-sharing'
  ref 'https://learn.microsoft.com/en-us/power-bi/enterprise/service-admin-azure-ad-b2b#invite-guest-users'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
