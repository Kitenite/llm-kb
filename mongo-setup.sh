#!/bin/bash
source .env

echo "sleeping for 5 seconds"
sleep 5

echo mongo_setup.sh time now: `date +"%T" `
mongosh --host mongodb:${CONTAINER_MONGO_PORT} --authenticationDatabase admin --username ${MONGO_INITDB_ROOT_USERNAME} --password ${MONGO_INITDB_ROOT_PASSWORD} <<EOF
  var cfg = {
    "_id": "${MONGO_REPLICA_SET_NAME}",
    "version": 1,
    "members": [
      {
        "_id": 0,
        "host": "mongodb:${CONTAINER_MONGO_PORT}",
        "priority": 1
      }
    ]
  };
  rs.initiate(cfg);
EOF

echo "Mongo replica set initiated"