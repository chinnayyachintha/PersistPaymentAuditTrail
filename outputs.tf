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
