control "microsoft-365-foundations-5.1.2.5" do
  title "Ensure the option to remain signed in is hidden"
  desc "The option for the user to Stay signed in, or the Keep me signed in option, will prompt a user after a successful login. When the user selects this option, a persistent refresh token is created. The refresh token lasts for 90 days by default and does not prompt for sign-in or multifactor."

  desc "check",
       "Ensure the option to remain signed in is hidden:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity> Users > User settings.
        3. Ensure Show keep user signed in is highlighted No."

  desc "fix",
       "To disable the option to remain signed in:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity> Users > User settings.
        3. Set Show keep user signed in to No.
        4. Click Save"

  impact 0.5
  tag severity: "medium"
  tag cis_controls: [{ "7" => ["16.3"] }]

  ref "https://learn.microsoft.com/en-us/entra/identity/authentication/concepts-azure-multi-factor-authentication-prompts-session-lifetime?source=recommendations"
  ref "https://learn.microsoft.com/en-us/entra/fundamentals/how-to-manage-stay-signed-in-prompt"

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
