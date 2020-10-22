---------------------------
-- Getting External Data --
---------------------------
//create or replace external function EXT_UDF_fetch_asset_price_data(url string)
create or replace external function EXT_UDF_fetch_asset_price_data(symbol string, fromDate int, toDate int)
    returns variant
    api_integration = api_int_pricedata --Tell the External Function how to connect to my AWS account
    as 'https://{domain}.execute-api.ap-southeast-2.amazonaws.com/prod/{endpoint}';


// The FinHubb API would like the time in UnixSeconds
// https://www.epochconverter.com/
select to_timestamp(1590969600) as startDate,
       to_timestamp(1595808000) as startDate;

// Simple call to get Snowflakes stock price
select EXT_UDF_fetch_asset_price_data('SNOW', 1590969600, 1595808000) as apiData;


// Now lets make it dynamically fetch the last 7 days history
set daysHistory = 7;
select $daysHistory;

//Convert a datetime to unix seconds
select dateadd(day, -$daysHistory, current_date())::timestamp
     , DATE_PART('EPOCH_SECOND', dateadd(day, -$daysHistory, current_date())::timestamp);


// Which stock symbols should we get?
with cte_stocksymbols 
as
(
  select 'SNOW' as symbol
  union
  select 'AMZN' as symbol
  union
  select 'MSFT' as symbol
  union
  select 'GOOGL' as symbol
)

// Fetch the data from FinHubb
, cte_stockprices
as
(
  select Symbol
       , DATE_PART('EPOCH_SECOND', dateadd(day, -$daysHistory, current_date())::timestamp) as fromDate
       , DATE_PART('EPOCH_SECOND', current_date()) as toDate
       , EXT_UDF_fetch_asset_price_data(symbol, fromDate, toDate) as apiData
  from cte_stocksymbols
)

//Read the results. Each set of price data comes back as an array, which we can flatten
//"Hey! The Bollinger Bands are null!"
//These are calculated using the last X number of candles (20 if you didn't adjust the python code)
//apiData:response.entry[20] and onwards have populated data
select symbol
     , d.value as entry
     , to_timestamp((entry:OpenTime::int)) as OpenTime
     , entry:OpenTime::int as OpenTime
     , entry:Open::number(20, 5) as OpenPrice
     , entry:High::number(20, 5) as HighPrice
     , entry:Low::number(20, 5) as LowPrice
     , entry:Close::number(20, 5) as ClosePrice
     , entry:Volume::int as Volume
from cte_stockprices,
     lateral flatten(input => apiData:response) d
;