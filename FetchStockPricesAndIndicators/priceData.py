# import unzip_requirements # Use this when deploying through Serverless
import ta
from ta.volatility import BollingerBands
from ta.utils import dropna
import json
import boto3
import pandas as pd
import requests
from config import FinnHubAPI

def GetPriceDataFromExchangeFinnHub(event, context):
    retVal= {}
    retVal["data"] = []

    # For debugging the input, write the EVENT to CloudWatch logs
    print(json.dumps(event))

    for row in event["data"]:
        sflkRowRef = row[0] # This is how Snowflake keeps track of data as it gets returned
        symbol = row[1]    # The data passed in from Snowflake that the input row contains.
        fromDate = row[2]
        toDate = row[3]
        
        
        # Will return URL without token to Snowflake for tracking
        URL = f'https://finnhub.io/api/v1/stock/candle?symbol={symbol}&resolution=D&from={fromDate}&to={toDate}'

        # Add our FinnHubAPI Key to the end of the URL.
        # This is in a new variable which will not be returned to Snowflake
        URLWithToken = f'{URL}&token={FinnHubAPI.TOKEN}'
        
        # GET data from the API
        httpData = requests.get(url = URLWithToken).json()
        
        # Convert to Pandas DataFrame
        df = pd.DataFrame(httpData)

        # Add the column names
        print("Adding column names")
        df.columns = ["Close", "High", "Low", "Open", "Status", "OpenTime", "Volume"]

        # Set DateTime columns to correct type
        df['OpenTime'] = pd.to_datetime(df['OpenTime'], unit='ms')
        df['Open'] = df['Open'].astype(float)
        df['High'] = df['High'].astype(float)
        df['Low'] = df['Low'].astype(float)
        df['Close'] = df['Close'].astype(float)
        df['Volume'] = df['Volume'].astype(float)

        # Clean NaN values
        print("Cleaning NA values")
        df = dropna(df)

        # Calculate the Bollinger Bands indicator
        indicator_bb = BollingerBands(close=df["Close"], n=20, ndev=2)        
        df['bb_bbm'] = indicator_bb.bollinger_mavg()
        df['bb_bbh'] = indicator_bb.bollinger_hband()
        df['bb_bbl'] = indicator_bb.bollinger_lband()
        df['bb_bbhi'] = indicator_bb.bollinger_hband_indicator()
        df['bb_bbli'] = indicator_bb.bollinger_lband_indicator()
        df['bb_bbw'] = indicator_bb.bollinger_wband()
        df['bb_bbp'] = indicator_bb.bollinger_pband()

        print("converting OHLC pandas to JSON. This does it as a string")
        buffer = df.to_json(orient = "records")

        print("Interpret the JSON string into a dictionary for output")
        jsonResponse = json.loads(buffer)

        # Prepare the output response
        response = {}
        response["url"] = URL
        response["response"] = jsonResponse

        retVal["data"].append([sflkRowRef,response])

    # For debugging the output, write the RETurn VALue to CloudWatch logs
    # print(json.dumps(retVal))

    return retVal