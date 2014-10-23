set -x

# This is a generic wrapper script for running docker containers.
# All docker apps take one required common parameter, `dockerImage`. This is the
# name of the container image that will be run. Additionally, any
# other app-specific parameters may be specified. Notice that all we are
# doing here is setting up local variables to receive the values passed
# in from the job

DOCKER_IMAGE="${dockerImage}"

# The application bundle is already here. We check to see if we need to unpack
# it using the flag parameter `unpackInputs` passed in.

if [ -n "${unpackInputs}" ]; then
	APP_BUNDLE="${appBundle}"
	app_bundle_extension="${APP_BUNDLE##*.}"

	if [ "$app_bundle_extension" == 'zip' ]; then
		unzip "$APP_BUNDLE"
	elif [ "$app_bundle_extension" == 'tar' ]; then
		tar xf "$APP_BUNDLE"
	elif [ "$app_bundle_extension" == 'gz' ] || [ "$app_bundle_extension" == 'tgz' ]; then
		tar xzf "$APP_BUNDLE"
	elif [ "$app_bundle_extension" == 'bz2' ]; then
		bunzip "$APP_BUNDLE"
	elif [ "$app_bundle_extension" == 'rar' ]; then
		unrar "$APP_BUNDLE"
	else
		echo "Unable to unpack application bundle due to unknown compression extension .${extension}. Terminating job ${AGAVE_JOB_ID}" >&2
		${AGAVE_JOB_CALLBACK_FAILURE}
		exit
	fi
fi

# Fail the job if the build fails
if [ -z "$DOCKER_IMAGE" ]; then
	echo "No Docker image specified or provided. Terminating job ${AGAVE_JOB_ID}" >&2
	${AGAVE_JOB_CALLBACK_FAILURE}
	exit
fi

# Run the container in docker, mounting the current job directory as /scratch in the container
# Note that here the docker container image must exist for the container to run. If it was
# not built using a passed in Dockerfile, then it will be downloaded here prior to
# invocation. Also note that all output is written to the mounted directory. This allows
# Agave to stage out the data after running.

sudo docker run -i -t -v `pwd`:/home/ubuntu/scratch -w /home/ubuntu/scratch $DOCKER_IMAGE 2>> ${AGAVE_JOB_NAME}.err

if [ ! $? ]; then
	echo "Docker process exited with an error status." >&2
	${AGAVE_JOB_CALLBACK_FAILURE}
	exit
fi

# Good practice would suggest that you clean up your image after running. For throughput
# you may want to leave it in place. iPlant's docker servers will clean up after themselves
# using a purge policy based on size, demand, and utilization.

#sudo docker rmi $DOCKER_IMAGE
