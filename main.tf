module "network" {
  source = "./modules/network"

  name_prefix = "${var.project_name}-${var.environment}"
  vpc_cidr    = var.vpc_cidr
}

module "web" {
  source = "./modules/web"

  name_prefix      = "${var.project_name}-${var.environment}"
  vpc_id           = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_id
  instance_type    = var.instance_type
}
