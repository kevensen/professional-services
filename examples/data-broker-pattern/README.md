# Aurinko Reference Architecture for GCP
This reference architecture provides an example of how to build a data pipeline for GCP.
## Basic Data Flow
Data originiates from a client-side application using the DataBroker SDK.  Currently, the maximum size of a PubSub payload is 10MB.  Therefore, if the the data being sent is less than 10MB, the message will be sent along the *streaming* data flow.  If the payload is greater than 10MB, the *batch* data flow is executed.

![Data Flow](images/aurinko_data_flow.png)

**NOTE:** The Terraform templates deploy the Google Cloud PubSub, Server Ingestion App, and BigQuery components.
## Prerequisites
### Deployment Machine
In order to invoke Terraform using this framswork, the following must be installed on the deplyment machine.
1. Apache Maven
2. Hashicorp Terraform

### CI/CD Build Machine
In an example environment, this could be the same machine as the deployment machine
1. Apache Maven
## Deploy Reference Architecture
Deploy the reference architecture with Terraform.  View the README.md in the terraform subdirectory.
## Invoke the Java Example
Navigate to the "java/" subdirectory and view the README.md for instructions on how to publish a test message.