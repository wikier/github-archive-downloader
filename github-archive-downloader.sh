#!/bin/sh

# Copyright 2012 Sergio Fernández <sergio@wikier.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

WGET="wget -t 0 -N"
OUTPUT="archive"
GZIP="gzip -d"
BASE="http://data.githubarchive.org"
EXTENSION="json.gz"

mkdir -p $OUTPUT

download() {
    Y=$1
    if [ ${#2} -lt 2 ];
    then
        M="0$2"
    else
        M="$2"
    fi
    if [ ${#3} -lt 2 ];
    then
        D="0$3"
    else
        D="$3"
    fi
    $WGET -P $OUTPUT $BASE/$Y-$M-$D.$EXTENSION
}

DEFAULT_STARTS="2012-03-11"
DEFAULT_ENDS=$(date +%Y-%m-%d)

unset TEXT
echo -n "Starting date [$DEFAULT_STARTS]: "
read TEXT
if [ -z ${TEXT} ]; 
then
    STARTS=$DEFAULT_STARTS
else
    STARTS=$TEXT
fi
echo "Seting starting date to $STARTS"

unset TEXT
echo -n "Ending date [$DEFAULT_ENDS]: "
read TEXT
if [ -z ${TEXT} ]; 
then
    ENDS=$DEFAULT_ENDS
else
    ENDS=$TEXT
fi
echo "Seting ending date to $ENDS"

#DATE_STARTS=$(date -d $STARTS)
#DATE_ENDS=$(date -d $ENDS)
#if ( $DATE_ENDS < $DATE_STARTS ); 
#then
#    echo "invalid range of dates!"
#    exit
#fi

STARTS_YEAR=`echo $STARTS | awk -F- '{print $1}'`
STARTS_MONTH=`echo $STARTS | awk -F- '{print $2}'`
STARTS_DAY=`echo $STARTS | awk -F- '{print $3}'`
ENDS_YEAR=`echo $ENDS | awk -F- '{print $1}'`
ENDS_MONTH=`echo $ENDS | awk -F- '{print $2}'`
ENDS_DAY=`echo $ENDS | awk -F- '{print $3}'`

for YEAR in $(seq $STARTS_YEAR $ENDS_YEAR);
do
    for DAY in $(seq $STARTS_DAY 30); #FIXME: will fail when the archive has more years
    do
        download $YEAR $STARTS_MONTH $DAY
    done
    for MONTH in $(seq $((STARTS_MONTH+1)) $((ENDS_MONTH-1)));
    do
        for DAY in $(seq 1 30); #FIXME: months with 31
        do
            download $YEAR $MONTH $DAY
        done
    done
    for DAY in $(seq 1 $ENDS_DAY); #FIXME: will fail when the archive has more years
    do
        download $YEAR $ENDS_MONTH $DAY
    done
done 

$GZIP $OUTPUT/*.$EXTENSION

