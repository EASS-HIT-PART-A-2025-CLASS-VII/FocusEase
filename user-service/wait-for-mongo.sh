#!/bin/sh

# Wait for MongoDB to be ready using node script
until node -e "
const net = require('net');
const client = new net.Socket();
client.connect(27017, 'mongo-db', () => process.exit(0));
client.on('error', () => process.exit(1));
" 
do
  echo "Waiting for MongoDB connection..."
  sleep 2
done

# Start the application
npm install
npm run start
