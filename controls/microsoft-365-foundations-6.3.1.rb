control 'microsoft-365-foundations-6.3.1' do
    title 'Ensure users installing Outlook add-ins is not allowed'
    desc 'Specify the administrators and users who can install and manage add-ins for Outlook in Exchange Online
        By default, users can install add-ins in their Microsoft Outlook Desktop client, allowing data access within the client application.'
    
    desc 'check'
    'To audit using the UI:
        1. Navigate to Exchange admin center https://admin.exchange.microsoft.com.
        2. Click to expand Roles select User roles.
        3. Select Default Role Assignment Policy.
        4. In the properties pane on the right click on Manage permissions.
        5. Under Other roles verify My Custom Apps, My Marketplace Apps and My ReadWriteMailboxApps are unchecked.
    To audit using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following command: 
            Get-EXOMailbox | Select-Object -Unique RoleAssignmentPolicy | 
            ForEach-Object { 
                Get-RoleAssignmentPolicy -Identity $_.RoleAssignmentPolicy | 
                Where-Object {$_.AssignedRoles -like "*Apps*"} 
            } | Select-Object Identity, @{Name="AssignedRoles"; Expression={ Get-Mailbox | Select-Object -Unique RoleAssignmentPolicy | 
            ForEach-Object { 
                Get-RoleAssignmentPolicy -Identity $_.RoleAssignmentPolicy | 
                Select-Object -ExpandProperty AssignedRoles | 
                Where-Object {$_ -like "*Apps*"} 
                } 
            }}
        3. Verify My Custom Apps, My Marketplace Apps and My ReadWriteMailboxApps are not present.
    Note: As of the current release the manage permissions link no longer displays anything when a user assigned the Global Reader role clicks on it. Global Readers as an alternative can inspect the Roles column or use the PowerShell method to perform the audit.'

    desc 'fix'
    'To remediate using the UI:
        1. Navigate to Exchange admin center https://admin.exchange.microsoft.com.
        2. Click to expand Roles select User roles.
        3. Select Default Role Assignment Policy.
        4. In the properties pane on the right click on Manage permissions.
        5. Under Other roles uncheck My Custom Apps, My Marketplace Apps and My ReadWriteMailboxApps.
        6. Click Save changes.
    To remediate using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following command: 
            $policy = "Role Assignment Policy - Prevent Add-ins" 
            $roles = "MyTextMessaging", "MyDistributionGroups", ` "MyMailSubscriptions", "MyBaseOptions", "MyVoiceMail", ` "MyProfileInformation", "MyContactInformation", "MyRetentionPolicies", ` "MyDistributionGroupMembership" 
            New-RoleAssignmentPolicy -Name $policy -Roles $roles 
            Set-RoleAssignmentPolicy -id $policy -IsDefault 
            # Assign new policy to all mailboxes 
            Get-EXOMailbox -ResultSize Unlimited | Set-Mailbox -RoleAssignmentPolicy $policy
        If you have other Role Assignment Policies modify the last line to filter out your custom policies'
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['9.4'] }, { '7' => ['5.1'] }]

    ref 'https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/add-ins-for-outlook/specify-who-can-install-and-manage-add-ins?source=recommendations'
    ref 'https://learn.microsoft.com/en-us/exchange/permissions-exo/role-assignment-policies'
end

    