import json
import boto3

def SendNotification(event, context):    
    # print(event) # Debug, writes input to CloudWatch log
    
    retVal= {}
    retVal["data"] = []
    
    for row in event["data"]:
        sflkRowRef = row[0] # This is how Snowflake keeps track of data as it gets returned
        content = row[1]    # The data passed in from Snowflake that the input row contains.
                            # If the passed in data was a Variant, it lands here as a dictionary. Handy!
        
        # Extract anything needed from the row
        emailSubject = content['Subject']
        emailBody = content['Body']
        
        message = {"foo": "bar"} # SNS doesn't use this part for emails, but you MUST HAVE IT or the publish call will error
        client = boto3.client('sns')
        snsResponse = client.publish(
            TargetArn='arn:aws:sns:{your SNS ARN here}',
            Message=json.dumps({'default': json.dumps(message),
                                'email': emailBody}),
            Subject=emailSubject,
            MessageStructure='json'
        )
        
        sflkResponse={}
        sflkResponse["snsResponse"] = snsResponse #['snsResponse']['messageId']

        retVal["data"].append([sflkRowRef,sflkResponse])

    ## Debug, writes output to CloudWatch log
    # print('--- RESPONSE FROM LAMBDA ---')
    # print(retVal)
    
    return retVal