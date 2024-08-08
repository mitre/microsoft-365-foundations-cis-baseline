control "microsoft-365-foundations-1.3.2" do
  title "Ensure 'Idle session timeout' is set to '3 hours (or less)' for unmanaged devices"
  desc "Idle session timeout allows the configuration of a setting which will timeout inactive users after a pre-determined amount of time. When a user reaches the set idle timeout session, they'll get a notification that they're about to be signed out. They have to select to stay signed in or they'll be automatically signed out of all Microsoft 365 web apps. Combined with a Conditional Access rule this will only impact unmanaged devices. A managed device is considered a device managed by Intune MDM.
        The following Microsoft 365 web apps are supported.
            • Outlook Web App
            • OneDrive for Business
            • SharePoint Online (SPO)
            • Office.com and other start pages
            • Office (Word, Excel, PowerPoint) on the web
            • Microsoft 365 Admin Center
        NOTE: Idle session timeout doesn't affect Microsoft 365 desktop and mobile apps.
        The recommended setting is 3 hours (or less) for unmanaged devices."
  desc "check",
       "Step 1 - Ensure Idle session timeout is configured:
            1. Navigate to the Microsoft 365 admin center https://admin.microsoft.com/.
            2. Click to expand Settings Select Org settings.
            3. Click Security & Privacy tab.
            4. Select Idle session timeout.
            5. Verify Turn on to set the period of inactivity for users to be signed off of Microsoft 365 web apps is set to 3 hours (or less).
        Step 2 - Ensure the Conditional Access policy is in place:
            1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/
            2. Expand Protect > Conditional Access.
            3. Inspect existing conditional access rules for one that meets the below conditions:
                • Users is set to All users
                • Cloud apps or actions > Select apps is set to Office 365.
                • Conditions > Client apps is Browser and nothing else.
                • Session is set to Use app enforced restrictions.
                • Enable Policy is set to On
        NOTE: To ensure that idle timeouts affect only unmanaged devices, both steps must be completed."
  desc "fix",
       "To configure Idle session timeout:
        1. Navigate to the Microsoft 365 admin center https://admin.microsoft.com/.
        2. Click to expand Settings Select Org settings.
        3. Click Security & Privacy tab.
        4. Select Idle session timeout.
        5. Check the box Turn on to set the period of inactivity for users to be signed off of Microsoft 365 web apps
        6. Set a maximum value of 3 hours.
        7. Click save.
    Step 2 - Ensure the Conditional Access policy is in place:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/
        2. Expand Protect > Conditional Access
        3. Click New policy and give the policy a name.
        4. Select Users > All users.
        5. Select Cloud apps or actions > Select apps and select Office 365
        6. Select Conditions > Client apps > Yes check only Browser unchecking all other boxes.
        7. Select Sessions and check Use app enforced restrictions.
        8. Set Enable policy to On and click Create.
    NOTE: To ensure that idle timeouts affect only unmanaged devices, both steps must be completed."

  impact 0.5
  tag severity: "medium"
  tag cis_controls: [{ "8" => ["4.3"] }]

  ref "https://learn.microsoft.com/en-us/microsoft-365/admin/manage/idle-session-timeout-web-apps?view=o365-worldwide"

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
