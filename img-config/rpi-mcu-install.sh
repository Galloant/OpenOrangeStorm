#!/bin/bash

# Path to other resources
MCU_SWFLASH_ALT="${HOME}/OpenOrangeStorm/mcu-firmware/alt-method/mcu-swflash-run.sh"

if [[ -z $1 ]]; then
    # Prompt the user to select the MCU for updating
    echo ""
    echo "Choose the MCU(s) to update:"
    echo ""
    select mcu_choice in "STM32" "RP2040" "Virtual RPi" "Pico-based USB Accelerometer" "All" "Cancel"; do
    case $mcu_choice in
        STM32 ) echo "Updating STM32 MCU..."; break;;
        RP2040) echo "Updating RP2040 (printhead) MCU..."; break;;
		Virtual\ RPi ) echo "Updating Virtual RPi MCU..."; break;;
        Pico-based\ USB\ Accelerometer ) echo "Updating Pico-based USB Accelerometer..."; break;;
        All ) echo "Starting update process for STM32, RP2040, Virtual RPi MCU and Pico USB Accelerometer"; break;;
            Cancel ) echo "Update canceled."; exit;;
        esac
    done
else
    # Use the first argument as the MCU choice
    mcu_choice=$1
fi

# Installing Katapult
cd ~/
git clone https://github.com/Arksine/katapult

# Update Klipper repository
cd ~/klipper/ && git pull origin master

# Update procedure for STM32 MCU
if [[ "$mcu_choice" == "STM32" ]] || [[ "$mcu_choice" == "All" ]]; then
    clear
    echo "Proceeding with STM32 MCU Update..."
    make clean
    cp ~/OpenOrangeStorm/mcu-firmware/mcu.config ~/klipper/.config
    make
	
	
	auto_updater() {
		echo "Trying to put the STM32 into bootloader mode..."
		
		#Trying to get the MCU unbound
		echo M112 > ~/printer_data/comms/klippy.serial 
		sleep 1
		echo FIRMWARE_RESTART > ~/printer_data/comms/klippy.serial
		sleep 1
		systemctl stop klipper
	
		echo "Checking if succeeded..."
		output=$(cd ~/katapult/scripts && python3 flash_can.py -i can0 -q)
	
		# Display the output to the user
		echo "$output"
		
		# Prompt the user to input a UUID
		read -p "Please enter the UUID that is the STM32 (usually the first one): " uuid
		
		# Confirm the selected UUID
		echo "You selected the UUID: $uuid"
		
		python3 flash_can.py -i can0 -u $uuid -f ~/klipper/out/klipper.bin
		
		return
		}
	

	manual_update() {
		
			# Regular update through microSD card
			# Create the 'Firmware' directory if it doesn't exist
			mkdir -p ~/printer_data/config/Firmware
	
			# Remove old files in previous parent directory
			rm ~/printer_data/config/X_4.bin > /dev/null 2>&1
			rm ~/printer_data/config/elegoo_k1.bin > /dev/null 2>&1
			rm ~/printer_data/config/ZNP_GIGA.bin > /dev/null 2>&1
	
			cp ~/klipper/out/klipper.bin ~/printer_data/config/Firmware/ZNP_GIGA.bin
	
			clear
			# Display instructions for downloading the firmware
			ip_address=$(hostname -I | awk '{print $1}')
			echo ""
			echo -e "\nTo download firmware files:"
			echo "1. Visit: http://$ip_address/#/configure"
			echo "2. Click the Firmware folder in the left Config list"
			echo "3. Right-click and Download 'ZNP_GIGA.bin'"
			echo "   Then copy to a FAT32 formatted microSD card."
			echo ""
			echo -e "\nTo complete the update:"
			echo "1. After this script completes, power off the printer" 
			echo "   Then insert the microSD card."
			echo "2. Power on, and check the MCU version in Fluidd's system tab."
			echo "3. The '.bin' file on the microSD will be renamed to..." 
			echo "   '.CUR' if the update was successful."
			echo ""
			echo -e "\nFor printers without external microSD slots:"
			echo -e "Visit the OpenOrangeStorm wiki for info (if not already done)\n"
			echo -e "https://github.com/OpenNeptune3D/OpenOrangeStorm/wiki"
			echo ""
			echo -e "\nHave you downloaded the bin files and are ready to continue? (y)"
			read continue_choice
			if [[ "$continue_choice" =~ ^[Yy]$ ]]; then
				echo ""
				if [[ "$mcu_choice" == "STM32" ]]; then
					echo "Power-off the machine and insert the microSD card."
					sleep 4
					# Exit only if the selected choice was specifically STM32, not "All"
					exit
				fi
			fi
		}

	if auto_updater; then
		echo "Auto update for the STM32 was a success!!"
		echo ""
		echo "continuing..."
		sleep 2
	else
		echo "Auto update didn't work..."
		echo ""
		echo "Trying the SD-card method..."
		sleep 2
		manual_update
	fi	
fi

if [[ "$mcu_choice" == "RP2040" ]] || [[ "$mcu_choice" == "All" ]]; then
    clear
    echo "Proceeding with RP2040 (printhead) MCU Update..."
    make clean
    cp ~/OpenOrangeStorm/mcu-firmware/printhead.config ~/klipper/.config
    make
	
	
	auto_updater() {
		echo "Trying to put the RP2040 into bootloader mode..."
		
		sudo M112 > ~/printer_data/comms/klippy.serial 
		sleep 1
		sudo FIRMWARE_RESTART > ~/printer_data/comms/klippy.serial
		sleep 1
		sudo systemctl stop klipper
	
		echo "Checking if succeeded..."
		output=$(cd ~/katapult/scripts && python3 flash_can.py -i can0 -q)
	
		# Display the output to the user
		echo "$output"
		
		# Prompt the user to input a UUID
		read -p "Please enter the UUID that is the RP2040 (usually the second one): " uuid
		
		# Confirm the selected UUID
		echo "You selected the UUID: $uuid"
		
		python3 flash_can.py -i can0 -u $uuid -f ~/klipper/out/klipper.bin
		
		return
		}
	

	if auto_updater; then
		echo "Auto update for the RP2040 was a success!!"
		echo ""
		sleep 2
	else
		cp ~/klipper/out/klipper.bin ~/printer_data/config/Firmware/RP2040.bin
		echo "Something didn't go as planned..."
		echo "Either retry, or put the firmware on manually"
		echo "Read the documentation how to do that!"
		echo "We've copied the firmware into ~/printer_data/config/Firmware/RP2040.bin"
		
		seconds=20

		while [ $seconds -ge 0 ]; do
			echo -ne "$seconds... "
			sleep 1
			seconds=$((seconds - 1))
		done
	fi	
fi

# Update procedure for Pico-based Accelerometer
pico_skipped=false
if [[ "$mcu_choice" == "Pico-based USB Accelerometer" ]] || [[ "$mcu_choice" == "All" ]]; then
    clear
    echo "Proceeding with Pico-based USB Accelerometer Update..."

    # check if there is any pico connected, and identify if it is in bootloader mode or not
    while true; do
        pico_bootloader=$(lsusb | grep '2e8a:0003' 2>/dev/null)
        if [[ -z "$pico_bootloader" ]]; then
            echo ""
            read -n 1 -p "Please put your Pico in bootloader mode
Skip with (s) or press any key to continue..." key
            if [[ $key = s ]] || [[ $key = S ]]; then
                pico_skipped=true
                clear
                break
            fi
        else
            echo ""
            echo "Pico detected in bootloader mode. Proceeding..."
            break
        fi
    done

    if [[ "$pico_skipped" == false ]]; then
        sudo apt install -y python3-numpy python3-matplotlib libatlas-base-dev libopenblas-dev
        ~/klippy-env/bin/pip install -v numpy

        make clean
        cp ~/OpenOrangeStorm/mcu-firmware/pico_usb.config ~/klipper/.config
        make

        make flash FLASH_DEVICE=2e8a:0003
        echo ""
        echo "Pico-based Accelerometer update completed."
        sleep 2
        echo ""
    fi
fi

# Update procedure for Virtual RPi MCU
if [[ "$mcu_choice" == "Virtual RPi" ]] || [[ "$mcu_choice" == "All" ]]; then
    clear
    echo "Proceeding with Virtual MCU RPi Update..."
    echo ""
    sudo apt install -y python3-numpy python3-matplotlib libatlas-base-dev libopenblas-dev
    ~/klippy-env/bin/pip install -v numpy
    sudo cp ./scripts/klipper-mcu.service /etc/systemd/system/
    sudo systemctl enable klipper-mcu.service
    make clean
    cp ~/OpenOrangeStorm/mcu-firmware/virtualmcu.config ~/klipper/.config
    sudo service klipper stop

    if grep -iq "mks" /boot/.OpenOrangeStorm.txt; then
        printf "Skipping Kernel patch based on system check.\n"
        sleep 2
    elif grep -iq "dec 11" /boot/.OpenOrangeStorm.txt; then 
        echo "kernel.sched_rt_runtime_us = -1" | sudo tee -a /etc/sysctl.d/10-disable-rt-group-limit.conf
    fi

    make flash
    echo ""
    echo "Virtual MCU update completed."
    sleep 2
    clear
    echo ""

    # System reboot countdown for Virtual RPi MCU update
    countdown=20
    echo "Rebooting in $countdown seconds..."
    while [ $countdown -gt 0 ]; do
        echo "$countdown..."
        sleep 1
        countdown=$((countdown - 1))
    done
    sudo reboot
fi
