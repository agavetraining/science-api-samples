Agave Science API Tutorial Samples
=================================

This project contains a collection of JSON sample data that can be used as templates for interacting with the Agave API. By editing the samples and leveraging the CLI, you can quickly bootstrap the users, systems, monitors, and apps you need for your digital lab to start running jobs and managing data quickly.

Requirements
------------

The only requirement to follow along with the included samples is the [Agave CLI](https://bitbucket.org/agaveapi/cli). You can download the Agave CLI [here](https://bitbucket.org/agaveapi/cli):

Installation
------------

No installation is necessary. Just download the Agave CLI and add the bin directory to your classpath and you're ready to go.

```
export PATH=$PATH:/path/to/agave-cli/bin
```

Contents
--------

```
- README.md                         This file
- QUICKSTART.md                     An end-to-end overview of commonly used features
+ apps
    - README.md                     Information on registering apps
    + head-1.00                     A simple head app fully wrapped and ready to register
    + wc-1.00                       A bare bones wc app fully wrapped and ready to register
    + docker                        Sample apps using docker containers for portability and reproducibility
    + bwa-lonestar4-0.7.4           Working example of BWA
+ auth
    - README.md                     Information on authenticating to Agave
+ clients
    - README.md                     Information on obtaining your client keys
    - non-web-client.json           Sample client description for a non-web client application.
    - web-client.json               Sample client description for a web-based application.
+ credentials
    - README.md                     Information on assigning credentials to systems
    + login
        - gsissh-cred.json          Sample gsissh login credential definition with serialized X509 cert
        - gsissh-myproxy.json	    Sample gsissh login credential definition using a standard MyProxy server
        - gsissh-mpg.json           Sample gsissh login credential definition using a MyProxy Gateway server
        - ssh-password.json         Sample password login credential definition for ssh login
        - ssh-keys.json             Sample ssh key login credential definition for ssh login
+ storage
        - gridftp-cred.json         Sample gridftp login credential definition with serialized X509 cert for an irods storage system
        - gridftp-myproxy.json      Sample gridftp login credential definition using a standard MyProxy server for an irods storage system
        - gridftp-mpg.json          Sample gridftp login credential definition using a MyProxy Gateway server for an irods storage system
        - irods-cred.json           Sample X509 login credential definition with serialized X509 cert for an irods storage system
        - irods-myproxy.json        Sample X509 login credential definition using a standard MyProxy server for an irods storage system
        - irods-mpg.json            Sample X509 login credential definition using a MyProxy Gateway server for an irods storage system
        - irods-password.json       Sample password login credential definition for an irods storage system
        - irods-pam.json            Sample pam login credential definition for an irods storage system
        - ssh-password.json         Sample password login credential definition for SFTP access
        - ssh-keys.json             Sample ssh key login credential definition for SFTP access
        - s3.json                   Sample Amazon S3 auth definition for API access
        - ftp.json                  Sample FTP auth definition for API access
        - ftp-anonymous.json        Sample Anonymous FTP auth definition for public ftp servers.
+ files
    - README.md                     Information on managing and moving data
    - picksumipsum.txt              Simple text file used in the examples
+ internal_users
    - README.md                     Information on managing internal users
    - internal_user_basic.json      Bare bones internal user description ready to submit
    - internal_user_full.json       Detailed internal user description ready to submit
+ jobs
    - README.md                     Information on running and managing jobs
    - cloudrunner-submit.json	    Basic job description to generically run your existing application code in the cloud.
    - dockerapp-submit.json         Detailed job description for running a Dockerized science app
    - head-5.97-submit.json         Detailed job description ready to submit
    - wc-1.00-submit.json           Bare bones job description ready to submit
+ metadata
    - README.md                     Information on managing metadata
    - project.json                  Example of creating a "project" metadata object
    - project_note.json             Example of creating a note that can be added to a project
    - complex_meta.json             Structured metadata the validates against the provided schemata
    - schemata.json                 Valid json schema metadata definition
    - simple_meta.json              Simple key-value metadata entry
+ monitors
    - monitor_advanced.json         Full monitor description with multiple nofitications and system status control
    - monitor_basic.json            Bare bones monitor description checking system status and nothing else
    - monitor_with_email.json       Bare bones monitor description that sends email notification when status changes
    - monitor_with_webhook.json     Bare bones monitor description that invokes webhook notification when status changes
+ notifications
    - README.md                     Information on managing notifications
    - email_notif.json              Template for one-off email notifications
    - webhook_notif.json            Template for persistent webhook notifications
+ postits
    - postit_basic.json     	    Bare bones user postit description to create a new postit with default limits and lifetime
    - postit_full.json       	    Detailed postit description with time and rate limits
+ profiles
    - README.md                     Information on managing internal users
    - profile_basic.json     	    Bare bones user profile ready to submit and create a new API user
    - profile_full.json             Detailed user profile ready to submit and create a new API user
+ systems
    + execution
        - README.md                 Information on managing execution systems
        - condor.json               Sample condor system
        - gsissh-cred.json          Sample gsissh system with provided credential
        - gsissh-mpg.json           Sample gsissh system using a myproxy gateway for credential mgmt
        - gsissh-myproxy.json       Sample gsissh system using a standard myproxy server for credential mgmt
        - local.json                Sample execution system that submits jobs to the local system
        - lonestar4.tacc.utexas.edu Copy of the system definition for TACC's Lonestar cluster
        - ssh-password.json         Sample ssh system using password auth
        - ssh-sshkeys.json          Sample ssh system accessible via ssh key authentication
        - ssh-tunnel.json           Sample ssh system using password auth and accessible via proxy tunnel
        - stampede.tacc.utexas.edu  Copy of the system definition for TACC's Stampede cluster
    + storage
        - README.md                 Information on managing storage systems
        - ftp.json                  Sample ftp system using password auth
        - gridftp-cred.json         Sample gridftp system with provided credential
        - gridftp-mpg.json          Sample gridftp system using a myproxy gateway service for credential mgmt
        - gridftp-myproxy.json      Sample gridftp system using a myproxy server for credential mgmt
        - irods-password.json       Sample irods system using native password authentication
        - irods-pam.json            Sample irods system using pam authentication
        - irods-mpg.json            Sample irods system using a myproxy gateway service for credential mgmt
        - irods-password.json       Sample irods system using a myproxy server for credential mgmt
        - local.json                Sample execution system that only interacts with the local file system.
        - sftp-password.json        Sample sftp system using password authentication
        - sftp-sshkeys.json         Sample sftp system using ssh key authentication
        - sftp-tunnel.json          Sample sftp system using password authentication and accessible via proxy tunnel
```