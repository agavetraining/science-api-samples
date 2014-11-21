#!/bin/bash

DIR=$( cd "$( dirname "$0" )" && pwd )

# set test variables
export dataset="$DIR/lib/testdata.csv"
export chartType="line"
export xlabel="Trade_Date"
export ylabel="Stock_Value"
export showXLabel=1
export showYLabel=1
export showLegend=1
export separateCharts=0
export height=512
export width=1024
export format="png"
export background="#999999"

# call wrapper script as if the values had been injected by the API
sh -c ../wrapper.sh
