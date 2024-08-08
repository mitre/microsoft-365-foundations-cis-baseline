control 'microsoft-365-foundations-9.1.1' do
    title 'Ensure guest user access is restricted'
    desc 'This setting allows business-to-business (B2B) guests access to Microsoft Fabric, and contents that they have permissions to. With the setting turned off, B2B guest users receive an error when trying to access Power BI.
        The recommended state is Enabled for a subset of the organization or Disabled.'
    
    desc 'check'
    "Ensure guest user access is restricted:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Ensure that Guest users can access Microsoft Fabric adheres to one of these states:
            o State 1: Disabled
            o State 2: Enabled with Specific security groups selected and defined.
    Important: If the organization doesn't actively use this feature it is recommended to keep it Disabled."

    desc 'fix'
    "Restrict guest user access:
        1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal
        2. Select Tenant settings.
        3. Scroll to Export and Sharing settings.
        4. Set Guest users can access Microsoft Fabric to one of these states:
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