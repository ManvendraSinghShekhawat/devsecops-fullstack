output "ecr_repo_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

