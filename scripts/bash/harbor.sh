#!/usr/bin/env bash

kubectl create secret docker-registry harbor-pull-secret \
  --docker-server=cr.utz.ru \
  --docker-username='username' \
  --docker-password='super-secret-password' \
  --namespace=balance-plus
