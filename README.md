# php-app-on-azure-paas
Microsoft Azure の PaaS を用いて PHPアプリケーションをホストするサンプルです。

## 環境

### アプリケーション

- PHP 8
- Laravel 9

### インフラストラクチャ

- [Azure Web Apps for containers](https://learn.microsoft.com/en-gb/azure/app-service/overview)
- [Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/)

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
