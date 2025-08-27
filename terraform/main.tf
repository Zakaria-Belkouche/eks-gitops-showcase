module "Network" {
  source              = "./modules/Network"
  subnet_az           = var.subnet_az
  privatesubnet_cidrs = var.privatesubnet_cidrs
  publicsubnet_cidrs  = var.publicsubnet_cidrs
  vpc_cidr            = var.vpc_cidr
}

module "Iam" {
  source = "./modules/iam"
  github_owner = var.github_owner
  github_ref = var.github_ref
  github_repo = var.github_repo
  aws_region = var.aws_region
  ecr_repo_name = var.ecr_repo_name
}

module "sg" {
  source                    = "./modules/SecurityGroups"
  vpc_id                    = module.Network.vpc
  cluster_security_group_id = module.eks.cluster_security_group_id
}


module "eks" {
  source             = "./modules/eks"
  public_subnet_ids  = module.Network.public_subnet_ids_list
  private_subnet_ids = module.Network.private_subnet_ids_list
  k8_version         = var.k8_version
  my_ip              = var.my_ip
  cluster_role_arn   = module.Iam.cluster_role
}

module "irsa" {
  source                 = "./modules/irsa"
  cluster_name           = module.eks.cluster_name
  hostedzone_arn         = var.hostedzone_arn
  cert_manager_namespace = var.certmanager_namespace
  dns_namespace          = var.dns_namespace
  depends_on             = [module.eks]
}

module "helm" {
  source       = "./modules/helm"
  ebs_csi_role = module.irsa.ebs_csi_role_arn
  depends_on   = [module.irsa]
  count        = var.enable_addons ? 1 : 0
}

module "nodegroup" {
  source             = "./modules/nodegroup"
  ng_ami_type        = var.ng_ami_type
  ng_capacity_type   = var.ng_capacity_type
  ng_disk_size       = var.ng_disk_size
  ng_instance_types  = var.ng_instance_types
  max_nodes          = var.max_nodes
  min_nodes          = var.min_nodes
  desired_nodes      = var.desired_nodes
  max_unavailable    = var.max_unavailable
  node_sg            = module.sg.node_sg
  cluster_name       = module.eks.cluster_name
  node_role_arn      = module.Iam.node_role
  private_subnet_ids = module.Network.private_subnet_ids_list
}
