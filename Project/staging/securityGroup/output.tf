output "web_sg_id" {
  value = module.security-group-staging.web_sg_id
}

output "load_balancer_id" {
  value = module.security-group-staging.load_balancer_id
}

output "bastion_sg_id" {
  value = module.security-group-staging.bastion_sg_id
}