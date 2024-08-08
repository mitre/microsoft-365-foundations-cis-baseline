control 'microsoft-365-foundations-3.2.1' do
    title 'Ensure DLP policies are enabled'
    desc 'Data Loss Prevention (DLP) policies allow Exchange Online and SharePoint Online content to be scanned for specific types of data like social security numbers, credit card numbers, or passwords.'

    desc 'check'
    'Ensure DLP policies are enabled:
        1. Navigate to Microsoft Purview https://compliance.microsoft.com.
        2. Under Solutions select Data loss prevention then Policies.
        3. Verify that policies exist and are enabled.'
    
    desc 'fix'
    'To enable DLP policies:
        1. Navigate to Microsoft Purview https://compliance.microsoft.com.
        2. Under Solutions select Data loss prevention then Policies.
        3. Click Create policy.'

    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['3.1'] }, { '7' => ['13'] }, { '7' => ['14.7'] }]

    ref 'https://learn.microsoft.com/en-us/microsoft-365/compliance/dlp-learn-about-dlp?view=o365-worldwide'

    describe 'manual' do
        skip 'manual'
    end
end