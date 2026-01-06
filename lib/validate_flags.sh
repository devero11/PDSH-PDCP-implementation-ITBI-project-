#!/bin/bash


parse_args(){
  while getopts ":i:n:" opt; do
    case $opt in
      i) image="$OPTARG" ;;
      n) number="$OPTARG" ;;
      \?) echo "Error: Invalid option -$OPTARG" >&2 exit 1 ;;
      :) echo "Error: Option -$OPTARG requires an argument." >&2 exit 1 ;;
    esac
  done

}

