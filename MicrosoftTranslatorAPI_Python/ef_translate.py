import os, requests, json
import logging, httpx
import azure.functions as func
 
async def main(req: func.HttpRequest) -> func.HttpResponse:
   endpoint = "https://api.cognitive.microsofttranslator.com/"
   path = "/translate?api-version=3.0"
   params = "&to=it"
   constructed_url = endpoint + path + params
 
   headers = {
       "Ocp-Apim-Subscription-Key": "<YOUR-COGNITIVE-SERVICES-KEY>",
       "Ocp-apim-subscription-region": "<YOUR-COGNITIVE-SERVICES-REGION>",
       "Content-Type": "application/json"
   }
 
   req_body = req.get_json()
      
   if req_body :
       translated = []
       body = []
       i = 0
 
       # Format JSON data passed from Snowflake to what Translator API expects.
       for row in req_body["data"]:
           body.append({"text": row[1]})
      
       # Microsoft recommends using asynchronous APIs for network IO.
       # This example uses httpx library to make async calls to the API.
       client = httpx.AsyncClient()
       response = await client.post(constructed_url, headers = headers, json = body)
       response_json = response.json()
  
       # Process and format response into Snowflake expected JSON.
       for row in response_json:
           translations = row["translations"][0]
           translated_text = translations["text"]
           translated.append([req_body["data"][i][0], translated_text])
           i += 1
    
       output = {"data": translated}
       return func.HttpResponse(json.dumps(output))
  
   else:
       return func.HttpResponse(
            "Please pass data to translate in the request body",
            Status_code = 400
       )
