#!/bin/sh

#---------------------------------------------------------------------------------------------------------------------------#
#		This script is designed to make seeding already downloaded content easier. It does this by saving           		#
#	torrent to the new download directory and creating a magnetLINKqbittorrent shell script that contains everything	   	#
#	needed to easily reseed content, including the .torrent and a mechanism to handle  authentication   					#
#	and remote sessions.																									#
#				Feel free to customise this script as needed. Any suggestions or improvements can be        				#
#				directed to the Github project   qBittorrent-RESEEDER on GITHUB.COM			   								#
#															    															#
#																														    #
#															    															#
#---------------------------------------------------------------------------------------------------------------------------#

## USER entered variables
## The included values are the defaults
QBT_USERNAME="admin"
QBT_PASSWORD="adminadmin"
QBT_HOST_IP=localhost					#change if using non local webui server
QBT_HOST_PORT=8080						# change if using non default host
##  This is where you selected to store your .torrent files, if unsure or not enabled
##  In the GUI, got to Tools->Preferences->Downloads-> select either Copy .torrent files to: OR Copy .torrent files for completed
##  torrents to:  and select a path to where you want your to store you torrents.
##    ex: /home/yourUserName/Documents/TORRENT_STORE
##	Enter that path here within the quotes
TORRENT_STORE=""

QBT_TORRENT_NAME=$1
QBT_SAVE_PATH=$2
QBT_ROOT_PATH=$3
QBT_INFOHASH=$4
QBT_CONTENT_PATH=$5
QBT_FILE_COUNT=$6


##Save Old directory and Create Placeholder for New directory
OLD_DIR="$QBT_SAVE_PATH"
NEW_DIR="$QBT_SAVE_PATH""$QBT_TORRENT_NAME"-DIR

##Check if Current Directory has been Modified by Script
if [[ $OLD_DIR =~ \-DIR ]]
then
	echo " Directory already processed"
	NEW_DIR=$OLD_DIR
else
 	echo "Proceeed, not processed yet"
	## Create New Directory
  		mkdir "$NEW_DIR"
	## Move File/Folder from Old Directory to New Directory
  		mv "$QBT_ROOT_PATH" "$NEW_DIR"
fi

##  Copy torrent from designated .torrent storage directory to download directory
##  ** If unknown, the option must be selected in the qbittorrent/PREFERENCES/Copy .torrent files to:  [PATH to .torrents]
##	or 	qbittorrent/PREFERENCES/Copy .torrent files for completed torrents to:  [PATH to .torrents]
cp $TORRENT_STORE/"$QBT_TORRENT_NAME".torrent "$NEW_DIR"
 
##  Create "torrent name".magnetLINKqbittorrent bash script 
##  Arguments supplied to script
##   1=host ip 2=port 3= username 4=password
cat > "$NEW_DIR"/"$QBT_TORRENT_NAME".magnetLINKqbittorrent <<EOL
#!/bin/sh
name="$QBT_TORRENT_NAME"
TORRENT_HASH="$QBT_INFOHASH"

QBT_HOST="\$1"
QBT_PORT="\$2"
QBT_USERNAME="\$3"
QBT_PASSWORD="\$4" 
currentDIR="\$( cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd )"

cookie_hash=\$((curl -i --header "Referer: http://\$QBT_HOST:\$QBT_PORT" --data-urlencode "username=\$QBT_USERNAME" --data-urlencode "password=\$QBT_PASSWORD" http://\$QBT_HOST:\$QBT_PORT/api/v2/auth/login | grep "set-cookie:" | cut -d';' -f1 | cut -d':' -f2) 2>&1)  
	cookie_hash=\${cookie_hash##* }
	
foundSTRING="\$(curl http://\$QBT_HOST:\$QBT_PORT/api/v2/torrents/info?hashes=\$TORRENT_HASH --cookie "\$cookie_hash")"
declare -a torrentFiles
for file in "\$currentDIR"\/*.torrent
do
    torrentFiles=("\${torrentFiles[@]}" "\$file")
done

if [ "\$foundSTRING" == "[]" ]
then
   for torrent in "\${torrentFiles[@]}"
   do
   	  curl -X POST --form "cookie='\$cookie_hash'" --form "savepath=\$currentDIR"  --form paused=false --form root_folder=true --form "torrents=@\$torrent" http://\$QBT_HOST:\$QBT_PORT/api/v2/torrents/add   
		  curl http://\$QBT_HOST:\$QBT_PORT/api/v2/torrents/recheck?hashes=\$TORRENT_HASH --cookie "\$cookie_hash"
			curl http://\$QBT_HOST:\$QBT_PORT/api/v2/torrents/resume?hashes=\$TORRENT_HASH --cookie "\$cookie_hash"   
   done
   echo \$name" is NOT already loaded in qBittorrent"
else
   curl -X POST --data "cookie='\$cookie_hash'" --data "hashes=\$TORRENT_HASH" --data-urlencode "location=\$currentDIR" http://\$QBT_HOST:\$QBT_PORT/api/v2/torrents/setLocation
   curl http://\$QBT_HOST:\$QBT_PORT/api/v2/torrents/recheck?hashes=\$TORRENT_HASH --cookie "\$cookie_hash"
   curl http://\$QBT_HOST:\$QBT_PORT/api/v2/torrents/resume?hashes=\$TORRENT_HASH --cookie "\$cookie_hash"
   
   echo \$name" already in list, moving to current location."
fi
EOL

## Change to new location in qBittorrent
# login to webui
	cookie_hash=$((curl -i --header "Referer: http://$QBT_HOST_IP:$QBT_HOST_PORT" --data-urlencode "username=$QBT_USERNAME" --data-urlencode "password=$QBT_PASSWORD" http://$QBT_HOST_IP:$QBT_HOST_PORT/api/v2/auth/login | grep "set-cookie:" | cut -d';' -f1 | cut -d':' -f2) 2>&1)  
	cookie_hash=${cookie_hash##* }
	echo "Cookie hash is: " $cookie_hash
	curl -X POST --cookie "$cookie_hash" --data "hashes=$QBT_INFOHASH" --data-urlencode "location=$NEW_DIR" http://$QBT_HOST_IP:$QBT_HOST_PORT/api/v2/torrents/setLocation 
 echo $name" placed its own folder for easy seeding"
