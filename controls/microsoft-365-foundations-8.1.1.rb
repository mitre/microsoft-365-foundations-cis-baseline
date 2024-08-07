control 'microsoft-365-foundations-8.1.1' do
    title 'Ensure external file sharing in Teams is enabled for only approved cloud storage services'
    desc 'Microsoft Teams enables collaboration via file sharing. This file sharing is conducted within Teams, using SharePoint Online, by default; however, third-party cloud services are allowed as well.
        Note: Skype for business is deprecated as of July 31, 2021 although these settings may still be valid for a period of time. See the link in the references section for more information.'

    desc 'check'
    'To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Teams select Teams settings.
        3. Under files verify that only authorized cloud storage options are set to On and all others Off.
    To audit using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams
        2. Run the following to verify the recommended state: 
            Get-CsTeamsClientConfiguration | fl AllowDropbox,AllowBox,AllowGoogleDrive,AllowShareFile,AllowEgnyte
        3. Verify that only authorized providers are set to True and all others False.'
    
    desc 'fix'
    'To set external file sharing in Teams:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Teams select Teams settings.
        3. Set any unauthorized providers to Off.
    To set cloud sharing options using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams
        2. Run the following PowerShell command to disable external providers that are not authorized. (the example disables Citrix Files, DropBox, Box, Google Drive and Egnyte) 
            $storageParams = @{ AllowGoogleDrive = $false AllowShareFile = $false AllowBox = $false AllowDropBox = $false AllowEgnyte = $false } 
            Set-CsTeamsClientConfiguration @storageParams'
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['3.3'] }, { '7' => ['14.7'] }]

    ref 'https://learn.microsoft.com/en-us/microsoft-365/enterprise/manage-skype-for-business-online-with-microsoft-365-powershell?view=o365-worldwide'
    