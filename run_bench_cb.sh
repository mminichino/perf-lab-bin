#!/bin/sh
PRINT_USAGE="Usage: $0 -n count"
COUNT=1
options=""

while getopts "n:" opt
do
  case $opt in
    n)
      COUNT=$OPTARG
      ;;
    \?)
      print_usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

if [ "$COUNT" -gt 1 ]; then
   options="-m 512"
fi

for n in $(seq 1 $COUNT); do
  [ ! -d $HOME/output${n} ] && mkdir $HOME/output${n}
done

for n in $(seq 1 $COUNT); do
  docker run -d -v $HOME/output${n}:/output --network host mminichino/ycsb /bench/bin/run_cb.sh -b ycsb${n} $options $@
done
