#!/bin/bash

#we need to give the path of directory which we need to backup and we need to create variable for it

source_directory=("/home", "/ubuntu")

# we need to mention where we are going to  ackup this data 

destination="/backup"

# now we need to give date format for the snapshots we will going to backup 

timestamp=$(date +"%Y%m%d_%H%M%S")

# now we need to create a log file where all standard input and error are going to be stored

logfile="/home/ubuntu/backup_$timestamp.log"

# now we need to create the destination directory including parent directory

mkdir -p "$destination/$timestamp"

# now we need to give permission to owner only to read write and execute backup directory

chmod 700 "$destination"

# we need to check now if src exits or not in directory

for src in "${source_directory[@]}"; do
    if [ ! -d "$src" ]; then
        echo "Error: Source directory '$src' does not exist." | tee -a "$logfile"
        exit 1
    fi
    if [ ! -r "$src" ]; then
        echo "Error: Source directory '$src' is not readable." | tee -a "$logfile"
        exit 1
    fi
done

# Check if the destination directory exists and is writable
if [ ! -d "$destination" ]; then
    echo "Error: Destination directory '$destination' does not exist." | tee -a "$logfile"
    exit 1
fi
if [ ! -w "$destination" ]; then
    echo "Error: Destination directory '$destination' is not writable." | tee -a "$logfile"
    exit 1
fi

# we need to synchronize the files now and need to append files and delete removed files

for src in "${source_directory[@]}"; do

rsync -a --delete "$src" "$destination/$timestamp" &>> "$logfile"

done

# we need to check logs which are older and we can delete those

find "$destination" -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \; &>> "$logfile"

# now  we need to share report of the backup over mail

if grep -q "rsync error" "$logfile"; then
    mail -s "Backup Failed on $(hostname)" admin@example.com < "$logfile"
    exit 1
else
    mail -s "Backup Successful on $(hostname)" admin@example.com < "$logfile"
    exit 0
fi
