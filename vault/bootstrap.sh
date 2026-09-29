#!/usr/bin/env bash

set -euo pipefail

VAULT_NAMESPACE="vault"
VAULT_POD="vault-0"
VAULT_ADDR="http://127.0.0.1:8200"

VAULT_AUTH_PATH="kubernetes"
VAULT_POLICY="external-secrets"
VAULT_ROLE="external-secrets"

ESO_SERVICE_ACCOUNT="external-secrets"
ESO_NAMESPACE="external-secrets"

POLICY_FILE="external-secrets.hcl"

vault_exec() {
  kubectl exec \
    -n "${VAULT_NAMESPACE}" \
    "${VAULT_POD}" \
    -- env VAULT_ADDR="${VAULT_ADDR}" vault "$@"
}

echo "==> Checking Vault status"

vault_exec status

echo "==> Checking KV v2 secrets engine"

if ! vault_exec secrets list | grep -q '^secret/'; then
  echo "Creating KV v2 secrets engine: secret/"

  vault_exec secrets enable \
    -path=secret \
    kv-v2
else
  echo "KV secrets engine secret/ already exists"
fi

echo "==> Checking Kubernetes authentication method"

if ! vault_exec auth list | grep -q '^kubernetes/'; then
  echo "Enabling Kubernetes authentication"

  vault_exec auth enable kubernetes
else
  echo "Kubernetes authentication already enabled"
fi

echo "==> Configuring Kubernetes authentication"

kubectl exec \
  -n "${VAULT_NAMESPACE}" \
  "${VAULT_POD}" \
  -- sh -c \
  'VAULT_ADDR=http://127.0.0.1:8200 \
   vault write auth/kubernetes/config \
   kubernetes_host="https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}"'

echo "==> Applying Vault policy: ${VAULT_POLICY}"

kubectl exec \
  -i \
  -n "${VAULT_NAMESPACE}" \
  "${VAULT_POD}" \
  -- env VAULT_ADDR="${VAULT_ADDR}" \
  vault policy write "${VAULT_POLICY}" - \
  < "${POLICY_FILE}"

echo "==> Creating/updating Kubernetes auth role: ${VAULT_ROLE}"

vault_exec write \
  "auth/${VAULT_AUTH_PATH}/role/${VAULT_ROLE}" \
  bound_service_account_names="${ESO_SERVICE_ACCOUNT}" \
  bound_service_account_namespaces="${ESO_NAMESPACE}" \
  audience="vault" \
  token_policies="${VAULT_POLICY}" \
  token_ttl="1h"

echo "==> Vault bootstrap completed"
