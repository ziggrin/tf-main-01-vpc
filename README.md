# Terraform EC2 ECS VPC

This project sets up an AWS VPC with EC2 instances for ECS using Terraform. It includes configurations for load balancers, security groups, IAM roles, and VPC endpoints.

### What's cool:

- The load balancer uses `dualstack-without-public-ipv4`, which lets me use a free internet-facing IPv6 address while still being able to keep the rest of the services running in IPv4.
- Security groups and IAM policies use the **least privilege principle**, 
- To save costs on Fargate and VPC Endpoints, I host ECS clusters on AWS Free tier *EC2 instances, which lets me run this app **24/7 without any costs**.
- RDS DBs use intra subnets that do not have a connection to the outside world

*this forces me to use public subnets instead of keeping everything under additional protection layer that is granted by private subnets

## Project Structure

- `main.tf`: Defines the VPC and its subnets.
- `ec2-instance.tf`: Configures the EC2 instances and related IAM roles.
- `load-balancers.tf`: Sets up the load balancers and their listeners.
- `security-groups.tf`: Defines the security groups and their rules.
- `variables.tf`: Contains the input variables for the Terraform configuration.
- `providers.tf`: Specifies the required providers and their versions.

## Prerequisites

- Terraform v0.12 or later
- AWS account with appropriate permissions
- AWS CLI configured with your credentials

## Usage

1. Clone the repository:
    ```sh
    git clone git@github.com:YOURUSERNAME/tf-main-01-vpc.git
    cd terraform-ec2-ecs/vpc
    ```

2. Initialize Terraform:
    ```sh
    terraform init
    ```

3. Review the plan:
    ```sh
    terraform plan
    ```

4. Apply the configuration:
    ```sh
    terraform apply
    ```

## Variables

The following variables are defined in `variables.tf`:

- `aws_account`: Name of the AWS Account to connect to (default: `main-01`)
- `aws_region`: AWS region to connect to (default: `eu-north-1`)
- `environment`: Instance environment (default: `PREPROD`)
- `certificate_arn`: Certificate ARN for the domain (sensitive)

## Resources

The project creates the following resources:

- VPC with public and intra subnets
- EC2 instances with ECS optimized AMI
- Application Load Balancer with HTTP and HTTPS listeners
- Security groups for EC2 instances, load balancers, and other services

## Notes

- The VPC endpoints in `vpc-endpoints.tf` are currently commented out. Uncomment them if needed.
- The security group rule for SSH access in `security-groups.tf` should be removed after initial setup.

## Projects that currently use this VPC

- [Preproduction-training-calendar](https://github.com/ziggrin/tf-preprod-training-calendar)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
