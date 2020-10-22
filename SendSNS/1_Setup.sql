//DOCO on ExternalFucntions
//https://docs.snowflake.com/en/sql-reference/external-functions.html

create database if not exists admin;
create schema if not exists extfuncs;
use admin.extfuncs;

show integrations;

//// 1) Create the integration
create or replace api integration api_int_notifications
  api_provider = aws_api_gateway
  api_aws_role_arn = 'arn:aws:iam::{{AWSAccountID}}:role/{{AWSRole}}' --Role created in AWS account
  enabled = true
  api_allowed_prefixes = ('{{API Gateway Endpoint}}') --API endpoint
;

//// 2) Take the API_AWS_IAM_USER_ARN, and API_AWS_EXTERNAL_ID, put them into the roles TrustRelationship
//---- API_AWS_IAM_USER_ARN goes into;
//"Principal": {
//        "AWS": "{{API_AWS_IAM_USER_ARN here}}"
//      }
//
//----API_AWS_EXTERNAL_ID goes into;
//      "Condition": {
//        "StringEquals": {
//          "sts:ExternalId": "{{API_AWS_EXTERNAL_ID here}}"
//        }
//      }

describe integration api_int_notifications;

show external functions;

create or replace external function EXT_UDF_SendNotification(notificationDetails variant)
    returns variant
    api_integration = api_int_notifications
    as '{{full URL of API Gateway Endpoint}}';