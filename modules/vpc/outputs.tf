output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "public_subnet_cidr_blocks" {
  value = module.vpc.public_subnets_cidr_blocks
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "vpc" {
  value = module.vpc
}

output "vpc_brief" {
  value = {
    azs                         = module.vpc.azs
    id                          = module.vpc.vpc_id
    name                        = module.vpc.name
    private_route_table_ids     = module.vpc.private_route_table_ids
    private_subnets             = module.vpc.private_subnets
    private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
    public_route_table_ids      = module.vpc.public_route_table_ids
    public_subnets              = module.vpc.public_subnets
    public_subnets_cidr_blocks  = module.vpc.public_subnets_cidr_blocks
  }
}

output "endpoints_sg" {
  value = {
    id = aws_security_group.endpoints.id
  }
}
