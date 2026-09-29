kubectl exec -n vault vault-0 -- env VAULT_ADDR=http://127.0.0.1:8200 vault status

kubectl exec -it -n vault vault-0 -- env VAULT_ADDR=http://127.0.0.1:8200 vault operator init

kubectl exec -it -n vault vault-0 -- env VAULT_ADDR=http://127.0.0.1:8200 vault operator unseal

kubectl exec -it -n vault vault-0 -- env VAULT_ADDR=http://127.0.0.1:8200 vault login
