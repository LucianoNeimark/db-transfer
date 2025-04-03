# Use the official PostgreSQL 16 image (which includes pg_dump 16.6)
FROM postgres:16

# Set the working directory inside the container
WORKDIR /backup

# Copy the backup script into the container
COPY backup.sh /backup/
RUN chmod +x /backup/backup.sh

# Command to run the script when the container starts
CMD ["/backup/backup.sh"]
