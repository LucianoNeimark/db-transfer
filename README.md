# db-transfer
This repository provides a Docker image for running a PostgreSQL 16 container with automated backup and restoration. It creates a backup from a specified source database and restores it into a target database within the container.

## How to run
1) Create a folder where you will store the .env and the script.sh file
2) Execute ```docker build -t pg_backup .```
3) Inside the created folder execute ```docker run --rm --env-file .env -v $(pwd)/backup-data:/backup-data pg_backup```  


## Disclaimer
Inside the .env theres an option to only generate the backup file but not restore it into any TARGET DB