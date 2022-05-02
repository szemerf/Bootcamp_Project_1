#!/bin/bash

# -------------------------------------------------
# Script to excute various commands to track
# system resources
# Save reports in corresponding backup directory
# -------------------------------------------------

# Print top command output to capture cpu stats at point in time.
# Could pipe to head to just get summaray pane, but 
# decided to print all processes running at the time.

top -n 1 -b > ~/HW5/backups/cpuuse/cpu_usage_$(date '+%Y%m%d').txt

# Print free memory stats at point in time

free -h > ~/HW5/backups/freemem/freemem_$(date '+%Y%m%d').txt

# Print disk usage at point in time

du -hs / 2>/dev/null > ~/HW5/backups/diskuse/diskuse_$(date '+%Y%m%d').txt

# Print Open Ports

lsof -i -n | grep LISTEN > ~/HW5/backups/openlist/openlist_$(date '+%Y%m%d').txt

# Print Free Diskspace

df -h > ~/HW5/backups/freedisk/freedisk_$(date '+%Y%m%d').txt

