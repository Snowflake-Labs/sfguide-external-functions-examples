 
-- create API integration

create or replace api integration external_api_integration
   api_provider = azure_api_management
   azure_tenant_id = '<YOUR-AD-TENANT-ID>'
   azure_ad_application_id = '<YOUR-AZURE-AD-APPLICATION-ID>'
   api_allowed_prefixes = ('https://<api-management-service-name>.azure-api.net/<api_url_suffix>')
   enabled = true;

-- create external function
create or replace external function translate_en_italian(input string)
    returns variant
    api_integration = external_api_integration
    as 'https://<API Management service name>.azure-api.net/<api_url_suffix>/<http_triggered_function_name>'
    ;
