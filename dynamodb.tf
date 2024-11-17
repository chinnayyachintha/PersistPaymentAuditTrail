# Maintain a log of every access and update to the PaymentLedger for compliance and traceability.

resource "aws_dynamodb_table" "payment_audit_trail" {
  name           = var.dynamodb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  hash_key = "AuditID"

  attribute {
    name = "AuditID"
    type = "S"
  }

  attribute {
    name = "TransactionID"
    type = "S"
  }

  attribute {
    name = "Action"
    type = "S"
  }

  attribute {
    name = "Actor"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "S"
  }

  attribute {
    name = "QueryDetails"
    type = "S"
  }

  attribute {
    name = "Response"
    type = "S"
  }

  # Global Secondary Indexes (GSI)
  global_secondary_index {
    name            = "TransactionID-Index"
    hash_key        = "TransactionID"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 5
  }

  global_secondary_index {
    name            = "Action-Index"
    hash_key        = "Action"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 5
  }

  global_secondary_index {
    name            = "Timestamp-Index"
    hash_key        = "Timestamp"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 5
  }

  global_secondary_index {
    name            = "Actor-Index"
    hash_key        = "Actor"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 5
  }

  global_secondary_index {
    name            = "QueryDetails-Index"
    hash_key        = "QueryDetails"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 5
  }

  global_secondary_index {
    name            = "Response-Index"
    hash_key        = "Response"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 5
  }

  tags = {
    Name = "${var.dynamodb_table_name}"
  }
}
