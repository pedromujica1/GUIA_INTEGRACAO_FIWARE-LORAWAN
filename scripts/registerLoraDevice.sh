#!/bin/bash

# Verifica se o arquivo .env existe
if [ ! -f .env ]; then
    echo "Erro: Arquivo .env não encontrado."
    echo "Crie um arquivo .env baseado no .env.template e preencha com suas credenciais."
    exit 1
fi

# Carrega as variáveis do .env
source .env

# Verifica variáveis obrigatórias
if [ -z "$DEVICE_ID" ] || [ -z "$APP_EUI" ] || [ -z "$DEV_EUI" ] || [ -z "$APPLICATION_ID" ] || [ -z "$APPLICATION_KEY" ]; then
    echo "Erro: Variáveis obrigatórias não definidas no .env"
    exit 1
fi

# Verifica se SERVICE_PATH está definido
if [ -z "$SERVICE_PATH" ]; then
    echo "Erro: Variável SERVICE_PATH não definida no .env"
    exit 1
fi

# Faz a requisição POST para o FIWARE
echo "Registrando dispositivo $DEVICE_ID no FIWARE..."
echo

response=$(curl --silent --write-out "HTTPSTATUS:%{http_code}" \
--location --request POST 'http://localhost:4041/iot/devices' \
--header 'fiware-service: openiot' \
--header "fiware-servicepath: $SERVICE_PATH" \
--header 'Content-Type: application/json' \
--data-raw '{
    "devices": [
        {
            "device_id": "'"$DEVICE_ID"'",
            "entity_name": "'"$ENTITY_NAME"'",
            "entity_type": "LoraDevice",
            "attributes": [
                { "object_id": "best_co", "name": "Best_CO", "type": "Float"},
                { "object_id": "best_no2", "name": "Best_NO2", "type": "Float"},
                { "object_id": "best_ox", "name": "Best_OX", "type": "Float"},
                { "object_id": "best_so2", "name": "Best_SO2", "type": "Float"},
                { "object_id": "co_1", "name": "CO_1", "type": "Float"},
                { "object_id": "co_2", "name": "CO_2", "type": "Float"},
                { "object_id": "co_3", "name": "CO_3", "type": "Float"},
                { "object_id": "co_4", "name": "CO_4", "type": "Float"},
                { "object_id": "co_ae", "name": "CO_AE", "type": "Float"},
                { "object_id": "co_we", "name": "CO_WE", "type": "Float"},
                { "object_id": "no2_1", "name": "NO2_1", "type": "Float"},
                { "object_id": "no2_2", "name": "NO2_2", "type": "Float"},
                { "object_id": "no2_3", "name": "NO2_3", "type": "Float"},
                { "object_id": "no2_4", "name": "NO2_4", "type": "Float"},
                { "object_id": "no2_ae", "name": "NO2_AE", "type": "Float"},
                { "object_id": "no2_we", "name": "NO2_WE", "type": "Float"},
                { "object_id": "ox_1", "name": "OX_1", "type": "Float"},
                { "object_id": "ox_2", "name": "OX_2", "type": "Float"},
                { "object_id": "ox_3", "name": "OX_3", "type": "Float"},
                { "object_id": "ox_4", "name": "OX_4", "type": "Float"},
                { "object_id": "ox_ae", "name": "OX_AE", "type": "Float"},
                { "object_id": "ox_we", "name": "OX_WE", "type": "Float"},
                { "object_id": "so2_1", "name": "SO2_1", "type": "Float"},
                { "object_id": "so2_2", "name": "SO2_2", "type": "Float"},
                { "object_id": "so2_3", "name": "SO2_3", "type": "Float"},
                { "object_id": "so2_4", "name": "SO2_4", "type": "Float"},
                { "object_id": "so2_ae", "name": "SO2_AE", "type": "Float"},
                { "object_id": "so2_we", "name": "SO2_WE", "type": "Float"},
                { "object_id": "Temperatura", "name": "Temperatura", "type": "Float"},
                { "object_id": "Umidade", "name": "Umidade", "type": "Float"},
                { "object_id": "data", "name": "DATA", "type": "Text"},
                { "object_id": "hora", "name": "HORA", "type": "Text"}
            ],
            "internal_attributes": {
                "lorawan": {
                    "application_server": {
                        "host": "'"$APP_SERVER_HOST"'",
                        "username": "'"$APP_SERVER_USERNAME"'",
                        "password": "'"$APP_SERVER_PASSWORD"'",
                        "provider": "TTN"
                    },
                    "app_eui": "'"$APP_EUI"'",
                    "dev_eui": "'"$DEV_EUI"'",
                    "application_id": "'"$APPLICATION_ID"'",
                    "application_key": "'"$APPLICATION_KEY"'",
                    "data_model": "'"$DATA_MODEL"'"
                }
            }
        }
    ]
}')

# Extrai resposta e código de status
body=$(echo "$response" | sed -e 's/HTTPSTATUS\:.*//g')
status=$(echo "$response" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

if [ "$status" -ne 201 ]; then
    echo "Erro ao registrar dispositivo: HTTP $status"
    echo "Resposta do servidor:"
    echo "$body"
    exit 1
else
    echo "Dispositivo registrado com sucesso!"
fi
