resource "aws_launch_template" "nodes" {
  name_prefix            = "eks-ng-"
  vpc_security_group_ids = [var.node_sg]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.ng_disk_size
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = "worker-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.ng_instance_types
  capacity_type   = var.ng_capacity_type
  ami_type        = var.ng_ami_type

  scaling_config {
    desired_size = var.desired_nodes
    min_size     = var.min_nodes
    max_size     = var.max_nodes
  }

  update_config { max_unavailable = var.max_unavailable }

  launch_template {
    id      = aws_launch_template.nodes.id
    version = aws_launch_template.nodes.latest_version
  }
}