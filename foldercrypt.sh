#!/bin/bash

encrypt_folder() {
    folder_path="$1"
    encrypted_file="$2"
    password="$3"
    tar czf - "$folder_path" | openssl enc -aes-256-cbc -salt -pbkdf2 -out "$encrypted_file" -k "$(echo -n "$password" | openssl sha256)"
}

decrypt_folder() {
    encrypted_file="$1"
    decrypted_folder="$2"
    password="$3"
    temp_dir=$(mktemp -d)

    openssl enc -aes-256-cbc -d -pbkdf2 -in "$encrypted_file" -out "$temp_dir/decrypted.tar.gz" -k "$(echo -n "$password" | openssl sha256)" 2>/dev/null
    
    if [ $? -ne 0 ]; then
        echo "Error: Incorrect password or failed to decrypt."
        rm -rf "$temp_dir"
        exit 1
    fi

    if [ -d "$decrypted_folder" ]; then
        rm -rf "$decrypted_folder"
    fi

    mkdir -p "$decrypted_folder"
    tar xzf "$temp_dir/decrypted.tar.gz" -C "$decrypted_folder"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to extract the archive."
        rm -rf "$temp_dir"
        exit 1
    fi
    rm -rf "$temp_dir"
}

check_password_length() {
    password="$1"
    if [ ${#password} -lt 10 ]; then
        echo "Password must be at least 10 characters."
        exit 1
    fi
}

if [ "$#" -eq 1 ] && [ "$1" == "--help" ]; then
    echo "Usage: foldercrypt -enc <folder_path> | -dec <encrypted_file>"
    echo "Options:"
    echo "  -enc <folder_path>        Encrypts the specified folder."
    echo "                            Example: foldercrypt -enc my_folder"
    echo "  -dec <encrypted_file>     Decrypts the specified encrypted file."
    echo "                            Example: foldercrypt -dec my_folder.enc"
    exit 0
fi

if [ "$#" -lt 2 ]; then
    echo "Invalid input. Use 'foldercrypt --help' for more information."
    exit 1
fi

operation="$1"
if [ "$operation" == "-enc" ]; then
    folder_path="$2"
    encrypted_file="${folder_path}.enc"
    echo "Enter password (must be at least 10 characters):"
    read -s password
    check_password_length "$password"
    encrypt_folder "$folder_path" "$encrypted_file" "$password"
    echo "Encryption completed. Encrypted file: $encrypted_file"
elif [ "$operation" == "-dec" ]; then
    encrypted_file="$2"
    decrypted_folder="${encrypted_file%.enc}"

    if [ ! -f "$encrypted_file" ]; then
        echo "Error: The file '$encrypted_file' does not exist or is not a file."
        exit 1
    fi

    echo "Enter password:"
    read -s password
    decrypt_folder "$encrypted_file" "$decrypted_folder" "$password"
    if [ $? -eq 0 ]; then
        echo "Decryption completed. Decrypted folder: $decrypted_folder"
    fi
else
    echo "Invalid operation. Use 'foldercrypt --help' for more information."
    exit 1
fi
