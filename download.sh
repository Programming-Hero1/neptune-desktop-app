#!/bin/bash

# Retrieve the latest release information from GitHub's API
release=$(curl --silent "https://api.github.com/repos/Programming-Hero1/neptune-desktop-app/releases/latest")

# Extract the URL of the asset we want to download
URL=$(echo $release | grep -o '"browser_download_url": "[^"]*"' | sed 's/"browser_download_url": "\(.*\)"/\1/' | grep '\.exe$')

# Check if there are multiple .exe files in the release
if [ $(echo $release | grep -o '"browser_download_url": "[^"]*"' | sed 's/"browser_download_url": "\(.*\)"/\1/' | grep '\.exe$' | wc -l) -gt 1 ]; then
  echo "Error: Found multiple .exe files in the release. Aborting."
  exit 1
fi

# Check if there are no .exe files in the release
if [ $(echo $release | grep -o '"browser_download_url": "[^"]*"' | sed 's/"browser_download_url": "\(.*\)"/\1/' | grep '\.exe$' | wc -l) -eq 0 ]; then
  echo "Error: No .exe files found in the release. Aborting."
  exit 1
fi

# Download the asset with progress bar
FILENAME=$(basename $URL)
echo "Downloading $FILENAME..."
curl --progress-bar -L -o $FILENAME $URL

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "File downloaded successfully."
else
  echo "Failed to download file."
fi

# Install the downloaded file
echo "Installing $FILENAME..."
./$FILENAME

# Check if the installation was successful
if [ $? -eq 0 ]; then
  echo "Installation successful."
else
  echo "Installation failed."
fi
