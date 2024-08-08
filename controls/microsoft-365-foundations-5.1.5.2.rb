control 'microsoft-365-foundations-5.1.5.2' do
    title 'Ensure user consent to apps accessing company data on their behalf is not allowed'
    desc "Control when end users and group owners are allowed to grant consent to applications, and when they will be required to request administrator review and approval. Allowing users to grant apps access to data helps them acquire useful applications and be productive but can represent a risk in some situations if it's not monitored and controlled carefully."

    desc 'check'
    'To audit using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Applications select Enterprise applications.
        3. Under Security select Consent and permissions > User consent settings.
        4. Verify User consent for applications is set to Do not allow user consent.
    To audit using PowerShell:
        1. Connect to Microsoft Graph using Connect-MgGraph -Scopes "Policy.Read.All"
        2. Run the following command: 
            (Get-MgPolicyAuthorizationPolicy).DefaultUserRolePermissions | Select-Object -ExpandProperty PermissionGrantPoliciesAssigned
        3. Ensure ManagePermissionGrantsForSelf.microsoft-user-default-low is not present OR that nothing is returned.'

    desc 'fix'
    'To remediate using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Applications select Enterprise applications.
        3. Under Security select Consent and permissions > User consent settings.
        4. Under User consent for applications select Do not allow user consent.
        5. Click the Save option at the top of the window.'

    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['3.3'] }, { '7' => ['14.6'] }]

    ref 'https://learn.microsoft.com/en-us/azure/active-directory/manage-apps/configure-user-consent?tabs=azure-portal&pivots=portal'
end