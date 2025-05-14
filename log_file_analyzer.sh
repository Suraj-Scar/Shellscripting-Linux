#!/bin/bash

#we need to create variable to locate logs 

logfile="/var/log/nginx/access.log"

# Check if the log file exists and is readable

if [ ! -f "$logfile" ]; then
    
    echo "Error: Log file '$logfile' does not exist." >&2  #it will check if file exits using -f flag
    
    exit 1

elif [ ! -r "$logfile" ]; then
    
    echo "Error: Log file '$logfile' is not readable." >&2  # it will check if file is readable suing -r flag
    
    exit 1
fi

# need to create variable to show us the reports of the logs with current date

report="/tmp/log_report_$(date +%y%m%d_%h%m%s).txt"

echo "Log analysis  report - $(date)" > "$report" # it will initialize all the output in report and also display message over screen

# now we need to count total logs entries

total=$(wc -l < "$logfile")  # wc that is word count will count words and store it in report file

echo "Total logs are $total" >> "$report"

# now we need to list out top 10 requested URL's

echo -e "/ntop 10 requested URL'S" >> "$report"

awk '{print $7}' "$logfile" | sort | uniq -c | sort -rn | head -10 >> "$report"  # it will extract 7th unit character of requested URL from logfile and then it will sort it according to uniqness and list out top 10 and store it in report file

# we need to tally client and server errors and save it to report file

echo -e "\n4xx Client Errors:" >> "$report"

grep '" 4[0-9][0-9] ' "$logfile" | wc -l >> "$report"  # Searches for lines with HTTP status codes in the 4xx range, indicating client errors.

echo -e "\n5xx server Errors:" >> "$report"

grep '" 5[0-9][0-9] ' "$logfile" | wc -l >> "$report"  # Searches for lines with HTTP status codes in the 5xx range, indicating server errors.

# we need to change the file permission for report file due to security reasons

chmod 600 "$report"

echo "report saved to $report"



