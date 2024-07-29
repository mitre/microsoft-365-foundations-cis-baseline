## SAF TEMPLATE FILE

(Below is an example of the README that should be in place for a SAF-developed InSpec profile -- requirements, running instructions, etc.)

InSpec profile to validate the secure configuration of a Kubernetes node against [DISA's](https://iase.disa.mil/stigs/Pages/index.aspx) Kubernetes Secure Technical Implementation Guide (STIG) Version 1 Release 1.

## Getting Started  
It is intended and recommended that InSpec and this profile be run from a __"runner"__ host (such as a DevOps orchestration server, an administrative management system, or a developer's workstation/laptop) against the target remotely using the SSH transport.

__For the best security of the runner, always install on the runner the _latest version_ of InSpec and supporting Ruby language components.__

Latest versions and installation options are available at the [InSpec](http://inspec.io/) site.

The Kubernetes STIG includes security requirements for both the Kubernetes cluster itself and the nodes that comprise it. This profile includes the checks for the node portion. It is intended  to be used in conjunction with the <b>[Kubernetes Cluster](https://github.com/mitre/k8s-cluster-stig-baseline)</b> profile that performs automated compliance checks of the Kubernetes cluster.

## Getting Started

### Requirements

#### Kubernetes Cluster
- Kubernetes Platform deployment
- Access to the Kubernetes Node over ssh
- Account providing appropriate permissions to perform audit scan


#### Required software on the InSpec Runner
- git
- [InSpec](https://www.chef.io/products/chef-inspec/)

### Setup Environment on the InSpec Runner
#### Install InSpec
Go to https://www.inspec.io/downloads/ and consult the documentation for your Operating System to download and install InSpec.

#### Ensure InSpec version is at least 4.23.10 
```sh
inspec --version
```
### Profile Input Values
The default values for profile inputs are given in `inspec.yml`. These values can be overridden by creating an `inputs.yml` file -- see [the InSpec documentation for inputs](https://docs.chef.io/inspec/inputs/).

```yml
  - name: manifests_path
    description: 'Path to Kubernetes manifest files on the target node'
    type: string
    value: '/etc/kubernetes/manifests'
    required: true

  - name: pki_path
    description: 'Path to Kubernetes PKI files on the target node'
    type: string
    value: '/etc/kubernetes/pki/'
    required: true

  - name: kubeadm_path
    description: 'Path to kubeadm file on the target node'
    type: string
    value: '/usr/local/bin/kubeadm'
    required: true

  - name: kubectl_path
    description: 'Path to kubectl on the target node'
    type: string
    value: '/usr/local/bin/kubectl'
    required: true

  - name: kubernetes_conf_files
    description: 'Path to Kubernetes conf files on the target node'
    type: array
    value:
        - /etc/kubernetes/admin.conf
        - /etc/kubernetes/scheduler.conf
        - /etc/kubernetes/controller-manager.conf
    required: true

```

### How to execute this instance  
(See: https://www.inspec.io/docs/reference/cli/)

**Execute the Kubernetes Node profile on each node in the cluster. The profile will adapt its checks based on the Kubernetes components located on the node.**

#### Execute a single Control in the Profile 
**Note**: Replace the profile's directory name - e.g. - `<Profile>` with `.` if currently in the profile's root directory.

```sh
inspec exec <Profile> -t ssh://TARGET_USERNAME@TARGET_IP:TARGET_PORT --sudo -i <your_PEM_KEY> --controls=<control_id> --show-progress
```

#### Execute a Single Control and save results as JSON 
```sh
inspec exec <Profile> -t ssh://TARGET_USERNAME@TARGET_IP:TARGET_PORT --sudo -i <your_PEM_KEY> --controls=<control_id> --show-progress --reporter json:results.json
```

#### Execute All Controls in the Profile 
```sh
inspec exec <Profile>  -t ssh://TARGET_USERNAME@TARGET_IP:TARGET_PORT --sudo -i <your_PEM_KEY> --show-progress
```

#### Execute all the Controls in the Profile and save results as JSON 
```sh
inspec exec <Profile> -t ssh://TARGET_USERNAME@TARGET_IP:TARGET_PORT --sudo -i <your_PEM_KEY> --show-progress  --reporter json:results.json
```

## Check Overview

**Kubernetes Components**

This profile evaluates the STIG compliance of the following Kubernetes Components by evaluating their process configuration:

- kube-apiserver
- kube-controller-manager
- kube-scheduler
- kubelet
- kube-proxy
- etcd

If these components are not in use in the target cluster or named differently, the profile has to be adapted for the target K8S distribution using an [InSpec Profile Overlay](https://blog.chef.io/understanding-inspec-profile-inheritance).