#!/bin/sh
PRINT_USAGE="Usage: $0 [ -w number | -l ]"
NUMBER=1

while getopts "w:l" opt
do
  case $opt in
    w)
      docker logs -f ycsb${NUMBER}
      ;;
    l)
      docker ps -a -f name=ycsb
      ;;
    \?)
      print_usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))
