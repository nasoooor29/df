#!/bin/bash

# Global error handler
error_handler() {
    echo -e "\033[31m$(basename $0) failed. Please fix the script.\033[0m"
    exit 1
}

trap error_handler ERR