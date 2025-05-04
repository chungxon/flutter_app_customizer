#!/bin/bash
set -e

red=$(tput setaf 1)
green=$(tput setaf 2)
none=$(tput sgr0)

# Get working directory of the script
cd "$(dirname "$0")"
SCRIPT_DIR=$(pwd)
# echo "Current directory: ${SCRIPT_DIR}"

# Define configuration file
CONFIG_FILE="${SCRIPT_DIR}/configs.props"

# Define `load_properties` file path
LOAD_PROPERTIES="${SCRIPT_DIR}/load_properties.sh"

# Download load_properties script if not exist
if [ ! -f "${LOAD_PROPERTIES}" ]; then
    curl -s https://raw.githubusercontent.com/chungxon/load_properties/refs/heads/master/scripts/load_properties.sh -o ${LOAD_PROPERTIES}
    echo "Load properties file downloaded: ${LOAD_PROPERTIES}"
fi

# Source the load_properties script
source ${LOAD_PROPERTIES}

# Load properties
loadProperties ${CONFIG_FILE}

# Define `overrides` directory
OVERRIDES_DIR="${SCRIPT_DIR}/overrides"
# echo "Overrides directory: ${OVERRIDES_DIR}"

# Define root directory of the project
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
echo "Project directory: ${PROJECT_DIR}"

# Override all files and folders in `overrides` folder with the ones in
# `project` folder if they exist
if [ -d "${OVERRIDES_DIR}" ]; then
    echo "Copying "${OVERRIDES_DIR}" to project..."
    cp -Rf "${OVERRIDES_DIR}/" "${PROJECT_DIR}/"
    echo "Overriding done!"
fi

# Navigate to project folder
cd "${PROJECT_DIR}"

# Install the latest `flutter_launcher_icons` package to generate app icons
dart pub remove flutter_launcher_icons
dart pub add dev:flutter_launcher_icons
flutter pub get

# Generating app icons
dart run flutter_launcher_icons -f ${SCRIPT_DIR}/flutter_launcher_icons.yaml

#------------------------------------------------------------------------------------------#
# # Install `rename_app` package to rename app
# flutter pub add dev:rename_app
# flutter pub get

# # Rename app
# dart run rename_app:main all="${appName}" # android="Android Name" ios="IOS Name" web="Web Name" mac="Mac Name" windows="Windows Name" linux="Linux Name" others="Others Name"
#------------------------------------------------------------------------------------------#

#------------------------------------------------------------------------------------------#
# Install `change_app_package_name` package to change app package name
flutter pub add dev:change_app_package_name
flutter pub get

# Change package name
dart run change_app_package_name:main ${iosBundleId} --ios
dart run change_app_package_name:main ${androidPackageName} --android
#------------------------------------------------------------------------------------------#

#------------------------------------------------------------------------------------------#
# Install `rename` package to rename app and change bundle ID
flutter pub global activate rename
flutter pub get

# Rename app using `rename`
rename setAppName --targets ios,android --value "${appName}" # --targets ios,android,macos,windows,linux,web

# # Change bundle ID (Not working as expected due to Extension problem - https://github.com/onatcipli/rename/issues/46)
# rename setBundleId --targets ios --value ${iosBundleId}
# rename setBundleId --targets android --value ${androidPackageName}
#------------------------------------------------------------------------------------------#

# Clean up
# rm ${LOAD_PROPERTIES}

# Print success message
# Adjusting the output for better alignment
line_width=80

printf "\n"
printf "%${line_width}s\n" | tr ' ' '='
printf "* %-77s*\n" "App customization complete!"
printf "* %-77s*\n" "- App name: ${appName}"
printf "* %-77s*\n" "- Android package: ${androidPackageName}"
printf "* %-77s*\n" "- iOS bundle ID: ${iosBundleId}"
printf "* ${green}%-78s${none}*\n" "✅ All overrides have been applied."
printf "%${line_width}s\n" | tr ' ' '='

exit 0