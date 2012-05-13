#!/bin/sh

BASE="wget http://data.githubarchive.org/"
EXTENSION=".json.gz"

DEFAULT_STARTS="2012-03-11"
DEFAULT_ENDS=$(date +%Y-%m-%d)

unset TEXT
echo -n "Starting date [$DEFAULT_STARTS]: "
read TEXT
if [ -z ${TEXT} ]; then
    STARTS=$DEFAULT_STARTS
else
    STARTS=$TEXT
fi
echo "Seting starting date to $STARTS"

unset TEXT
echo -n "Ending date [$DEFAULT_ENDS]: "
read TEXT
if [ -z ${TEXT} ]; then
    ENDS=$DEFAULT_ENDS
else
    ENDS=$TEXT
fi
echo "Seting ending date to $ENDS"















