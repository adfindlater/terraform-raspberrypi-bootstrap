# terraform-raspberrypi-bootstrap

# New README

1. update `terraform.tfvars` with the correct username ans password
   used by the pis, as well as the timezone.
2. update the `terraform_pis.sh` script with a single IP address for the control plane node and
   one or more worker node IP addresses.
3. Run `terraform_pis.sh` to provision the nodes and create a k8s cluster.

e.g.
```
control_plane_ip="192.168.1.123"
worker_ips=("192.168.1.124" "192.168.1.125")
```

# Original README
NOTE: Though still functional, I've replaced this functionality with Ansible and a better provisioning model IMO: https://github.com/clayshek/raspi-ubuntu-ansible

## Summary

<a href="https://www.terraform.io/">Terraform</a> Provisioner for bootstrapping a <a href="https://www.raspberrypi.org">Raspberry Pi</a> base configuration. This is meant to be a run-once bootstrap Terraform <a href="https://www.terraform.io/docs/provisioners/index.html">provisioner</a> for a vanilla Raspberry Pi. Provisioners by default run only at resource creation, additional runs without cleanup may introduce problems.

In addtion to bootstrapping, this provisioner also:

- Installs Prometheus Node Exporter for Prometheus metrics collection
- Copies the k8s_prep.sh script from this repository to /home/pi/ to optionally install & configure prerequisites for latest ARM release of Kubernetes, including Docker, based off of https://gist.github.com/alexellis/fdbc90de7691a1b9edb545c17da2d975. 
- Copies the helm/install-helm-tiller.sh script from this repo which downloads Helm client, configures Kubernetes RBAC prerequisites, and initiates Helm with an ARM compatible <a href="https://cloud.docker.com/repository/docker/clayshek/tiller-arm">Tiller Docker image</a>. 


## Requirements

- <a href="https://www.terraform.io/downloads.html">Terraform</a> (written with v0.11.3, tested working up to 0.11.11)
- A newly flashed Raspberry Pi (tested with Raspbian Stretch Lite through 2018-11-13 release, should work with prior version Jessie)
- SSH access to Pi, See <a href="https://www.raspberrypi.org/documentation/remote-access/ssh/">Enable SSH on a headless Raspberry Pi</a>

## Usage

- Clone the repository
- Customize the parameters in the terraform.tfvars file as applicable for provisioning.
- Run <code>terraform init</code> (required for first run). 
- Apply the configuration:

```
terraform apply
```

- Optional, run <code>./k8s_prep.sh</code> to install Kubernetes and prerequisites, including Docker. 

- Optional, once Kubernetes cluster online and functional, run <code>./helm/install-helm-tiller.sh</code> to install <a href="https://docs.helm.sh/">Helm/Tiller</a>.

## To-Do

 - [X] Add Prometheus Node Exporter install.
 - [X] Add Helm & Tiller init scripts
 - [ ] Possibly add functionality for multiple Raspberry Pi deployments from a single run, using <a href="https://www.terraform.io/docs/configuration/resources.html#using-variables-with-count">variables with count</a>.
 - [ ] Implement tests.

 ## License

This is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT).
