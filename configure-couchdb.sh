#!/bin/sh
couchdb -b
sleep 5
curl -X PUT http://localhost:5984/registry
cd /tmp/npmjs.org
npm start \
  --npm-registry-couchapp:couch=http://localhost:5984/registry
npm run load \
  --npm-registry-couchapp:couch=http://localhost:5984/registry
npm run copy \
  --npm-registry-couchapp:couch=http://localhost:5984/registry
sleep 5
