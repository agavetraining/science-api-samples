WRAPPERDIR=$( cd "$( dirname "$0" )" && pwd )

# The input file will be staged in for you as part of the job request.
# Here we just sanity check that it exists.
inputfile=${dataset}
if [[ ! -e "$inputfile" ]]; then
	echo "Input file was not found in the job directory" >&2
	exit 1
fi

# We will drop the output graphs into a standard place
outdir="$WRAPPERDIR/output"
mkdir -p "$outdir"

# Now run the pyplot app with the injected chart type and directory as commandline options
python $WRAPPERDIR/lib/main.py -v --output-location=$outdir --chart-type=${chartType} $inputfile
