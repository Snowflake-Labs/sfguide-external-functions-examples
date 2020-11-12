import boto3
import json

def ExtractEntitiesFromArticle(event, context):
    retVal= {}
    retVal["data"] = []

    # Data is sent to Lambda via a HTTPS POST call. We want to get to the payload send by Snowflake
    event_body = event["body"]
    payload = json.loads(event_body)
    
    for row in payload["data"]:
        sflkRowRef = row[0] # This is how Snowflake keeps track of data as it gets returned
        inputText = row[1]

        client = boto3.client('comprehend')
        comprehendResponse = client.detect_entities(
            Text=inputText,
            LanguageCode='en'
        )
        
        retVal["data"].append([sflkRowRef,comprehendResponse])


    return retVal