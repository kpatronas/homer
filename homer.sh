#!/bin/bash

# Get the hostname
host=$(hostname)

# Calculate the total size of /home
total_size=$(du -sb /home | cut -f1)

# Loop through each directory in /home
for dir in /home/*; do
    if [ -d "$dir" ]; then
        user=$(basename "$dir")
        size=$(du -sb "$dir" | cut -f1)
        human_readable_size=$(du -sh "$dir" | cut -f1)
        last_mod=$(stat -c %y "$dir" | cut -d' ' -f1)
        percent=$(echo "scale=2; ($size / $total_size) * 100" | bc)
        echo -e "$size\t$human_readable_size\t$percent%\t$user\t$last_mod"
    fi
done | sort -nr | awk -v host="$host" -v total_size="$total_size" -F'\t' '{print host "\t" int(total_size/1024/1024/1024) "G" "\t" $2 "\t" $3 "\t" $4 "\t" $5}' | column -t
