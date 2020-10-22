External Functions can be used to get data from a HTTP endpoint.
Pricing data provided by FinnHub - https://finnhub.io/

You'll need an API from FinnHub, nice and free

Shoutouts to bukosabino for the fantastic TechnicalAanlysis Python library used in this example!
Technical Analysis - https://github.com/bukosabino/ta

```
$ pip install --upgrade ta
$ pip install --upgrade pandas
$ pip install --upgrade requests
```


At the time of writing, the Pandas Python Package is too large to go directly to Lamdba. To get around this, I use the Serverless Framework. It takes care of zipping, compiling, uploading, creating the Lambda, and linking the API Gateway with one CLI call
`sls deploy`

If this is new to you, here's a great guide!

https://www.serverless.com/blog/serverless-python-packaging/

If you do use the Serverless Framework, you'll need to uncomment the first line in priceData.py
`import unzip_requirements # Use this when deploying through Serverless`
