param webAppName1 string 
param webApp1Location string

resource appPlan1 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: '${webAppName1}-plan'
  kind: 'app,linux'
  location: webApp1Location
  sku: {
    name: 'F1'
  }
}

resource webApplication1 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName1
  location: webApp1Location
  kind: 'app,linux,container'
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

output appId string = webApplication1.id
