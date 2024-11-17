output "kms_key_arn" {
  description = "ARN of the KMS Key for encryption"
  value       = aws_kms_key.payment_audit_key.arn
}

output "dynamodb_table_name" {
  description = "Name of the PaymentLedger DynamoDB table"
  value       = aws_dynamodb_table.payment_audit_trail.name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function for persisting payment ledger"
  value       = aws_lambda_function.persist_payment_audit_trail.arn
}

output "iam_role_arn" {
  description = "ARN of the IAM Role used by the Lambda function"
  value       = aws_iam_role.payment_audit_role.arn
}

# backup_table outputs
# Output the ARN of the Backup Vault
output "payment_audit_trail_backup_vault_arn" {
  value = aws_backup_vault.payment_audit_trail_vault.arn
  description = "The ARN of the payment audit trail backup vault"
}

# Output the name of the Backup Vault
output "payment_audit_trail_backup_vault_name" {
  value = aws_backup_vault.payment_audit_trail_vault.name
  description = "The name of the payment audit trail backup vault"
}

# Output the Backup Plan ID
output "payment_audit_trail_backup_plan_id" {
  value = aws_backup_plan.payment_audit_trail_backup_plan.id
  description = "The ID of the payment audit trail backup plan"
}

# Output the ARN of the IAM Role used by AWS Backup
output "payment_audit_trail_backup_role_arn" {
  value = aws_iam_role.backup_role.arn
  description = "The ARN of the IAM role used for AWS Backup"
}

# Output the Backup Selection ID (not ARN as the ARN is not supported)
output "payment_audit_trail_backup_selection_id" {
  value = aws_backup_selection.payment_ledger_backup_selection.id
  description = "The ID of the backup selection"
}

# Output the DynamoDB Table ARN
output "payment_audit_trail_dynamodb_table_arn" {
  value = aws_dynamodb_table.payment_audit_trail.arn
  description = "The ARN of the DynamoDB payment audit trail table"
}

