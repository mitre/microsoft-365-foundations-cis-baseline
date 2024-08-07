control 'microsoft-365-foundations-7.2.8' do
    title 'Ensure external sharing is restricted by security group'
    desc 'External sharing of content can be restricted to specific security groups. This setting is global, applies to sharing in both SharePoint and OneDrive and cannot be set at the site level in SharePoint.
        The recommended state is Enabled or Checked.
        Note: Users in these security groups must be allowed to invite guests in the guest invite settings in Microsoft Entra. Identity > External Identities > External collaboration settings'
    
    desc 'check'
    'To audit using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Scroll to and expand More external sharing settings.
        4. Ensure the following:
            o Verify Allow only users in specific security groups to share externally is checked
            o Verify Manage security groups is defined and accordance with company procedure.'
    
    desc 'fix'
    'To remediate using the UI:
        1. Navigate to SharePoint admin center https://admin.microsoft.com/sharepoint
        2. Click to expand Policies > Sharing.
        3. Scroll to and expand More external sharing settings.
        4. Set the following:
            o Check Allow only users in specific security groups to share externally
            o Define Manage security groups in accordance with company procedure.'

    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['6.8'] }]

    ref 'https://learn.microsoft.com/en-us/sharepoint/manage-security-groups'

    describe 'manual' do
        skip 'manual'