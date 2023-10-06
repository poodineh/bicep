param webAppName1 string = 'ptwfdApp1'
param webAppName2 string = 'ptwfdApp2'
param location string = 'westeurope'
param fdName string = 'ptwFrontDoor'

resource appPlan1 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: '${webAppName1}-plan'
  location: location
  sku: {
    name: 'F1'
  }
}

resource webApplication1 'Microsoft.Web/sites@2021-01-15' = {
  name: webAppName1
  location: location
  properties: {
    serverFarmId: appPlan1.id
  }
}

resource appPlan2 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: '${webAppName2}-plan'
  location: location
  sku: {
    name: 'F1'
  }
}

resource webApplication2 'Microsoft.Web/sites@2021-01-15' = {
  name: webAppName2
  location: location
  properties: {
    serverFarmId: appPlan2.id
  }
}

resource resource 'Microsoft.Network/frontdoors@2020-05-01' = {
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
