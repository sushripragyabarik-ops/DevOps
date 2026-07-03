import json

def lambda_handler(event, context):

    for record in event["Records"]:

        filename = record["s3"]["object"]["key"]

        print(f"Uploaded File: {filename}")

    return {
        "statusCode": 200,
        "body": json.dumps("Success")
    }