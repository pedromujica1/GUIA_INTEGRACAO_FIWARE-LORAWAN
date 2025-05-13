#!/bin/sh

curl --location --request POST 'http://localhost:4041/iot/devices' \
--header 'fiware-service: openiot' \
--header 'fiware-servicepath: /'"$SERVICE_PATH"'' \
--header 'Content-Type: application/json' \
--data-raw '{
    "devices": [
        {
            "device_id": "tbeam-v1",
            "entity_name": "PaxCounter",
            "entity_type": "LoraDevice",
            "attributes": [
                { "object_id": "field1", "name": "Field1", "type": "Number" },
                { "object_id": "field2", "name": "Field2", "type": "Number" },
                { "object_id": "field3", "name": "Field3", "type": "Number" }
            ],
            "internal_attributes": {
                "lorawan": {
                    "application_server": {
                        "host": "",
                        "username": "",
                        "password": "",
                        "provider": "TTN"
                    },
                    "app_eui": "",
                    "dev_eui": "",
                    "application_id": "",
                    "application_key": "",
                    "data_model": "application_server"
                }
            }
        }
    ]
}'
