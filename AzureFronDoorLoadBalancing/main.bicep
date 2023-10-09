targetScope = 'subscription'

param webApp1Name string
param webApp2Name string
param webApp1Location string
param webApp2Location string
param frontDoorName string

resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'FrontDoor-ResourceGroup'
  location: webApp1Location
}

module frontDoor 'frontDoorLoadBalancer.bicep' = {
  scope: rg
  name: 'FrontDoor-Service'
  params: {
    webAppName1: webApp1Name
    webAppName2: webApp2Name
    webApp1Location: webApp1Location
    webApp2Location: webApp2Location
    fdName: frontDoorName
  }
}

output frontDoorHost string = frontDoor.outputs.frontDoorHost
output app1Host string = frontDoor.outputs.app1Host
output app2Host string = frontDoor.outputs.app2Host
