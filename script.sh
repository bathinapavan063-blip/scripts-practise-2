#!/bin/bash

################################################################################
# Java Installation Script for Linux EC2 Server
# Supports: Amazon Linux 2, Ubuntu, CentOS/RHEL
# Options: OpenJDK 8, 11, 17, 21
################################################################################

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
JAVA_VERSION=11
INSTALL_DIR="/usr/local/java"
VERBOSE=false

################################################################################
# Helper Functions
################################################################################

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

OPTIONS:
    -v, --version VERSION   Java version to install (8, 11, 17, 21)
                            Default: 11
    -d, --dir DIRECTORY     Installation directory
                            Default: /usr/local/java
    --verbose               Enable verbose output
    -h, --help              Show this help message

EXAMPLES:
    # Install Java 11 (default)
    sudo bash $0
    
    # Install Java 17
    sudo bash $0 -v 17
    
    # Install to custom directory
    sudo bash $0 -v 11 -d /opt/java

EOF
    exit 0
}

################################################################################
# Argument Parsing
################################################################################

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--version)
                JAVA_VERSION="$2"
                shift 2
                ;;
            -d|--dir)
                INSTALL_DIR="$2"
                shift 2
                ;;
            --verbose)
                VERBOSE=true
                shift
                ;;
            -h|--help)
                show_usage
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                ;;
        esac
    done
    
    # Validate Java version
    if [[ ! "$JAVA_VERSION" =~ ^(8|11|17|21)$ ]]; then
        print_error "Invalid Java version. Supported: 8, 11, 17, 21"
        exit 1
    fi
}

################################################################################
# System Detection
################################################################################

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        OS_VERSION=$VERSION_ID
    else
        print_error "Cannot detect OS"
        exit 1
    fi
    
    print_info "Detected OS: $OS (Version: $OS_VERSION)"
}

################################################################################
# Prerequisite Checks
################################################################################

check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "This script must be run as root"
        exit 1
    fi
}

check_java_installed() {
    if command -v java &> /dev/null; then
        EXISTING_VERSION=$(java -version 2>&1 | head -n 1)
        print_warning "Java is already installed: $EXISTING_VERSION"
        read -p "Continue with installation? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
}

################################################################################
# Installation Functions
################################################################################

install_amazon_linux_2() {
    print_header "Installing Java $JAVA_VERSION on Amazon Linux 2"
    
    print_info "Updating package manager..."
    yum update -y
    
    case $JAVA_VERSION in
        8)
            print_info "Installing OpenJDK 8..."
            yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
            ;;
        11)
            print_info "Installing OpenJDK 11..."
            yum install -y java-11-amazon-corretto java-11-amazon-corretto-devel
            ;;
        17)
            print_info "Installing OpenJDK 17..."
            yum install -y java-17-amazon-corretto java-17-amazon-corretto-devel
            ;;
        21)
            print_info "Installing OpenJDK 21..."
            yum install -y java-21-amazon-corretto java-21-amazon-corretto-devel
            ;;
    esac
}

install_ubuntu() {
    print_header "Installing Java $JAVA_VERSION on Ubuntu"
    
    print_info "Updating package manager..."
    apt-get update -y
    
    case $JAVA_VERSION in
        8)
            print_info "Installing OpenJDK 8..."
            apt-get install -y openjdk-8-jdk openjdk-8-jre
            ;;
        11)
            print_info "Installing OpenJDK 11..."
            apt-get install -y openjdk-11-jdk openjdk-11-jre
            ;;
        17)
            print_info "Installing OpenJDK 17..."
            apt-get install -y openjdk-17-jdk openjdk-17-jre
            ;;
        21)
            print_info "Installing OpenJDK 21..."
            apt-get install -y openjdk-21-jdk openjdk-21-jre
            ;;
    esac
}

install_centos_rhel() {
    print_header "Installing Java $JAVA_VERSION on CentOS/RHEL"
    
    print_info "Updating package manager..."
    yum update -y
    
    case $JAVA_VERSION in
        8)
            print_info "Installing OpenJDK 8..."
            yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
            ;;
        11)
            print_info "Installing OpenJDK 11..."
            yum install -y java-11-openjdk java-11-openjdk-devel
            ;;
        17)
            print_info "Installing OpenJDK 17..."
            yum install -y java-17-openjdk java-17-openjdk-devel
            ;;
        21)
            print_info "Installing OpenJDK 21..."
            yum install -y java-21-openjdk java-21-openjdk-devel
            ;;
    esac
}

################################################################################
# Post-Installation Configuration
################################################################################

verify_installation() {
    print_header "Verifying Installation"
    
    if command -v java &> /dev/null; then
        JAVA_VERSION_OUTPUT=$(java -version 2>&1)
        print_success "Java installed successfully!"
        echo -e "${GREEN}$JAVA_VERSION_OUTPUT${NC}"
    else
        print_error "Java installation verification failed"
        exit 1
    fi
    
    if command -v javac &> /dev/null; then
        print_success "Java compiler (javac) is available"
    else
        print_
