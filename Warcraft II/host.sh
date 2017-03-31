#!/bin/sh
unamestr=`uname`
if [ -z "$LTSP_CLIENT" ]; then
	ip=`python getip.py`
else
	ip=$LTSP_CLIENT
fi
matchmaker="137.207.64.83:8080"
curl "$matchmaker/host?ip=$ip&g=$1"

tmpfile=$(mktemp ~/dosbox-wc2.XXXXXX)
cp doshost.conf $tmpfile
sed -ie "s/%PORT%/1337/g" $tmpfile
if [ "$unamestr"=="Darwin" ]; then
        dosbox -conf $tmpfile
else
        /usr/bin/ltsp-localapps /usr/bin/dosbox -conf $tmpfile
fi
