# Microsoft Azure のリソースデプロイ

## 利用するリソース

- Azure Container Registry
- Azure App Service Plan
- Azure Web Apps for containers
- (Optional) Azure Database for mySQL

※ Deploy to Azure ボタンを設置予定

## デバッグ

### Azure CLI によるデプロイ

```bash
WORKLOAD_NAME="{string to identify your resources}"
RESOURCE_GROUP_NAME="rg-${WORKLOAD_NAME}"
LOCATION="{location that resources are deploy}"
az login
az group create --name ${RESOURCE_GROUP_NAME} --location ${LOCATION}
az deployment group create --resource-group ${RESOURCE_GROUP_NAME} --template-file main.bicep
```

### Bicep によるARMテンプレート生成

```bash
az bicep build --file main.bicep --outdir .
```