control "microsoft-365-foundations-2.1.5" do
  title "Ensure Safe Attachments for SharePoint, OneDrive, and Microsoft Teams is Enabled"
  desc "Safe Attachments for SharePoint, OneDrive, and Microsoft Teams scans these services for malicious files."

  desc "check",
       "Ensure Safe Attachments for SharePoint, OneDrive, and Microsoft Teams is Enabled:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com
        2. Under Email & collaboration select Policies & rules
        3. Select Threat policies then Safe Attachments.
        4. Click on Global settings
        5. Ensure the toggle is Enabled to Turn on Defender for Office 365 for SharePoint, OneDrive, and Microsoft Teams.
        6. Ensure the toggle is Enabled to Turn on Safe Documents for Office clients.
        7. Ensure the toggle is Deselected/Disabled to Allow people to click through Protected View even if Safe Documents identified the file as malicious.
    To audit using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            Get-AtpPolicyForO365 | fl Name,EnableATPForSPOTeamsODB,EnableSafeDocs,AllowSafeDocsOpen
        Verify the values for each parameter as below:
            EnableATPForSPOTeamsODB : True
            EnableSafeDocs : True
            AllowSafeDocsOpen : False"

  desc "fix",
       "To enable Safe Attachments for SharePoint, OneDrive, and Microsoft Teams:
        1. Navigate to Microsoft 365 Defender https://security.microsoft.com
        2. Under Email & collaboration select Policies & rules
        3. Select Threat policies then Safe Attachments.
        4. Click on Global settings
        5. Click to Enable Turn on Defender for Office 365 for SharePoint, OneDrive, and Microsoft Teams
        6. Click to Enable Turn on Safe Documents for Office clients
        7. Click to Disable Allow people to click through Protected View even if Safe Documents identified the file as malicious.
        8. Click Save
    To remediate using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command:
            Set-AtpPolicyForO365 -EnableATPForSPOTeamsODB $true -EnableSafeDocs $true -AllowSafeDocsOpen $false"

  impact 0.5
  tag severity: "medium"
  tag cis_controls: [
        { "8" => ["9.7"] },
        { "8" => ["10.1"] },
        { "7" => ["7.10"] },
        { "7" => ["8.1"] }
      ]
  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
