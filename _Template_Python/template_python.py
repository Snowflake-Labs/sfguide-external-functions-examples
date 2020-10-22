import json

def lambda_handler(event, context):
    
    retVal= {}
    retVal["data"] = []
    

    # Need to see what your INPUT looks like?
    print(json.dumps(event)) # This will be written to CloudWatch log

    for row in event["data"]:
        sflkRowRef = row[0] # This is how Snowflake keeps track of data as it gets returned
        input = row[1]
        
        # Pass each row through a processRow function        
        response = processRow(input)

        # Top-level element must be "data".
        # Each item in the array should say which rowIndex it was sources from - sflkRowRef
        retVal["data"].append([sflkRowRef,response])

    print(json.dumps(retVal))
    return retVal
    


def processRow(input):
    retVal = 0

    # Wrap the processing in a try/except
    # If a single row errors, it should not fail the entire ExternalFunction
    try:
        retVal = input + 3
    except:
        retVal = "Error processing this row..."
        
    return retVal