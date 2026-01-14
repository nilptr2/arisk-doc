#!/bin/bash

# Arisk Open V2 API Test Script
# Usage: ./test_open_v2.sh <YOUR_API_KEY>

API_KEY=$1
BASE_URL=http://

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

# 1. Analysis APIs
echo "Starting Analysis API tests..."

# Create Analysis Task
CREATE_TASK_BODY='{
  "chain": "ethereum",
  "token": "usdt",
  "address": "0xd8da6bf26964af9d7eed9e03e53415d37aa96045",
  "count_limit": 100
}'
echo "Creating analysis task..."
TASK_RESPONSE=$(curl -s -X POST \
    --url "$BASE_URL/v2/analysis/tasks" \
    -H "X-API-Key: $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$CREATE_TASK_BODY")
echo "$TASK_RESPONSE" | jq .
TASK_ID=$(echo "$TASK_RESPONSE" | jq -r '.task_id')

if [ "$TASK_ID" != "null" ] && [ -n "$TASK_ID" ]; then
    echo "Task ID: $TASK_ID"
    
    # Get Status
    make_request "GET" "/v2/analysis/tasks/$TASK_ID/status"
    
    # Get Result
    make_request "GET" "/v2/analysis/tasks/$TASK_ID/result"
else
    echo "Failed to create analysis task, skipping follow-up tests."
fi

# List Analysis Tasks
make_request "GET" "/v2/analysis/tasks?page=1&page_size=10"


# 2. Monitor APIs
echo "Starting Monitor API tests..."

# Add Monitored Address
ADD_MONITOR_BODY='{
  "chain": "ethereum",
  "token": "usdt",
  "addresses": [
    {
      "address": "0xd8da6bf26964af9d7eed9e03e53415d37aa96045",
      "name": "Vitalik-V2-Test"
    }
  ]
}'
echo "Adding monitor address..."
MONITOR_ADD_RESPONSE=$(curl -s -X POST \
    --url "$BASE_URL/v2/monitor/addresses" \
    -H "X-API-Key: $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$ADD_MONITOR_BODY")
echo "$MONITOR_ADD_RESPONSE" | jq .

# Extract the first address_id for update test
ADDRESS_ID=$(echo "$MONITOR_ADD_RESPONSE" | jq -r '.addresses[0].address_id')

if [ "$ADDRESS_ID" != "null" ] && [ -n "$ " ]; then
    echo "Address ID: $ADDRESS_ID"
    
    # Update Monitor Address (Pause)
    UPDATE_BODY='{"status": 2}'
    make_request "POST" "/v2/monitor/addresses/$ADDRESS_ID" "$UPDATE_BODY"
    
    # List Alerts for this address
    make_request "GET" "/v2/monitor/alerts?address_id=$ADDRESS_ID&page=1&page_size=10"
else
    echo "Failed to add monitor address, skipping update/alert tests."
fi

# List Monitored Addresses
make_request "GET" "/v2/monitor/addresses?page=1&page_size=10"

# List All Alerts
make_request "GET" "/v2/monitor/alerts?page=1&page_size=10"


# 3. Cleanup
echo "Cleaning up..."
if [ "$ADDRESS_ID" != "null" ] && [ -n "$ADDRESS_ID" ]; then
    DELETE_BODY="{\"address_ids\": [\"$ADDRESS_ID\"]}"
    make_request "POST" "/v2/monitor/addresses/delete" "$DELETE_BODY"
fi

echo "Tests completed."
