# bicep
Azure Bicep to IaC

The reference code base of the Medium articles.

https://medium.com/@poodineh


Scenario
We want to implement a Multi-geo redundancy including two web applications on Azure web App Service on diffrent locations(West Europe and East US), and a global load balancer supporting HTTP2 and HTTPS.

Base on the scenario requirements, we should take an Azure Front Door load balancer.

Solution

This Bicep template includes the following files:
* main.bicep
* frontDoorLoadBalancer.bicep
* parameters.json

This Bicep template creates the following resources:
* Two App Service Plans
* Two Web App Services
* A Azure Front Door

How to configure the Bicep template:
Download/Clone the code base from GitHub to the desired local directory.
Open the parameters.json file and change the values as desired. Do not forget to save the changes.



