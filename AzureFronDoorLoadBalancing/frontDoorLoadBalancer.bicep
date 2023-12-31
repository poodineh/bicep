param webAppName1 string 
param webAppName2 string 
param webApp1Location string
param webApp2Location string
param fdName string

resource appPlan1 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: '${webAppName1}-plan'
  location: webApp1Location
  sku: {
    name: 'F1'
  }
}

resource webApplication1 'Microsoft.Web/sites@2021-01-15' = {
  name: webAppName1
  location: webApp1Location
  properties: {
    serverFarmId: appPlan1.id
  }
}

resource appPlan2 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: '${webAppName2}-plan'
  location: webApp2Location
  sku: {
    name: 'F1'
  }
}

resource webApplication2 'Microsoft.Web/sites@2021-01-15' = {
  name: webAppName2
  location: webApp2Location
  properties: {
    serverFarmId: appPlan2.id
  }
}

resource frontDoor1 'Microsoft.Network/frontdoors@2020-05-01' = {
  name: fdName
  location: 'global'
  tags: {}
  properties: {
    friendlyName: fdName
    enabledState: 'Enabled'
    healthProbeSettings: [
      {
        name: 'simple'
        properties: {
          path: '/'
          protocol: 'Https'
          intervalInSeconds: 30
          healthProbeMethod: 'Head'
          enabledState: 'Enabled'
        }
      }
    ]
    loadBalancingSettings: [
      {
        name: 'simple'
        properties: {
          sampleSize: 4
          successfulSamplesRequired: 2
          additionalLatencyMilliseconds: 0
        }
      }
    ]
    frontendEndpoints: [
      {
        name: fdName
        properties: {
          hostName: '${fdName}.azurefd.net'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 0
          webApplicationFirewallPolicyLink: null          
        }        
      }
    ]
    backendPools: [
      {
        name: fdName
        properties: {
          healthProbeSettings: {
            id: resourceId('Microsoft.Network/FrontDoors/healthProbeSettings', fdName, 'simple')
          }
          loadBalancingSettings: {
            id: resourceId('Microsoft.Network/FrontDoors/loadBalancingSettings', fdName, 'simple')
          }
          backends: [
            {
              address: webApplication1.properties.defaultHostName
              enabledState: 'Enabled'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
              backendHostHeader: webApplication1.properties.defaultHostName
            }
            {
              address: webApplication2.properties.defaultHostName
              enabledState: 'Enabled'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
              backendHostHeader: webApplication2.properties.defaultHostName
            }
          ]          
        }        
      }
    ]
    routingRules: [
      {
        name: fdName
        properties: {          
          acceptedProtocols: [
            'Http'
            'Https'
          ]
          patternsToMatch: [
            '/*'
          ]
          enabledState: 'Enabled'
          routeConfiguration: {
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
            customForwardingPath: null
            forwardingProtocol: 'HttpsOnly'            
            cacheConfiguration: null
            backendPool: {
              id: resourceId('Microsoft.Network/FrontDoors/BackendPools', fdName, fdName)
            }
          }
          frontendEndpoints: [
            {
              id: resourceId('Microsoft.Network/FrontDoors/FrontendEndpoints', fdName, fdName)
            }
          ]
        }        
      }
    ]
    backendPoolsSettings: {
      enforceCertificateNameCheck: 'Enabled'
      sendRecvTimeoutSeconds: 30
    }
  }
}

output frontDoorHost string = frontDoor1.properties.frontendEndpoints[0].properties.hostName
output app1Host string = webApplication1.properties.hostNames[0]
output app2Host string = webApplication2.properties.hostNames[0]
