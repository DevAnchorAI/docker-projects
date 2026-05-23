import json
import boto3

def lambda_handler(event, context):
    """
    Simple Lambda function example that processes events
    """
    print(f"Received event: {json.dumps(event)}")
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Hello from Lambda!',
            'event': event
        })
    }
