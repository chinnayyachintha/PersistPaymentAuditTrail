resource "aws_lambda_function" "persist_payment_audit_trail" {
  function_name = "persist-${var.dynamodb_table_name}"

  role    = aws_iam_role.payment_audit_role.arn
  handler = "paymentaudit-trail.persist_payment_audit_trail"
  runtime = "python3.8"

  filename         = "paymentaudit-trail.zip"
  source_code_hash = filebase64sha256("paymentaudit-trail.zip")

  environment {
    variables = {
      DYNAMODB_AUDIT_TABLE_NAME = aws_dynamodb_table.payment_audit_trail.name
      KMS_KEY_ARN               = aws_kms_key.payment_audit_key.arn
    }
  }

  timeout = 60

  vpc_config {
    subnet_ids         = [data.aws_subnet.private_subnet.id]     # Reference the private subnet
    security_group_ids = [data.aws_security_group.private_sg.id] # Reference the security group
  }

}