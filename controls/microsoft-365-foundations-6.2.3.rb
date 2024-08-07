control 'microsoft-365-foundations-6.2.2' do
    title 'Ensure email from external senders is identified'
    desc "External callouts provide a native experience to identify emails from senders outside the organization. This is achieved by presenting a new tag on emails called "External" (the string is localized based on the client language setting) and exposing related user interface at the top of the message reading view to see and verify the real sender's email address.
        Once this feature is enabled via PowerShell, it might take 24-48 hours for users to start seeing the External sender tag in email messages received from external sources (outside of your organization), providing their Outlook version supports it.
        The recommended state is ExternalInOutlook set to Enabled True
        Note: Mail flow rules are often used by Exchange administrators to accomplish the External email tagging by appending a tag to the front of a subject line. There are limitations to this outlined here. The preferred method in the CIS Benchmark is to use the native experience."
    
    desc 'check'
    'To verify external sender tagging using PowerShell:
        1. Connect to Exchange online using Connect-ExchangeOnline.
        2. Run the following PowerShell command: 
            Get-ExternalInOutlook
        3. For each identity verify Enabled is set to True and the AllowList only contains email addresses the organization has permitted to bypass external tagging.'
    
    desc 'fix'
    'To enable external tagging using PowerShell:
        1. Connect to Exchange online using Connect-ExchangeOnline.
        2. Run the following PowerShell command: 
            Set-ExternalInOutlook -Enabled $true'
    
    impact 0.5
    tag severity: 'medium'

    ref 'https://techcommunity.microsoft.com/t5/exchange-team-blog/native-external-sender-callouts-on-email-in-outlook/ba-p/2250098'
    ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/set-externalinoutlook?view=exchange-ps'