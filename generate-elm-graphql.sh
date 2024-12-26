#!/bin/bash

# Function to check if the GraphQL server is ready
wait_for_server() {
    echo "Waiting for GraphQL server to be ready..."
    while true; do
        response=$(curl -s -X POST http://localhost:8080/graphql \
            -H "Content-Type: application/json" \
            -d '{"query": "{ __schema { types { name } } }"}' 2>/dev/null)
        
        if echo "$response" | grep -q '"data"'; then
            break
        fi
        echo "Server not ready yet, retrying in 1 second..."
        sleep 1
    done
    echo "GraphQL server is ready!"
}

# Wait for the server to be ready
wait_for_server

# Generate Elm code
elm-graphql http://localhost:8080/graphql --base Api --output src/elm/src 