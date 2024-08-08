control 'microsoft-365-foundations-1.3.6' do
  title 'Ensure the customer lockbox feature is enabled'
  desc 'Customer Lockbox is a security feature that provides an additional layer of control and transparency to customer data in Microsoft 365. It offers an approval process for Microsoft support personnel to access organization data and creates an audited trail to meet compliance requirements.'

  desc 'check',
       "Ensure the customer lockbox feature is enabled:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com.
        2. Click to expand Settings then select Org settings.
        3. Select Security & privacy tab.
        4. Click Customer lockbox.
        5. Ensure the box labeled Require approval for all data access requests is checked.
    To verify the Customer Lockbox feature is enabled using the SecureScore Portal:
        1. Navigate to the Microsoft 365 SecureScore portal. https://securescore.microsoft.com
        2. Search for Turn on customer lockbox feature under Improvement actions
    To verify the Customer Lockbox feature is enabled using the REST API:
        GET https://graph.microsoft.com/beta/security/secureScores
    To verify the Customer Lockbox feature is enabled using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command: Get-OrganizationConfig | Select-Object CustomerLockBoxEnabled
        3. Verify the value is set to True"

  desc 'fix',
       "To enable the Customer Lockbox feature:
        1. Navigate to Microsoft 365 admin center https://admin.microsoft.com.
        2. Click to expand Settings then select Org settings.
        3. Select Security & privacy tab.
        4. Click Customer lockbox.
        5. Check the box Require approval for all data access requests.
        6. Click Save.
    To set the Customer Lockbox feature to enabled using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            Set-OrganizationConfig -CustomerLockBoxEnabled $true"
  impact 0.5
  tag severity: 'medium'
  ref 'https://learn.microsoft.com/en-us/azure/security/fundamentals/customer-lockbox-overview'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
