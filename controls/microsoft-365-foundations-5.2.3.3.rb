control 'microsoft-365-foundations-5.2.3.3' do
  title 'Ensure password protection is enabled for on-prem Active Directory'
  desc "Microsoft Entra Password Protection provides a global and custom banned password list. A password change request fails if there's a match in these banned password list. To protect on-premises Active Directory Domain Services (AD DS) environment, install and configure Entra Password Protection.
        Note: This recommendation applies to Hybrid deployments only and will have no impact unless working with on-premises Active Directory."

  desc 'check',
       "To audit using the UI:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Protection select Authentication methods.
        3. Select Password protection and ensure that Enable password protection on Windows Server Active Directory is set to Yes and that Mode is set to Enforced."

  desc 'fix',
       "To remediate using the UI:
        • Download and install the Azure AD Password Proxies and DC Agents from the following location: https://www.microsoft.com/download/details.aspx?id=57071 After installed follow the steps below.
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Protection select Authentication methods.
        3. Select Password protection and set Enable password protection on Windows Server Active Directory to Yes and Mode to Enforced."

  desc 'rationale',
       'This feature protects an organization by prohibiting the use of weak or leaked
        passwords. In addition, organizations can create custom banned password lists to
        prevent their users from using easily guessed passwords that are specific to their
        industry. Deploying this feature to Active Directory will strengthen the passwords that
        are used in the environment.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['5.2'] }, { '7' => ['4.4'] }]
  tag default_value: 'Enable - Yes
                      Mode - Audit'
  tag nist: ['IA-5(1)', 'CA-9', 'SC-7', 'SC-7(5)']

  ref 'https://learn.microsoft.com/en-us/azure/active-directory/authentication/howto-password-ban-bad-on-premises-operations'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
