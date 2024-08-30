control 'microsoft-365-foundations-8.1.1' do
  title 'Ensure external file sharing in Teams is enabled for only approved cloud storage services'
  desc "Microsoft Teams enables collaboration via file sharing. This file sharing is conducted within Teams, using SharePoint Online, by default; however, third-party cloud services are allowed as well.
        Note: Skype for business is deprecated as of July 31, 2021 although these settings may still be valid for a period of time. See the link in the references section for more information."

  desc 'check',
       "To audit using the UI:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Teams select Teams settings.
        3. Under files verify that only authorized cloud storage options are set to On and all others Off.
    To audit using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams
        2. Run the following to verify the recommended state:
            Get-CsTeamsClientConfiguration | fl AllowDropbox,AllowBox,AllowGoogleDrive,AllowShareFile,AllowEgnyte
        3. Verify that only authorized providers are set to True and all others False."

  desc 'fix',
       "To set external file sharing in Teams:
        1. Navigate to Microsoft Teams admin center https://admin.teams.microsoft.com.
        2. Click to expand Teams select Teams settings.
        3. Set any unauthorized providers to Off.
    To set cloud sharing options using PowerShell:
        1. Connect to Teams PowerShell using Connect-MicrosoftTeams
        2. Run the following PowerShell command to disable external providers that are not authorized. (the example disables Citrix Files, DropBox, Box, Google Drive and Egnyte)
            $storageParams = @{ AllowGoogleDrive = $false AllowShareFile = $false AllowBox = $false AllowDropBox = $false AllowEgnyte = $false }
            Set-CsTeamsClientConfiguration @storageParams"

  desc 'rationale',
       'Ensuring that only authorized cloud storage providers are accessible from Teams will
        help to dissuade the use of non-approved storage providers.'

  impact 0.5
  tag severity: 'medium'
  tag cis_controls: [{ '8' => ['3.3'] }, { '7' => ['14.7'] }]
  tag default_value: 'AllowDropBox : True
                      AllowBox : True
                      AllowGoogleDrive : True
                      AllowShareFile : True
                      AllowEgnyte : True'
  tag nist: ['AC-3', 'AC-5', 'AC-6', 'MP-2', 'AT-2']

  ref 'https://learn.microsoft.com/en-us/microsoft-365/enterprise/manage-skype-for-business-online-with-microsoft-365-powershell?view=o365-worldwide'

  ensure_file_sharing_enabled_cloud_script = %{
     $appName = 'cisBenchmarkL512'
     $client_id = '#{input('client_id')}'
     $tenantid = '#{input('tenant_id')}'
     $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2('#{input('certificate_path')}','#{input('certificate_password')}')
     Connect-MicrosoftTeams -Certificate $cert -ApplicationId $client_id -TenantId $tenantid > $null

     $teamsClientConfig = Get-CsTeamsClientConfiguration | Select-Object AllowDropbox,AllowBox,AllowGoogleDrive,AllowShareFile,AllowEgnyte
     $allTrue = $false
     foreach ($property in @('AllowDropbox', 'AllowBox', 'AllowGoogleDrive', 'AllowShareFile', 'AllowEgnyte')) {
        if ($teamsClientConfig.$property -ne $true) {
          $allTrue = $false
          break
        }
      }
      if ($allTrue) {
          Write-Output "True"
      } else {
          Write-Output "False"
      }
    }

  powershell_output = powershell(ensure_file_sharing_enabled_cloud_script)
  describe 'Ensure that all the authorized cloud storage services ' do
    subject { powershell_output.stdout.strip }
    it 'are set to true' do
      expect(subject).to eq('True')
    end
  end
end
