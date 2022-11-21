#!/bin/bash

pushd app

if [ ! -d "vendor" ]; then
  composer install
fi

if [ ! -f ".env" ]; then
  cp .env.example .env
fi

popd

