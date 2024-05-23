# Folder Encryption/Decryption Script V2 for Raspberry Pi

This script provides a simple way to encrypt and decrypt folders using the AES algorithm with PBKDF2 for key derivation. It utilizes OpenSSL for encryption and decryption processes. The script is designed to run on a Raspberry Pi, but it can be used on any Linux-based system.

Youtube Video: [Encryption on Raspberry pi](https://youtu.be/KQOr3ikgw-M)

## Installation

1. Clone the repository:

```bash
git clone https://github.com/adistrim/AESFolderCrypt-V2
```

2. Change to the project directory:

```bash
cd AESFolderCrypt-V2
```

3. Run the installation script:

```bash
./install.sh
```

## Usage

### Help
To view detailed usage instructions, use:
```bash
foldercrypt --help
```


### Encrypting a Folder:
```bash
foldercrypt -enc <folder_path>
```
Example:
```bash
foldercrypt -enc my_folder
```
### Decrypting an Encrypted File:
```bash
foldercrypt -dec <encrypted_file>
```
Example:
```bash
foldercrypt -dec my_folder.enc
```

## License

This project is licensed under the [MIT License](LICENSE).

