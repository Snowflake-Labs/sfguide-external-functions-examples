------------------
-- ML Inference --
------------------
use extfuncdemodb.extfuncs;


create or replace external function EXT_UDF_entity_extraction(bodyext string)
    returns variant
    api_integration = api_int_pricedata --Tell the External Function how to connect to my AWS account
    as 'https://{domain}.execute-api.{region}.amazonaws.com/prod/{endpoint}';


--Test the external function.
--Result is the full response of the Lambda. An array of entities
SELECT EXT_UDF_entity_extraction('Richard Morwood (Aged 35) works at Snowflake. He loves working there!');


create or replace table articleText
(
  sourceUrl string,
  bodyText string
);

insert into articleText (sourceUrl, bodyText)
values ('https://www.snowflake.com/news/snowflake-announces-availability-aws-marketplace/', 'SAN MATEO, Calif. – Nov. 29, 2016 – Snowflake Computing, the data warehouse built for the cloud, today announced immediate availability of the Snowflake Elastic Data Warehouse through AWS Marketplace in conjunction with the launch of SaaS Subscriptions on AWS Marketplace. AWS Marketplace is an online store that helps customers find, buy, and immediately start using the software and services they need to build products and run their businesses. Visitors to the marketplace can quickly access ready-to-use software and pay only for what they use. “AWS Marketplace strives to offer customers the best possible selection of software products from ISVs to enable customer choice,” said Barry Russell, GM of Global Business Development, AWS Marketplace and Catalog Services, Amazon Web Services. “Our customers want solutions like Snowflake that are built on AWS and designed with the cloud in mind, and their support of SaaS Subscriptions on AWS Marketplace makes it even easier for customers to procure and deploy Snowflake for their data and analytics needs.” Snowflake, the data warehouse built for the cloud, was founded with the vision of eliminating the barriers to data analytics. Snowflake’s data warehouse built for the cloud delivers the performance, concurrency, and simplicity needed to support today’s diverse data and analytic')
     , ('https://www.snowflake.com/news/snowflake-announces-general-availability-on-google-cloud-in-london-u-k/', 'SAN MATEO, Calif. – June 23, 2020 – Snowflake, the cloud data platform, today announced general availability on Google Cloud in London, U.K.. The expansion follows Snowflake’s general availability on Google Cloud in the US and Netherlands earlier this year and reflects a continued rise in customer demand from organizations with a Google Cloud or multi-cloud strategy. Snowflake accelerated its London launch to empower organizations, such as the U.K.’s National Health Service, with a scalable, powerful data platform capable of generating rapid data insights that can help organizations as they respond to the COVID-19 pandemic. For Greater Manchester Health and Social Care Partnership, having a U.K.-hosted cloud data platform was essential, due to the sensitive nature of their data. With Snowflake, a number of key health and social care organisations in Greater Manchester will now be able to access a multi-cloud data platform for data science and analytics that scales to support any number of users and is secure by design. Matt Hennessey, Chief Intelligence and Analytics Officer for the Greater Manchester Health and Social Care Partnership, said: “Snowflake is a valuable addition to the suite of digital technologies that comprise the Greater Manchester Digital Platform. Snowflake will provide a powerful mechanism for generating quick data insights and driving decision-making that ultimately supports the health and wellbeing of our citizens.”')
     , ('https://www.snowflake.com/news/snowflake-announces-availability-on-microsoft-azure/', 'SAN MATEO, Calif. – July 12, 2018 – Snowflake Computing, the data warehouse built for the cloud, today announced immediate availability of its data warehouse-as-a-service on Microsoft Azure for preview. Customer demand for Azure, and the need for large organizations to have flexibility across their cloud strategy, has prompted Snowflake to offer Azure as a cloud computing option to run Snowflake’s cloud-built data warehouse. Nielsen, the global measurement and data analytics company, built their next-generation Connected System as a cloud-native platform. “We strongly believe that advancements in computing will happen more rapidly in the Cloud. We are proactively building the future of our business by leveraging Snowflake and Microsoft Azure,” Nielsen Buy CTO, Srini Varadarajan said. Nielsen’s Connected System operates on large volumes of global, retail, point-of-sale data to produce analytics that enable FMCG and retail companies around the world to achieve sustained, profitable growth in today’s ever-evolving industries. “Snowflake and Azure deliver the scale and performance we need to enable modern data analytics so we can deliver our customers the product and consumer insights they need,” Varadarajan said. “We look forward to what’s on the horizon with Azure and Snowflake.” Snowflake CEO, Bob Muglia said: “Organizations continue to move their data analytics to the cloud at an increasing pace, with the cloud data warehouse at the core of their strategy. Customer demand for an Azure-based data warehouse is also on the rise. We’re working with Microsoft to provide the performance, concurrency and flexibility that Azure customers require from a modern, cloud-built data warehouse.” Corporate Vice President for Azure Compute at Microsoft Corp., Corey Sanders said: “Migration of an enterprise data warehouse to the cloud is a key requirement for Azure customers. We look forward to partnering with Snowflake to enable these data warehouse migrations for enterprise customers moving onto Microsoft Azure. I am excited to have Snowflake available on the Azure platform.”')
;


--Response per input row
select EXT_UDF_entity_extraction(bodyText) as results
from articleText;


--Let's flatten the entities
with cte_strings as
(
  select EXT_UDF_entity_extraction(bodyText) as results
  from articleText
)

select f.value as EntityVariant,
       f.value:Type::string as EntityType,
       f.value:Text::string as Entity,
       f.value:Score::number(11, 10) as Score
from cte_strings, 
     lateral flatten(input => results:Entities) f
;