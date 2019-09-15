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
feel free to make requests for features or report bugs...im just doing this for fun..:>

# Installation
 1. Copy the makeReseedQbittorrent.sh to a place that won't change and is accesible to your qBittorrent install.
 2. Go to Tools->Preferences->Downloads-> select/enable Run External Program On Torrent Completion and enter the
    path to where you placed the makeReseedQbittorrent.sh 
select the file makeDirectoryForSeed.sh

For the reseeder 
Paste the contents of the reseeder to somewhere. Make the file executable. and run it via a terminal
ex: [user@hostname Downloads]$ ./reseeder
