##########
## EC2 ECS Instance
##########

## Role
resource "aws_iam_role" "ec2_ecs_instance_role" {
  name = "ecs-instance-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach the managed policy that gives ECS the required permissions
resource "aws_iam_role_policy_attachment" "ec2_ecs_instance_policy" {
  role       = aws_iam_role.ec2_ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# Create an instance profile for the ECS instance 
# This is "container" for role permissions - so that credentials will be safetly stored etc.
resource "aws_iam_instance_profile" "ec2_ecs_instance_profile" {
  name = "ecsInstanceProfile"
  role = aws_iam_role.ec2_ecs_instance_role.name
}

# Data block to fetch the latest ECS optimized AMI - WHICH MIGHT NOT BE THE SMARTEST MOVE
data "aws_ami" "ec2_ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

# EC2 instance that will host ECS tasks in a public subnet
resource "aws_instance" "ecs_container_instance" {
  ami                         = data.aws_ami.ec2_ecs_optimized.id
  instance_type               = "t3.micro"  # Free Tier eligible in many regions
  subnet_id                   = module.vpc.public_subnets[0] # Use public subnet 1a
  associate_public_ip_address = true  # Force public IP assignment
  vpc_security_group_ids      = [ aws_security_group.ecs_ec2_instance_ingress.id, 
                                  aws_security_group.allow_all_egress.id ]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ecs_instance_profile.name
  key_name                    = "web"

  # Use user data to configure the ECS agent (adjust the cluster name accordingly)
  user_data = <<-EOF
    #!/bin/bash
    echo "ECS_CLUSTER=preprod-training-calendar" >> /etc/ecs/ecs.config
  EOF

  tags = {
    Name = "ecs-container-instance"
  }
}
