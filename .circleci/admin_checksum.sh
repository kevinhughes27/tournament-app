find clients/admin/* -not -path "*node_modules*" -type f -exec md5sum {} \; | sort -k 2 | md5sum
