#!/usr/bin/env bash

# Check we have the tools

JQ=$(which jq)
if [ -z "$JQ" ]; then
  echo "Cannot find jq .. please install it and try again"
  exit 1
fi

GREP=$(which grep)
if [ -z "$GREP" ]; then
  echo "Cannot find grep .. please install it and try again"
  exit 1
fi

PS=$(which ps)
if [ -z "$PS" ]; then
  echo "Cannot find ps .. please install it and try again"
  exit 1
fi

CUT=$(which cut)
if [ -z "$CUT" ]; then
  echo "Cannot find cut .. please install it and try again"
  exit 1
fi

UNIQ=$(which uniq)
if [ -z "$UNIQ" ]; then
  echo "Cannot find uniq .. please install it and try again"
  exit 1
fi

CURL=$(which curl )
if [ -z "$CURL" ]; then
  echo "Cannot find curl .. please install it and try again"
  exit 1
fi


# Locate any running shader compilations

STEAMID=$( $PS efax | $GREP -Eo [s]hadercache/[0-9]\* |$CUT -d / -f 2 |$UNIQ)
if [ -z "$STEAMID" ]; then
  echo "Nothing currently compiling"
  exit 0
fi

# Use that ID to scrape the name of the game

APPNAME=$( $CURL -s -L http://store.steampowered.com/api/appdetails?appids=$STEAMID  | $JQ --arg steamkey "$STEAMID" '.["\($steamkey)"].data.name' )


echo "$APPNAME is currently having its Vulcan Shaders compiled"
