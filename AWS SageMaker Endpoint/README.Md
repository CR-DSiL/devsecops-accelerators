### CloudFormation template to deploy SageMaker Endpoint

The provided template deploys a SageMaker Endpoint in an auto scaling group and a Lambda function to handle the API requests.

The SageMaker endpoint configured with Endpoint config, Reference Model, necessary execution role.

Lambda function deploys along with API gate way and creats a lamda function resource with python3.7 environment.

Any one can consider this template with their custom variable names and deploy it to get the same stack. You can choose to deploy certain components by commenting other resources.