# Docker Meme
#
# VERSION       4.9.1
# DOCKER-VERSION        0.8.1
FROM    centos:latest
#FROM	centos-meme4904

MAINTAINER Rion Dooley <dooley@tacc.utexas.edu>

RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

RUN yum -y update

# install build tools
RUN yum -y install tar build-essential gcc libxml2 libxslt gzip python zlib-devel csh

RUN yum -y install openssh-server && ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && echo 'root:changeme' | chpasswd
RUN sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
RUN sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config

# install java
RUN yum -y install java-1.7.0-openjdk
ENV JAVA_HOME /usr/java/default

# Install MEME from source
RUN wget -O meme-4.9.0_4.tar.gz http://ebi.edu.au/ftp/software/MEME/4.9.0/meme_4.9.0_4.tar.gz
RUN tar xzf meme-4.9.0_4.tar.gz ; pwd; ls -al
RUN cd meme_4.9.0; ./configure ; make ; make install

# Import the datasets to run a simulation
RUN mkdir /data
ADD psp.txt /data/psp.txt
ADD Ratio_Top500_Trans.txt /data/Ratio_Top500_Trans.txt

# Run the application
RUN /bin/meme /meme_4.9.0/tests/crp0.s -oc /meme_ext_out -dna -mod oops -pal -dna

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

#ENTRYPOINT ["/bin/meme", "/meme_4.9.0/tests/crp0.s -oc /meme_ext_out -dna -mod oops -pal-dna" ]

