source "controlli.sh"

#LOGIN
function login(){
	echo "$(date) | login">>log.log
	az login>/dev/null
}


#LOG OUT
function lgout(){
	read -p "confermi di voler fare il logout (y/n): " clg
	if [[ "$clg" == "y" ]];then
		echo "$(date) | logout">>log.log
		az logout>/dev/null
	fi
}


#START VM
function startvm(){
	echo "$(date) | start VM">>log.log
	echo ""
	echo " ------------"
	echo " | START VM |"
	echo " ------------"
	echo ""
	
	echo "Menù VM: "
	nome=$(elncovm)
	echo ""
	echo "Menù resource-group: "
	rg=$(elncoresourcegroup)
    az vm start --name $nome --resource-group $rg
	
}


#STOP VM
function stopvm(){
	echo ""
	echo "-----------"
	echo "| STOP VM |"
	echo "-----------"
	echo ""
	
	echo "Menù VM: "
	nome=$(elncovm)
	echo ""
	echo "Menù resource-group: "
    rg=$(elncoresourcegroup)
    az vm stop --name $nome --resource-group $rg
}


#REMOVE VM
function rmvm(){
	echo "$(date) | VM REMOVE">>log.log
	echo ""
	echo "-------------"
	echo "| REMOVE VM |"
	echo "-------------"
	echo ""

	echo "Menù VM: "
    nome=$(elncovm)
    echo ""
    echo "Menù resource-group:"
    rg=$(elncoresourcegroup)
	az vm delete --name $nome --resource-group $rg
}


#ELENCO VM
function elencovm(){
	echo "$(date) | VM list">>log.log
	echo ""
	echo " -------------"
	echo " | ELENCO VM |"
	echo " -------------"
	echo ""
	echo "$(date) | elenco VM">>log.log
	az vm list --output table
	echo ""
	echo "NUMERO DI VM PRESENTI: $(az vm list --query "length([])")"
	echo ""
}


function elencoimage(){
	echo "$(date) | image list">>log.log
	echo ""
	echo " -------------------"
	echo " | ELENCO IMAGE OS |"
	echo " -------------------"
	echo ""
	az vm image list --output tsv --query "[].urnAlias"
}


#ELENCO IP
function elencoip(){
	echo "$(date) | elenco ip address">>log.log

	echo ""
	echo "----------------"
	echo "| ELENCO IP VM |"
	echo "----------------"
	echo ""
	az vm list-ip-addresses -o table
}


#ELENCO RESORCE GROUP
function elencorg(){
	echo ""
	echo "-------------------------"
	echo "| ELENCO RESOURCE GROUP |"
	echo "-------------------------"
	echo ""
	echo "$(date) | elenco resource group">>log.log
	az group list --output table	
}


#AGGUINGI RESOURCE GROUP
function addrg(){
	echo ""
	echo "----------------------"
	echo "| ADD RESOURCE GROUP |"
	echo "----------------------"
	echo ""
	echo "$(date) | ADD RESOURCE GROUP">>log.log
	
	read -p "inserisci il nome che si vuole dare al resource-group--> " nrg
	
	echo "Menù location:"
	location=$(elncolocation)
	
	az group create --name $nrg --location $location --output table
}


#REMOVE VM
function rmrg(){
	echo "$(date) | REMOVE RESOURCE GROUP">>log.log
    
	echo ""
	echo "-------------------------"
	echo "| REMOVE RESOURCE GROUP |"
	echo "-------------------------"
	echo ""
	echo "Menù resource-group: "
	rg=$(elncoresourcegroup)
	az group delete --name $rg	
}


function connectvm(){
	 echo "Menù scelta VM: "
    nome=$(elncovm)
    echo ""
    echo "Menù scelta resource-group: "
    rg=$(elncoresourcegroup)
	ip=$(az vm show -d --resource-group $rg --name $nome --query 'publicIps' -o tsv)
    user=$(az vm show -d --resource-group $rg --name $nome --query 'osProfile.adminUsername' -o tsv)

    ssh $user@$ip
}

#REATE VM
function creavm(){
	echo "$(date) | CREATE VM">>log.log

	echo ""
	echo "-------------------"
	echo "|    CREATE VM    |"
	echo "-------------------"
	echo ""

	read -p "inserisci il numero delle vm che vuoi creare -->" nvm

	while true;do
		echo ""
		read -p "nome vm -->" nome
		echo ""
		controllovm $nome
		if [[ $? == 0 ]];then
			break
		else 
			echo "vm esistente"
		fi
	done

	#RESOURCE GROUP
	echo ""
	echo "Menù resource-group: "
	rg=$(elncoresourcegroup)
	
	#IMMAGINE
	echo ""
	echo "Menù image: "
	os=$(elncoimmagini)
	echo ""
	
	#MENÙ RIORITY
	echo " MENU VM PRIVACY"
	echo "1) SSH Keys"
	echo "2) Password and User"
	read -p "-->" s

	case $s in 
		( 1 )
		read -p "confermi la creazione della VM (y/n): " sc
			
		if [[ $sc == "y" ]];then
			echo "$(date) | creazione VM in corso...">>log.log
			indice=0
			while [[ $indice != $nvm ]];do
				indice=$(($indice + 1))
				az vm create -n $nome$indice --resource-group $rg --image $os --public-ip-sku Standard --generate-ssh-keys >/dev/null
				if [[ $? == 0 ]];then
					echo ""
					echo "VM $nome$indice CREATA CON SUCCESSO"
					echo ""
					echo "$(date) | vm created successfull">>log.log
					az vm list-ip-addresses --name $nome$indice --resource-group $rg --output table
				else
					echo "errore nella creazione della VM, riprova"
					echo "$(date) | errore nella creazione della VM">>log.log
				fi
			done
		fi
		;;
		( 2 )
		#NOME UTENTE	
		read -p "nome utente -->" utente

		#PASSWORD
		while true;do
			read -p "password -->" pwd
			read -p "ripetere la password -->" pwd2
			if [[ "$pwd" == "$pwd2" ]] && [[ ${#pwd} -ge 12 ]] && [[ "$pwd" =~ [^a-zA-Z0-9] ]] && [[ "$pwd" =~ [A-Z] ]];then 
				echo "$(date) | password inserita correttamente">>log.log
				echo ""
				echo "password corretta"
				echo ""
				break
			else
				echo "$(date) | password non valida">>log.log
				echo "password non valida"
				echo ""
			fi	
		done

		echo "----------------------------"
		echo ""
		echo "nome: $nome"
		echo "os: $os"
		echo "user: $utente"
		echo ""
		echo "----------------------------"
		echo ""
		read -p "confiermi la creazione della VM (y/n): " sc
			
		if [[ $sc == "y" ]];then
			echo "$(date) | create VM">>log.log
			indice=0
			while [[ $indice != $nvm ]];do
				indice=$(($indice + 1))
				az vm create -n $nome$indice --resource-group $rg --image $os --admin-username $utente --admin-password $pwd --public-ip-sku Standard >/dev/null
				if [[ $? == 0 ]];then
					echo ""
					echo "VM $nome$indice creata con successo"
					echo ""
					echo "$(date) | vm created successfull">>log.log
					az vm list-ip-addresses --name $nome$indice --resource-group $rg --output table
				else
					echo "errore nella creazione della VM, riprova"
					echo "$(date) | errore nella creazione della VM">>log.log
				fi
			done
		fi
		;;

	esac

} 
