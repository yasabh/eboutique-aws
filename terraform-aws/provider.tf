provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.eboutique.token
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
}
