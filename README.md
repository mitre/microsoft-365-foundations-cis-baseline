# Microsoft 365 Foundation CIS Benchmark
This InSpec Profile was created to facilitate testing and auditing of `CIS Microsoft 365 Benchmark`
infrastructure and applications when validating compliancy with [Center for Internet Security (CIS) Benchmark](https://www.cisecurity.org/cis-benchmarks)
requirements.
 
- Profile Version: **3.1.0**
- Benchmark Date: **2024-04-29**
- Benchmark Version: **3.0.0**
 
 
This profile was developed to reduce the time it takes to perform a security checks based upon the
CIS Guidance from the Center for Internet Security (CIS).
 
The results of a profile run will provide information needed to support an Authority to Operate (ATO)
decision for the applicable technology.
 
The CIS Ubuntu Linux 22.04 LTS CIS Profile uses the [InSpec](https://github.com/inspec/inspec)
open-source compliance validation language to support automation of the required compliance, security
and policy testing for Assessment and Authorization (A&A) and Authority to Operate (ATO) decisions
and Continuous Authority to Operate (cATO) processes.

The M365 CIS Benchmark includes security requirements for an Microsoft 365 environment.
 
Table of Contents
=================
* [CIS Benchmark  Information](#benchmark-information)
* [Requirements](#requirements)
* [Getting Started](#getting-started)
    * [Intended Usage](#intended-usage)
    * [Tailoring to Your Environment](#tailoring-to-your-environment)
    * [Testing the Profile Controls](#testing-the-profile-controls)
* [Running the Profile](#running-the-profile)
    * [Directly from Github](#directly-from-github)
    * [Different Run Options](#different-run-options)
* [Using Heimdall for Viewing Test Results](#using-heimdall-for-viewing-test-results)
* [Check Overview]()
 
## Benchmark Information
The Center for Internet Security, Inc. (CIS®) create and maintain a set of Critical Security Controls (CIS Controls) for applications, computer systems and networks
connected to the Department of Defense (DoD). These guidelines are the primary security standards
used by the DoD agencies. In addition to defining security guidelines, the CISs also stipulate
how security training should proceed and when security checks should occur. Organizations must
stay compliant with these guidelines or they risk having their access to the DoD terminated.
 
Requirements associated with the CIS Ubuntu Linux 22.04 LTS CIS are derived from the
[Security Requirements Guides](https://csrc.nist.gov/glossary/term/security_requirements_guide)
and align to the [National Institute of Standards and Technology](https://www.nist.gov/) (NIST)
[Special Publication (SP) 800-53](https://csrc.nist.gov/Projects/risk-management/sp800-53-controls/release-search#!/800-53)
Security Controls, [DoD Control Correlation Identifier](https://public.cyber.mil/stigs/cci/) and related standards.
 
The CIS Ubuntu Linux 22.04 LTS CIS profile checks were developed to provide technical implementation
validation to the defined DoD requirements, the guidance can provide insight for any organizations wishing
to enhance their security posture and can be tailored easily for use in your organization.
 
[top](#table-of-contents)
## Requirements
### Microsoft 365
- M365 account API credentials and certificate
- M365 providing appropriate permissions to perform audit scan
  - This can be done by creating an application registration within your account, which will provide you with the appropriate credentials to login such as Client ID and Tenant ID. You will need to create a Client Secret/Certificate as well. The following link provides more detail on how to setup an application registration: [Application_Registration_Steps](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=certificate)

### Ensure the Following Permissions on your Application Registration Account
  - Microsoft Graph
    - SecurityEvents.Read.All
    - User.Read
    - UserAuthenticationMethod.Read.All
    - AuditLog.Read.All,
    - Policy.Read.All
  - Office 365 Exchange Online
    - Exchange.ManageAsApp
  - SharePoint
    - Sites.FullControl.All

### Required software and steps needed on the InSpec Runner
- git
- [Powershell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4)
- [InSpec](https://www.chef.io/products/chef-inspec/)
- [train-pwsh](https://github.com/mitre/train-pwsh)
- [inspec-pwsh](https://github.com/mitre/inspec-pwsh)

It is important to follow/understand the documentation for train-pwsh and inspec-pwsh that is linked above for this profile to run correctly. For context, the train-pwsh is the transport that is used to maintain a persistent connection with various Powershell sessions. Meanwhile, inspec-pwsh is a resource pack that is used to connect controls using different modules to its corresponding session group (e.g. session for exchange, teams, exchange/graph, etc.). The documentation for inspec-pwsh has more detail about the resource pack. 

Particularly, for train-pwsh, your organization field will also need to be defined as a environment variable named `ORGANIZATION` as it is used in a profile. The train-pwsh documentation has more detail on how to do this. 

### PowerShell Module Installation
Ensure access and install the following powershell modules. The controls also have the module installation code when running the Powershell queries for redundancy purposes:
- [Microsoft.Graph](https://learn.microsoft.com/en-us/powershell/microsoftgraph/installation?view=graph-powershell-1.0#installation)
- [ExchangeOnlineManagement](https://learn.microsoft.com/en-us/powershell/exchange/connect-to-exchange-online-powershell?view=exchange-ps)
- [PnP.PowerShell](https://learn.microsoft.com/en-us/powershell/sharepoint/sharepoint-pnp/sharepoint-pnp-cmdlets)
- [MicrosoftTeams](https://learn.microsoft.com/en-us/microsoftteams/teams-powershell-install)

## Getting Started  
### InSpec (CINC-auditor) setup
For maximum flexibility/accessibility `cinc-auditor`, the open-source packaged binary version of Chef InSpec should be used,
compiled by the CINC (CINC Is Not Chef) project in coordination with Chef using Chef's always-open-source InSpec source code.
For more information see [CINC Home](https://cinc.sh/)
 
It is intended and recommended that CINC-auditor and this profile executed from a __"runner"__ host
(such as a DevOps orchestration server, an administrative management system, or a developer's workstation/laptop)
against the target. This can be any Unix/Linux/MacOS or Windows runner host, with access to the Internet.
 
> [!TIP]
> **For the best security of the runner, always install on the runner the latest version of CINC-auditor and any other supporting language components.**
 
To install CINC-auditor on a UNIX/Linux/MacOS platform use the following command:
```bash
curl -L https://omnitruck.cinc.sh/install.sh | sudo bash -s -- -P cinc-auditor
```
 
To install CINC-auditor on a Windows platform (Powershell) use the following command:
```powershell
. { iwr -useb https://omnitruck.cinc.sh/install.ps1 } | iex; install -project cinc-auditor
```
 
To confirm successful install of cinc-auditor:
```
cinc-auditor -v
```
 
Latest versions and other installation options are available at [CINC Auditor](https://cinc.sh/start/auditor/) site.
 
[top](#table-of-contents)
### Intended Usage
1. The latest `released` version of the profile is intended for use in A&A testing, as well as
    providing formal results to Authorizing Officials and Identity and Access Management (IAM)s.
    Please use the `released` versions of the profile in these types of workflows.
 
2. The `main` branch is a development branch that will become the next release of the profile.
    The `main` branch is intended for use in _developing and testing_ merge requests for the next
    release of the profile, and _is not intended_ be used for formal and ongoing testing on systems.
 
[top](#table-of-contents)
### Tailoring to Your Environment
This profile uses InSpec Inputs to provide flexibility during testing. Inputs allow for
customizing the behavior of Chef InSpec profiles.
 
InSpec Inputs are defined in the `inspec.yml` file. The `inputs` configured in this
file are **profile definitions and defaults for the profile** extracted from the profile
guidances and contain metadata that describe the profile, and shouldn't be modified.
 
InSpec provides several methods for customizing profile behaviors at run-time that does not require
modifying the `inspec.yml` file itself (see [Using Customized Inputs](#using-customized-inputs)).
 
The following inputs are permitted to be configured in an inputs `.yml` file (often named inputs.yml)
for the profile to run correctly on a specific environment, while still complying with the security
guidance document intent. This is important to prevent confusion when test results are passed downstream
to different stakeholders under the *security guidance name used by this profile repository*
 
For changes beyond the inputs cited in this section, users can create an *organizationally-named overlay repository*.
For more information on developing overlays, reference the [MITRE SAF Training](https://mitre-saf-training.netlify.app/courses/beginner/10.html)
 
#### Example of tailoring Inputs *While Still Complying* with the security guidance document for the profile:
 
```yaml
#Controls using this input:
#1.3.1
- name: org_domain
  sensitive: true
  description: 'Domain for organization'
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
 
> [!NOTE]
>Inputs are variables that are referenced by control(s) in the profile that implement them.
 They are declared (defined) and given a default value in the `inspec.yml` file.
 
#### Using Customized Inputs
Customized inputs may be used at the CLI by providing an input file or a flag at execution time.
 
1. Using the `--input` flag
 
    Example: `[inspec or cinc-auditor] exec <my-profile.tar.gz> --input disable_slow_controls=true`
 
2. Using the `--input-file` flag.
   
    Example: `[inspec or cinc-auditor] exec <my-profile.tar.gz> --input-file=<my_inputs_file.yml>`
 
>[!TIP]
> For additional information about `input` file examples reference the [MITRE SAF Training](https://mitre.github.io/saf-training/courses/beginner/06.html#input-file-example)
 
Chef InSpec Resources:
- [InSpec Profile Documentation](https://docs.chef.io/inspec/profiles/).
- [InSpec Inputs](https://docs.chef.io/inspec/profiles/inputs/).
- [inspec.yml](https://docs.chef.io/inspec/profiles/inspec_yml/).
 
 
[top](#table-of-contents)
### Testing the Profile Controls
The Gemfile provided contains all the necessary ruby dependencies for checking the profile controls.
#### Requirements
All action are conducted using `ruby` (gemstone/programming language). Currently `inspec`
commands have been tested with ruby version 3.1.2. A higher version of ruby is not guaranteed to
provide the expected results. Any modern distribution of Ruby comes with Bundler preinstalled by default.
 
Install ruby based on the OS being used, see [Installing Ruby](https://www.ruby-lang.org/en/documentation/installation/)
 
After installing `ruby` install the necessary dependencies by invoking the bundler command
(must be in the same directory where the Gemfile is located):
```bash
bundle install
```
 
#### Testing Commands
 
Linting and validating controls:
```bash
  bundle exec rake [inspec or cinc-auditor]:check # Validate the InSpec Profile
  bundle exec rake lint                            # Run RuboCop Linter
  bundle exec rake lint:auto_correct       # Autocorrect RuboCop offenses (only when it's safe)
  bundle exec rake pre_commit_checks  # Pre-commit checks
```
 
Ensure the controls are ready to be committed into the repo:
```bash
  bundle exec rake pre_commit_checks
```
 
 
[top](#table-of-contents)
## Running the Profile
**Note**: Replace the profile's directory name - e.g. - `<Profile>` with `.` if currently in the profile's root directory.

```sh
inspec exec <Profile> -t pwsh://<Options Dictionary Name> --controls=<control_id> --enhanced-outcomes --input-file=inputs.yml
```

#### Execute a Single Control and save results as JSON 
```sh
inspec exec <Profile> -t pwsh://<Options Dictionary Name> --controls=<control_id> --enhanced-outcomes --input-file=inputs.yml --reporter json:results.json
```

#### Execute All Controls in the Profile 
```sh
inspec exec <Profile> -t pwsh://<Options Dictionary Name> --enhanced-outcomes --input-file=inputs.yml
```

#### Execute all the Controls in the Profile and save results as JSON 
```sh
inspec exec <Profile> -t pwsh://<Options Dictionary Name> --enhanced-outcomes --input-file=inputs.yml --reporter json:results.json
```
[top](#table-of-contents)

## Different Run Options
 
[Full exec options](https://docs.chef.io/inspec/cli/#options-3)
 
[top](#table-of-contents)
## Using Heimdall for Viewing Test Results
The JSON results output file can be loaded into **[Heimdall-Lite](https://heimdall-lite.mitre.org/)**
or **[Heimdall-Server](https://github.com/mitre/heimdall2)** for a user-interactive, graphical view of the profile scan results.
 
Heimdall-Lite is a `browser only` viewer that allows you to easily view your results directly and locally rendered in your browser.
Heimdall-Server is configured with a `data-services backend` allowing for data persistency to a database (PostgreSQL).
For more detail on feature capabilities see [Heimdall Features](https://github.com/mitre/heimdall2?tab=readme-ov-file#features)
 
Heimdall can **_export your results into a DISA Checklist (CKL) file_** for easily uploading into eMass using the `Heimdall Export` function.
 
Depending on your environment restrictions, the [SAF CLI](https://saf-cli.mitre.org) can be used to run a local docker instance
of Heimdall-Lite via the `saf view:heimdall` command.
 
Additionally both Heimdall applications can be deployed via docker, kubernetes, or the installation packages.
## Check Overview

### M365 Services

This profile evaluates the M365 CIS Benchmark compliance of the following M365 administrative centers by evaluating their setting configurations:

- Microsoft 365 Admin Center
- Microsoft 365 Defender
- Microsoft Purview
- Microsoft Entra Admin Center
- Microsoft Exchange Admin Center
- Microsoft SharePoint Admin Center
- Microsoft Fabric

### Control and Automation Status

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
| 5.1.1.1   | Automated         |
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
| 5.2.3.4   | Automated         |
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

[top](#table-of-contents)

## Authors
[Center for Internet Security (CIS)](https://www.cisecurity.org/)
 
[MITRE Security Automation Framework Team](https://saf.mitre.org)
 
## NOTICE
 
© 2018-2025 The MITRE Corporation.
 
Approved for Public Release; Distribution Unlimited. Case Number 18-3678.
 
## NOTICE
 
MITRE hereby grants express written permission to use, reproduce, distribute, modify, and otherwise leverage this software to the extent permitted by the licensed terms provided in the LICENSE.md file included with this project.
 
## NOTICE  
 
This software was produced for the U. S. Government under Contract Number HHSM-500-2012-00008I, and is subject to Federal Acquisition Regulation Clause 52.227-14, Rights in Data-General.  
 
No other use other than that granted to the U. S. Government, or to those acting on behalf of the U. S. Government under that Clause is authorized without the express written permission of The MITRE Corporation.
 
For further information, please contact The MITRE Corporation, Contracts Management Office, 7515 Colshire Drive, McLean, VA  22102-7539, (703) 983-6000.
 
## NOTICE
[CIS Benchmarks are published by Center for Internet Security](https://www.cisecurity.org/cis-benchmarks)
