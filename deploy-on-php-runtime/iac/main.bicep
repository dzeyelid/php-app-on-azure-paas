@description('リソース名に付与する識別用の文字列（プロジェクト名など）を入力してください')
param workloadName string

@description('Azure App Service Plan のプランを選択してください')
@allowed(['F1', 'B1', 'B2', 'B3', 'S1', 'S2', 'S3', 'P1v2', 'P2v2', 'P3v2', 'P1v3', 'P2v3', 'P3v3'])
param appServicePlanSkuCode string = 'P1v2'

var resourceGroupLocation = resourceGroup().location

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
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    reserved: true
    vnetRouteAllEnabled: true
    vnetImagePullEnabled: true
    siteConfig: {
      linuxFxVersion: 'PHP|8.1'
      acrUseManagedIdentityCreds: true
      alwaysOn: appServicePlanSkuCode != 'F1'
      appCommandLine: 'if [ -f /home/site/wwwroot/startUpCommand.sh ];then bash /home/site/wwwroot/startUpCommand.sh; fi'
      http20Enabled: true
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
    }
    httpsOnly: true
  }
}
