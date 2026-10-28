{{/* Build DATABASE_URL, leaving the password for ESO to render from Vault. */}}
{{- define "turbo-gant-bootstrap.databaseUrl" -}}
{{- $username := .Values.config.POSTGRES_USER | urlquery | replace "+" "%20" -}}
{{- $password := `{{ .POSTGRES_PASSWORD | urlquery | replace "+" "%20" }}` -}}
{{- $database := .Values.config.POSTGRES_DB | urlquery | replace "+" "%20" -}}
{{- printf "postgresql+psycopg2://%s:%s@%s:%v/%s" $username $password .Values.database.host .Values.database.port $database -}}
{{- end -}}
