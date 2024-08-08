control 'microsoft-365-foundations-2.4.1' do
  title 'Ensure Priority account protection is enabled and configured'
  desc "Identify priority accounts to utilize Microsoft 365's advanced custom security features. This is an essential tool to bolster protection for users who are frequently targeted due to their critical positions, such as executives, leaders, managers, or others who have access to sensitive, confidential, financial, or high-priority information.
        Once these accounts are identified, several services and features can be enabled, including threat policies, enhanced sign-in protection through conditional access policies, and alert policies, enabling faster response times for incident response teams."

  desc 'check',
       "Audit with a 3-step process
    Step 1: Verify Priority account protection is enabled:
        1.Navigate to Microsoft 365 Defender https://security.microsoft.com/
        2.Select Settings > E-mail & Collaboration > Priority account protection
        3.Ensure Priority account protection is set to On
    Step 2: Verify that priority accounts are identified and tagged accordingly:
        4.Select User tags
        5.Select the PRIORITY ACCOUNT tag and click Edit
        6.Verify the assigned members match the organization's defined priority accounts or groups.
        7.Repeat the previous 2 steps for any additional tags identified, such as Finance or HR.
    Step 3: Ensure alerts are configured:
        8.Expand E-mail & Collaboration on the left column.
        9.Select Policies & rules > Alert policy
        10.Ensure alert policies are configured for priority accounts, enabled and have a valid recipient. The tags column can be used to identify policies using a specific tag"

  desc 'fix',
       "Remediate with a 3-step process
    Step 1: Enable Priority account protection in Microsoft 365 Defender:
        1.Navigate to Microsoft 365 Defender https://security.microsoft.com/
        2.Select Settings > E-mail & Collaboration > Priority account protection
        3.Ensure Priority account protection is set to On
    Step 2: Tag priority accounts:
        4.Select User tags
        5.Select the PRIORITY ACCOUNT tag and click Edit
        6.Select Add members to add users, or groups. Groups are recommended.
        7.Repeat the previous 2 steps for any additional tags needed, such as Finance or HR.
        8.Next and Submit.
    Step 3: Configure E-mail alerts for Priority Accounts:
        9.Expand E-mail & Collaboration on the left column.
        10.Select New Alert Policy
        11.Enter a valid policy Name & Description. Set Severity to High and Category to Threat management.
        12.Set Activity is to Detected malware in an e-mail message
        13.Mail direction is Inbound
        14.Select Add Condition and User: recipient tags are
        15.In the Selection option field add chosen priority tags such as Priority account.
        16.Select Every time an activity matches the rule.
        17.Next and Verify valid recipient(s) are selected.
        18.Next and select Yes, turn it on right away. Click Submit to save the alert.
        19.Repeat steps 10 - 18 for the Activity field Activity is: Phishing email detected at time of delivery
    NOTE: Any additional activity types may be added as needed. Above are the minimum recommended."

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['9.7'] }]

  ref 'https://learn.microsoft.com/en-us/microsoft-365/admin/setup/priority-accounts'
  ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/security-recommendations-for-priority-accounts'

  describe "This control's test logic needs to be implemented." do
    skip "This control's test logic needs to be implemented."
  end
end
