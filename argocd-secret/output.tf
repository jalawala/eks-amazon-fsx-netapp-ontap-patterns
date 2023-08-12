output "aws_secret_manager_secret" {
  value       = aws_secretsmanager_secret.argocd
  description = "secret manager secret"
}

output "aws_secretsmanager_secret_version" {
  value       = aws_secretsmanager_secret_version.argocd
  description = "secret manager secret version"
  sensitive = true
}
