#!/bin/bash

# Default values
home_dir="/home"
print_headers=true

# Parse command line options
while getopts "d:h" opt; do
    case ${opt} in
        d)
            home_dir=$OPTARG
            ;;
        h)
            print_headers=false
            ;;
        \?)
            echo "Usage: cmd [-d home_dir] [-h]"
            exit 1
            ;;
    esac
done

# Check if the specified directory exists
if [ ! -d "$home_dir" ]; then
    echo "Error: Directory '$home_dir' does not exist."
    exit 1
fi

# Get the hostname
host=$(hostname)

# Find the partition containing the home directory
partition=$(df "$home_dir" | tail -1 | awk '{print $1}')

# Get the total size of the partition in bytes
partition_total_size=$(df --block-size=1 "$home_dir" | tail -1 | awk '{print $2}')

# Loop through each directory in the specified home directory
for dir in "$home_dir"/*; do
    if [ -d "$dir" ]; then
        user=$(basename "$dir")
        size=$(du -sb "$dir" | cut -f1)
        human_readable_size=$(du -sh "$dir" | cut -f1)
        last_mod=$(stat -c %y "$dir" | cut -d' ' -f1)
        percent=$(echo "scale=2; ($size / $partition_total_size) * 100" | bc)
        echo -e "$size\t$human_readable_size\t$percent%\t$user\t$last_mod"
    fi
done | sort -nr | awk -v print_headers="$print_headers" -v partition="$partition" -v host="$host" -v total_size="$partition_total_size" -v print_headers="$print_headers" -F'\t' '
BEGIN {
    if (print_headers=="true") {
        print "Hostname\tPartition\tPart-Size\tDir-Size\tDir-Perc\tDir-Name Last-Modified"
    }
}
{
    print host "\t" partition "\t" int(total_size/1024/1024/1024) "G" "\t" $2 "\t" $3 "\t" $4 "\t" $5
}' | column -t
