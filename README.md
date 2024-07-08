_# image-wasstraat

# Container Image Wasstraat

## Project Setup

This document provides step-by-step instructions to set up and run the project using Docker Compose.

### Prerequisites
- Docker

### Steps

#### 1. Docker Compose Up

To start the project, run the following command:
```bash
docker-compose up
```

#### 2. Setup the Vault

Ensure Vault is properly configured.

#### 3. Generate Public and Private Key with Cosign

Generate the public and private keys if you intend to sign your own images:
```bash
cosign generate-key-pair
```

#### 4. Paste Public and Private Key in Init Vault Script

Insert the generated public and private keys into the initialization script for Vault.

#### 5. Run the Init Vault Script

Execute the initialization script to set up Vault.

#### 6. Let Clair Finish Loading Database

Clair may take some time to load its database. Please be patient during this process.

### GitLab Setup

#### 1. Connect the Runner

Ensure your GitLab Runner is properly connected to your GitLab instance.

#### 2. Load in the Pipelines

Import the pipelines into your GitLab project.

#### 3. Setup the Pipeline Tags

Configure the necessary tags for your pipelines.

#### 4. Setup the Schedule Pipeline

Configure the schedule for running your pipelines.

### Setup Variables

Configure the following variables in your GitLab CI/CD settings:

- `mongo_uri`
- `COSIGN_PASSWORD`
- `VAULT_ADDR`
- `VAULT_TOKEN_PRIVATE_KEY`
- `VAULT_TOKEN_PUBLIC_KEY`

### Running Pipelines

When running pipelines, use the following variables:

- `IMAGE_NAME`: `<YOUR IMAGE NAME>`
- `IMAGE_TAG`: `<YOUR IMAGE TAG>`
- `TOKEN_PATH`: `<THE TOKEN PATH (use "test" as value if using the vault init script)>`

Make sure to replace placeholders with your actual values.

---

This setup ensures a smooth configuration and deployment of your project using Docker Compose, Vault, and GitLab pipelines. If you encounter any issues, please refer to the official documentation of the respective tools for further assistance.
