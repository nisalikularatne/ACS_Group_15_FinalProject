
# Module to deploy basic networking
module "bastion-dev" {
  source        = "../../../modules/bastionHost"
  prefix        = var.prefix
  instance_type = var.instance_type
  linux_key_ec2 = var.linux_key_ec2
  bucket_name   = var.bucket_name
}
