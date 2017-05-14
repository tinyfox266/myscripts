#!/bin/bash

#################
# this script is used to download the video embedded in a web page.
# we use the website "www.flv.com" to acquire the real urls of the video.

# usage：
#     get-video.sh <page_containing_video>
#######################

flv_web_addr=$1
flv_dir=$HOME/videos    # the location of the videos
flvcd_page_file=~/tmp/flv_page_file
filetype="mp3\|mp4"

wget -q -O $flvcd_page_file "http://www.flvcd.com/parse.php?format=high&kw=$flv_web_addr"

# get urls of the video pieces
flvurls=($(iconv -f gbk -t utf8 $flvcd_page_file | grep "$filetype" |  sed "s/http/\nhttp/g"  | grep ^http | sed 's/\(^http[^ <"]*\)\(.*\)/\1/g' |grep -v "\.\." |grep -v "|") ) 

echo "hello $flvurls"


# get video title
flvtitle=( "$(iconv -f gbk -t utf8 $flvcd_page_file  | grep "当前解析" | sed 's/.*<\/strong>\(.*\) .*/\1/' | sed 's/ //g')" ) 

echo "hello title: ${flvtitle[0]}"


nr_urls=${#flvurls[@]}

if [ $nr_urls -eq 0 ]
then
    echo "No videos found in this page :("
    exit 1
fi

for ((i=0; i<$nr_urls; i++))
do
    idx=$(printf "%03d" "$i")
    title=${flvtitle}_$idx
    url=${flvurls[$i]}
    suffix=${url##*.}
    echo "title: $title"
    echo "  url: $url"
    wget -U NoSuchBrowser/1.0 -O "$flv_dir/$title.$suffix" $url
done

cd $flv_dir
finaltitle=$(echo ${flvtitle} | sed s/-.*//g)

# merge video pieces into one full video.
mencoder -oac pcm -ovc copy -idx -o $finaltitle.$suffix "$finaltitle"* 
