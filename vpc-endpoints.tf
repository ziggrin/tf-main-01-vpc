######################
## ONLY USED IN FARGATE (WITHOUT NAT GATEWAY) SETUP
######################


# ###########
# # VPC endpoints
# # I am using Endpoints so that NATGateway costs won't eat me alive
# ###########

# # ECR API Endpoint
# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [ aws_security_group.endpoint-ecr-for-ecs-task.id ]
#   subnet_ids          = module.vpc.intra_subnets
#   private_dns_enabled = true

#   tags = merge(local.sg_tags, {
#     Name = "endpoint-ecr-api"
#   })
# }

# # ECR Docker Registry Endpoint
# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [ aws_security_group.endpoint-ecr-for-ecs-task.id ]
#   subnet_ids          = module.vpc.intra_subnets
#   private_dns_enabled = true

#   tags = merge(local.sg_tags, {
#     Name = "endpoint-ecr-docker-registry"
#   })
# }

# # S3 Gateway Endpoint
# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = module.vpc.vpc_id
#   service_name      = "com.amazonaws.${var.aws_region}.s3"
#   vpc_endpoint_type = "Gateway"
#   route_table_ids   = module.vpc.intra_route_table_ids

#   tags = merge(local.sg_tags, {
#     Name = "endpoint-s3"
#   })
# }

# # Logs (cloudwatch) Endpoint
# resource "aws_vpc_endpoint" "logs" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.aws_region}.logs"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [ aws_security_group.endpoint-ecr-for-ecs-task.id ]
#   subnet_ids          = module.vpc.intra_subnets
#   private_dns_enabled = true

#   tags = merge(local.sg_tags, {
#     Name = "endpoint-logs"
#   })
# }

# ## Endpoints needed for AWS Parameter Store and 
# ## for access to containers through aws ecs execute-commands

# ### SSM Endpoints
# resource "aws_vpc_endpoint" "ssm" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.aws_region}.ssm"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = module.vpc.intra_subnets
#   security_group_ids  = [ aws_security_group.endpoint-ecr-for-ecs-task.id ]
#   private_dns_enabled = true

#   tags = merge(local.sg_tags, {
#     Name = "endpoint-ssm"
#   })
# }

# ### EC2 Messages Endpoint
# resource "aws_vpc_endpoint" "ec2messages" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = module.vpc.intra_subnets
#   security_group_ids  = [ aws_security_group.endpoint-ecr-for-ecs-task.id ]
#   private_dns_enabled = true

#   tags = merge(local.sg_tags, {
#     Name = "endpoint-ec2messages"
#   })
# }

# ### SSM Messages Endpoint
# resource "aws_vpc_endpoint" "ssmmessages" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = module.vpc.intra_subnets
#   security_group_ids  = [ aws_security_group.endpoint-ecr-for-ecs-task.id ]
#   private_dns_enabled = true

#   tags = merge(local.sg_tags, {
#     Name = "endpoint-ssmmessages"
#   })
# }
