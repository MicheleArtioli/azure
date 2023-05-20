source "create_vm_azure.sh"
source "function.sh"
source "./main_install.sh"

echo "">>log.log
echo "---------------------------------------------">>log.log
echo "$(date) | START PROGRAM">>log.log
echo ""
figlet -c "Microsoft  Azure  Virtual  Machine"
echo ""
echo "                      BY Serena Guidi and Michele Artioli"
echo ""
echo ""


while true;do

	echo ""
	echo "     ------------------------------------------------------------------------"
	echo "     |                           MENÙ PRINCIPALE                            |"
	echo "     ------------------------------------------------------------------------"
	echo ""
	echo ""
	echo ""
	
	
	
	echo "   1) LOG IN"
	echo "   2) LOG OUT"
	echo "   3) CREAZIONE VM"
	echo "   4) INFO VM"
	echo "   5) INSTALLAZIONE PROGRAMMI"
	echo "   6) CONNESSIONE VM"
	echo "   7) QUIT"
	read -p " --> " s

    case $s in
        ( 1 )
            login;;
        ( 2 )
            lgout;;
        ( 3 )
            menuvm;;
        ( 4 )
	    menuinfovm;;
        ( 5 )
            menuin;;
        ( 6 )
            connectvm;;
        ( 7 )
            read -p "vuoi eseguire il log out (y/n): " sc
                if [[ "$sc" == "y" ]];then
                    logout
                fi
                echo "$(date) | EXIT">>log.log
                exit 0;;
        ( * )
            echo "OPZIONE NON VALIDA"
            echo "$(date) | MAIN MENÙ opzione non valida">>log.log
        ;;

    esac
done







