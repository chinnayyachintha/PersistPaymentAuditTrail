import boto3
import os
import base64
from datetime import datetime

# Initialize the KMS and DynamoDB clients
kms = boto3.client('kms')
dynamodb = boto3.resource('dynamodb')

# Ensure the environment variable for the DynamoDB table is set
DYNAMODB_AUDIT_TABLE_NAME = os.environ.get('DYNAMODB_AUDIT_TABLE_NAME')
if not DYNAMODB_AUDIT_TABLE_NAME:
    raise ValueError("Environment variable 'DYNAMODB_AUDIT_TABLE_NAME' is not set.")

table = dynamodb.Table(DYNAMODB_AUDIT_TABLE_NAME)

def encrypt_data(data):
    """
    Encrypt data using KMS and return as base64-encoded string.
    """
    encrypted_data = kms.encrypt(
        KeyId=os.environ['KMS_KEY_ARN'],
        Plaintext=data.encode('utf-8')
    )
    # Convert binary CiphertextBlob to base64 string
    return base64.b64encode(encrypted_data['CiphertextBlob']).decode('utf-8')

def persist_payment_audit_trail(event, context):
    """
    Persist payment audit trail to DynamoDB with encrypted data.
    """
    try:
        # Extract details from the event
        transaction_id = event['transaction_id']
        action = event['action']  # e.g., 'READ', 'WRITE'
        actor = event['actor']  # e.g., 'user-service', 'payment-service'
        query_details = event['query_details']
        response = event['response']

        # Encrypt sensitive data
        encrypted_query_details = encrypt_data(query_details)
        encrypted_response = encrypt_data(response)

        # Generate unique Audit ID and ISO 8601 timestamp
        audit_id = str(datetime.utcnow().timestamp())
        timestamp = datetime.utcnow().isoformat()

        # Log entry in the Audit Table
        table.put_item(
            Item={
                'AuditID': audit_id,
                'TransactionID': transaction_id,
                'Action': action,
                'Actor': actor,
                'Timestamp': timestamp,
                'QueryDetails': encrypted_query_details,
                'Response': encrypted_response
            }
        )

        return {
            'statusCode': 200,
            'body': 'Audit Log Created'
        }

    except Exception as e:
        # Log and return the error
        print(f"Error persisting audit trail: {e}")
        return {
            'statusCode': 500,
            'body': f"Error persisting audit trail: {str(e)}"
        }

# Optional: Decrypt Data for Validation
def decrypt_data(encrypted_data):
    """
    Decrypt base64-encoded string using KMS.
    """
    decrypted_data = kms.decrypt(
        CiphertextBlob=base64.b64decode(encrypted_data)
    )
    return decrypted_data['Plaintext'].decode('utf-8')
