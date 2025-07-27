# Requisições HTTP/Tutorias importantes

## Para deletar dispositivo TTN do Banco de dados MongoDB
```bash
docker exec -it <id_container_mongodb> mongo
```
### No Shel do MongoDb

```bash
show dbs
```
```bash
use iotagentlora
```
```bash
show collections
```
Resulta na seguinte saída
```console
devices
groups
```
### Para ver os dispositivos
```bash
db.devices.find().pretty()
```
### Para deletar uma coleção
```bash
db.<nome_da_collection>.drop()
```
### Para deletar dispositivo
```bash
db.devices.deleteOne({ device_id: "env2" })
```
### Busca por device ID
Você pode buscar por um campo específico, como device_id:
```bash
db.devices.find({ device_id: "tbeam-v1" }).pretty()
```

## 📋 Consultas e Ações no Orion Context Broker

### 🔍 Listar todas as entidades no Context Broker

Mostra todos os dispositivos e sensores registrados no Orion Context Broker para um dado serviço e caminho:

```bash
curl localhost:1026/v2/entities/ \
  -s -S \
  -H 'Accept: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /airQuality' \
  | python3 -mjson.tool


curl localhost:1026/v2/entities/SensorCvel \
  -s -S \
  -H 'Accept: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /airQuality' \
  | python3 -mjson.tool
```
### ❌ Deletar uma entidade do Context Broker

Remove uma entidade específica do Orion. Substitua <ID_ENTIDADE> pelo ID real da entidade que deseja remover:
```bash
curl -X DELETE \
  'http://localhost:1026/v2/entities/<ID_ENTIDADE>' \
  -s -S \
  -H 'Accept: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /airQuality'
```

### 🕵️ Verificar o último dado recebido por uma entidade
Consulta o estado atual de uma entidade específica, útil para verificar se o dado do sensor foi recebido:
```bash
curl localhost:1026/v2/entities/SensorQualidadeAr_Londrina \
  -s -S \
  -H 'Accept: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /airQuality' \
  | python3 -mjson.tool


curl localhost:1026/v2/entities/SensorCvel \
  -s -S \
  -H 'Accept: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /airQuality' \
```
## 📡 Consultas no IoT Agent

### 📦 Listar todos os dispositivos provisionados
Retorna a lista de sensores e atuadores registrados no IoT Agent. Isso mostra o mapeamento entre os dispositivos físicos e as entidades no Orion:
```bash
curl --location 'http://localhost:4041/iot/devices' \
  --header 'fiware-service: openiot' \
  --header 'fiware-servicepath: /'
```
```bash
curl -X DELETE 'http://localhost:4041/iot/devices/env2'   --header 'fiware-service: openiot'   --header 'fiware-servicepath: /airQuality'
```

## 🧹 Recuperação do Orion Context Broker
Se o Orion Context Broker não estiver iniciando corretamente, pode haver conflitos de rede ou containers corrompidos. Tente os seguintes comandos para "resetar" o ambiente Docker:
```bash
# Remove containers parados
sudo docker container prune -f

# Remove redes não utilizadas
sudo docker network prune -f

# Força recriação dos containers
sudo docker compose up -d --force-recreate
```

## Comandos SQL

### Testar cliente SQL
```sh
docker exec -it db-postgres psql -U postgres -d postgres
```


### Comandos SQL para verificar seus dados

```SQL
SELECT table_schema,table_name
FROM information_schema.tables
WHERE table_schema ='openiot'
ORDER BY table_schema,table_name;

SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'openiot' AND table_name = 'airquality_paxcounter_loradevice';
```
### Requisição para limitar output
```SQL
SELECT * FROM openiot.airquality_paxcounter_loradevice limit 10;
```

### Comando SQL para gerar gráfico Grafana
```SQL
SELECT 
    recvtime::timestamp AS "time",   
    attrvalue::numeric AS "Number"  
FROM 
    openiot.airquality_paxcounter_loradevice
WHERE 
    attrtype = 'Number'        
    AND attrvalue::numeric = 0;
```
### Verificar CO_Corrigido

```SQL

SELECT recvtime, attrvalue
FROM openiot.airquality_sensorcvel_loradevice
WHERE attrname = 'CO_Corrigido'
ORDER BY recvtime DESC
LIMIT 10;

```

