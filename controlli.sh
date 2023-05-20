function controresourcegroup(){
	var=$(az group list --query "[].name" -o tsv)
	if [[ "$var" =~ .*[[:space:]]"$1"[[:space:]].* ]];then
		return 1
	else
		return 0
	fi
}

function controllolocation(){
	var=$(az account list-locations --query "[].name" -o tsv | sort)
	if [[ "$var" =~ .*[[:space:]]"$1"[[:space:]].* ]];then
		return 1
	else
		return 0
	fi
}

function controllovm(){
	var=$(az vm list --query "[].name" -o tsv)
	if [[ $var =~ .*[[:space:]]"$1".* ]];then
		return 1
	else
		return 0
	fi
}

function controlloinage(){
	var=$(az vm image list --output table --query "[].urnAlias")
	if [[ "$var" =~ .*[[:space:]]"$1"[[:space:]].* ]];then
		return 1
	else
		return 0
	fi
}


######################

function elncoimmagini(){
    echo "$(date) | elenco immagini">>log.log
    var=$(az vm image list --output tsv --query "[].urnAlias")
    PS3='--> '
    select s in ${var[@]};do
        if [ -n "$var" ]; then
        echo $s
        break
        fi
    done
}

function elncoresourcegroup(){
    echo "$(date) | elenco resource goup">>log.log
    var=$(az group list --query "[].name" -o tsv)
    PS3='--> '
    select s in ${var[@]};do
        if [ -n "$var" ]; then
        echo $s
        break
        fi
    done
}


function elncolocation(){
    echo "$(date) | elenco location">>log.log
    var=$(az account list-locations --query "[].name" -o tsv | sort)
    PS3='--> '
    select s in ${var[@]};do
        if [ -n "$var" ]; then
        echo $s
        break
        fi
    done
}

function elncovm(){
    echo "$(date) | elenco vm">>log.log
    var=$(az vm list --query "[].name" -o tsv)
    PS3='--> '
    select s in ${var[@]};do
        if [ -n "$var" ]; then
        echo $s
        break
        fi
    done
}



