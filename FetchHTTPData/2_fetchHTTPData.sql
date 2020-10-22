use extfuncdemodb.extfuncs;

create or replace external function EXT_UDF_fetchHTTPData(url string)
    returns variant
    api_integration = api_int_notifications --Tell the External Function how to connect to my AWS account
    as 'https://{domain}.execute-api.{region}.amazonaws.com/prod/{endpoint}';


--Test the external function.
with cte_endpoints
as
(
    select 'https://gbfs.citibikenyc.com/gbfs/en/system_regions.json' as URL
    union
    select 'https://domain.com/dataEndpoint' as URL
)

SELECT EXT_UDF_fetchHTTPData(URL)
from cte_endpoints;