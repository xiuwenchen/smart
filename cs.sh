#!/bin/bash

# Script to interact with smart contracts
# This script provides utilities for smart contract operations

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to get token input with validation
get_token_input() {
    local token=""
    local valid=false
    
    while [ "$valid" = false ]; do
        read -p "Enter your token: " token
        
        # Validate token (check if not empty)
        if [ -z "$token" ]; then
            echo -e "${RED}Error: Token cannot be empty${NC}"
        else
            # Basic token format validation (alphanumeric and common special chars)
            if [[ "$token" =~ ^[a-zA-Z0-9_\-\.]+$ ]]; then
                valid=true
            else
                echo -e "${RED}Error: Token contains invalid characters${NC}"
            fi
        fi
    done
    
    echo "$token"
}

# Function to validate configuration
validate_config() {
    local config_file="${1:-.env}"
    
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}Error: Configuration file not found: $config_file${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Configuration file validated${NC}"
    return 0
}

# Function to initialize smart contract interaction
init_contract() {
    local contract_address="${1}"
    local token="${2}"
    
    if [ -z "$contract_address" ] || [ -z "$token" ]; then
        echo -e "${RED}Error: Both contract address and token are required${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Initializing contract at: $contract_address${NC}"
    echo -e "${GREEN}Using token: ${token:0:10}...${NC}"
    return 0
}

# Main script logic
main() {
    echo -e "${YELLOW}Smart Contract Utility Script${NC}"
    
    # Get token input
    echo "Please provide your authentication token:"
    token=$(get_token_input)
    
    if [ -z "$token" ]; then
        echo -e "${RED}Error: Failed to obtain valid token${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Token received successfully${NC}"
    
    # Validate configuration
    if ! validate_config; then
        exit 1
    fi
    
    # Initialize contract
    contract_address="0x1234567890abcdef"
    if ! init_contract "$contract_address" "$token"; then
        exit 1
    fi
    
    echo -e "${GREEN}Script completed successfully${NC}"
}

# Run main function
main "$@"
