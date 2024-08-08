control 'microsoft-365-foundations-5.1.2.1' do
    title "Ensure 'Per-user MFA' is disabled"
    desc 'Legacy per-user Multi-Factor Authentication (MFA) can be configured to require individual users to provide multiple authentication factors, such as passwords and additional verification codes, to access their accounts. It was introduced in earlier versions of Office 365, prior to the more comprehensive implementation of Conditional Access (CA).'

    desc 'check'
    'To audit per-user MFA using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Users select All users.
        3. Click on Per-user MFA on the top row.
        4. Ensure under the column Multi-factor Auth Status that each account is set to Disabled'
    
    desc 'fix'
    'Disable per-user MFA using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Users select All users.
        3. Click on Per-user MFA on the top row.
        4. Click the empty box next to Display Name to select all accounts.
        5. On the far right under quick steps click Disable.'
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['6.3'] }]

    ref 'https://learn.microsoft.com/en-us/azure/active-directory/authentication/howto-mfa-userstates#convert-users-from-per-user-mfa-to-conditional-access'
    ref 'https://learn.microsoft.com/en-us/microsoft-365/admin/security-and-compliance/set-up-multi-factor-authentication?view=o365-worldwide#use-conditional-access-policies'
    ref 'https://learn.microsoft.com/en-us/azure/active-directory/authentication/howto-mfa-userstates#convert-per-user-mfa-enabled-and-enforced-users-to-disabled'

    describe 'manual' do
        skip 'manual'
    end
end