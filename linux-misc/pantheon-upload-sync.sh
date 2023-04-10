#!/bin/bash

##
# PANTHEON FILES UPLOAD/DOWNLOAD
# This requires both terminus via composer and the terminus "pancakes" plugin
#
# 1. Save it as pantheon-upload-sync.sh in your user folder
#
# 2. Add an alias to run it in your ~/.bash_profile or ~/.zshrc (if using zsh):
#    alias pansync='source ~/pantheon-upload-sync.sh'
#
# 3. Navigate to a local Pantheon site directory. This script assumes that the
#    directory name does NOT have PREFIX-, so it is added automatically.
#
# 4. Run pansync in terminal
##

# version
version='2.1'

# Add composer stuff to path (so terminus can work)
export PATH=$PATH:~/vendor/bin

# set current (default) dir
default=${PWD##*/}

# Info
echo ''
echo '+--------------------------+'
echo '|                          |'
echo '|   PANTHEON UPLOAD SYNC   |'
echo '|                          |'
echo '|   Run from site root!    |'
echo '|   Version '$version'     |'
echo '|                          |'
echo '+--------------------------+'

# Manual site name
echo ''
echo 'Manual site name? (blank enter to assume PREFIX-'$default')'
read site

if [ ! $site ]; then
	site=PREFIX-$default
fi

# Get current site ID
export SITE=$(terminus site:info $site --field=ID)

# Get current site framework
export FRAMEWORK=$(terminus site:info $site --field=Framework)

# set local uploads path
if [ $FRAMEWORK == "drupal8" ] || [ $FRAMEWORK = "drupal" ]; then
	files='./sites/default/files/'
elif [ $FRAMEWORK == "wordpress" ]; then
	files='./wp-content/uploads/'
else
	echo 'Incompatible framework '$FRAMEWORK
 	exit
fi

# Get info
echo ''
echo 'Which Pantheon evironment do you want to sync? (dev, test, live, etc)'
read env

echo ''
echo 'Upload or download? (upload, download)'
read action

echo ''
echo 'Open DB connection? (yes, no)'
read dbconnect

# Open db connection
if [ $dbconnect == "yes" ]; then
	terminus pancakes $site.$env --app=sequel
fi

# Do upload or download
if [ $action == "upload" ]; then
	rsync -rLvz --size-only --ipv4 --progress -e 'ssh -p 2222' $files --temp-dir=~/tmp/ $env.$SITE@appserver.$env.$SITE.drush.in:files/
elif [ $action == "download" ]; then
	rsync -rLvz --size-only --ipv4 --progress -e 'ssh -p 2222' $env.$SITE@appserver.$env.$SITE.drush.in:files/ $files
fi
