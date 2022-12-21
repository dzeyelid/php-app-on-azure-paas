@description('リソース名に付与する識別用の文字列（プロジェクト名など）を入力してください')
param workloadName string

@description('Azure App Service Plan のプランを選択してください')
@allowed(['F1', 'B1', 'B2', 'B3', 'S1', 'S2', 'S3', 'P1v2', 'P2v2', 'P3v2', 'P1v3', 'P2v3', 'P3v3'])
param appServicePlanSkuCode string = 'P1v2'

@description('Azure Container Registry の SKU を選択してください')
@allowed(['Basic', 'Standard', 'Premium'])
param containerRegistrySkuName string = 'Basic'

// @description('Azure Database for MySQL の MySQL のバージョンを選択してください')
// @allowed(['5.7', '8.0'])
// param mySqlServerVersion string = '8.0'

// @description('Azure Database for MySQL の管理者ユーザー名を入力してください')
// param mySqlServerAdminLoginUserName string

// @description('Azure Database for MySQL の管理者パスワードを入力してください')
// @secure()
// param mySqlServerAdminLoginPassword string

var resourceGroupLocation = resourceGroup().location

resource registry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: 'cr${join(split(workloadName, '-'), '')}'
  location: resourceGroupLocation
  sku: {
    name: containerRegistrySkuName
  }
  properties: {
    adminUserEnabled: true
    networkRuleBypassOptions: 'AzureServices'
    zoneRedundancy: 'Disabled'
    anonymousPullEnabled: false
  }
}

var roleDefinitionIdAcrPull = resourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')

resource roleAssignmentContainerRegistry 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: registry
  name: guid(registry.id, roleDefinitionIdAcrPull, resourceId('Microsoft.Devices/IotHubs', webApp.name))
  properties: {
    roleDefinitionId: roleDefinitionIdAcrPull
    principalId: webApp.identity.principalId
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'plan-${workloadName}'
  location: resourceGroupLocation
  sku: {
    name: appServicePlanSkuCode
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'app-${workloadName}'
  location: resourceGroupLocation
  kind: 'app,linux,container'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    reserved: true
    vnetRouteAllEnabled: true
    vnetImagePullEnabled: true
    siteConfig: {
      linuxFxVersion: 'DOCKER|mcr.microsoft.com/appsvc/staticsite:latest'
      acrUseManagedIdentityCreds: true
      alwaysOn: true
      http20Enabled: true
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
      // appSettings: addMySql ? [
      //   {
      //     name: 'MYSQL_HOST'
      //     value: '${mySql.name}.mysql.database.azure.com'
      //   }
      //   {
      //     name: 'MYSQL_USER'
      //     value: mySqlServerAdminLoginUserName
      //   }
      //   {
      //     name: 'MYSQL_KEY'
      //     value: mySqlServerAdminLoginPassword
      //   }
      // ] : []
    }
    httpsOnly: true
  }
}
