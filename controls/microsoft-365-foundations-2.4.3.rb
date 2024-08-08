control 'microsoft-365-foundations-2.4.3' do
  title 'Ensure Microsoft Defender for Cloud Apps is enabled and configured'
  desc "Microsoft Defender for Cloud Apps is a Cloud Access Security Broker (CASB). It provides visibility into suspicious activity in Microsoft 365, enabling investigation into potential security issues and facilitating the implementation of remediation measures if necessary.
        Some risk detection methods provided by Entra Identity Protection also require Microsoft Defender for Cloud Apps:
            •Suspicious manipulation of inbox rules
            •Suspicious inbox forwarding
            •New country detection
            •Impossible travel detection
            •Activity from anonymous IP addresses
            •Mass access to sensitive files"

  desc 'check',
       "Ensure Microsoft Defender for Cloud Apps is enabled and configured:
        1.Navigate to Microsoft 365 Defender https://security.microsoft.com/
        2.Select Settings > Cloud apps.
        3.Scroll to Connected apps and select App connectors.
        4.Ensure that Microsoft 365 and Microsoft Azure both show in the list as Connected.
        5.Go to Cloud Discovery > Microsoft Defender for Endpoint and check if the integration is enabled.
        6.Go to Information Protection > Files and verify Enable file monitoring is checked."

  desc 'fix',
       "Configure Information Protection and Cloud Discovery:
        1.Navigate to Microsoft 365 Defender https://security.microsoft.com/
        2.Select Settings > Cloud apps.
        3.Scroll to Information Protection and select Files.
        4.Check Enable file monitoring.
        5.Scroll up to Cloud Discovery and select Microsoft Defender for Endpoint.
        6.Check Enforce app access, configure a Notification URL and Save.
    Note: Defender for Endpoint requires a Defender for Endpoint license.
    Configure App Connectors:
        1.Scroll to Connected apps and select App connectors.
        2.Click on Connect an app and select Microsoft 365.
        3.Check all Azure and Office 365 boxes then click Connect Office 365.
        4.Repeat for the Microsoft Azure application."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [
    { '8' => ['10.1'] },
    { '8' => ['10.5'] },
    { '7' => ['6.2'] },
    { '7' => ['16'] }
  ]

  ref 'https://learn.microsoft.com/en-us/defender-cloud-apps/connect-office-365'
  ref 'https://learn.microsoft.com/en-us/defender-cloud-apps/connect-azure'
  ref 'https://learn.microsoft.com/en-us/defender-cloud-apps/best-practices'
  ref 'https://learn.microsoft.com/en-us/defender-cloud-apps/get-started'
  ref 'https://learn.microsoft.com/en-us/azure/active-directory/identity-protection/concept-identity-protection-risks'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
