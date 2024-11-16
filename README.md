# Payment Audit Trail Implementation

## Objective

This project implements a payment audit trail system to maintain a log of every access and update to the PaymentLedger for compliance and traceability. The log captures details of all significant actions on the payment data, such as creating transactions or accessing data for refunds. This log is stored in the **PaymentAuditTrail** DynamoDB table, and sensitive data is encrypted using **AWS KMS** for secure storage.

---

## Architecture Overview

### Lambda Function

The Lambda function `persist_payment_audit_trail` logs audit events, such as access to payment data, updates to transaction records, or any other significant operations. It writes an entry in the **PaymentAuditTrail** DynamoDB table.

### DynamoDB

The **PaymentAuditTrail** table stores the audit log entries with the following attributes:

- **AuditID** (Primary Key): Unique identifier for the audit log.
- **TransactionID**: Refers to the original payment transaction associated with the action.
- **Action**: Type of operation (e.g., 'WRITE', 'READ').
- **Actor**: Service or user performing the action (e.g., 'payment-service', 'user-service').
- **Timestamp**: Date and time when the action occurred.
- **QueryDetails**: Details of the query or access operation performed.
- **Response**: Result or outcome of the query or action.

### AWS KMS

**AWS Key Management Service (KMS)** is used to encrypt sensitive information related to the audit trail, ensuring secure storage of sensitive data.

### IAM Roles and Policies

IAM roles and policies are configured to allow the Lambda function to access DynamoDB and KMS securely. The policies allow the following actions:

- **KMS**: `kms:Encrypt`, `kms:Decrypt` for encrypting and decrypting sensitive data.
- **DynamoDB**: Permissions for operations like `PutItem`, `GetItem`, `Query`, `UpdateItem`, and `Scan`.
- **Logs**: Permissions for creating logs in CloudWatch to monitor the audit trail activity.

---

## Secure Connection to DynamoDB with AWS PrivateLink

The audit trail logs are securely stored in DynamoDB, and a **PrivateLink** connection ensures that the traffic between the Lambda function and DynamoDB is isolated within the AWS network. This configuration prevents the data from being exposed to the public internet, ensuring enhanced security for sensitive audit data.

### VPC Configuration

- DynamoDB is accessed via a private subnet, and the Lambda function operates within the VPC for secure communication.

### Security Groups

- Security groups are configured to control access to DynamoDB, ensuring that only authorized Lambda functions can interact with it.

---

## IAM Role and Permissions

The IAM role `paymentledger-role` is granted necessary permissions to the Lambda function to interact with DynamoDB, AWS KMS, and write logs to CloudWatch. The policies allow the following actions:

- **KMS**: `kms:Encrypt`, `kms:Decrypt` for encrypting and decrypting sensitive data.
- **DynamoDB**: Permissions for operations like `PutItem`, `GetItem`, `Query`, `UpdateItem`, and `Scan`.
- **Logs**: Permissions for creating logs in CloudWatch to monitor the audit trail activity.

---

## How to Deploy

1. Clone this repository.
2. Make sure your AWS credentials are set up correctly (using AWS CLI or environment variables).
3. Run `terraform init` to initialize the Terraform environment.
4. Run `terraform apply` to deploy the infrastructure.

---

## Secure Connection with AWS PrivateLink

In order to securely connect to DynamoDB and ensure that the traffic does not traverse the public internet, **AWS PrivateLink** is used to create a private connection to DynamoDB.

- **PrivateLink Setup**: DynamoDB is accessed through PrivateLink in a VPC, and security groups are configured to only allow access from the Lambda function.
- **Encryption**: The data is encrypted using **AWS KMS**, ensuring that sensitive details are stored securely in DynamoDB.
