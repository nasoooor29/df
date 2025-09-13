#!/bin/bash

# Colored logging functions
green() {
    echo -e "\033[32m$1\033[0m"
}

red() {
    echo -e "\033[31m$1\033[0m"
}

yellow() {
    echo -e "\033[33m$1\033[0m"
}

blue() {
    echo -e "\033[34m$1\033[0m"
}

# Global error handler
error_handler() {
    red "$(basename $0) failed. Please fix the script."
    exit 1
}

trap error_handler ERR