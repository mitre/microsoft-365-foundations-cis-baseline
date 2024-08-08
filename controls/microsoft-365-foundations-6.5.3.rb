control 'microsoft-365-foundations-6.5.3' do
    title 'Ensure additional storage providers are restricted in Outlook on the web'
    desc "This setting allows users to open certain external files while working in Outlook on the web. If allowed, keep in mind that Microsoft doesn't control the use terms or privacy policies of those third-party services.
        Ensure AdditionalStorageProvidersAvailable are restricted."
    
    desc 'check'
    'To audit using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command: 
            Get-OwaMailboxPolicy | Format-Table Name, AdditionalStorageProvidersAvailable
        3. Verify that the value returned is False.'
    
    desc 'fix'
    'To remediate using PowerShell:
        1. Connect to Exchange Online using Connect-ExchangeOnline.
        2. Run the following PowerShell command: 
            Set-OwaMailboxPolicy -Identity OwaMailboxPolicy-Default -AdditionalStorageProvidersAvailable $false'
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['3.3'] }, { '7' => ['13.1'] }, { '7' => ['13.4'] }]

    ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/set-owamailboxpolicy?view=exchange-ps'
    ref 'https://support.microsoft.com/en-us/topic/3rd-party-cloud-storage-services-supported-by-office-apps-fce12782-eccc-4cf5-8f4b-d1ebec513f72'
end
    