#!/usr/bin/env bash

kubectl create secret docker-registry harbor-pull-secret \
  --docker-server=cr.utz.ru \
  --docker-username='username' \
  --docker-password='super-secret-password' \
  --namespace=balance-plus

kubectl create secret generic gitlab-runner-token \
  --from-literal=runner-token='glrt-secret' \
  --from-literal=runner-registration-token='' \
  --namespace=gitlab-runner
