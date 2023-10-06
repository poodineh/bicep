
param fdName string
param location string = resourceGroup().location

resource resource 'Microsoft.Network/frontdoors@2020-05-01' = {
  name: fdName
  location: location
  tags: {}
  properties: {
    friendlyName: fdName
    enabledState: 'Enabled'
    healthProbeSettings: [
      {
        name: 'healthProbeSettings-1696431623172'
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
        name: 'loadBalancingSettings-1696431623172'
        properties: {
          sampleSize: 4
          successfulSamplesRequired: 2
          additionalLatencyMilliseconds: 0
        }
      }
    ]
    frontendEndpoints: [
      {
        name: 'ptwFrontend-azurefd-net'
        properties: {
          hostName: 'ptwFrontend.azurefd.net'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 0
          webApplicationFirewallPolicyLink: null          
        }        
      }
    ]
    backendPools: [
      {
        name: 'myBackendPool'
        properties: {
          backends: [
            {
              address: 'p44appcsoint001.azurewebsites.net'
              enabledState: 'Enabled'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
              backendHostHeader: 'p44appcsoint001.azurewebsites.net'
            }
          ]
          loadBalancingSettings: {
            id: '/subscriptions/25f13276-305b-40b3-8d36-647f5966cf13/resourceGroups/iin-12-rg-int-001/providers/Microsoft.Network/frontdoors/ptwFrontend/loadBalancingSettings/loadBalancingSettings-1696431623172'
          }
          healthProbeSettings: {
            id: '/subscriptions/25f13276-305b-40b3-8d36-647f5966cf13/resourceGroups/iin-12-rg-int-001/providers/Microsoft.Network/frontdoors/ptwFrontend/healthProbeSettings/healthProbeSettings-1696431623172'
          }
        }
        id: '/subscriptions/25f13276-305b-40b3-8d36-647f5966cf13/resourceGroups/iin-12-rg-int-001/providers/Microsoft.Network/frontdoors/ptwFrontend/backendPools/myBackendPool'
      }
    ]
    routingRules: [
      {
        name: 'LocationRule'
        properties: {
          frontendEndpoints: [
            {
              id: '/subscriptions/25f13276-305b-40b3-8d36-647f5966cf13/resourceGroups/iin-12-rg-int-001/providers/Microsoft.Network/frontdoors/ptwFrontend/frontendEndpoints/ptwFrontend-azurefd-net'
            }
          ]
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
            backendPool: {
              id: '/subscriptions/25f13276-305b-40b3-8d36-647f5966cf13/resourceGroups/iin-12-rg-int-001/providers/Microsoft.Network/frontdoors/ptwFrontend/backendPools/myBackendPool'
            }
            cacheConfiguration: null
          }
        }
        id: '/subscriptions/25f13276-305b-40b3-8d36-647f5966cf13/resourceGroups/iin-12-rg-int-001/providers/Microsoft.Network/frontdoors/ptwFrontend/routingRules/LocationRule'
      }
    ]
    backendPoolsSettings: {
      enforceCertificateNameCheck: 'Enabled'
      sendRecvTimeoutSeconds: 30
    }
  }
}
