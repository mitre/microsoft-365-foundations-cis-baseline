control 'microsoft-365-foundations-9.1.2' do
    title 'Ensure external user invitations are restricted'
    desc 'This setting helps organizations choose whether new external users can be invited to the organization through Power BI sharing, permissions, and subscription experiences. This setting only controls the ability to invite through Power BI.
        The recommended state is Enabled for a subset of the organization or Disabled.
        Note: To invite external users to the organization, the user must also have the Microsoft Entra Guest Inviter role'

    desc 'check'
    "Ensure external user invitations are restricted:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Ensure that Users can invite guest users to collaborate through item sharing and permissions adheres to one of these states:
            o State 1: Disabled
            o State 2: Enabled with Specific security groups selected and defined.
    Important: If the organization doesn't actively use this feature it is recommended to keep it Disabled."

    desc 'fix'
    "Restrict external user invitations:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Set Users can invite guest users to collaborate through item sharing and permissions to one of these states:
            o State 1: Disabled
            o State 2: Enabled with Specific security groups selected and defined.
    Important: If the organization doesn't actively use this feature it is recommended to keep it Disabled."

    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['6.8'] }]
    
    ref 'https://learn.microsoft.com/en-us/power-bi/admin/service-admin-portal-export-sharing'
    ref 'https://learn.microsoft.com/en-us/power-bi/enterprise/service-admin-azure-ad-b2b#invite-guest-users'

    describe 'manual' do
        skip 'manual'
