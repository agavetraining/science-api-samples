#!/bin/bash

DIR=$( cd "$( dirname "$0" )" && pwd )

# set test variables
export dataset="$DIR/lib/testdata.csv"
export chartType="bar"

# call wrapper script as if the values had been injected by the API
sh -c ../wrapper.sh
