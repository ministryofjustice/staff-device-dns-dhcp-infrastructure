output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}


output "public_subnet_cidr_blocks" {
  value = module.vpc.public_subnets_cidr_blocks
}
