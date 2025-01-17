module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "eboutique-cluster"
  cluster_version = "1.28"

  # VPC and Subnets
  vpc_id          = aws_vpc.app_vpc.id
  subnet_ids      = aws_subnet.app_subnet[*].id

  # Endpoint Access Configuration
  cluster_endpoint_public_access  = true    # Enables public endpoint

  # Managed Node Groups
  eks_managed_node_groups = {
    eboutique-kng = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
      key_name       = "eboutique-key" # Replace with your SSH key pair name
      tags = {
        role = "kubernetes-node-group"
      }
    }
  }

  tags = {
    env = "dev"
    app = "eboutique"
  }
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  value = module.eks.cluster_id
}
