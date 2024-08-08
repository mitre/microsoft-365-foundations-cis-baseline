control 'microsoft-365-foundations-9.1.8' do
    title 'Ensure enabling of external data sharing is restricted'
    desc 'Power BI admins can specify which users or user groups can share datasets externally with guests from a different tenant through the in-place mechanism. Disabling this setting prevents any user from sharing datasets externally by restricting the ability of users to turn on external sharing for datasets they own or manage.
        The recommended state is Enabled for a subset of the organization or Disabled.'

    desc 'check'
    "Ensure external data sharing is restricted:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Ensure that Allow specific users to turn on external data sharing adheres to one of these states:
            o State 1: Disabled
            o State 2: Enabled with Specific security groups selected and defined.
    Important: If the organization doesn't actively use this feature it is recommended to keep it Disabled."

    desc 'fix'
    "Restrict external data sharing:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Set Allow specific users to turn on external data sharing to one of these states:
            o State 1: Disabled
            o State 2: Enabled with Specific security groups selected and defined.
    Important: If the organization doesn't actively use this feature it is recommended to keep it Disabled."

    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['3.3'] }, { '8' => ['6.8'] }]

    ref 'https://learn.microsoft.com/en-us/power-bi/admin/service-admin-portal-export-sharing'

    describe 'manual' do
        skip 'manual'
    end
end