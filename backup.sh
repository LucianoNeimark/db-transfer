#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Ensure all required variables are set
if [ -f .env ]; then
    while IFS='=' read -r key value; do
        if [[ ! $key =~ ^# && -n $key ]]; then
            export "$key"="$value"
        fi
    done < .env
fi

# Export password so pg_dump doesn't prompt for it
export PGPASSWORD="$SOURCE_DB_PASSWORD"

# Run pg_dump and save the output
echo "Starting database backup from $SOURCE_DB_HOST:$SOURCE_DB_PORT..."
mkdir -p /backup
pg_dump -h "$SOURCE_DB_HOST" -U "$SOURCE_DB_USER" -d "$SOURCE_DB_NAME" -p "$SOURCE_DB_PORT" -F c -f "/backup-data/$OUTPUT_FILE"

# Check if the dump was successful
if [ $? -eq 0 ]; then
    echo "Backup completed: /backup/$OUTPUT_FILE"
else
    echo "Backup failed!"
    exit 1
fi

if [[ "$ONLY_GENERATE_DUMP" == "false" ]]; then
    echo "Restore is enabled!"
    echo "Restoring DB file $OUTPUT_FILE on $TARGET_DB_NAME"
    export PGPASSWORD="$TARGET_DB_PASSWORD"
    pg_restore -h "$TARGET_DB_HOST" -U "$TARGET_DB_USER" -d "$TARGET_DB_NAME" -p "$TARGET_DB_PORT" -F c "/backup/$OUTPUT_FILE"

    if [ $? -eq 0 ]; then
        echo "Restore to DB: $TARGET_DB_NAME completed"
    else
        echo "Restore finished with errors or warnings!"
        exit 1
    fi

else
    echo "Restore is disabled!"
fi