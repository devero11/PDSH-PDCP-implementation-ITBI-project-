#!/bin/bash


replace_names(){
  STRING="$2"
  USERNAME="${1%@*}"
  HOSTNAME="${1#*@}"
  STRING=$(echo "$STRING" | sed -e "s/%u/$USERNAME/g" -e "s/%h/$HOSTNAME/g")
}

