param kvName string
param location string
param appPrincipalId string

resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: kvName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    accessPolicies: [
      {
        objectId: appPrincipalId
        permissions: {
          secrets: [ 
            'set'
            'get'
          ]
        }
        tenantId: subscription().tenantId
      }
    ]
  }
}
