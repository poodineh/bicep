targetScope = 'resourceGroup'

param webApp1Name string
param kvName string
param location string = resourceGroup().location
@secure()
param applicationPassword string

module kv 'keyvault.bicep'= {
  name: 'kv'
  params: {
    kvName: kvName
    location: location
    appPrincipalId: webApplication1.identity.principalId
  }
}

module secret 'kvsecret.bicep' = {
  name: 'secret'
  params: {
    kvName: kvName
    secretName: 'applicationPassword'
    secretValue: applicationPassword
  }
  dependsOn: [
    kv
  ]
}

resource appPlan1 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: '${webApp1Name}-plan'
  kind: 'app,linux'
  location: location
  sku: {
    name: 'F1'
  }
}

resource webApplication1 'Microsoft.Web/sites@2022-09-01' = {
  name: webApp1Name
  location: location
  kind: 'app,linux,container'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appPlan1.id
    siteConfig: {
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Integration'
        }
      ]
    }
  }
}

module appSettings 'webappConfig.bicep' = {
  name: 'myAwesomeFunction-appSettings'
  params: {
    appName: webApp1Name
    currentAppSettings: list('${webApplication1.id}/config/appsettings', '2021-02-01').properties
    appSettings: {
      secretName: '@Microsoft.KeyVault(VaultName=${kvName};SecretName=${secret.outputs.secretKv})'
    }
  }
  dependsOn: [
    secret
  ]
}

