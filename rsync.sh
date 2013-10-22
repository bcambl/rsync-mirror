#!/bin/sh
 
# This script will mirror a directory tree from a local machine to a remote machine.  
# You may re-run the script as needed to keep the two locations syncronized. After
# the first time this script has completed, re-running the script will only transfer 
# files that are new or have changed.
# REMEMBER TO SETUP SSH KEYS FOR PASSWORD-LESS LOGIN.
 
# Destination host machine name
DEST="hostname"
 
# User that rsync will connect as
USER="username"
 
# Directory to copy from on source server.
BACKDIR="/full/path/on/local/"
 
# Directory to copy to on remote server.
DESTDIR="/full/path/on/remote/"
 
# Specify excludes files and directories (default: empty)
EXCLUDES=/full/path/to/excludes
 
# Rsync Options:
# -n Don't do any copying, but display what rsync *would* copy. For testing.
# -a Archive. Mainly propogate file permissions, ownership, timestamp, etc.
# -u Update. Don't copy file if file on destination is newer.
# -v Verbose -vv More verbose. -vvv Even more verbose.
# -l Copies softlink/ symlink files
# -O Omit dir times (avoid it trying to set modification times on directories)
# See man rsync for other options.
 
# For testing.  Only displays what rsync *would* do and does no actual copying.
OPTS="-n -vvv -u -a -l -O --rsh=ssh --exclude-from=$EXCLUDES --stats --progress"
 
# Does copy, but still gives a verbose display of what it is doing
#OPTS="-v -u -a -l -O --rsh=ssh --exclude-from=$EXCLUDES --stats"
 
# Copies and does no display at all.
#OPTS="--archive --update --rsh=ssh --exclude-from=$EXCLUDES --quiet"
 
# Set PATH if used with cron
export PATH=$PATH:/bin:/usr/bin:/usr/local/bin
 
# Only run rsync if $DEST responds.
VAR=`ping -s 1 -c 1 $DEST > /dev/null; echo $?`
if [ $VAR -eq 0 ]; then
    rsync $OPTS $BACKDIR $USER@$DEST:$DESTDIR
else
    echo "Cannot connect to $DEST."
fi
