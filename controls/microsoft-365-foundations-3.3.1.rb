control 'microsoft-365-foundations-3.3.1' do
  title 'Ensure SharePoint Online Information Protection policies are set up and used'
  desc 'SharePoint Online Data Classification Policies enables organizations to classify and label content in SharePoint Online based on its sensitivity and business impact. This setting helps organizations to manage and protect sensitive data by automatically applying labels to content, which can then be used to apply policy-based protection and governance controls.'

  desc 'check',
       "Ensure SharePoint Online Information Protection policies are set up and used:
        1. Navigate to Microsoft Purview compliance portal https://compliance.microsoft.com.
        2. Under Solutions select Information protection.
        3. Click on the Label policies tab.
        4. Ensure that a Label policy exists and is published accordingly."

  desc 'fix',
       "To set up SharePoint Online Information Protection:
        1. Navigate to Microsoft Purview compliance portal https://compliance.microsoft.com.
        2. Under Solutions select Information protection.
        3. Click on the Label policies tab.
        4. Click Create a label to create a label.
        5. Select the label and click on the Publish label.
        6. Fill out the forms to create the policy."

  desc 'rationale',
       'By categorizing and applying policy-based protection, SharePoint Online Data
        Classification Policies can help reduce the risk of data loss or exposure and enable
        more effective incident response if a breach does occur.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [
    { '8' => ['3.7'] },
    { '7' => ['13.1'] },
    { '7' => ['14.6'] }
  ]
  tag nist: ['RA-2', 'AU-6(1)', 'AU-7', 'IR-4(1)', 'SI-4(2)', 'SI-4(5)', 'AT-2']

  ref 'https://learn.microsoft.com/en-us/microsoft-365/compliance/data-classification-overview?view=o365-worldwide#top-sensitivity-labels-applied-to-content'
  ref 'https://learn.microsoft.com/en-us/purview/sensitivity-labels-sharepoint-onedrive-files'

  describe 'manual' do
    skip 'The test for this control needs to be done manually'
  end
end
