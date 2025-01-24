#!/bin/bash
# coc_rom_generator.sh : Alexander Upton : 01/24/2025
# coc_rom_generator.sh is a tool for MacOS and Linux users that
# are unable to utilize the Windows based Batch files and associated
# PowerShell functions that are provided with Coin-Op Collection releases.
#
# coc_rom_generator.sh and associated .env files are to be copied into the same directory
# that the Coin-Op Collection release zip file was extracted to and entirely relies on the
# Coin-Op Collection teams published Python repackaging tool that was included with the release.
#
# Support the Coin-Op Collection team exclusively at https://www.patreon.com/c/atrac17
#
# Copyright (c) 2025 Alexander Upton <alex.upton@gmail.com>
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# You can download the latest version of this script from:
# https://github.com/alexanderupton/MiSTer-Scripts

# ========= IMMUTABLE ================
APP="coc_rom_generator.sh"
VER="0.01"
OS=$(uname)

# Check for macOS or Linux
if [[ "$OS" == "Darwin" ]]; then
 export MRA_BIN="mra.mac"
elif [[ "$OS" == "Linux" ]]; then
 export MRA_BIN="mra.linux"
else
 echo "Unknown operating system: $OS"
 exit 1
fi

# Determine which Python is installed
if which python > /dev/null; then
 PYTHON_BIN=$(which python)
elif which python3 > /dev/null; then
 PYTHON_BIN=$(which python3)
else
 echo "Python is not installed or is not in your path. Exiting"
 exit 1
fi

# Find all .env files in the current directory
env_files=(*.env)

# Check if there are any .env files
if [ ${#env_files[@]} -eq 0 ]; then
 echo "No .env files found in the current directory."
 exit 1
fi

# Display the menu
echo "${APP}:v${VER}"
echo "Select a ROM to generate:"
for i in "${!env_files[@]}"; do
 echo "$((i + 1))) ${env_files[$i]}"| sed 's|.env||g'
done

# Get user choice
read -p "Enter your choice (1-${#env_files[@]}): " choice

# Validate the input
if [[ $choice -lt 1 || $choice -gt ${#env_files[@]} ]]; then
    echo "Invalid choice. Exiting."
    exit 1
fi

# Build the selected option
selected_file="${env_files[$((choice - 1))]}"
selected_function=$(basename ${selected_file} .env)
source "$selected_file"
${selected_function}

