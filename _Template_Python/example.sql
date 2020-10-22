create or replace database extfuncdemodb;
create or replace schema elt;

create or replace external function extfuncdemodb.elt.EXT_UDF_add_three(sourceNumber int)
    returns int
    api_integration = api_int_pricedata --Tell the External Function how to connect to my AWS account
    as 'https://{apigatewaydomain}.{region}.amazonaws.com/prod/{endpoint}';


--This will work nicely
with cte_numbers as
(
    select 5 as input
    union
    select 23 as input
)

select EXT_UDF_add_three(input)
from cte_numbers;