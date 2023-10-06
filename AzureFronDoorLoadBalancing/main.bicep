targetScope = 'subscription'

param location string 
param webApp1Name string
param webApp2Name string
param frontDoorName string

resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'AzureFrontDoor'
  location: location
}

module frontDoor 'frontDoorLoadBalancer.bicep' = {
  scope: rg
  name: 'frontDoor'
  params: {
    location: location
    webAppName1: webApp1Name
    webAppName2: webApp2Name
    fdName: frontDoorName
  }
}
