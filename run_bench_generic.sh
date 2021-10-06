#!/bin/sh
PRINT_USAGE="Usage: $0 -n count -p program"
COUNT=1
PROGRAM=""
DATE=$(date +%m%d%y_%H%M)

while getopts "n:p:" opt
do
  case $opt in
    n)
      COUNT=$OPTARG
      ;;
    p)
      PROGRAM=$OPTARG
      ;;
    \?)
      print_usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

if [ -z "$PROGRAM" ]; then
   echo "Nothing to run, exiting."
   exit
fi

for n in $(seq 1 $COUNT); do
  [ ! -d $HOME/output${n} ] && mkdir $HOME/output${n}
done

for n in $(seq 1 $COUNT); do
  [ -d $HOME/output${n} ] && mv $HOME/output${n} $HOME/output${n}.$DATE
done

for n in $(seq 1 $COUNT); do
  docker run -d -v $HOME/output${n}:/output --network host mminichino/ycsb $PROGRAM -n ${n} $@
done
