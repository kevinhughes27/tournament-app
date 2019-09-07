find clients/player_app/* -not -path "*node_modules*" -type f -exec md5sum {} \; | sort -k 2 | md5sum
