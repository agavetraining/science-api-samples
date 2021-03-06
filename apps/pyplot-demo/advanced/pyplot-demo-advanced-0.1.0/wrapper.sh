#set -x
WRAPPERDIR=$( cd "$( dirname "$0" )" && pwd )

# The application bundle is already here. We check to see if we need to unpack
# it using the boolean parameter `unpackInputs` passed in.
if [ -n "${unpackInputs}" ]; then

	# multiple datasets could be passed in, unpack each one as needed
	for i in ${dataset}; do

		dataset_extension="${i##*.}"

		if [ "$dataset_extension" == 'zip' ]; then
			unzip "$i"
		elif [ "$dataset_extension" == 'tar' ]; then
			tar xf "$i"
		elif [ "$dataset_extension" == 'gz' ] || [ "$dataset_extension" == 'tgz' ]; then
			tar xzf "$i"
		elif [ "$dataset_extension" == 'bz2' ]; then
			bunzip "$i"
		elif [ "$dataset_extension" == 'rar' ]; then
			unrar "$i"
		elif [ "$dataset_extension" != 'csv' ]; then
			echo "Unable to unpack dataset due to unrecognized file extension, ${dataset_extension}. Terminating job ${AGAVE_JOB_ID}" >&2
			${AGAVE_JOB_CALLBACK_FAILURE}
			exit
		fi

	done

fi

# Run the script with the runtime values passed in from the job request

# iterate over every input file/folder given
for i in `find $WRAPPERDIR -name "*.csv"`; do

	# iterate over every chart type supplied
	for j in ${chartType}; do

		inputfile=$(basename $i)
		outdir="$WRAPPERDIR/output/${inputfile%.*}"
		mkdir -p "$outdir"


		python $WRAPPERDIR/lib/main.py ${showYLabel} ${ylabel} ${showXLabel} ${xlabel} ${showLegend} ${height} ${width} ${background} ${format} ${separateCharts} -v --output-location=$outdir --chart-type=$j $i

		# send a callback notification for subscribers to receive alerts after every chart is generated
		${AGAVE_JOB_CALLBACK_NOTIFICATION}

	done

done
