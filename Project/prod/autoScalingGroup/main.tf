module "autoScalingGroup-prod" {
  source = "../../../modules/autoScalingGroup"
  prefix = var.prefix

  desired_capacity = var.desired_capacity
  min_size         = var.min_size
  max_size         = var.max_size
  env              = var.env
}