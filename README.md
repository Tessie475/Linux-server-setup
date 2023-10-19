# Ansible Playbook for Ubuntu Server Setup

This repository contains an Ansible playbook designed to set up a Ubuntu server hosted on AWS. This setup includes user creation, system utilities, and the installation of Terraform.

## Features

## AWS Infrastructure Creation with Terraform

This project provides a robust AWS infrastructure setup using Terraform. Below is a quick overview of the features:

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_instance"></a> [ec2\_instance](#module\_ec2\_instance) | ./modules/ec2_instance | n/a |
| <a name="module_subnet"></a> [subnet](#module\_subnet) | ./modules/subnet | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_avail_zone"></a> [avail\_zone](#input\_avail\_zone) | The availability zone | `string` | n/a | yes |
| <a name="input_my_ip"></a> [my\_ip](#input\_my\_ip) | My IP Address | `string` | n/a | yes |
| <a name="input_subnet_cidr_block"></a> [subnet\_cidr\_block](#input\_subnet\_cidr\_block) | The subnet CIDR BLOCK | `string` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | VPC CIDR block | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

### Configurable Parameters:

- **VPC CIDR Block**: Define the CIDR block for your VPC using `vpc_cidr_block`.
- **Subnet CIDR Block**: Set the CIDR block for your subnet with `subnet_cidr_block`.
- **Availability Zone**: Specify the AWS availability zone for resources via `avail_zone`.

### Resources Created:

1. **VPC**: A dedicated VPC (`aws_vpc`) for the project.
2. **Subnet**: A subnet (`aws_subnet`) within the created VPC.
3. **Internet Gateway**: An internet gateway (`aws_internet_gateway`) connected to the VPC, allowing for external internet access.
4. **Route Table**: A default route table (`aws_default_route_table`) is configured with routes to ensure internet connectivity via the internet gateway.
5. **Security Group**: Defines network traffic rules with the `aws_security_group` resource. By default, it allows ingress traffic on port `2222`.
6. **EC2 Instance**: Launches an EC2 (`aws_instance`) in the defined subnet. This instance uses the `t2.micro` instance type and comes with the predefined security group.

### Getting Started:

Ensure you have Terraform installed and AWS credentials configured. Modify the variable values in `variables.tf` to suit your project requirements. Once set, initialize and apply the Terraform configurations:

```bash
terraform init
terraform plan
terraform apply
```

With these commands, your AWS infrastructure will be up and running, ready for further development or deployment tasks.

## Ansible Playbook Configuration

Our infrastructure relies on Ansible playbooks to ensure seamless deployment and consistent configuration across instances. The following is a breakdown of the configurations present in the playbook:

### **Infrastructure Setup**:
These tasks are designed to set up the foundational elements of the target machine's infrastructure.

- **Directory Creation**:
  - **Dedicated Directory**: For storage or user-specific tasks, a dedicated directory named `/johns-dir` is created. Owned by the `root` user, this directory has been configured with permissions to ensure data integrity and security.
  
- **User Management**:
  - **User Configuration**: To provide application-specific or administrative tasks, a user named `John` is added. This user comes with:
    - A unique ID for system-level differentiation.
    - A specific home directory situated within the earlier created dedicated directory.
    - A shell set to `/bin/bash` for typical command-line operations.

### **User Utilities and Privileges**:
This section deals with providing utility tools and setting up required permissions.

- **Utility Scripts**:
  - **Skeleton Script**: To aid in system administration, a script named `nice-script.sh` is added to the default skeleton directory for new users. This script, when invoked, displays a breakdown of disk usage.
  
- **Access Control**:
  - **Elevated Privileges**: To simplify certain administrative tasks, the user `John` is provided with enhanced `sudo` privileges. This allows `John` to execute the `whoami` command without the typical password prompt, streamlining processes.

### **Software Management**:
Focused on installing and managing software packages, these tasks ensure the machine is equipped with the necessary tools for developers and administrators.

- **Essential Software**:
  - **Vital Packages**: To aid in text editing and terminal multiplexing, packages like `tmux` and `vim` are installed. These tools are essentials in most developer's toolkits.
  
- **Developer Tools**:
  - **Terraform Installation**: Recognizing the growing need for Infrastructure as Code (IaC), the playbook also handles the installation of the Terraform CLI. Before its installation, the playbook verifies the presence of the `unzip` utility, ensuring smooth installation.

By leveraging this Ansible playbook, the target infrastructure is brought to a consistent and predictable state, ready for further deployments or development tasks.


## Dynamic Ansible Inventory

The project includes a dynamic Ansible inventory script for easy provisioning and management of resources. This script generates the necessary inventory data based on your project's AWS EC2 instances. Here's how it works:

1. **Inventory Script**: The Ansible inventory script is located in the project directory and named `ansible_inventory.py`.

2. **Executable Script**: To use it, make sure it is executable. You can do this by running the following command in your terminal:

   ```bash
   chmod +x ansible_inventory.py
   ```

3. **Inventory Configuration**: The script is configured to define two groups:

   - `webserver`: This group contains the public IP address of the EC2 instance you want to configure using Ansible.
   - `_meta`: This section provides individual host variables for the `webserver` group. It includes details like the SSH port, private key file, and the user for SSH access.

