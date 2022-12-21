#!/bin/bash

mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.original
cp /home/site/wwwroot/server-config/default /etc/nginx/sites-available/default
service nginx reload

echo "StartUpCommand is finished."
