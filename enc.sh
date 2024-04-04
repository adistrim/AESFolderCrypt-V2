#!/bin/bash

# Function to encrypt folder
encrypt_folder() {
    folder_path="$1"
    encrypted_file="$2"
    password="$3"
    tar czf - "$folder_path" | openssl enc -aes-256-cbc -salt -out "$encrypted_file" -k "$password"
}

# Function to decrypt folder
decrypt_folder() {
    encrypted_file="$1"
    decrypted_folder="$2"
    password="$3"
    openssl enc -aes-256-cbc -d -in "$encrypted_file" -out "$decrypted_folder.tar.gz" -k "$password"
    tar xzf "$decrypted_folder.tar.gz" -C "$decrypted_folder"
    rm "$decrypted_folder.tar.gz"
}

echo "Enter 'enc' to encrypt or 'dec' to decrypt:"
read operation

if [ "$operation" == "enc" ]; then
    echo "Enter password:"
    read -s password
    echo "Enter path to folder to encrypt:"
    read folder_path
    echo "Enter path for encrypted file (with .enc extension):"
    read encrypted_file
    encrypt_folder "$folder_path" "$encrypted_file" "$password"
    echo "Encryption completed."
elif [ "$operation" == "dec" ]; then
    echo "Enter password:"
    read -s password
    echo "Enter path to encrypted file:"
    read encrypted_file
    echo "Enter path for decrypted folder:"
    read decrypted_folder
    decrypt_folder "$encrypted_file" "$decrypted_folder" "$password"
    echo "Decryption completed."
else
    echo "Invalid operation. Please enter 'enc' or 'dec'."
    exit 1
fi

