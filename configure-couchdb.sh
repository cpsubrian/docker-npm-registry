#!/bin/sh

couchdb -b
sleep 5
curl -X PUT http://localhost:5984/registry
couchapp push registry/app.js http://localhost:5984/registry
couchapp push www/app.js http://localhost:5984/registry
couchdb -d
