#!/bin/sh
IFS_BACKUP=${IFS}
IFS=""

echo "#*******************************************************************************#"
echo "#        Do you need a USERNAME and PASSWORD to connect to qBittorrent?         #"
echo "#                            [Y]es or [N]o                                      #"
echo "#*******************************************************************************#"
read -e -p 'input: ' authSelection
if [[ "$authSelection" =~ (y|Y|yes|YES) ]] ; then
	read -e -p  "Username: " USERNAME
	read -e -s -p 'Password: ' PASSWORD
	printf "\n"
fi

echo "#*******************************************************************************#"
echo "#        Is qBittorrent running on a NON-default PORT?                          #"
echo "#                            [Y]es or [N]o                                      #"
echo "#*******************************************************************************#"
read portSelection
if [[ "$portSelection" =~ (y|Y|yes|YES) ]] ; then
	read -e -p "port: " PORT
else 
	PORT=8080
fi
echo "#*******************************************************************************#"
echo "#             Is qBittorrent running on a localhost?                            #"
echo "#					   [if unsure, select YES]								                        	  #"
echo "#                          [Y]es or [N]o                                        #"
echo "#*******************************************************************************#"
read hostSelection
if [[ "$hostSelection" =~ (n|N|no|NO) ]] ; then
	read -e -p "Enter HOST ip or domain name: " HOST      
else
	HOST="localhost"
	
fi
echo "#**********************************************************************************************************************************************#"
echo "#      Enter a directory to be searched for MAGNETLINKS          #"
echo "#**********************************************************************************************************************************************#"
read -e -p 'input: ' searchDirectory

echo "#****************************************************************#"
echo "#      Looking for .magnetLINK files in" $searchDirectory "      #"
echo "#****************************************************************#"
results=( $(find "$searchDirectory" -name "*.magnetLINKqbittorrent") )

echo ""

while read -r results; do
    echo "... $results ..."
    sh $results	"$HOST" "$PORT" "$USERNAME" "$PASSWORD" 
done <<< "$results"
