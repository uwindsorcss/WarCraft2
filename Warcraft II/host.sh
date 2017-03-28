#!/bin/sh
unamestr=`uname`

ip=$(ifconfig | perl -nle 's/inet (\S+)/print $1/e' | grep -v 127.0.0.1 | head -n 1)
# TODO: change this to the match maker IP
matchmaker="10.243.59.165:8080"
curl "$matchmaker/host?ip=$ip&g=$1"

tmpfile=$(mktemp /tmp/dosbox-wc2.XXXXXX)
cp ./dosbox-wc2-host.conf $tmpfile
sed -ie "s/%PORT%/1337/g" $tmpfile
dosbox -conf $tmpfile
