#!/bin/bash

# Verifica se o arquivo .env existe
if [ ! -f .env ]; then
  echo "Erro: Arquivo .env não encontrado."
  exit 1
fi

# Carrega as variáveis do .env
source .env

# Verifica se a variável SERVICE_PATH foi definida
if [ -z "$SERVICE_PATH" ]; then
  echo "Erro: Variável SERVICE_PATH não definida no .env"
  exit 1
fi

# Remove possíveis aspas extras e espaços da variável
SERVICE_PATH=$(echo "$SERVICE_PATH" | tr -d '"' | xargs)

echo "Usando SERVICE_PATH: $SERVICE_PATH"
echo

# Faz a requisição de criação de subscription
curl --location 'http://localhost:1026/v2/subscriptions/' \
--header 'Content-Type: application/json' \
--header 'fiware-service: openiot' \
--header "fiware-servicepath: $SERVICE_PATH" \
--data '{
  "description": "Notify Cygnus of all context changes",
  "subject": {
    "entities": [
      {
        "idPattern": ".*"
      }
    ]
  },
  "notification": {
    "http": {
      "url": "http://cygnus:5055/notify"
    }
  },
  "throttling": 5
}'
