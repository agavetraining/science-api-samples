# This is a generic wrapper script for running docker containers. 
# All docker apps take one required common parameter, `dockerImage`. This is the 
# name of the container image that will be run. Additionally, any
# other app-specific parameters may be specified. Notice that all we are
# doing here is setting up local variables to receive the values passed 
# in from the job

DOCKER_IMAGE=${dockerImage}

# In the follow section, you would enter application specific parameters. For this
# generic example, we take two parameters, the command to run within the container
# and any other arguments for that command as a single string.

BINARY_COMMAND="${command}"
BINARY_ARGS="${commandArgs}"

# In addition to the common parameter, all docker apps take a single 
# optional common input file, `dockerFile`. If given, the docker file will
# be used to build the container. It is important not to include the binary's 
# execution as a RUN step in the Dockerfile as this will cause it to be run
# twice.

DOCKER_FILE=${dockerFile}

if [[ -n "$DOCKER_FILE" ]]; then
	docker build -rm -t "$DOCKER_IMAGE" "$DOCKER_FILE"
fi

# In the follow section, you would enter application specific input files.
# As with native apps, the input files will already be present in the job directory
# when this script is run. Here we generically specify a single input file to 
# give you a placeholder for staging a file for your app. Note that in this example
# the input file is simply staged and present in the container's /scratch directory,
# it is not passed into the actual docker run command.

IN1="${input1}"
IN2="${input3}"
IN3="${input2}"
IN4="${input4}"	
IN5="${input5}"

# Run the container in docker, mounting the current job directory as /scratch in the container
# Note that the docker container image must exist for the container to run. If it was
# not built using a passed in Dockerfile, then it will be downloaded here prior to 
# invocation. THIS CAN TAKE SOME TIME. Also note that any output not written to the 
# mounted directory during execution will be lost once the process completes. Any 
# data present in the job directory after execution will (optionally) be staged out 
# for you as part of the archiving process.

sudo docker run -v `pwd`:/scratch:rw ${DOCKER_IMAGE} ${BINARY_COMMAND} ${BINARY_ARGS}

# Good practice would suggest that you clean up your image after running. For better
# throughput, you may want to leave it in place. This will prevent the server from
# having to download the (potentially large) image for every run. If you do nothing 
# here and are running on iPlant servers, they will clean up after themselves using 
# 	a purge policy based on size, demand, and utilization.

#sudo docker rmi $DOCKER_IMAGE