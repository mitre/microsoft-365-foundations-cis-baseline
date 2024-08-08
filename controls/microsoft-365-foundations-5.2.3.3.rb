control 'microsoft-365-foundations-5.2.3.3' do
    title 'Ensure password protection is enabled for on-prem Active Directory'
    desc "Microsoft Entra Password Protection provides a global and custom banned password list. A password change request fails if there's a match in these banned password list. To protect on-premises Active Directory Domain Services (AD DS) environment, install and configure Entra Password Protection.
        Note: This recommendation applies to Hybrid deployments only and will have no impact unless working with on-premises Active Directory."
    
    desc 'check'
    'To audit using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Protection select Authentication methods.
        3. Select Password protection and ensure that Enable password protection on Windows Server Active Directory is set to Yes and that Mode is set to Enforced.'
    
    desc 'fix'
    'To remediate using the UI:
        • Download and install the Azure AD Password Proxies and DC Agents from the following location: https://www.microsoft.com/download/details.aspx?id=57071 After installed follow the steps below.
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Protection select Authentication methods.
        3. Select Password protection and set Enable password protection on Windows Server Active Directory to Yes and Mode to Enforced.'
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['5.2'] }, { '7' => ['4.4'] }]

    ref 'https://learn.microsoft.com/en-us/azure/active-directory/authentication/howto-password-ban-bad-on-premises-operations'

    describe 'manual' do
        skip 'manual'
    end
end