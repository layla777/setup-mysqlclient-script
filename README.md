# MySQL Client Setup Script () `mclient.sh`
**Current Version:** v0.9.0

[](LICENSE)
This script automates the setup of MySQL client-related environment variables and the installation of the Python `mysqlclient` package on macOS. It ensures seamless integration with Homebrew-installed MySQL versions and streamlines the otherwise tedious manual steps.
## Features
- **Multi-architecture support**: Works with both Apple Silicon (M1/M2) and Intel-based macOS systems.
- **Automatic environment setup**: Sets all necessary environment variables (e.g., `PATH`, `CFLAGS`, `LDFLAGS`) to ensure `mysqlclient` works properly.
- **Version flexibility**: Supports multiple MySQL versions (default: `mysql@8.0`).
- **Project-specific installations**: Automatically reads `mysqlclient` version from a `requirements.txt` file if present in the execution directory.
- **Convenient error handling**: Provides clear instructions if dependencies are missing.

## Requirements
Before using this script, ensure the following:
1. **macOS Environment**
   For now, this script is tailored for macOS (Apple Silicon and Intel).
2. **Homebrew Installed**
   MySQL must be installed via Homebrew. Example: `brew install mysql@8.0`.
3. **Python and pip Installed**
   Ensure Python (3.x recommended) and are installed. `pip`
4. **Optional**: A valid `requirements.txt` file
   If present, the script will use the defined `mysqlclient` version for installation.

## Installation
Place the script in a directory included in your `PATH`, such as `/usr/local/bin`:
``` 
mv mclient.sh /usr/local/bin/mclient  
chmod +x /usr/local/bin/mclient  
```
## Usage
Run the script with or without specifying a MySQL version:
### Example 1: Using the default MySQL version (`mysql@8.0`)
``` 
mclient  
```
### Example 2: Specifying a MySQL version
``` 
mclient mysql@8.4  
```
### Example 3: Checking the help menu
``` 
mclient --help  
```
## How It Works
1. **Environment Detection**
   Detects your system's architecture (Apple Silicon or Intel) and initializes the correct paths for MySQL.
2. **Environment Variable Configuration**
   Sets mandatory variables like `CFLAGS`, `LDFLAGS`, etc., required for building `mysqlclient`.
3. **mysqlclient Package Setup**
   Uninstalls any pre-existing `mysqlclient` version and installs the necessary version, optionally reading from your `requirements.txt`.
4. **Error Checking**
   Validates installed dependencies (e.g., `pkg-config` and ) and provides resolution steps if issues arise. `pip`

## Contribution
Found a bug? Have an idea for improvement?
Feel free to open an [issue](https://github.com/your-repo-link/issues) or create a [pull request](https://github.com/your-repo-link/pulls).
## License
This project is licensed under the [MIT License](LICENSE).
