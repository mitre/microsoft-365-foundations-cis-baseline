control 'microsoft-365-foundations-5.1.2.3' do
    title "Ensure 'Restrict non-admin users from creating tenants' is set to 'Yes'"
    desc "Non-privileged users can create tenants in the Entra administration portal under Manage tenant. The creation of a tenant is recorded in the Audit log as category \"DirectoryManagement\" and activity \"Create Company\". Anyone who creates a tenant becomes the Global Administrator of that tenant. The newly created tenant doesn't inherit any settings or configurations."

    desc 'check'
    'To audit using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/
        2. Click to expand Identity> Users > User settings.
        3. Ensure Restrict non-admin users from creating tenants is set to Yes
    To audit using PowerShell:
        1. Connect to Microsoft Graph using Connect-MgGraph -Scopes "Policy.Read.All"
        2. Run the following commands: 
            (Get-MgPolicyAuthorizationPolicy).DefaultUserRolePermissions | Select-Object AllowedToCreateTenants
        3. Ensure the returned value is False'
    
    desc 'fix'
    'To remediate using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/
        2. Click to expand Identity> Users > User settings.
        3. Set Restrict non-admin users from creating tenants to Yes then Save.
    To remediate using PowerShell:
        1. Connect to Microsoft Graph using Connect-MgGraph -Scopes "Policy.ReadWrite.Authorization"
        2. Run the following commands.
            # Create hashtable and update the auth policy 
            $params = @{ AllowedToCreateTenants = $false } 
            Update-MgPolicyAuthorizationPolicy -DefaultUserRolePermissions $params'
    
    impact 0.5
    tag severity: 'medium'

    ref 'https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/users-default-permissions#restrict-member-users-default-permissions'
    
