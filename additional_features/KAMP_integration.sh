#!/bin/bash

#V0.1 by Galloant


#definitions
scriptdir = ./
config = ~/printer_data/config
configKAMP = ~/printer_data/config/KAMP
KAMP = ~/Klipper-Adaptive-Meshing-Purging

function KAMP_tidyup_secpromt {
	while true; do
        clear_screen
		echo "=========================================================="
		echo "It is highly suggested that you make a backup of your config folder /n"
		echo "before you attempt this!"
		echo ""
		echo "And read the documentation! You need to change the START_GCODE section"
		echo "in your slicer!"
		echo ""
		echo ""
		echo "Done that?"
		echo ""
		echo " y(yes) n(no)"
		echo -e "(${R} Q ${NC}) Quit"
		echo "=========================================================="
		echo "Select an option by entering (1-1 / q):"
        echo -e "${G}Enter your choice:${NC}"

		read choice
		case $choice in
            y) KAMP_tidyup ;;
			n) 
            q) clear; echo -e "${G}Goodbye...${NC}"; sleep 2; exit 0 ;;
            *) echo -e "${R}Invalid choice. Please try again.${NC}" ;;
        esac
    done

}


function KAMP_tidyup {
	while true; do
        clear_screen
		echo "Stopping klipper service..."
		systemctl stop klipper
		
		#Installing virutal pins for the Start_Print.cfg
		
		echo "We'll install virtual pins for the Start_Print macro."
		sleep 2
		
		cd ~
		git clone https://github.com/pedrolamas/klipper-virtual-pins.git
		./klipper-virtual-pins/install.sh
		
		
		#Making folder in /config
		mkdir $configKAMP
		
		#Moving KAMP_Settings file
		if [ -e $config/KAMP_Settings.cfg ]; then
			echo "KAMP_Settings.cfg exists. Moving to ./KAMP/"
			mv $config/KAMP_Settings.cfg $configKAMP/
		else
			echo "File does not exist. Have you installed KAMP?"
			sleep 2
			exit
		fi
		
		#Moving or creating Start_Print macro
		if [ -e $config/Start_Print.cfg ]; then
			echo "Start_Print.cfg exists. Moving to ./KAMP/"
			mv $config/Start_Print.cfg $configKAMP/
		else
			echo "Start_Print.cfg does not exist. Creating it..."
			cp ./Start_Print.cfg $configKAMP/
		fi
		
		#Deleting and creating KAMP links
		if [ -e $config/Adaptive_Meshing.cfg ]; then
			echo "Adaptive_Meshing link exists. Moving to ./KAMP/"
			rm $config/Adaptive_Meshing.cfg
			ln -s $KAMP/Adaptive_Meshing.cfg $configKAMP/

		else
			echo "Symbolic link for Adaptive_Meshing.cfg does not exist. Creating it..."
			ln -s $KAMP/Adaptive_Meshing.cfg $configKAMP/
		fi		
	
		if [ -e $config/Line_Purge ]; then
			echo "Line_Purge link exists. Moving to ./KAMP/"
			rm $config/Line_Purge
			ln -s $KAMP/Line_Purge $configKAMP/

		else
			echo "Symbolic link for Line_Purge does not exist. Creating it..."
			ln -s $KAMP/Line_Purge $configKAMP/
		fi		
	
		if [ -e $config/Smart_Park.cfg ]; then
			echo "Smart_Park link exists. Moving to ./KAMP/"
			rm $config/Smart_Park.cfg
			ln -s $KAMP/Smart_Park.cfg $configKAMP/

		else
			echo "Symbolic link for Smart_Park.cfg does not exist. Creating it..."
			ln -s $KAMP/Smart_Park.cfg $configKAMP/
		fi	

		if [ -e $config/Voron_Purge.cfg ]; then
			echo "Voron_Purge link exists. Moving to ./KAMP/"
			rm $config/Voron_Purge.cfg
			ln -s $KAMP/Voron_Purge.cfg $configKAMP/

		else
			echo "Symbolic link for Voron_Purge.cfg does not exist. Creating it..."
			ln -s $KAMP/Voron_Purge.cfg $configKAMP/
		fi	
		
		echo "All done!"
		sleep 2
	
	done
}

# Main Script Logic
function main {   
    while true; do
        clear_screen
		echo -e "${C}$OpenOrangeStorm_ART${NC}"
		printf "    Branch:$current_branch | Model:$MODEL_FROM_FLAG | Kernel:$KERNEL_FROM_FLAG\n"
		echo "=========================================================="
		echo -e "                OpenOrangeStorm - ${M}Main Menu${NC}       "
		echo "=========================================================="
		echo ""
		echo "1) KAMP tidy-up"
		echo ""
		echo "No more options for the moment :)"
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		echo ""
		echo -e "(${R} Q ${NC}) Quit"
		echo "=========================================================="
		echo "Select an option by entering (1-1 / q):"
        echo -e "${G}Enter your choice:${NC}"

		read choice

        case $choice in
            1) KAMP_tidyup_secpromt ;;

            q) clear; echo -e "${G}Goodbye...${NC}"; sleep 2; exit 0 ;;
            *) echo -e "${R}Invalid choice. Please try again.${NC}" ;;
        esac
    done
	} 

if [ -z "$1" ]; then
	clearr_screen
	main