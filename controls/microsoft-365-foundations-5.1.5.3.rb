control 'microsoft-365-foundations-5.1.5.3' do
    title 'Ensure the admin consent workflow is enabled'
    desc 'The admin consent workflow gives admins a secure way to grant access to applications that require admin approval. When a user tries to access an application but is unable to provide consent, they can send a request for admin approval. The request is sent via email to admins who have been designated as reviewers. A reviewer takes action on the request, and the user is notified of the action.'

    desc 'check'
    'Ensure the admin consent workflow is enabled:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Applications select Enterprise applications.
        3. Under Security select Consent and permissions.
        4. Under Manage select Admin consent settings.
        5. Verify that Users can request admin consent to apps they are unable to consent to is set to Yes.'

    desc 'fix'
    'To enable the admin consent workflow, use the Microsoft 365 Admin Center:
        1. Navigate to Microsoft Entra admin center https://entra.microsoft.com/.
        2. Click to expand Identity > Applications select Enterprise applications.
        3. Under Security select Consent and permissions.
        4. Under Manage select Admin consent settings.
        5. Set Users can request admin consent to apps they are unable to consent to to Yes under Admin consent requests.
        6. Under the Reviewers choose the Roles and Groups that will review user generated app consent requests.
        7. Set Selected users will receive email notifications for requests to Yes
        8. Select Save at the top of the window.'
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['2.5'] }, { '7' => ['18.3'] }]

    ref 'https://learn.microsoft.com/en-us/azure/active-directory/manage-apps/configure-admin-consent-workflow'

    describe 'manual' do
        skip 'manual'
    end
end