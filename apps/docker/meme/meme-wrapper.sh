# This is a wrapper script for the dockerized meme_dooley-4.9.1 app. 
# All docker apps take one required common parameter, `dockerImage`. This is the 
# name of the container image that will be run. Additionally, any
# other app-specific parameters may be specified. Notice that all we are
# doing here is setting up local variables to receive the values passed 
# in from the job

DOCKER_IMAGE=${dockerImage}

# The meme 4.9.1 app supports
# a subset of the arguments and flags of the MEME program. The purpose
# of this app is to illustrate the use of docker in packaging and running 
# meme. To  expand the capability or functionality of this app, please 
# clone this app as necessary.
 
MAXSIZE=${maxsize}
NMOTIFS=${nmotifs}
MOD=${mod}
EVT=${evt}
MINW=${minw}
MAXW=${maxw} 

# If you did not handle conditional logic in the definitions of each 
# of your inputs and parameters, you can do so here. We use the -dna
# flag as an example. The app description defines the dna parameter 
# as a boolean type with argument = "-dna", showArgument = false, 
# and default = true. This means that if the user sets dna = true in 
# the job submission request, a value of "1" will be injected into all 
# ${dna} instances in this script. The conditional block below handles 
# the logic of translating that value into something of interest to this 
# app. 
#
# Another way to handle flag parameters is to set showArgument = true in 
# the dna parameter definition of your app description. Then when a user 
# submitted a job request, the value passed in for ${dna} would be replaced 
# with "-dna" if they set dna = true and "" otherwise. Whichever way you 
# do it is up to you. We mention this here just to give you some options.

if [[ -n ${dna} ]]; then
	DNA="-dna"
fi

# In addition to the common parameter, all docker apps take a single 
# optional common input file, `dockerFile`. If given, the docker file will
# be used to build the app. It is important not to include the binary's 
# execution as a RUN step in the Dockerfile as this will cause it to be run
# twice.

DOCKER_FILE=${dockerFile}

if [[ -n $DOCKER_FILE ]]; then
	sudo docker build -rm -t "$DOCKER_IMAGE" "$DOCKER_FILE"
fi

# In the follow section, you would enter application specific input files.
# As with native apps, the input files will be present in the job directory
# when this script is run.

DATASET_FILE=${dataset}
PSP_FILE=${psp}

# Run the container in docker, mounting the current job directory as /scratch in the container
# Note that here the docker container image must exist for the container to run. If it was
# not built using a passed in Dockerfile, then it will be downloaded here prior to 
# invocation. Also note that all output is written to the mounted directory. This allows
# Agave to stage out the data after running.

sudo docker run -i -t -v `pwd`:/scratch:ro $DOCKER_IMAGE "/bin/meme $DATASET_FILE -oc meme_ext_out $DNA -psp $PSP_FILE -maxsize ${MAXSIZE} -nmotifs ${NMOTIFS} -mod ${MOD} -evt ${EVT} -minw ${MINW} -maxw ${MAXW}"


# Good practice would suggest that you clean up your image after running. For throughput
# you may want to leave it in place. iPlant's docker servers will clean up after themselves
# using a purge policy based on size, demand, and utilization.

#sudo docker rmi $DOCKER_IMAGE

# keep this file around for reference after running
cat $0 >> *.agave.archive