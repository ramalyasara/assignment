#!/bin/bash

# Common Variables
Date=$(date '+%Y%m%d')
DateTimeStamp=$(date '+%y%m%d%H%M')

# Color Variables
GREEN='\033[0;32m'
NC='\033[0m' # No Color

ERROR="" # Used for error input for options menu

# Function to perform system health check
function getHealthCheck(){
	# Define the output file path
	output_dir="/tmp/$Date/system_information_$DateTimeStamp"
	output_file_path="$output_dir/system_information_$DateTimeStamp"
	
	# Create the directory if it doesn't exist
	mkdir -p "$output_dir"
	
	# Inform the user where the results are stored
	echo ""
	echo "Selected result will be saved to the $output_dir folder"
	echo "==========  System Information Collection Process  ==========" >> "$output_dir/script_information_$DateTimeStamp"
	echo " " >> "$output_dir/script_information_$DateTimeStamp"
	
	# Execute commands and save output
	
	# Date and Hostname
	echo "======== Date Time ========" >> "$output_file_path"
	echo "Date Time: $DateTimeStamp" >> "$output_file_path"
	echo "Host Name:" >> "$output_file_path"
	hostname >> "$output_file_path"
	echo "" >> "$output_file_path"
	
	# TOP command
	echo "========= TOP ===========" >> "$output_file_path"
	top -c -n 2 >> "$output_file_path"
	echo -e "Saving Top Information: ${GREEN}Successful${NC}"
	echo "" >> "$output_file_path"
	
	# Memory Information
	echo "======== Memory ========" >> "$output_file_path"
	free -g >> "$output_file_path"
	echo -e "Saving Memory Information: ${GREEN}Successful${NC}"
	echo "" >> "$output_file_path"
	
	# Load Average
	echo "======== Load Average ========" >> "$output_file_path"
	top -n 1 -b | grep "load average:" | awk '{print $10, $11, $12}' >> "$output_file_path"
	echo -e "Saving Load Average Information: ${GREEN}Successful${NC}"
	echo "" >> "$output_file_path"
	
	# Uptime
	echo "======== Up Time ========" >> "$output_file_path"
	uptime | awk '{print $3,$4}' | cut -f1 -d, >> "$output_file_path"
	echo -e "Saving Up Time Information: ${GREEN}Successful${NC}"
	echo "" >> "$output_file_path"
	
	# Disk Space Information
	echo "======== Disk Space ========" >> "$output_file_path"
	df -h >> "$output_file_path"
	echo -e "Saving Disk Space Information: ${GREEN}Successful${NC}"
	echo "" >> "$output_file_path"
	
	# INode Information
	echo "======== INode Space ========" >> "$output_file_path"
	df -i >> "$output_file_path"
	echo -e "Saving INode Space Information: ${GREEN}Successful${NC}"
	echo "" >> "$output_file_path"
	
	# Logged In Users
	echo "======== Logged In Users ========" >> "$output_file_path"
	who >> "$output_file_path"
	echo -e "Saving Logged In Users: ${GREEN}Successful${NC}"
	echo "" >> "$output_file_path"
	
	# Logged User Count
	echo "======== Logged User Count  ========" >> "$output_file_path"
	who | wc -l >> "$output_file_path"
	echo -e "Saving Logged User Count: ${GREEN}Successful${NC}"
	echo "" >> "$output_file_path"
	
	# Running Processes (beam)
	echo "======= Running beam Process ==========" >> "$output_file_path"
	ps ax | grep beam | awk '{print $1 " " $5 }' >> "$output_file_path"
	echo -e "Saving Running Process Information: ${GREEN}Successful${NC}"
	echo "" >> "$output_file_path"
	
	# Running Processes with Ports
	echo "======= Running Process with port ==========" >> "$output_file_path"
	epmd -names >> "$output_file_path"
	echo -e "Saving Running Process With Ports Information: ${GREEN}Successful${NC}"
	echo "" >> "$output_file_path"
}

# Call the function to run health checks
getHealthCheck
