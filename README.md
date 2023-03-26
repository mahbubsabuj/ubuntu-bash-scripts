# Thinkfan Config auto update:

## Create a bash script to Auto update ```thinkfan.conf``` file:
Save this file somewhere with .sh extension.
```bash
#!/bin/bash

# Where to look for the sensors
searchdir="/sys/devices/"

# Exclude from the search those paths containing the following
# expression. This may change for different machines.
exclude="pci0000:00"

# Read the location of hwmon devices.
cpu=($(find "$searchdir" -name "temp*_input" | grep -v "$exclude" | grep "coretemp.0"))
if [[ ${#cpu[@]} -eq 0 ]]; then
    echo "No hwmon devices found"
    exit 1
fi

# Replace the sensors in the configuration file.
filename="/etc/thinkfan.conf"
if [[ ! -f "$filename" ]]; then
    echo "Configuration file $filename not found"
    exit 1
fi

# Remove all lines after line 10
sed -i '11,$d' "$filename"

# Append the new sensors starting from line 10
printf "%s\n" "${cpu[@]/#/hwmon }" >> "$filename"
```
Make it executable:
```bash
chmod +x script_name.sh
```
## Edit thinkfan.service file:
```bash
sudo nano /lib/systemd/system/thinkfan.service  
```
And add the line below to service section:
```bash
ExecStartPre=/path_to_your_script/update_thinkfan_hwmon.sh
```
