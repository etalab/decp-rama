#!/bin/bash

source=$1

jq --arg source $source -f $DECP_HOME/scripts/jq/insertSource.jq 
#mv $2.temp $2
