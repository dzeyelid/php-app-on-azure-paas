# php-app-on-azure-paas
Microsoft Azure の PaaS を用いて PHPアプリケーションをホストするサンプルです。

## 環境

### アプリケーション構成

- PHP 8
- Laravel 9
- MySQL 8.0

### インフラストラクチャ

- [Azure Web Apps for containers](https://learn.microsoft.com/en-gb/azure/app-service/overview)
- [Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/)

Microsoft Azure でのリソース作成については、 [`iac`](./iac/) をご参照ください。

## 作業ログ

まずは Laravel の開発環境をインストールする

```bash
composer create-project laravel/laravel app
composer install
cp .env.example .env
php artisan key:generate
```

Laravel Sail を起動する

```bash
composer require laravel/sail --dev
php artisan sail:install
./vendor/bin/sail up
```

Azure Container Registry に Dockerイメージをプッシュする

```bash
AZURE_CONTAINER_REGISTRY_NAME=

CONTAINER_REGISTRY_SERVER=$(az acr show --name $AZURE_CONTAINER_REGISTRY_NAME | jq -r .loginServer)

COMMIT_HASH=$(git rev-parse HEAD)

# sail はあくまで開発用であり、少なくともコードのコピーを行っていないので、これ↓ではデプロイ後に動かない
docker tag sail-8.1/app:latest $CONTAINER_REGISTRY_SERVER/app:$COMMIT_HASH

az login
az acr login --name $AZURE_CONTAINER_REGISTRY_NAME
docker push $CONTAINER_REGISTRY_SERVER/app:$COMMIT_HASH

REGISTRY_CREDENCIAL=$(az acr credential show --name $AZURE_CONTAINER_REGISTRY_NAME)

REGISTRY_SERVER_USERNAME=$(echo $REGISTRY_CREDENCIAL | jq -r .username)
REGISTRY_SERVER_PASSWORD=$(echo $REGISTRY_CREDENCIAL | jq -r .passwords[0].value)
```

Azure Web App for containers の設定を更新する

```bash
AZURE_WEB_APP_NAME=
AZURE_RESOURCE_GROUP_NAME=

az webapp config container set --name $AZURE_WEB_APP_NAME --resource-group $AZURE_RESOURCE_GROUP_NAME --docker-custom-image-name $CONTAINER_REGISTRY_SERVER/app:$COMMIT_HASH
```