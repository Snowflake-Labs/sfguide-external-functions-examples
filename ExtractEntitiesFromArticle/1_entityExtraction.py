import boto3
import json

def ExtractEntitiesFromArticle(event, context):
    retVal= {}
    retVal["data"] = []

    for row in event["data"]:
        sflkRowRef = row[0] # This is how Snowflake keeps track of data as it gets returned
        inputText = row[1]

        client = boto3.client('comprehend')
        comprehendResponse = client.detect_entities(
            Text=inputText,
            LanguageCode='en'
        )
        
        retVal["data"].append([sflkRowRef,comprehendResponse])


    return retVal