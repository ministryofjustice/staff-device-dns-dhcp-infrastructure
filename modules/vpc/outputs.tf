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
