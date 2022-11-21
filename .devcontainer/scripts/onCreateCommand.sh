#!/bin/bash

if [ ${CODESPACES} = \"true\" ]; then
  REPO=$(echo $GITHUB_REPOSITORY | cut -d\"/\" -f2)

  pushd /workspaces/$REPO/app

  if [ ! -d "vendor" ]; then
    composer install
  fi

  if [ ! -f ".env" ]; then
    cp .env.example .env
  fi

  popd

fi
