#!/bin/bash

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    echo "Error: Windows is not supported."
    exit 1
fi

SOURCE_SCRIPT="foldercrypt.sh"
DESTINATION_DIR="/usr/local/bin"
DESTINATION_SCRIPT="foldercrypt"

if [ ! -f "$SOURCE_SCRIPT" ]; then
    echo "Error: The source script '$SOURCE_SCRIPT' does not exist."
    exit 1
fi

if [ -f "$DESTINATION_DIR/$DESTINATION_SCRIPT" ]; then
    sudo rm -f "$DESTINATION_DIR/$DESTINATION_SCRIPT"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to remove the existing script in '$DESTINATION_DIR'."
        exit 1
    fi
fi

sudo mv "$SOURCE_SCRIPT" "$DESTINATION_DIR/$DESTINATION_SCRIPT"
if [ $? -ne 0 ]; then
    echo "Error: Failed to move the script to '$DESTINATION_DIR'."
    exit 1
fi

sudo chmod +x "$DESTINATION_DIR/$DESTINATION_SCRIPT"
if [ $? -ne 0 ]; then
    echo "Error: Failed to make the script executable."
    exit 1
fi

echo "Installation successful!"
echo "You can now use the command 'foldercrypt --help' to get started."
