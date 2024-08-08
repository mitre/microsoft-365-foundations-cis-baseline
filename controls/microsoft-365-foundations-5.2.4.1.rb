control 'microsoft-365-foundations-5.2.4.1' do
  title "Ensure 'Self service password reset enabled' is set to 'All'"
  desc "Enabling self-service password reset allows users to reset their own passwords in Entra ID. When users sign in to Microsoft 365, they will be prompted to enter additional contact information that will help them reset their password in the future. If combined registration is enabled additional information, outside of multi-factor, will not be needed.
        NOTE: Effective Oct. 1st, 2022, Microsoft will begin to enable combined registration for all users in Entra ID tenants created before August 15th, 2020. Tenants created after this date are enabled with combined registration by default."

  desc 'check',
       "Ensure self-service password reset is enabled:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Protection > Password reset select Properties.
        3. Ensure Self service password reset enabled is set to All"

  desc 'fix',
       "To enable self-service password reset:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Protection > Password reset select Properties.
        3. Set Self service password reset enabled to All"

  impact 0.5
  tag severity: 'medium'

  ref 'https://learn.microsoft.com/en-us/microsoft-365/admin/add-users/let-users-reset-passwords?view=o365-worldwide'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/authentication/tutorial-enable-sspr'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/authentication/howto-registration-mfa-sspr-combined'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
