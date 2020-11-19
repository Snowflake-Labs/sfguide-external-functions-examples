# External Functions

[AWS CloudFormation](https://aws.amazon.com/cloudformation/) template for setting up AWS API Gateway and Lambda for Snowflake external functions.

Steps for creating Snowflake external function using this template:
1. Go to AWS cloudformation and create a stack using this template.
2. Note the Gateway IAM role and URL of the "echo" method created in the API Gateway.
3. Create API integration in Snowflake using the Gatway URL and Gateway Role ARN.
4. Update the API Gateway role trust relation with API integration's API_AWS_IAM_USER_ARN and API_AWS_EXTERNAL_ID.
5. Create and run the external function.