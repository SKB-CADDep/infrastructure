#!/usr/bin/env bash

vault kv put -mount=secret apps/balance-plus/dev/valve-stems/database username=valve password='Super-Secret-Password'

vault kv put -mount=secret apps/balance-plus/dev/condenser-calculator/database username=condenser password='Super-Secret-Password'

vault kv put -mount=secret apps/balance-plus/shared/harbor/pull username='username' password='Super-Secret-Password'

vault kv put -mount=secret apps/balance-plus/shared/gitlab token='Secret-Token'

vault kv put -mount=secret apps/turbo-gant/dev/database POSTGRES_PASSWORD='secret' ADMIN_PASSWORD='secret' SECRET_KEY='secret'
