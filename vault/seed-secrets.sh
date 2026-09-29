#!/usr/bin/env bash

set -euo pipefail

VAULT_NAMESPACE="vault"
VAULT_POD="vault-0"
VAULT_CONTAINER="vault"
VAULT_ADDR="http://127.0.0.1:8200"
VAULT_MOUNT="secret"

vault_exec() {
  kubectl exec \
    -n "${VAULT_NAMESPACE}" \
    "${VAULT_POD}" \
    -c "${VAULT_CONTAINER}" \
    -- env VAULT_ADDR="${VAULT_ADDR}" vault "$@"
}

echo "==> Checking Vault status"

vault_exec status

echo
echo "==> Creating PostgreSQL secret"

read -rsp "PostgreSQL password: " POSTGRES_PASSWORD
echo

printf '%s' "${POSTGRES_PASSWORD}" |
  kubectl exec \
    -i \
    -n "${VAULT_NAMESPACE}" \
    "${VAULT_POD}" \
    -c "${VAULT_CONTAINER}" \
    -- env VAULT_ADDR="${VAULT_ADDR}" \
    vault kv put \
      -cas=0 \
      -mount="${VAULT_MOUNT}" \
      infra/postgres \
      password=-

unset POSTGRES_PASSWORD

echo
echo "==> Creating Redis secret"

read -rsp "Redis password: " REDIS_PASSWORD
echo

printf '%s' "${REDIS_PASSWORD}" |
  kubectl exec \
    -i \
    -n "${VAULT_NAMESPACE}" \
    "${VAULT_POD}" \
    -c "${VAULT_CONTAINER}" \
    -- env VAULT_ADDR="${VAULT_ADDR}" \
    vault kv put \
      -cas=0 \
      -mount="${VAULT_MOUNT}" \
      infra/redis \
      password=-

unset REDIS_PASSWORD

echo
echo "==> Secrets successfully created"

echo
echo "Vault paths:"
echo "  secret/infra/postgres"
echo "  secret/infra/redis"
