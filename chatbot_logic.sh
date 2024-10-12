#!/bin/bash

# File path to the stock data JSON file
STOCK_DATA_FILE="stock_data.json"

# Function to display the home menu with stock exchange options
home_menu() {
    echo "Please select a Stock Exchange:"
    echo "1. LSEG"
    echo "2. NASDAQ"
    echo "3. NYSE"
    echo "4. Exit"
}

# Function to display stock options for a selected exchange
stock_menu() {
    local exchange=$1

    echo "Select a stock from $exchange:"

    # Use jq to extract stock names and prices from JSON
    jq -r ".${exchange}[] | \"\(.name) - \$\(.price)\"" "$STOCK_DATA_FILE"

    echo "Enter the stock number (1-5) to view the price or 6 to go back to Home Menu:"
}

# Function to get stock details for a selected stock
get_stock_price() {
    local exchange=$1
    local stock_index=$2

    # Use jq to extract stock price
    stock_name=$(jq -r ".${exchange}[$stock_index].name" "$STOCK_DATA_FILE")
    stock_price=$(jq -r ".${exchange}[$stock_index].price" "$STOCK_DATA_FILE")
    echo "The current price of $stock_name is \$${stock_price}"
}

# Main Chatbot Logic
while true; do
    home_menu
    read -p "Enter your choice: " exchange_choice

    case $exchange_choice in
        1)
            exchange="LSEG"
            ;;
        2)
            exchange="NASDAQ"
            ;;
        3)
            exchange="NYSE"
            ;;
        4)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice! Please select a valid option."
            continue
            ;;
    esac

    while true; do
        stock_menu "$exchange"
        read -p "Enter your choice: " stock_choice

        if [[ $stock_choice -ge 1 && $stock_choice -le 5 ]]; then
            get_stock_price "$exchange" $((stock_choice - 1))
        elif [[ $stock_choice -eq 6 ]]; then
            break
        else
            echo "Invalid choice! Please select a valid option."
        fi
    done
done
