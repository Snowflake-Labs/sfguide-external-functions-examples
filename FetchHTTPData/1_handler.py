import json
import requests 

def FetchHttpData(event, context):    
    retVal= {}
    retVal["data"] = []

    for row in event["data"]:
        sflkRowRef = row[0] # This is how Snowflake keeps track of data as it gets returned
        URL = row[1]    # The data passed in from Snowflake that the input row contains.
                        # If the passed in data was a Variant, it reaches Python as a dictionary. Handy!
        # URL = 'https://gbfs.citibikenyc.com/gbfs/en/system_regions.json'
        # r = requests.get(url = URL)
        # response = r.json()
        httpData = requests.get(url = URL).json()
        response = {}
        response["url"] = URL
        response["response"] = httpData

        retVal["data"].append([sflkRowRef,response])

    return retVal