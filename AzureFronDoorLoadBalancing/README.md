# bicep
Azure Bicep to IaC

The reference code base of the Medium articles.

https://medium.com/@poodineh


Scenario
We want to implement a Multi-geo redundancy including two web applications on Azure web App Service on diffrent locations(West Europe and East US), and a global load balancer supporting HTTP2 and HTTPS.

Base on the scenario requirements, we should take a load balancer from the table below.

| Service                       | Region              | Traffic
____________________________________________________________________
| Azure Front Door              | Global              | HTTP(S)
| Azure Traffic Manager         | Global              | Non-HTTP(S)
| Azure Application Gateway     | Regional            | HTTP(S)
| Azure Load Balancer           | Global/Regional     | Non-HTTP(S)
