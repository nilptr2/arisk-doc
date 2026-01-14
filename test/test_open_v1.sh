#!/bin/bash

# Arisk Open V1 API Test Script
# Usage: ./test_open_v1.sh <YOUR_API_KEY>

API_KEY=$1
BASE_URL=http://127.0.0.1:8000

if [ -z "$API_KEY" ]; then
    echo "Usage: $0 <YOUR_API_KEY>"
    exit 1
fi

echo "Using API Key: $API_KEY"
echo "Base URL: $BASE_URL"
echo "-----------------------------------"

# Utility function for making requests
make_request() {
    local method=$1
    local endpoint=$2
    local data=$3
    
    echo "Testing $method $endpoint..."
    if [ "$method" == "GET" ]; then
        curl -s -X GET \
            --url "$BASE_URL$endpoint" \
            -H "X-API-Key: $API_KEY" | jq .
    else
        curl -s -X POST \
            --url "$BASE_URL$endpoint" \
            -H "X-API-Key: $API_KEY" \
            -H "Content-Type: application/json" \
            -d "$data" | jq .
    fi
    echo "-----------------------------------"
}

# 1. Monitor APIs
echo "Starting Monitor API tests..."

# Add Monitored Address
ADD_BODY='{"address": "0xd8da6bf26964af9d7eed9e03e53415d37aa96045", "chain": "eth", "token": "ETH"}'
make_request "POST" "/v1/monitor/address/add" "$ADD_BODY"

# List Monitored Addresses
make_request "GET" "/v1/monitor/address/list?status=-1&page=1&page_size=10"

# Update Status (Disable)
UPDATE_STATUS_BODY='{"address": "0xd8da6bf26964af9d7eed9e03e53415d37aa96045", "chain": "eth", "token": "ETH", "status": 0}'
make_request "POST" "/v1/monitor/address/status/update" "$UPDATE_STATUS_BODY"

# List Alerts
make_request "GET" "/v1/monitor/alerts?page=1&page_size=10"

# List Risk Change Alerts
make_request "GET" "/v1/monitor/risk-change-alerts?page=1&page_size=10"

# Get Default Config
make_request "GET" "/v1/monitor/config/default"

# Set Default Config (Example)
CONFIG_BODY='{
  "config": {
    "detection": {
      "known_risk": true,
      "normal_transaction": true,
      "risk_change": true
    },
    "notification": {
      "email": {
        "enabled": false,
        "recipients": []
      },
      "webhook": {
        "enabled": false,
        "urls": [],
        "auth_key": ""
      }
    }
  }
}'
make_request "POST" "/v1/monitor/config/default" "$CONFIG_BODY"

# 2. Query APIs
echo "Starting Query API tests..."

# Create Query Task
CREATE_QUERY_BODY='{"address": "0xd8da6bf26964af9d7eed9e03e53415d37aa96045", "chain": "ethereum", "token": "usdt"}'
echo "Creating query task..."
QUERY_RESPONSE=$(curl -s -X POST \
    --url "$BASE_URL/v1/query/create" \
    -H "X-API-Key: $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$CREATE_QUERY_BODY")
echo "$QUERY_RESPONSE" | jq .
QUERY_HASH=$(echo "$QUERY_RESPONSE" | jq -r '.query_hash')

if [ "$QUERY_HASH" != "null" ] && [ -n "$QUERY_HASH" ]; then
    echo "Query Hash: $QUERY_HASH"
    
    # Get Status
    make_request "GET" "/v1/query/status?query_hash=$QUERY_HASH"
    
    # Get Result (Might need to wait if not finished)
    make_request "GET" "/v1/query/result?query_hash=$QUERY_HASH"
else
    echo "Failed to create query task, skipping follow-up tests."
fi

# List Query Histories
make_request "GET" "/v1/query/histories?page=1&page_size=5"

# 3. Cleanup
echo "Cleaning up..."
REMOVE_BODY='{"address": "0xd8da6bf26964af9d7eed9e03e53415d37aa96045", "chain": "eth", "token": "ETH"}'
make_request "POST" "/v1/monitor/address/remove" "$REMOVE_BODY"

echo "Tests completed."
