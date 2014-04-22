# This is a generic wrapper script for running docker containers. 
# All docker apps take one required common parameter, `dockerImage`. This is the 
# name of the container image that will be run. Additionally, any
# other app-specific parameters may be specified. Notice that all we are
# doing here is setting up local variables to receive the values passed 
# in from the job

DOCKER_IMAGE=${dockerImage}

# In the follow section, you would enter application specific parameters.

PARAM1=${param1}
PARAM2=${param2}

# In addition to the common parameter, all docker apps take a single 
# optional common input file, `dockerFile`. If given, the docker file will
# be used to build the app. It is important not to include the binary's 
# execution as a RUN step in the Dockerfile as this will cause it to be run
# twice.

DOCKER_FILE=${dockerFile}

if [[ -n $DOCKER_FILE ]]; then
	docker build -rm -t "$DOCKER_IMAGE" "$DOCKER_FILE"
fi

# In the follow section, you would enter application specific input files.
# As with native apps, the input files will be present in the job directory
# when this script is run.

INPUT1=${input1}


# Build up the arguments string
ARGS=""

if [ ${PARAM1} -ne 0 ]; then
	# do something
	ARGS='-a'
fi

if [ -n ${PARAM2} ]; then
	ARGS="$ARGS -l"
fi
	
# Run the container in docker, mounting the current job directory as /scratch in the container
# Note that here the docker container image must exist for the container to run. If it was
# not built using a passed in Dockerfile, then it will be downloaded here prior to 
# invocation. Also note that all output is written to the mounted directory. This allows
# Agave to stage out the data after running.

sudo docker run -i -t -v `pwd`:/scratch:ro $DOCKER_IMAGE "/bin/env ls ${ARGS} input/${INPUT1} > /scratch/output"

# Good practice would suggest that you clean up your image after running. For throughput
# you may want to leave it in place. iPlant's docker servers will clean up after themselves
# using a purge policy based on size, demand, and utilization.

#sudo docker rmi $DOCKER_IMAGE