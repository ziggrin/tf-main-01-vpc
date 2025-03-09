locals {
  sg_tags = {
    Environment = "preprod"
    Project     = "omega"
    Component   = "security-group"
    IaaC        = "terraform"
  }
}

########################
## Global SGs
########################

## Allow all egress
resource "aws_security_group" "allow_all_egress" {
  name        = "allow-all-egress"
  description = "Allow all outbound traffic"
  vpc_id      = module.vpc.vpc_id
  
  tags = merge(local.sg_tags, {
    Name = "allow-all-egress"
  })
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress_ipv4" {
  security_group_id = aws_security_group.allow_all_egress.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress_ipv6" {
  security_group_id = aws_security_group.allow_all_egress.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

## ICMP - allow all ingress
resource "aws_security_group" "icmp_allow_all_ingress" {
  name        = "icmp-allow-all-ingress"
  description = "Allow all ICMP inbound traffic"
  vpc_id      = module.vpc.vpc_id
  
  tags = merge(local.sg_tags, {
    Name = "icmp-allow-all-ingress"
  })
}

resource "aws_vpc_security_group_ingress_rule" "icmp_allow_all_ingress_ipv4_first_half" {
  security_group_id = aws_security_group.icmp_allow_all_ingress.id
  cidr_ipv4         = "0.0.0.0/1"
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
}

resource "aws_vpc_security_group_ingress_rule" "icmp_allow_all_ingress_ipv4_second_half" {
  security_group_id = aws_security_group.icmp_allow_all_ingress.id
  cidr_ipv4         = "128.0.0.0/1"
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
}

resource "aws_vpc_security_group_ingress_rule" "icmp_allow_all_ingress_ipv6_first_half" {
  security_group_id = aws_security_group.icmp_allow_all_ingress.id
  cidr_ipv6         = "::/1"
  from_port         = -1
  ip_protocol       = "icmpv6"
  to_port           = -1
}

resource "aws_vpc_security_group_ingress_rule" "icmp_allow_all_ingress_ipv6_second_half" {
  security_group_id = aws_security_group.icmp_allow_all_ingress.id
  cidr_ipv6         = "8000::/1"
  from_port         = -1
  ip_protocol       = "icmpv6"
  to_port           = -1
}

########################
## AWS Service specific SGs
########################

## ECS EC2 instance
resource "aws_security_group" "ecs_ec2_instance_ingress" {
  name        = "ecs-ec2-instance"
  description = "Allow incoming HTTP/HTTPS from ALB to EC2 ECS instance"
  vpc_id      = module.vpc.vpc_id

  tags = merge(local.sg_tags, {
    Name = "ecs-ec2-instance"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ecs_ec2_instance_ingress_ssh" {
  security_group_id = aws_security_group.ecs_ec2_instance_ingress.id
  cidr_ipv4         = "89.64.96.58/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "ecs_ec2_instance_ingress_http" {
  security_group_id = aws_security_group.ecs_ec2_instance_ingress.id
  referenced_security_group_id = aws_security_group.alb_allow_all_ingress.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "ecs_ec2_instance_ingress_https" {
  security_group_id = aws_security_group.ecs_ec2_instance_ingress.id
  referenced_security_group_id = aws_security_group.alb_allow_all_ingress.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "ecs_ec2_instance_ingress_ephemeral" {
  security_group_id = aws_security_group.ecs_ec2_instance_ingress.id
  referenced_security_group_id = aws_security_group.alb_allow_all_ingress.id
  from_port         = 32768
  ip_protocol       = "tcp"
  to_port           = 65535
}

## LOAD BALANCER - allow HTTP/HTTPS ingress
resource "aws_security_group" "alb_allow_all_ingress" {
  name        = "alb-allow-all-ingress-http-https"
  description = "Allow all HTTP/HTTPS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = merge(local.sg_tags, {
    Name = "alb-allow-all-ingress-http-https"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_all_ingress_ipv4_http_first_half" {
  security_group_id = aws_security_group.alb_allow_all_ingress.id
  cidr_ipv4         = "0.0.0.0/1"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_all_ingress_ipv4_http_second_half" {
  security_group_id = aws_security_group.alb_allow_all_ingress.id
  cidr_ipv4         = "128.0.0.0/1"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_all_ingress_ipv4_https_first_half" {
  security_group_id = aws_security_group.alb_allow_all_ingress.id
  cidr_ipv4         = "0.0.0.0/1"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_all_ingress_ipv4_https_second_half" {
  security_group_id = aws_security_group.alb_allow_all_ingress.id
  cidr_ipv4         = "128.0.0.0/1"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

### IPv6
resource "aws_vpc_security_group_ingress_rule" "alb_allow_all_ingress_ipv6_http" {
  security_group_id = aws_security_group.alb_allow_all_ingress.id
  cidr_ipv6         = "::/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_all_ingress_ipv6_https" {
  security_group_id = aws_security_group.alb_allow_all_ingress.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

## ECS - Fargate - allow ingress HTTP/HTTPS from ALB
resource "aws_security_group" "ecs_ingress" {
  name        = "ecs-ingress-http-https"
  description = "Allow inbound HTTP/HTTPS from ALB to ECS Fargate"
  vpc_id      = module.vpc.vpc_id

  tags = merge(local.sg_tags, {
    Name = "ecs-ingress-http-https"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ecs_ingress_ipv4_http" {
  security_group_id = aws_security_group.ecs_ingress.id
  referenced_security_group_id = aws_security_group.alb_allow_all_ingress.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "ecs_ingress_ipv4_https" {
  security_group_id = aws_security_group.ecs_ingress.id
  referenced_security_group_id = aws_security_group.alb_allow_all_ingress.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

## RDS - postgres-ingress-local
resource "aws_security_group" "postgres_local_ingress" {
  name        = "postgres-ingress-local"
  description = "Allow postgres access from VPC"
  vpc_id      = module.vpc.vpc_id

  tags = merge(local.sg_tags, {
    Name = "postgres-ingress-local"
  })
}

resource "aws_vpc_security_group_ingress_rule" "postgres_local_ingress" {
  security_group_id = aws_security_group.postgres_local_ingress.id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
}

########################
## Project specific SGs
########################

############
## preprod-training-calendar
############

## RDS - preprod-training-calendar
resource "aws_security_group" "preprod_training_calendar_postgres" {
  name        = "preprod-training-calendar-postgres"
  description = "Allow postgres from ECS task"
  vpc_id      = module.vpc.vpc_id

  tags = merge(local.sg_tags, {
    Name = "preprod-training-calendar-postgres"
  })
}

resource "aws_vpc_security_group_ingress_rule" "preprod_training_calendar_postgres" {
  security_group_id = aws_security_group.preprod_training_calendar_postgres.id
  referenced_security_group_id = aws_security_group.ecs_ec2_instance_ingress.id
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
}