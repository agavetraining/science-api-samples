######################################################
#
# PyPlot Demo Dockerfile
# Tag: pyplot-demo
#
# https://bitbucket.org/taccaci/agave-samples
#
# This image contains the pyplot demo app for the Agave
# APIs. It runs as a single executable container taking
# no arguments. You must mount a local volue to the
# /scratch volume within the container to see the outputs.
#
# docker run -it --rm -v `pwd`:/scratch pyplot-demo
#
######################################################

FROM agaveapi/scipy-matplot-2.7

MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

ADD testdata.csv /data/testdata.csv
ADD lib/main.py /data/main.py

WORKDIR /scratch

VOLUME /scratch
ENTRYPOINT [ "python", "/data/main.py", "--chart-type=line", "/data/testdata.csv"]
