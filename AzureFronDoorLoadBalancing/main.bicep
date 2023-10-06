targetScope = 'subscription'

var fdLocation = 'westeurope'

resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'AzureFrontDoor'
  location: fdLocation
}

module frontDoor 'webApp.bicep' = {
  scope: rg
  name: 'frontDoor'
  params: {
    location: fdLocation
  }
}
