#!/bin/bash

# Function to encrypt folder
encrypt_folder() {
    folder_path="$1"
    encrypted_file="$2"
    password="$3"
    tar czf - "$folder_path" | openssl enc -aes-256-cbc -salt -pbkdf2 -out "$encrypted_file" -k "$password"
}

# Function to decrypt folder
decrypt_folder() {
    encrypted_file="$1"
    decrypted_folder="$2"
    password="$3"
    openssl enc -aes-256-cbc -d -pbkdf2 -in "$encrypted_file" -out "$decrypted_folder.tar.gz" -k "$password"
    tar xzf "$decrypted_folder.tar.gz" -C "$decrypted_folder"
    rm "$decrypted_folder.tar.gz"
}

# Function to check password length
check_password_length() {
    password="$1"
    if [ ${#password} -lt 10 ]; then
        echo "Password must be at least 10 characters."
        exit 1
    fi
}

# Function to hash the password using a simple stuff
secure_hash() {
    local password="$1"
    local salt="$2"
    local iterations="$3"
    local hashed_text="$password"

    for ((i = 0; i < iterations; i++)); do
        # Concatenate password and salt
        local input="$password$salt"
        local input_length="${#input}"

        # Initialize an empty array to store the characters of the input
        local char_array=()

        # Convert input to an array of characters
        for ((j = 0; j < input_length; j++)); do
            char_array[$j]="${input:$j:1}"
        done

        # Iterate through the array and shuffle the characters
        for ((j = 0; j < input_length; j++)); do
            # Generating a random index within the range of the array
            random_index=$((RANDOM % input_length))

            # Swaping characters at current index and random index
            temp="${char_array[$j]}"
            char_array[$j]="${char_array[$random_index]}"
            char_array[$random_index]="$temp"
        done

        # Concatenating the shuffled characters to form the new input
        input="${char_array[*]}"
        hashed_output=$(echo -n "$hashed_text" | openssl sha256)

        # Hashing the new input using a simple hash function (XOR)
        local hash=0
        for ((j = 0; j < input_length; j++)); do
            char=${input:$j:1}
            ascii_val=$(printf "%d" "'$char")
            hash=$((hash ^ ascii_val))
        done

        # Updating the hashed_text with the new hash value
        hashed_text="$hashed_output"
    done

    echo "$hashed_text"
}

echo "Enter 'enc' to encrypt or 'dec' to decrypt:"
read operation

if [ "$operation" == "enc" ]; then
    echo "Enter password (must be at least 10 characters):"
    read -s password
    check_password_length "$password"
    hpassword=$(secure_hash "$password" "salt" 10)
    echo "Enter path to folder to encrypt:"
    read folder_path
    echo "Enter path for encrypted file (with .enc extension):"
    read encrypted_file
    encrypt_folder "$folder_path" "$encrypted_file" "$hpassword"
    echo "Encryption completed."
elif [ "$operation" == "dec" ]; then
    echo "Enter password:"
    read -s password
    hpassword=$(secure_hash "$password" "salt" 10)
    echo "Enter path to encrypted file:"
    read encrypted_file
    echo "Enter path for decrypted folder:"
    read decrypted_folder
    decrypt_folder "$encrypted_file" "$decrypted_folder" "$hpassword"
    echo "Decryption completed."
else
    echo "Invalid operation. Please enter 'enc' or 'dec'."
    exit 1
fi
