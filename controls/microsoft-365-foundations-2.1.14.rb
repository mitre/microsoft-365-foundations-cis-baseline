control 'microsoft-365-foundations-2.1.14' do
    title 'Ensure comprehensive attachment filtering is applied'
    desc 'The Common Attachment Types Filter lets a user block known and custom malicious file types from being attached to emails. The policy provided by Microsoft covers 53 extensions, and an additional custom list of extensions can be defined.
        The list of 187 extensions provided in this recommendation is comprehensive but not exhaustive.'

    desc 'check'
        'Note: Utilizing the UI for auditing Anti-malware policies can be very time consuming so it is recommended to use a script like the one supplied below. To Audit using PowerShell:
            1.Connect to Exchange Online using Connect-ExchangeOnline.
            2.Run the following script:
                # Evaluate each Malware policy containing over 120 extensions # Output a report showing a list of missing extensions and other params. $L2Extensions = @( "7z", "a3x", "ace", "ade", "adp", "ani", "app", "appinstaller", "applescript", "application", "appref-ms", "appx", "appxbundle", "arj", "asd", "asx", "bas", "bat", "bgi", "bz2", "cab", "chm", "cmd", "com", "cpl", "crt", "cs", "csh", "daa", "dbf", "dcr", "deb", "desktopthemepackfile", "dex", "diagcab", "dif", "dir", "dll", "dmg", "doc", "docm", "dot", "dotm", "elf", "eml", "exe", "fxp", "gadget", "gz", "hlp", "hta", "htc", "htm", "htm", "html", "html", "hwpx", "ics", "img", "inf", "ins", "iqy", "iso", "isp", "jar", "jnlp", "js", "jse", "kext", "ksh", "lha", "lib", "library-ms", "lnk", "lzh", "macho", "mam", "mda", "mdb", "mde", "mdt", "mdw", "mdz", "mht", "mhtml", "mof", "msc", "msi", "msix", "msp", "msrcincident", "mst", "ocx", "odt", "ops", "oxps", "pcd", "pif", "plg", "pot", "potm", "ppa", "ppam", "ppkg", "pps", "ppsm", "ppt", "pptm", "prf", "prg", "ps1", "ps11", "ps11xml", "ps1xml", "ps2", "ps2xml", "psc1", "psc2", "pub", "py", "pyc", "pyo", "pyw", "pyz", "pyzw", "rar", "reg", "rev", "rtf", "scf", "scpt", "scr", "sct", "searchConnector-ms", "service", "settingcontent-ms", "sh", "shb", "shs", "shtm", "shtml", "sldm", "slk", "so", "spl", "stm", "svg", "swf", "sys", "tar", "theme", "themepack", "timer", "uif", "url", "uue", "vb", "vbe", "vbs", "vhd", "vhdx", "vxd", "wbk", "website", "wim", "wiz", "ws", "wsc", "wsf", "wsh", "xla", "xlam", "xlc", "xll", "xlm", "xls", "xlsb", "xlsm", "xlt", "xltm", "xlw", "xml", "xnk", "xps", "xsl", "xz", "z" )
                $MissingCount = 0 
                $ExtensionPolicies = $null 
                $RLine = $ExtensionReport = @()
                $FilterRules = Get-MalwareFilterRule 
                $DateTime = $(((Get-Date).ToUniversalTime()).ToString("yyyyMMddTHHmmssZ"))
                $OutputFilePath = "$PWD\CIS-Report_$($DateTime).txt"
                
                $RLine += "$(Get-Date)`n" 
                function Test-MalwarePolicy { 
                    param ( 
                        $PolicyId 
                    ) 
                    # Find the matching rule for custom policies 
                    $FoundRule = $null 
                    $FoundRule = $FilterRules | 
                        Where-Object { $_.MalwareFilterPolicy -eq $PolicyId } 
                    if ($PolicyId.EnableFileFilter -eq $false) { 
                            $script:RLine += "WARNING: Common attachments filter is disabled." 
                    } 
                    if ($FoundRule.State -eq \'Disabled\') { 
                        $script:RLine += "WARNING: The Anti-malware rule is disabled." 
                    } 
                    $script:RLine += "`nManual review needed - Domains, inclusions and exclusions must be valid:" 
                    $script:RLine += $FoundRule | 
                        Format-List Name, RecipientDomainIs, Sent*, Except* 
                    }
                # Match any policy that has over 120 extensions defined 
                $ExtensionPolicies = Get-MalwareFilterPolicy | 
                    Where-Object {$_.FileTypes.Count -gt 120 } 
                if (!$ExtensionPolicies) { 
                    Write-Host "`nFAIL: A policy containing the minimum number of extensions was not found." -ForegroundColor Red
                    Write-Host "Only policies with over 120 extensions defined will be evaluated." -ForegroundColor Red Exit 
                    } 
                # Check each policy for missing extensions 
                foreach ($policy in $ExtensionPolicies){ 
                    $MissingExtensions = $L2Extensions | 
                    Where-Object { 
                        $extension = $_; -not $policy.FileTypes.Contains($extension) 
                        } 
                    if ($MissingExtensions.Count -eq 0) { 
                        $RLine += "-" * 60 
                        $RLine += "[FOUND] 
                        $($policy.Identity)" 
                        $RLine += "-" * 60 
                        $RLine += "PASS: Policy contains all extensions" 
                        Test-MalwarePolicy -PolicyId $policy 
                    } else { 
                        $MissingCount++ 
                        $ExtensionReport += @{ 
                            Identity = $policy.Identity
                            MissingExtensions = $MissingExtensions -join ', ' 
                        } 
                    } 
                } 
                if ($MissingCount -gt 0) {
                    foreach ($fpolicy in $ExtensionReport) {
                        $RLine += "-" * 60 
                        $RLine += "[PARTIAL] 
                        $($fpolicy.Identity)" 
                        $RLine += "-" * 60 
                        $RLine += "NOTICE - The following extensions were not found:`n"
                        $RLine += "$($fpolicy.MissingExtensions)`n" Test-MalwarePolicy -PolicyId $fpolicy.Identity 
                    } 
                } 
                # Output the report to a text file 
                Out-File -FilePath $OutputFilePath -InputObject $RLine 
                Get-Content $OutputFilePath 
                Write-Host "`nLog file exported to" $OutputFilePath
            3.Review the exported results which are stored in the present working directory.
            4.A pass for this recommendation is made when an active policy is in place that covers all extensions except for those explicitly defined as an exception by the organization. A passing policy must also be enabled and have the EnableFileFilter parameter enabled.
            5.Review any manual steps listed in the output, exceptions and inclusions are organizational specific.
        Note: Weighting by individual extension risk is beyond the scope of this document. Organizations should evaluate these both independently and based on business need.'
    
    desc 'fix'
    'To Remediate using PowerShell:
        1.Connect to Exchange Online using Connect-ExchangeOnline.
        2.Run the following script: 
            # Create an attachment policy and associated rule. The rule is 
            # intentionally disabled allowing the org to enable it when ready 
            $Policy = @{ 
                Name = "CIS L2 Attachment Policy" 
                EnableFileFilter = $true 
                ZapEnabled = $true 
                EnableInternalSenderAdminNotifications = $true 
                InternalSenderAdminAddress = \'admin@contoso.com\' # Change this. 
            } 
            $L2Extensions = @(
             "7z", "a3x", "ace", "ade", "adp", "ani", "app", "appinstaller", "applescript", "application", "appref-ms", "appx", "appxbundle", "arj", "asd", "asx", "bas", "bat", "bgi", "bz2", "cab", "chm", "cmd", "com", "cpl", "crt", "cs", "csh", "daa", "dbf", "dcr", "deb", "desktopthemepackfile", "dex", "diagcab", "dif", "dir", "dll", "dmg", "doc", "docm", "dot", "dotm", "elf", "eml", "exe", "fxp", "gadget", "gz", "hlp", "hta", "htc", "htm", "htm", "html", "html", "hwpx", "ics", "img", "inf", "ins", "iqy", "iso", "isp", "jar", "jnlp", "js", "jse", "kext", "ksh", "lha", "lib", "library-ms", "lnk", "lzh", "macho", "mam", "mda", "mdb", "mde", "mdt", "mdw", "mdz", "mht", "mhtml", "mof", "msc", "msi", "msix", "msp", "msrcincident", "mst", "ocx", "odt", "ops", "oxps", "pcd", "pif", "plg", "pot", "potm", "ppa", "ppam", "ppkg", "pps", "ppsm", "ppt", "pptm", "prf", "prg", "ps1", "ps11", "ps11xml", "ps1xml", "ps2", "ps2xml", "psc1", "psc2", "pub", "py", "pyc", "pyo", "pyw", "pyz", "pyzw", "rar", "reg", "rev", "rtf", "scf", "scpt", "scr", "sct", "searchConnector-ms", "service", "settingcontent-ms", "sh", "shb", "shs", "shtm", "shtml", "sldm", "slk", "so", "spl", "stm", "svg", "swf", "sys", "tar", "theme", "themepack", "timer", "uif", "url", "uue", "vb", "vbe", "vbs", "vhd", "vhdx", "vxd", "wbk", "website", "wim", "wiz", "ws", "wsc", "wsf", "wsh", "xla", "xlam", "xlc", "xll", "xlm", "xls", "xlsb", "xlsm", "xlt", "xltm", "xlw", "xml", "xnk", "xps", "xsl", "xz", "z" 
            ) 
            # Create the policy 
            New-MalwareFilterPolicy @Policy -FileTypes $L2Extensions 
            # Create the rule for all accepted domains 
            $Rule = @{ 
                Name = $Policy.Name
                Enabled = $false
                MalwareFilterPolicy = $Policy.Name 
                RecipientDomainIs = (Get-AcceptedDomain).Name 
                Priority = 0 
            } 
            New-MalwareFilterRule @Rule
        3.When prepared enable the rule either through the UI or PowerShell.

        Note: Due to the number of extensions the UI method is not covered. The objects can however be edited in the UI or manually added using the list from the script.
            1.Navigate to Microsoft Defender at https://security.microsoft.com/
            2.Browse to Policies & rules > Threat policies > Anti-malware.'
    
    impact 0.5
    tag severity: 'medium'
    tag cis_controls: [{ '8' => ['9.6'] }, {'7' => ['7.9']}, {'7' => ['8.1']}] 
    
    ref 'https://learn.microsoft.com/en-us/powershell/module/exchange/get-malwarefilterpolicy?view=exchange-ps'
    ref 'https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/anti-malware-policies-configure?view=o365-worldwide'
    ref 'https://learn.microsoft.com/en-us/deployoffice/compat/office-file-format-reference'
