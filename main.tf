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
  user_data = templatefile("${path.module}/scripts/bootstrap.sh.tftpl", {
    dockerfile_b64 = filebase64("${path.module}/app/Dockerfile")
    nginx_conf_b64 = filebase64("${path.module}/app/nginx.conf")
    index_html_b64 = filebase64("${path.module}/app/index.html")
  })
}
