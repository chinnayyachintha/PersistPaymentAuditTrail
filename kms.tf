# AWS KMS Key for Encryption &  Decryption

# AWS KMS Key for Payment Audit Trail Encryption & Decryption
resource "aws_kms_key" "payment_audit_key" {
  description = "KMS key for Payment Audit Trail encryption"
  key_usage   = "ENCRYPT_DECRYPT"
}

# KMS Alias for Payment Audit Trail Key
resource "aws_kms_alias" "payment_audit_key_alias" {
  name          = "alias/${var.dynamodb_table_name}-key"
  target_key_id = aws_kms_key.payment_audit_key.key_id # Fixed the typo here
}
