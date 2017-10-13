#!/bin/bash
# Get transmission credentials
auth=user:password
while true
do
sleep 1
add_trackers () {
    torrent_hash=$1
    id=$2
for base_url in https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt https://hastebin.com/raw/bererufibu ; do
    echo -e "\e[1m\e[5m"
    echo "URL for ${base_url}"
    echo -e "Adding trackers for \e[91m$torrent_name..."
    echo -en "\e[0m"
    echo -e "\e[2m\e[92m"
for tracker in $(curl -# "${base_url}") ; do
    echo -en "\e[0m"
    echo -ne "\e[93m*\e[0m ${tracker}..."
if transmission-remote  --auth="$auth" --torrent "${torrent_hash}" -td "${tracker}" | grep -q 'success'; then
    echo -e '\e[91m failed.'
    echo -en "\e[0m"
else
    echo -e '\e[92m done.'
    echo -en "\e[0m"
fi
 done
done
sleep 5m
rm /tmp/TTAA.$id
}
# Get list of active torrents
    ids="$(transmission-remote --auth="$auth" --list | grep -E 'Downloading' | grep '^ ' | awk '{ print $1 }')"
    for id in $ids ; do
add_date="$(transmission-remote --auth="$auth"  --torrent "$id" --info| grep '^  Date added: ' |cut -c 21-)"
add_date_t="$(date -d "$add_date" "+%Y-%m-%d %H:%M")"
dater="$(date "+%Y-%m-%d %H:%M")"
dateo="$(date -d "1 minutes ago" "+%Y-%m-%d %H:%M")"

if [ ! -f /tmp/TTAA.$id ]; then
#if [[ $add_date_t == $dater ]]; then
if [[ ( "$add_date_t" == "$dater" || "$add_date_t" == "$dateo" ) ]]; then
    hash="$(transmission-remote --auth="$auth"  --torrent "$id" --info | grep '^  Hash: ' | awk '{ print $2 }')"
    torrent_name="$(transmission-remote --auth="$auth"  --torrent "$id" --info | grep '^  Name: ' |cut -c 9-)"
    add_trackers "$hash" "$id" &
    touch /tmp/TTAA.$id
fi
fi
done
done
