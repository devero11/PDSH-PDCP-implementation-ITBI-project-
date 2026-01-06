#!bin/bash

STRING="$1"
USERNAME="$2"
HOSTNAME="$3"

replace(){

rezultat=$(echo "$STRING" | sed -e "s/%u/$USERNAME/g" -e "s/%h/$HOSTNAME/g")

echo "$rezultat"
}


replace
