param currentAppSettings object 
param appSettings object
param appName string

resource siteconfig 'Microsoft.Web/sites/config@2020-12-01' = {
  name: '${appName}/appsettings'
  properties: union(currentAppSettings, appSettings)
}
