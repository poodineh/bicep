param kvName string
@secure()
param secretValue string
param secretName string

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: '${kvName}/${secretName}'
  properties: {
    value: secretValue
  }
}

output secretUrl string = keyVaultSecret.properties.secretUri
output secretKv string = secretName
