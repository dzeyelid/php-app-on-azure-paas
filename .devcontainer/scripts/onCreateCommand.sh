#!/bin/bash

sudo sed -i -e 's/\(^\(xdebug.start_with_reques\).*=.*yes\)/; \1\n\2 = no/g' /usr/local/etc/php/conf.d/xdebug.ini

if [ ${CODESPACES} = "true" ]; then
  REPO=$(echo $GITHUB_REPOSITORY | cut -d"/" -f2)
  APP_DIR="/workspaces/$REPO/app"

  pushd $APP_DIR

  if [ ! -d "vendor" ]; then
    composer install
  fi

  if [ ! -f ".env" ]; then
    cp .env.example .env
  fi

  popd

fi
