#set -x
WRAPPERDIR=$( cd "$( dirname "$0" )" && pwd )

# The input file will be staged in for you as part of the job request.
# Here we just sanity check that it exists.
inputfile=${dataset}
if [[ ! -e "$inputfile" ]]; then
	echo "Input file was not found in the job directory" >&2
	exit 1
fi

# Set the dimensions of the chart if specified. Because Agave validates the type
# and value, we know the width and height values are either positive integers or empty
if [[ -n "${height}" ]]; then
	HEIGHT="--height=${height}"
fi

if [[ -n "${width}" ]]; then
	WIDTH="--width=${width}"
fi

# Set the chart properties. Boolean values are passed in as 1 for true or 0 for
# false or empty.
if [[ "${background}" == "1" ]]; then
	BACKGROUND="--background=${showLegend}"
fi

if [[ "${showLegend}" == "1" ]]; then
	SHOW_LEGEND="--show-legend"
fi

if [[ "${separateCharts}" == "1" ]]; then
	SEPARATE_CHARTS="--separate-charts"
fi

if [[ -z "${format}" ]]; then
	IMAGE_FORMAT="--format=png"
fi

# Set the x and y labels. Since we need to quote the values, we check for existence first
# rather than prefixing with an argument defined and passed in from the app description.
if [[ "${showYLabel}" == "1" ]]; then
	if [[ -n "${ylabel}" ]]; then
		X_LABEL="--show-y-label --y-label=${ylabel}"
	fi
fi

if [[ "${showXLabel}" == "1" ]]; then
	if [[ -n "${xlabel}" ]]; then
		X_LABEL="--show-x-label --x-label=${xlabel}"
	fi
fi

# We will drop the output graphs into a standard place
outdir="$WRAPPERDIR/output"
mkdir -p "$outdir"

# Run the script with the runtime values passed in from the job request
python $WRAPPERDIR/lib/main.py ${showYLabel} "${Y_LABEL}" "${X_LABEL}" ${SHOW_LEGEND} ${HEIGHT} ${WIDTH} ${BACKGROUND} ${IMAGE_FORMAT} ${SEPARATE_CHARTS} -v --output-location=$outdir --chart-type=${CHART_TYPE} ${inputFile}
