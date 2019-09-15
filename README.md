# qBittorrent-Reseeder

The purpose of this reseeder shell scripts it to make the adding of previously downloaded material easier.
An added benefit is that if you move your content around and don't want to individually change its location 
in the client, you can just run the reseeder to automatically change it for you. Once you have downloaded 
the content once with the post download script enabled, the .torrent file is copied with a special shell 
script into a folder with the content. The .magnetLINKqbittorrent script can be executed on its own, to seed
the content with the qBittorrent client. Or you can run the reseeder script to simple collect all these
***.magnetLINKqbittorrent files and adds them to be seeded once again or have it current loction in the client
updated.

# Limitations
Because of the nature of the qBittorrent, only the linux version works with these tools. The windows
and mac versions might be supported someday. Access with username and password is also in the works.

# Contact
basecase.fm@gmail.com
feel free to make requests for features or report bugs...im just doing this for fun..   :]

# Installation
 1. Copy the makeReseedQbittorrent.sh and qbittorrent-reseeder.sh to a place that won't change and is accesible to your qBittorrent install.
 2. Go to Tools->Preferences->Downloads-> select/enable Run External Program On Torrent Completion and enter sh 
    followed by the path to where you placed the makeReseedQbittorrent.sh and "%N" "%D" "%R" "%I" "%F" %C.
    ex: sh /home/yourUserName/Documents/makeReseedQbittorrent.sh "%N" "%D" "%R" "%I" "%F" %C
 3. Go to Tools->Preferences->Downloads-> select either Copy .torrent files to: OR Copy .torrent files for completed
    torrents to:  and select a path to where you want your to store you torrents.
    ex: /home/yourUserName/Documents/TORRENT_STORE
    ** Remember this location you will have to enter the path into makeReseedQbittorrent.sh
 4. Open the makeReseedQbittorrent.sh file in your editir of choice and look for the USER entered variables section.
    Enter username and password if desired and host IP and port if you changed them within the client.
    
    That is it. now when a torrent completes, it will be ready for reseeding and automated location management.

# Usage
  A single .magnetLINKqbottorrent file can run from terminal with:
  [userName@hostname ~]$ sh NameOfTorrent.magnetLINKqbitorrent localhost 8080
  this only works for your local instance of qbittorret. Use qbittorrent-reseeder for more complex cases 

# For qbittorrent-reseeder 
  Via the termina, navigate to where you placed qbittorrent-reseeder and run it via
ex: [user@hostname Documents]$ sh ./qbittorrent-reseeder
 follow the prompts and enter where you want to search for content to be processed.
 HINT: after reorganizing your content ie: moving folders around to different drives or catagorizing your stuff in folders
  run the qbittorrent-reseeder to reconnect all your torrent in the clent with their current location.
