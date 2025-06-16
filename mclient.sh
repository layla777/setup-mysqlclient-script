#!/bin/bash

# ================================
# MySQL Client Download and Setup Script
# ================================
# [Overview]
# This script automates the setup of the environment to use the MySQL client
# and installs the Python package "mysqlclient" on macOS (Apple Silicon and Intel Mac).
#
# [Prerequisites]
# 1. Homebrew must be installed.
# 2. MySQL (customizable version, default is 8.0) must be installed via Homebrew:
#   - Apple Silicon: /opt/homebrew/opt/mysql@xxx
#   - Intel Mac:  /usr/local/opt/mysql@xxx
# 3. Python and pip must be installed.
# 4. (Optional) If `requirements.txt` exists in the same directory, it will install the version of `mysqlclient` specified in the file.
#
# [Usage]
# 1. Specify the version explicitly:
#    mclient mysql@8.4
#    If not specified, the default version `mysql@8.0` is used.
# 2. To view detailed help options:
#    mclient --help
# ================================

# --- Argument check ---
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: bash setup_mysqlclient.sh [MySQL version]"
  echo ""
  echo "Options:"
  echo " -h, --help  Show this help message and exit"
  echo ""
  echo "Details:"
  echo " This script sets up the MySQL client library and installs the Python 'mysqlclient' package."
  echo " Default MySQL version: mysql@8.0"
  exit 0
fi

# --- MySQL version setup (default: mysql@8.0) ---
MYSQL_VERSION=${1:-mysql@8.0}

# ================================
# Compatible with Apple Silicon and Intel Mac
# ================================
echo "Detecting system architecture..."
if [[ $(uname -m) == "arm64" ]]; then
  # Apple Silicon (M1/M2)
  MYSQL_PATH="/opt/homebrew/opt/${MYSQL_VERSION}"
  echo " Detected Apple Silicon (arm64). Using path: $MYSQL_PATH"
else
  # Intel Mac
  MYSQL_PATH="/usr/local/opt/${MYSQL_VERSION}"
  echo " Detected Intel Mac (x86_64). Using path: $MYSQL_PATH"
fi

# --- Environment variable setup ---
echo "Setting up MySQL environment variables..."
export PATH="${MYSQL_PATH}/bin:$PATH"
export CFLAGS="-I${MYSQL_PATH}/include/mysql"
export LDFLAGS="-L${MYSQL_PATH}/lib"
export PKG_CONFIG_PATH="${MYSQL_PATH}/lib/pkgconfig"
export DYLD_LIBRARY_PATH="${MYSQL_PATH}/lib:${DYLD_LIBRARY_PATH}"

# Log for confirmation
echo "Environment variables set:"
echo " PATH: $PATH"
echo " CFLAGS: $CFLAGS"
echo " LDFLAGS: $LDFLAGS"
echo " PKG_CONFIG_PATH: $PKG_CONFIG_PATH"
echo " DYLD_LIBRARY_PATH: $DYLD_LIBRARY_PATH"
echo "-----------------------------------"

# --- Error handling function ---
function handle_error {
  echo "[ERROR] $1"
  echo "Resolution:"
  echo " - Apple Silicon (arm64): brew install ${MYSQL_VERSION} --build-from-source"
  echo " - Intel Mac (x86_64):  brew install ${MYSQL_VERSION}"
  exit 1
}

# --- Check required files (MySQL headers) ---
echo "Checking for required MySQL header files..."
if [ ! -f "${MYSQL_PATH}/include/mysql/mysql.h" ]; then
  handle_error "Missing MySQL header file (mysql.h). Please install MySQL via Homebrew."
fi

# --- Check for required commands ---
echo "Checking for required commands (pkg-config, pip)..."
if ! command -v pkg-config &>/dev/null; then
  handle_error "Missing pkg-config. Please install it via Homebrew (brew install pkg-config)."
fi
if ! command -v pip &>/dev/null; then
  handle_error "Missing pip. Please install the Python package manager."
fi

# --- Verify operation with pkg-config ---
echo "Checking MySQL client configuration via pkg-config..."
pkg-config --cflags mysqlclient || handle_error "Failed to validate MySQL client with pkg-config."
pkg-config --libs mysqlclient || handle_error "Failed to validate MySQL client libraries with pkg-config."

# --- Check requirements.txt ---
REQUIREMENTS_FILE="./requirements.txt"
MYSQLCLIENT_VERSION=""
if [ -f "$REQUIREMENTS_FILE" ]; then
  echo "Checking requirements.txt for mysqlclient version..."
  MYSQLCLIENT_VERSION=$(grep -E '^mysqlclient[<>=!~]*' "$REQUIREMENTS_FILE" | head -n 1 | tr -d '[:space:]')
  if [ -n "$MYSQLCLIENT_VERSION" ]; then
    echo " Found specified version: $MYSQLCLIENT_VERSION"
  else
    echo " No specific mysqlclient version found in requirements.txt. Installing latest version..."
  fi
else
 echo "requirements.txt not found. Installing latest mysqlclient version..."
fi

# --- Uninstall existing package ---
echo "Uninstalling existing mysqlclient package..."
pip uninstall -y mysqlclient &>/dev/null && echo " Uninstall complete." || echo " mysqlclient not installed, skipping."

# --- Install mysqlclient ---
if [ -n "$MYSQLCLIENT_VERSION" ]; then
  echo "Installing specified version: $MYSQLCLIENT_VERSION via pip..."
  pip install "$MYSQLCLIENT_VERSION" --no-cache && echo ":white_check_mark: Installation successful!" || handle_error "Failed to install $MYSQLCLIENT_VERSION."
else
  echo "Installing latest version of mysqlclient via pip..."
  pip install mysqlclient --force-reinstall --no-cache && echo ":white_check_mark: Installation successful!" || handle_error "Failed to install mysqlclient."
fi

# --- Final confirmation ---
pip show mysqlclient &>/dev/null && echo ":white_check_mark: mysqlclient installation confirmed." || handle_error "Failed to validate mysqlclient installation."