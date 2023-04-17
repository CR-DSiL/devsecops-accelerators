resource "aws_eks_addon" "aws-ebs" {
	cluster_name = aws_eks_cluster.example.name
	addon_name   = "aws-ebs-csi"
  }

  resource "aws_eks_cluster" "example" {
	cluster_name    = "my-cluster"
    cluster_version = "1.22"
  
    cluster_endpoint_private_access = true
    cluster_endpoint_public_access  = true
  
    cluster_addons = {
      coredns = {
        resolve_conflicts = "OVERWRITE"
      }
      kube-proxy = {}
      vpc-cni = {
        resolve_conflicts = "OVERWRITE"
      }
    }
  
    vpc_id     = "vpc-08128800a678927a5"
    subnet_ids = ["subnet-06357da6d85ba9ca2", "subnet-0a422cfb9a015da69", "subnet-07dcbce7c6632713e"]
  
    eks_managed_node_groups = {
      blue = {}
      green = {
        min_size     = 1
        max_size     = 1
        desired_size = 1
  
        instance_types = ["t3.medium"]
        capacity_type  = "SPOT"
      }
    }
  
    tags = {
      Environment = "dev"
      Terraform   = "true"
    }
  }
  }
  
  data "tls_certificate" "example" {
	url = aws_eks_cluster.example.identity[0].oidc[0].issuer
  }
  
  resource "aws_iam_openid_connect_provider" "example" {
	client_id_list  = ["sts.amazonaws.com"]
	thumbprint_list = [data.tls_certificate.example.certificates[0].sha1_fingerprint]
	url             = aws_eks_cluster.example.identity[0].oidc[0].issuer
  }
  
  data "aws_iam_policy_document" "example_assume_role_policy" {
	statement {
	  actions = ["sts:AssumeRoleWithWebIdentity"]
	  effect  = "Allow"
  
	  condition {
		test     = "StringEquals"
		variable = "${replace(aws_iam_openid_connect_provider.example.url, "https://", "")}:sub"
		values   = ["system:serviceaccount:kube-system:aws-node"]
	  }
  
	  principals {
		identifiers = [aws_iam_openid_connect_provider.example.arn]
		type        = "Federated"
	  }
	}
  }
  
  resource "aws_iam_role" "example" {
	assume_role_policy = data.aws_iam_policy_document.example_assume_role_policy.json
	name               = "example-vpc-cni-role"
  }
  
  resource "aws_iam_role_policy_attachment" "example" {
	policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
	role       = aws_iam_role.example.name
  }