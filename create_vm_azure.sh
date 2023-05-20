source "function.sh"

function menuvm(){
    while true;do

        echo ""
        echo ""
        echo "     ------------------------------------------------------------------------"
        echo "     |                      MENÙ DI CREAZIONE DELLE VM                      |"
        echo "     ------------------------------------------------------------------------"
        echo ""
        echo ""

        echo "   1)  Creazione del RESOURCE-GROUP"
        echo "   2)  ELiminazione del RESOURCE-GROUP"
        echo "   3)  Creazione di VM"
        echo "   4)  Avvio della VM"
        echo "   5)  Arresto della VM"
        echo "   6)  Eliminazione della VM"
        echo "   7) <- Torna al menù principale"
        read -p " --> " s
        case $s in
            ( 1 )
                addrg;;
            ( 2 )
                rmrg;;
            ( 3 )
               	creavm;;
            ( 4 )
                startvm;;
            ( 5 )
                stopvm;;
            ( 6 )
                rmvm;;
            ( 7 )
            break;;
            ( * )
            echo "OPZIONE NON VALIDA"
        esac
    done

}


function menuinfovm(){
    while true;do
        echo ""
        echo ""
        echo "     ------------------------------------------------------------------"
        echo "     |                      MENÙ DI INFO SULLE VM                     |"
        echo "     ------------------------------------------------------------------"
        echo ""
        echo ""
        
        echo "   1)  ELENCO delle VM"
        echo "   2)  ELENCO delle IMMAGINI"
        echo "   3)  ELENCO degli IP delle VM"
        echo "   4)  ELENCO dei RESOURCE GROUP"
        echo "   5) <- Torma al menù primcipale"
        read -p " --> " s

         case $s in
            ( 1 )
                elencovm;;
            ( 2 )
                elencoimage;;
            ( 3 )
                elencoip;;
            ( 4 )
                elencorg;;
            ( 5 )
                break;;
            ( * )
                echo "opzione non valida";;
        esac
    done
}
