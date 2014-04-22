# This is a generic wrapper script for running docker containers. 
# All docker apps take one optional common parameter, `dockerImage`. This is the 
# name of the container image that will be run. Additionally, any
# other app-specific parameters may be specified. Notice that all we are
# doing here is setting up local variables to receive the values passed 
# in from the job

DOCKER_IMAGE=${dockerImage}

# In the follow section, you would enter application specific parameters.
# the following are sample parameters for the `wc` app which should be present
# on any linux container

PLL=${printLongestLine}
OUTPUT_FILE=wc_out.txt

# In addition to the common parameter, all docker apps take a single 
# common input file, `dockerFile`, which is also optional. Either the 
# dockerImage or the dockerFile should be specified in order to properly
# run the container. In this example, we only use the dockerImage

#DOCKER_FILE=${dockerFile}

# In the follow section, you would enter application specific input files.
# As with native apps, the input files will be present in the job directory
# when this script is run.

set -x
IFILE=${query1}
LFILE=$(basename ${IFILE})


# Check for existence of input file...
if [ -e input/$FILENAME ]; then
	
	# Build up the arguments string
	ARGS=" -clw"

	if [[ -n $PLL ]]; then
		ARGS="${ARGS}m"
	fi
	
	# Run the container in docker, mounting the current job directory as /scratch in the container
	sudo docker run -i -t -v `pwd`:/scratch:ro centos "wc ${ARGS} ${IFILE} > /scratch/${OUTPUT_FILE}"

	# Good practice would suggest that you clean up your image after running. For throughput
	# you may want to leave it in place. iPlant's docker servers will clean up after themselves
	# using a purge policy based on size, demand, and utilization.

	#sudo docker rmi $DOCKER_IMAGE
fi

# Do some app cleanup just for fun
cp *.ipcexe batch.submit
tar czvf output.tar.gz ${OUTPUT_FILE}

set +x