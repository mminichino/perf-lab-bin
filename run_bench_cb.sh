#!/bin/sh
PRINT_USAGE="Usage: $0 -n count"
COUNT=1
DATE=$(date +%m%d%y_%H%M)
CONTAINER="cbperf"
SHELL=0
options=""

while getopts "n:o:c:s" opt
do
  case $opt in
    n)
      COUNT=$OPTARG
      ;;
    o)
      options="$options -o $OPTARG"
      ;;
    c)
      CONTAINER=$OPTARG
      ;;
    s)
      SHELL=1
      ;;
    \?)
      print_usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

if [ "$COUNT" -gt 1 ]; then
   options="$options -m 512"
fi

for n in $(seq 1 $COUNT); do
  [ ! -d $HOME/output${n} ] && mkdir $HOME/output${n}
done

for n in $(seq 1 $COUNT); do
  [ -d $HOME/output${n} ] && mv $HOME/output${n} $HOME/output${n}.$DATE
done

for n in $(seq 1 $COUNT); do
  [ -n "$(docker ps -q -a -f name=ycsb${n})" ] && docker rm ycsb${n}
  if [ "$SHELL" -eq 0 ]; then
    docker run -d -v $HOME/output${n}:/output --network host --name ycsb${n} mminichino/${CONTAINER} /bench/bin/run_cb.sh -b ycsb${n} $options $@
  else
    docker run -it -v $HOME/output${n}:/output --network host --name ycsb${n} mminichino/${CONTAINER} bash
  fi
done
