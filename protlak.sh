#!/bin/bash

hosts_file="/etc/hosts"
start_token="## start-gsd"
end_token="## end=gsd"
node_command="node protlakserver.js"

action=$1

site_list=( 'reddit.com'
    'digg.com' 'news.ycombinator.com'
    'infoq.com' 'twitter.com'
    'facebook.com' 'youtube.com'
    'vimeo.com' 'delicious.com' 'flickr.com'
    'linkedin.com'
    'myspace.com' 'slashdot.org' 
    'idnes.cz' 'ihned.cz' 'zdrojak.cz' )

function exit_with_error()
{
    # output to stderr
    echo $1 >&2
    print_help
    exit 1
}

function print_help()
{
    echo Usage: ./`basename $0` "[work | play]"
}

function work()
{
    # check if work mode has been set
    if grep "$start_token" $hosts_file &> /dev/null; then
        if grep "$end_token" $hosts_file &> /dev/null; then
            exit_with_error "Work mode already set."
        fi
    fi

    addSitesToHostsFile
    startSilentMode
    startNode
}

function play()
{
    removeSitesFromHostsFile
    stopSilentMode
    stopNode
}

function addSitesToHostsFile() {
    echo $start_token >> $hosts_file

    for site in "${site_list[@]}"
    do
        echo -e "127.0.0.1\t$site" >> $hosts_file
        echo -e "127.0.0.1\twww.$site" >> $hosts_file
    done

    echo $end_token >> $hosts_file
}



function removeSitesFromHostsFile() {
    # removes $start_token-$end_token section
    # in any place of hosts file (not only in the end)
    sed_script="{
s/$end_token/$end_token/
t finished_sites

s/$start_token/$start_token/
x
t started_sites

s/$start_token/$start_token/
x
t started_sites

p
b end
: started_sites
d
: finished_sites
x
d
: end
d
}"
    sed -i -e "$sed_script" $hosts_file    
}

function startSilentMode() {
	osascript protlakon.scpt
}

function stopSilentMode() {
	osascript protlakoff.scpt
}

function startNode() {
	if [ $(ps aux | grep -e "$node_command\$" | grep -v grep | wc -l | tr -s "\n") -eq 0 ]; then 
        `$node_command` &
    fi
}

function stopNode() {
    pids=`ps -ax | grep -e "$node_command\$" | grep -v grep | awk '{print $1}'`
    for p in $pids; do
        kill $p
    done
}

# check for input parameters
[[ "$#" -eq 0 ]] && exit_with_error "No parameters given"

# run fron root user
# to change hosts file
[ $(whoami) == "root" ] || exit_with_error "Please, run from root"

# if no hosts file found...
[ -e $hosts_file ] || exit_with_error "No hosts file found"

case "$action" in
    "play")
        play; ;;
    "work")
        work; ;;
        *) exit_with_error "Some weird params given" ;;
esac
