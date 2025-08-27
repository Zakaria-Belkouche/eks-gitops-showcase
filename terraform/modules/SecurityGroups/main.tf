resource "aws_security_group" "nodes" {
  name        = "eks-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # pod-pod traffic within sg
  ingress {
    description = "Node to node (all protocols)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  #   ingress {
  #   description     = "Control plane to node 443"
  #   from_port       = 443
  #   to_port         = 443
  #   protocol        = "tcp"
  #   security_groups = [var.cluster_security_group_id]
  # }

  ingress {
    description     = "Control plane to kubelet 10250"
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    security_groups = [var.cluster_security_group_id]
  }

  ingress {
    from_port       = 8443
    to_port         = 8443
    protocol        = "tcp"
    security_groups = [var.cluster_security_group_id]
  }

  lifecycle {
    ignore_changes = [ingress]
  }
}


resource "aws_security_group_rule" "cluster_443_from_nodes" {
  type                     = "ingress"
  security_group_id        = var.cluster_security_group_id # the EKS Cluster SG
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nodes.id
}

