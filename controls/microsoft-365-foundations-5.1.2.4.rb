control 'microsoft-365-foundations-5.1.2.4' do
    title "Ensure 'Restrict access to the Azure AD administration portal' is set to 'Yes'"
    desc 'Restrict non-privileged users from signing into the Microsoft Entra admin center.
        Note: This recommendation only affects access to the web portal. It does not prevent privileged users from using other methods such as Rest API or PowerShell to obtain information. Those channels are addressed elsewhere in this document.'
    
    desc 'check'
    'To audit using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/
        2. Click to expand Identity> Users > User settings.
        3. Verify under the Administration center section that Restrict access to Microsoft Entra admin center is set to Yes'
    
    desc 'fix'
    'To remediate using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/
        2. Click to expand Identity> Users > User settings.
        3. Set Restrict access to Microsoft Entra admin center to Yes then Save.'

    impact 0.5
    tag severity: 'medium'

    ref 'https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/users-default-permissions#restrict-member-users-default-permissions'

    describe 'manual' do
        skip 'manual'
    end
end