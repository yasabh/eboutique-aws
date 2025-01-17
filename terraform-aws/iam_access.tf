# IAM User Data
data "aws_iam_user" "eboutique_admin" {
  user_name = "eboutique-admin" # Replace with your IAM user name
}

# Access Entry for IAM User
resource "aws_eks_access_entry" "eboutique_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = data.aws_iam_user.eboutique_admin.arn
  type          = "STANDARD"
}

# Associate Admin Policies
resource "aws_eks_access_policy_association" "eboutique_AmazonEKSAdminPolicy" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = aws_eks_access_entry.eboutique_admin.principal_arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_policy_association" "eboutique_AmazonEKSClusterAdminPolicy" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_eks_access_entry.eboutique_admin.principal_arn

  access_scope {
    type = "cluster"
  }
}
