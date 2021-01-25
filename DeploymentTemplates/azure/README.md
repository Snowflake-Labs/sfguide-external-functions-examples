# External Functions

[Azure Resource Manager](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/quickstart-create-templates-use-the-portal#edit-and-deploy-the-template) template for setting up Azure API Management instance and Azure Function App for Snowflake external functions.

Steps for creating Snowflake external function using this template:
 1. Create a new [app registration](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app) that represents the API gateway and Azure Function app.
 2. Use the application ID of the app from step #1 for azureadApplicationId parameter and deploy this template.
 3. Note the URL of the API management instance and the Function App.  
 4. Create API integration in Snowflake using the API management URL and the Azure AD application ID.
 5. Get the service principal of the Snowflake application created using the consent flow.
 6. Replace SNOWFLAKE_SERVICE_PRINCIPAL_ID with the above value in the validate-jwt policy.
 7. Create and run the external function.