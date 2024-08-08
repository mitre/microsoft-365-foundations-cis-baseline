control "microsoft-365-foundations-5.1.2.6" do
  title "Ensure 'LinkedIn account connections' is disabled"
  desc "LinkedIn account connections allow users to connect their Microsoft work or school account with LinkedIn. After a user connects their accounts, information and highlights from LinkedIn are available in some Microsoft apps and services."

  desc "check",
       "Ensure that LinkedIn account connections is disabled:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Users select User settings.
        3. Under LinkedIn account connections ensure No is highlighted."

  desc "fix",
       "To disable LinkedIn account connections:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Users select User settings.
        3. Under LinkedIn account connections select No.
        4. Click Save."

  impact 0.5
  tag severity: "medium"
  tag cis_controls: [{ "8" => ["4.8"] }, { "7" => ["13.3"] }]

  ref "https://learn.microsoft.com/en-us/azure/active-directory/enterprise-users/linkedin-integration"
  ref "https://learn.microsoft.com/en-us/azure/active-directory/enterprise-users/linkedin-user-consent"

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
