source "./function.sh"
function install_mysql(){
    echo "$(date) | install mysql-server">>log.log
    echo ""
    echo "Seleziona la VM per l'installazione di mysql-server: "
    nome=$(elncovm)
    #rg=$(az vm show --name $nome --query 'resourceGroup' -o tsv)
    echo ""
    echo "Seleziona il resource-group della VM appena scelta: "
    rg=$(elncoresourcegroup)
    echo ""
    read -p "Passa un file .sh per la creazione del database--> " dbc

    echo "$(date) | open-port 3306">>log.log
    az vm open-port --resource-group $rg --name $nome --port 3306 >/dev/null
    echo " porta 3306 aperta"
    echo "$(date) | run script install mysql-server">>log.log
    echo ""
    echo "START mysql-server install"
    az vm run-command invoke --resource-group $rg --name $nome --command-id RunShellScript --scripts @installmysql.sh >/dev/null
    az vm run-command invoke --resource-group $rg --name $nome --command-id RunShellScript --scripts @$dbc >/dev/null
    echo ""
    echo " END mysql-server install"
}

function uninstall_mysql(){
    echo "$(date) | uninstall mysql-server">>log.log
    echo ""
    echo "Seleziona la VM per la disinstallazione di mysql-server: "
    nome=$(elncovm)
    #rg=$(az vm show --name $nome --query 'resourceGroup' -o tsv)
    echo ""
    echo "Seleziona il resource-group della VM appena scelta: "
    rg=$(elncoresourcegroup)

    echo "$(date) | VM scelta $nome">>log.log
    echo "$(date) | run script uninstall mysql-server">>log.log
    az vm run-command invoke --resource-group $rg --name $nome --command-id RunShellScript --scripts @uninstallmysql.sh
    echo ""
    echo " disinstallazione completata"
}

function install_apache(){
    echo "$(date) | run script install apache">>log.log
    echo ""
    echo "Seleziona la VM per l'installazione di apache: "
    nome=$(elncovm)
    echo ""
    echo "Seleziona il resource-group della VM appena scelta: "
    rg=$(elncoresourcegroup)
    ip=$(az vm show -d --resource-group $rg --name $nome --query 'publicIps' -o tsv)
    user=$(az vm show -d --resource-group $rg --name $nome --query 'osProfile.adminUsername' -o tsv)
    az vm open-port --resource-group $rg --name $nome --port 80 >/dev/null
    echo "porta 80 aperta"
    echo ""
    read -p "Passa la directory di lavoro della webapp che vuoi pubblicare--> " dir
    while true;do
    if [[ -d $dir ]];then
        echo "dir found"
        scp -r -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $dir $user@$ip:/home/$user/app
        break
    else
        echo "dir not found"
        read -p "Passa la directory di lavoro della webapp che vuoi pubblicare--> " dir
    fi
    done
    echo ""
    echo "START apache install"
    az vm run-command invoke --resource-group $rg --name $nome --scripts @apInstall.sh --command-id RunShellScript >/dev/null
    echo "END apache install"
    echo ""
    PS3='#--> '
        echo "Menu scelta installazione PHP"
        select t in "Installazione PHP" "Continua senza PHP";do
        echo "Voce di menu' n. $REPLY"
        case $t in
                ( "Installazione PHP" )
                echo "START php install"
                az vm run-command invoke --resource-group $rg --name $nome --scripts @phInstall.sh --command-id RunShellScript >/dev/null
                echo "END php install."
                break;;
                ( "Continua senza PHP" )
                echo "no php install."
                break;;
        esac
        done

}

function uninstall_apache(){
      echo "Seleziona la VM per la disinstallazione di apache:"
      nome=$(elncovm)
      echo ""
      echo "Seleziona il resource-group della VM appena scelta: "
      rg=$(elncoresourcegroup)
      az vm run-command invoke --resource-group $rg --name $nome --scripts @apUninstall.sh --command-id RunShellScript >/dev/null
}

function menuin(){
    while true;do
        echo ""
        echo "     -----------------------------------------------------------------------------"
        echo "     |                    MENÙ DI INSTALLAZIONE DEI PROGRAMMI                    |"
        echo "     -----------------------------------------------------------------------------"
        echo ""
        echo ""
        echo "   1) Installazione di mysql-sever"
        echo "   2) Disinstallazione di mysql-server"
        echo "   3) Installazione di apache2"
        echo "   4) Disinstallazione di apache2"
        echo "   5) Torna al menù principale"

        read -p " --> " s
        case $s in
            ( 1 )
            install_mysql
            ;;
            ( 2 )
            uninstall_mysql
            ;;
            ( 3 )
            install_apache
            ;;
            ( 4 )
            uninstall_apache
            ;;
            ( 5 )
            break;;
            ( * )
            echo "Scelta non valida";;
        esac
    done
}
