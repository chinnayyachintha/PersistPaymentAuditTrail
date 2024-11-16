import boto3
import os
from datetime import datetime

# Initialize the KMS client
kms = boto3.client('kms')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_AUDIT_TABLE_NAME'])

def encrypt_data(data):
    """Encrypt data using KMS"""
    encrypted_data = kms.encrypt(
        KeyId=os.environ['KMS_KEY_ARN'],
        Plaintext=data.encode('utf-8')
    )
    return encrypted_data['CiphertextBlob']

def persist_payment_audit_trail(event, context):
    transaction_id = event['transaction_id']
    action = event['action']  # e.g., 'READ', 'WRITE'
    actor = event['actor']  # e.g., 'user-service', 'payment-service'
    query_details = event['query_details']
    response = event['response']

    # Encrypt query details and response with KMS
    encrypted_query_details = encrypt_data(query_details)
    encrypted_response = encrypt_data(response)

    # Create a new Audit ID
    audit_id = str(datetime.now().timestamp())

    # Log entry in the Audit Table
    table.put_item(
        Item={
            'AuditID': audit_id,
            'TransactionID': transaction_id,
            'Action': action,
            'Actor': actor,
            'Timestamp': str(datetime.now()),
            'QueryDetails': encrypted_query_details,
            'Response': encrypted_response
        }
    )

    return {
        'statusCode': 200,
        'body': 'Audit Log Created'
    }
