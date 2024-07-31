#!/bin/bash

# Get the hostname
host=$(hostname)

# Find the partition containing /home
partition=$(df /home | tail -1 | awk '{print $1}')

# Get the total size of the partition in bytes
partition_total_size=$(df --block-size=1 /home | tail -1 | awk '{print $2}')

# Loop through each directory in /home
for dir in /home/*; do
    if [ -d "$dir" ]; then
        user=$(basename "$dir")
        size=$(du -sb "$dir" | cut -f1)
        human_readable_size=$(du -sh "$dir" | cut -f1)
        last_mod=$(stat -c %y "$dir" | cut -d' ' -f1)
        percent=$(echo "scale=2; ($size / $partition_total_size) * 100" | bc)
        echo -e "$size\t$human_readable_size\t$percent%\t$user\t$last_mod"
    fi
done | sort -nr | awk -v host="$host" -v total_size="$partition_total_size" -F'\t' '{print host "\t" int(total_size/1024/1024/1024) "G" "\t" $2 "\t" $3 "\t" $4 "\t" $5}' | column -t
