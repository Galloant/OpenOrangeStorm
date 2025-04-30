#!/bin/bash

function KAMP_tidyup {
	while true; do
        clear_screen
		echo "=========================================================="
		echo "It is highly suggested that you make a backup of your config folder /n"
		echo "before you attempt this!"
		echo ""
		echo "And read the documentation! you need to change the START_GCODE section"
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
            1) KAMP_tidyup ;;

            q) clear; echo -e "${G}Goodbye...${NC}"; sleep 2; exit 0 ;;
            *) echo -e "${R}Invalid choice. Please try again.${NC}" ;;
        esac
    done
	} 

if [ -z "$1" ]; then
	clearr_screen
	main