## Getting Started  
It is intended and recommended that InSpec and this profile be run from a __"runner"__ host (such as a DevOps orchestration server, an administrative management system, or a developer's workstation/laptop) against the target.

__For the best security of the runner, always install on the runner the _latest version_ of InSpec and supporting Ruby language components.__

Latest versions and installation options are available at the [InSpec](http://inspec.io/) site.

The M365 CIS Benchmark includes security requirements for an Microsoft 365 environment.

## Getting Started

### Requirements

#### Microsoft 365
- M365 account API credentials and certificate
- M365 providing appropriate permissions to perform audit scan
  - This can be done by creating an application registration within your account, which will provide you with the appropriate credentials to login such as Client ID and Tenant ID. You will need to create a Client Secret/Certificate as well. The following link provides more detail on how to setup an application registration: [Application_Registration_Steps](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=certificate)

# Ensure the Following Permissions on your Application Registration Account
  - Microsoft Graph
    - SecurityEvents.Read.All
    - User.Read
  - Office 365 Exchange Online
    - Exchange.ManageAsApp
  - SharePoint
    - Sites.FullControl.All
  
#### Required software on the InSpec Runner
- git
- [Powershell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4)
- [InSpec](https://www.chef.io/products/chef-inspec/)

## PowerShell Module Installation
Ensure access and install the following powershell modules. The controls also have the module installation code when running the Powershell queries for redundancy purposes:
- [Microsoft.Graph](https://learn.microsoft.com/en-us/powershell/microsoftgraph/installation?view=graph-powershell-1.0#installation)
- [ExchangeOnlineManagement](https://learn.microsoft.com/en-us/powershell/exchange/connect-to-exchange-online-powershell?view=exchange-ps)
- [PnP.PowerShell](https://learn.microsoft.com/en-us/powershell/sharepoint/sharepoint-pnp/sharepoint-pnp-cmdlets)
- [MicrosoftTeams](https://learn.microsoft.com/en-us/microsoftteams/teams-powershell-install)

### Setup Environment on the InSpec Runner
#### Install InSpec
Go to https://www.inspec.io/downloads/ and consult the documentation for your Operating System to download and install InSpec.

#### Check InSpec version is at least version 6
```sh
inspec --version
```
### Profile Input Values
The default values for profile inputs are given in `inspec.yml`. Not all values in `inspec.yml` have been given a default value -- for example, the sensitive connection and authentication variables have not been (and cannot be) given a default. 

These values need to be overridden with values appropriate for your environment. You must create an `inputs.yml` file -- see [the InSpec documentation for inputs](https://docs.chef.io/inspec/inputs/).

** DO NOT COMMIT YOUR INPUTS.YML FILE! ** That file will include sensitive login info for your own M365 instance.

```yml
    #Controls using this input:
    #1.1.3, 1.2.1, 1.2.2, 1.3.1, 1.3.3, 1.3.6, 
    #2.1.1, 2.1.2, 2.1.3, 2.1.4, 2.1.5, 2.1.6, 2.1.7, 2.1.8, 2.1.9, 2.1.10, 2.1.14, 2.4.4, 
    #3.1.1, 3.2.2, 
    #5.1.1.1, 5.1.2.2, 5.1.2.3, 5.1.3.1, 5.1.5.2, 5.1.8.1, 5.2.2.3, 5.2.3.4, 
    #6.1.1, 6.1.2, 6.1.3, 6.1.4, 6.2.1, 6.2.2, 6.2.3, 6.3.1, 6.5.1, 6.5.2, 6.5.3, 
    #7.2.1, 7.2.2, 7.2.3, 7.2.4, 7.2.5, 7.2.6, 7.2.7, 7.2.9, 7.2.10, 7.3.1, 7.3.2, 7.3.4,
    #8.1.1, 8.1.2, 8.2.1, 8.5.1, 8.5.2, 8.5.3, 8.5.4, 8.5.5, 8.5.6, 8.5.7, 8.5.8, 8.6.1
    - name: client_id
      sensitive: true
      description: 'Client ID for Microsoft 365'
      type: String
      required: true

    #Controls using this input:
    #1.1.3, 1.2.1, 1.2.2, 1.3.1,
    #5.1.1.1, 5.1.2.2, 5.1.2.3, 5.1.3.1, 5.1.5.2, 5.1.8.1, 5.2.3.4, 
    #7.2.1, 7.2.2, 7.2.3, 7.2.4, 7.2.5, 7.2.6, 7.2.7, 7.2.9, 7.2.10, 7.3.1, 7.3.2, 7.3.4,
    #8.1.1, 8.1.2, 8.2.1, 8.5.1, 8.5.2, 8.5.3, 8.5.4, 8.5.5, 8.5.6, 8.5.7, 8.5.8, 8.6.1
    - name: tenant_id
      sensitive: true
      description: 'Tenant ID for Microsoft 365'
      type: String
      required: true

    #Controls using this input:
    #1.1.3, 1.2.1, 1.2.2, 1.3.1,
    #5.1.1.1, 5.1.2.2, 5.1.2.3, 5.1.3.1, 5.1.5.2, 5.1.8.1, 5.2.3.4, 
    #7.2.1, 7.2.2, 7.2.3, 7.2.4, 7.2.5, 7.2.6, 7.2.7, 7.2.9, 7.2.10, 7.3.1, 7.3.2, 7.3.4,
    #8.1.2
    - name: client_secret
      sensitive: true
      description: 'Client Secret for Microsoft 365'
      type: String
      required: true

    #Controls using this input:
    #1.2.2, 1.3.3, 1.3.6,
    #2.1.1, 2.1.2, 2.1.3, 2.1.4, 2.1.5, 2.1.6, 2.1.7, 2.1.8, 2.1.9, 2.1.10, 2.1.14, 2.4.4, 
    #3.1.1, 3.2.2, 
    #5.2.2.3,
    #6.1.1, 6.1.2, 6.1.3, 6.1.4, 6.2.1, 6.2.2, 6.2.3, 6.3.1, 6.5.1, 6.5.2, 6.5.3, 
    #7.2.1, 7.2.2, 7.2.3, 7.2.4, 7.2.5, 7.2.6, 7.2.7, 7.2.9, 7.2.10, 7.3.1, 7.3.2, 7.3.4,
    #8.1.1, 8.1.2, 8.2.1, 8.5.1, 8.5.2, 8.5.3, 8.5.4, 8.5.5, 8.5.6, 8.5.7, 8.5.8, 8.6.1
    - name: certificate_path
      sensitive: true
      description: 'Certificate path for M365'
      type: String
      required: true
      
    #Controls using this input:
    #1.2.2, 1.3.3, 1.3.6,
    #2.1.1, 2.1.2, 2.1.3, 2.1.4, 2.1.5, 2.1.6, 2.1.7, 2.1.8, 2.1.9, 2.1.10, 2.1.14, 2.4.4, 
    #3.1.1, 3.2.2, 
    #5.2.2.3,
    #6.1.1, 6.1.2, 6.1.3, 6.1.4, 6.2.1, 6.2.2, 6.2.3, 6.3.1, 6.5.1, 6.5.2, 6.5.3, 
    #7.2.1, 7.2.2, 7.2.3, 7.2.4, 7.2.5, 7.2.6, 7.2.7, 7.2.9, 7.2.10, 7.3.1, 7.3.2, 7.3.4,
    #8.1.1, 8.1.2, 8.2.1, 8.5.1, 8.5.2, 8.5.3, 8.5.4, 8.5.5, 8.5.6, 8.5.7, 8.5.8, 8.6.1
    - name: certificate_password
      sensitive: true
      description: 'Password for certificate for M365'
      type: String
      required: true

    #Controls using this input:
    #1.2.2, 1.3.1, 1.3.3, 1.3.6,
    #2.1.1, 2.1.2, 2.1.3, 2.1.4, 2.1.5, 2.1.6, 2.1.7, 2.1.8, 2.1.9, 2.1.10, 2.1.14, 2.4.4, 
    #3.1.1, 3.2.2, 
    #5.2.2.3,
    #6.1.1, 6.1.2, 6.1.3, 6.1.4, 6.2.1, 6.2.2, 6.2.3, 6.3.1, 6.5.1, 6.5.2, 6.5.3, 
    #8.6.1
    - name: organization
      sensitive: true
      description: 'M365 Organization'
      type: String
      required: true

    #Controls using this input:
    #2.1.6
    - name: notify_outbound_spam_recipients
      sensitive: true
      description: 'Email address to notify administrator for Exchange Online Spam Policies'
      type: Array
      required: true

    #Controls using this input:
    #2.1.6
    - name: bcc_suspicious_outbound_additional_recipients
      sensitive: true
      description: 'BCC email address to notify additional recipients for Exchange Online Spam Policies'
      type: Array
      required: true

    #Controls using this input:
    #2.1.8
    - name: spf_domains
      sensitive: true
      description: 'Array of domains needed to check for SPF record'
      type: Array
      required: true

    #Controls using this input:
    #2.1.10
    - name: dmarc_domains
      sensitive: true
      description: 'Array of DMARC records to check'
      type: Array
      required: true

    #Controls using this input:
    #2.1.10
    - name: reporting_mail_address
      sensitive: true
      description: 'Reporting mail address needed for DMARC check'
      type: String
      required: true

    #Controls using this input:
    #2.1.10
    - name: moera_domains
      sensitive: true
      description: 'Array of MOERA records to check'
      type: Array
      required: true

    #Controls using this input:
    #3.2.2
    - name: permitted_exceptions_teams_locations
      sensitive: true
      description: 'Permitted exceptions for teams locations'
      type: Array
      required: true

    #Controls using this input:
    #6.2.1
    - name: internal_domains_transport_rule
      sensitive: true
      description: 'Domains internal to the organization to be checked'
      type: Array
      required: true

    #Controls using this input:
    #6.2.3
    - name: email_addresses_bypass_external_tagging
      sensitive: true
      description: 'Email address list that are allowed to bypass external tagging'
      type: Array
      required: true

    #Controls using this input:
    #6.5.2
    - name: mailtipslargeaudiencethreshold_value
      sensitive: true
      description: 'MailTipsLargeAudienceThreshold value to check for in MailTips setting'
      required: true

    #Controls using this input:
    #6.5.2
    - name: authorized_domains_teams_admin_center
      sensitive: true
      description: 'List of authorized domains for AllowedDomains option in Teams Admin Center'
      type: Array
      required: true

    #Controls using this input:
    #8.6.1
    - name: reporting_email_addresses_for_malicious_messages
      sensitive: true
      description: 'Email addresses to check to report malicious messages in Teams and Defender'
      type: Array
      required: true

    #Controls using this input:
    #7.2.1, 7.2.2, 7.2.3, 7.2.4, 7.2.5, 7.2.6, 7.2.7, 7.2.9, 7.2.10, 7.3.1, 7.3.2, 7.3.4,
    - name: sharepoint_admin_url
      sensitive: true
      description: 'SharePoint Admin URL to connect to'
      type: String
      required: true

    #Controls using this input:
    #7.2.6
    - name: domains_trusted_by_organization
      sensitive: true
      description: 'Domains that are trusted by organization in SharePoint'
      type: Array
      required: true

    #Controls using this input:
    #7.2.9
    - name: external_user_expiry_in_days_spo_threshold
      sensitive: true
      description: 'Threshold in days to check for external user expiry in SharePoint'
      value: 30
      required: true

    #Controls using this input:
    #7.2.10
    - name: email_attestation_re_auth_days_spo_threshold
      sensitive: true
      description: 'Threshold in days to check for email attestation auth in SharePoint'
      value: 15
      required: true

    #Controls using this input:
    #7.3.2
    - name: trusted_domains_guids
      sensitive: true
      description: 'Domain GUIDs trusted from the on premises environment'
      type: Array
      required: true

```

### How to execute this instance  
(See: https://www.inspec.io/docs/reference/cli/)

**How to execute the Microsoft 365 profile**

#### Execute a single Control in the Profile 
**Note**: Replace the profile's directory name - e.g. - `<Profile>` with `.` if currently in the profile's root directory.

```sh
inspec exec <Profile> --controls=<control_id> --input client_id=<insert your client_id here> tenant_id=<insert your tenant_id here> client_secret=<insert your client_secret here> certificate_path=cert.pfx certificate_password=<insert certificate password here> organization=<insert your M365 organization URL here> --enhanced-outcomes --input-file=inputs.yml
```

#### Execute a Single Control and save results as JSON 
```sh
inspec exec <Profile> --input client_id=<insert your client_id here> tenant_id=<insert your tenant_id here> client_secret=<insert your client_secret here> certificate_path=<insert your certificate path here> certificate_password=<insert certificate password here> organization=<insert your M365 organization URL here> --controls=<control_id> --enhanced-outcomes --input-file=inputs.yml --reporter json:results.json
```

#### Execute All Controls in the Profile 
```sh
inspec exec <Profile> --input client_id=<insert your client_id here> tenant_id=<insert your tenant_id here> client_secret=<insert your client_secret here> certificate_path=<insert your certificate path here> certificate_password=<insert certificate password here> organization=<insert your M365 organization URL here> --enhanced-outcomes --input-file=inputs.yml
```

#### Execute all the Controls in the Profile and save results as JSON 
```sh
inspec exec <Profile> --input client_id=<insert your client_id here> tenant_id=<insert your tenant_id here> client_secret=<insert your client_secret here> certificate_path=<insert your certificate path here>  certificate_password=<insert certificate password here> organization=<insert your M365 organization URL here> --enhanced-outcomes --input-file=inputs.yml --reporter json:results.json
```

It is important to note that in the commands above there are both an input file as well as inputs. The inputs that are in the input file are non-sensitive, while the inputs that are being passed along in the command line are sensitive. The reasoning behind keeping these separate is to ensure folks do not accidentally commit their input files with sensitive data. 
## Check Overview

**M365 Services**

This profile evaluates the M365 CIS Benchmark compliance of the following M365 administrative centers by evaluating their setting configurations:

- Microsoft 365 Admin Center
- Microsoft 365 Defender
- Microsoft Purview
- Microsoft Entra Admin Center
- Microsoft Exchange Admin Center
- Microsoft SharePoint Admin Center
- Microsoft Fabric

# Control and Automation Status

Not all controls in the CIS Benchmark are capable of automated assessment. The table below marks which controls are automated and which ones are manual.

| Control   | Automation Status |
|-----------|-------------------|
| 1.1.1     | Manual            |
| 1.1.2     | Manual            |
| 1.1.3     | Automated         |
| 1.1.4     | Manual            |
| 1.2.1     | Automated         |
| 1.2.2     | Automated         |
| 1.3.1     | Automated         |
| 1.3.2     | Manual            |
| 1.3.3     | Automated         |
| 1.3.4     | Manual            |
| 1.3.5     | Manual            |
| 1.3.6     | Automated         |
| 1.3.7     | Manual            |
| 1.3.8     | Manual            |
| 2.1.1     | Automated         |
| 2.1.2     | Automated         |
| 2.1.3     | Automated         |
| 2.1.4     | Automated         |
| 2.1.5     | Automated         |
| 2.1.6     | Automated         |
| 2.1.7     | Automated         |
| 2.1.8     | Automated         |
| 2.1.9     | Automated         |
| 2.1.10    | Automated         |
| 2.1.11    | Manual            |
| 2.1.12    | Manual            |
| 2.1.13    | Manual            |
| 2.1.14    | Automated         |
| 2.3.1     | Manual            |
| 2.3.2     | Manual            |
| 2.4.1     | Manual            |
| 2.4.2     | Manual            |
| 2.4.3     | Manual            |
| 2.4.4     | Automated         |
| 3.1.1     | Automated         |
| 3.1.2     | Manual            |
| 3.2.1     | Manual            |
| 3.2.2     | Automated         |
| 3.3.1     | Manual            |
| 5.1.1.1   | Manual            |
| 5.1.2.1   | Manual            |
| 5.1.2.2   | Automated         |
| 5.1.2.3   | Automated         |
| 5.1.2.4   | Manual            |
| 5.1.2.5   | Manual            |
| 5.1.2.6   | Manual            |
| 5.1.3.1   | Automated         |
| 5.1.5.1   | Manual            |
| 5.1.5.2   | Automated         |
| 5.1.5.3   | Manual            |
| 5.1.6.1   | Manual            |
| 5.2.2.1   | Manual            |
| 5.2.2.2   | Manual            |
| 5.2.2.3   | Automated         |
| 5.2.2.4   | Manual            |
| 5.2.2.5   | Manual            |
| 5.2.2.6   | Manual            |
| 5.2.2.7   | Manual            |
| 5.2.2.8   | Manual            |
| 5.2.3.1   | Manual            |
| 5.2.3.2   | Manual            |
| 5.2.3.3   | Manual            |
| 5.2.3.4   | Manual            |
| 5.2.4.1   | Manual            |
| 5.2.4.2   | Manual            |
| 5.2.6.1   | Manual            |
| 5.3.1     | Manual            |
| 5.3.2     | Manual            |
| 5.3.3     | Manual            |
| 6.1.1     | Automated         |
| 6.1.2     | Automated         |
| 6.1.3     | Automated         |
| 6.1.4     | Automated         |
| 6.2.1     | Automated         |
| 6.2.2     | Automated         |
| 6.2.3     | Automated         |
| 6.3.1     | Automated         |
| 6.4.1     | Manual            |
| 6.5.1     | Automated         |
| 6.5.2     | Automated         |
| 6.5.3     | Automated         |
| 7.2.1     | Automated         |
| 7.2.2     | Automated         |
| 7.2.3     | Automated         |
| 7.2.4     | Automated         |
| 7.2.5     | Automated         |
| 7.2.6     | Automated         |
| 7.2.7     | Automated         |
| 7.2.8     | Manual            |
| 7.2.9     | Automated         |
| 7.2.10    | Automated         |
| 7.3.1     | Automated         |
| 7.3.2     | Automated         |
| 7.3.3     | Manual            |
| 7.3.4     | Automated         |
| 8.1.1     | Automated         |
| 8.1.2     | Automated         |
| 8.2.1     | Automated         |
| 8.4.1     | Manual            |
| 8.5.1     | Automated         |
| 8.5.2     | Automated         |
| 8.5.3     | Automated         |
| 8.5.4     | Automated         |
| 8.5.5     | Automated         |
| 8.5.6     | Automated         |
| 8.5.7     | Automated         |
| 8.5.8     | Automated         |
| 8.6.1     | Automated         |
| 9.1.1     | Manual            |
| 9.1.2     | Manual            |
| 9.1.3     | Manual            |
| 9.1.4     | Manual            |
| 9.1.5     | Manual            |
| 9.1.6     | Manual            |
| 9.1.7     | Manual            |
| 9.1.8     | Manual            |
| 9.1.9     | Manual            |

For any controls marked as 'Manual', please refer to the following following at [SAF-CLI](https://saf-cli.mitre.org/) on how to apply manual attestations to the output of an automated assessment. The following [link](https://vmware.github.io/dod-compliance-and-automation/docs/automation-tools/safcli/) that references the SAF-CLI is also useful.
