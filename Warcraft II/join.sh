#!/bin/sh
unamestr=`uname`

if [ -z "$1" ]; then
  echo 'Usage: join.sh GAME'
  exit 1
fi

# TODO change this to the match maker url
matchmaker="137.207.64.83:8080"
ip=$(curl "$matchmaker/join?g=$1")

ping -c 1 "$ip" &> /dev/null
if [[ $? -ne 0 ]]; then
  echo "$1 is not reachable."
  exit 1
fi

tmpfile=$(mktemp ~/dosbox-wc2.XXXXXX)
cp dosjoin.conf $tmpfile
sed -ie "s/%PORT%/1337/g" $tmpfile
sed -ie "s/%ADDRESS%/$ip/g" $tmpfile
if [ "$unamestr" == "Darwin" ]; then
	dosbox -conf $tmpfile
else
	/usr/bin/ltsp-localapps /usr/bin/dosbox -conf $tmpfile
fi
