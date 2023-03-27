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

Here is my content of thinkfan.conf file:
```bash
tp_fan /proc/acpi/ibm/fan
#Fan settings
(0,     0,      42)
(1,     40,     47)
(2,     45,     52)
(3,     50,     57)
(4,     55,     62)
(5,     60,     77)
(7,     73,     93)
(127,   85,     32767)
hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon7/temp3_input
hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon7/temp4_input
hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon7/temp1_input
hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon7/temp5_input
hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon7/temp2_input
```
> NOTE: First 10 lines of my config contains Fan settings. These 10 lines are constant.

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

# xinput-settings:
## To list all touchpad divers:
```bash
xinput
```
## After identifying your driver, to list all settings associated with that driver:
```bash
xinput list-props "DRIVER_NAME"
```
## To make a property true:
```bash
xinput set-prop "DRIVER_NAME" "PROP_NAME" 1 
```
>Note: To make it permanent, you need to put it to your config file. in my case i'm using bspwm. so i have put it to my bspwmrc file.
> ```exec xinput set-prop "DRIVER_NAME" "PROP_NAME" 1```

**Resource followed:**
```link
https://major.io/2021/07/18/tray-icons-in-i3/
```
