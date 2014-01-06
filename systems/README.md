# Agave System Management Tutorial
*******

> This tutorial provides a brief overview of how to use several of the most commonly used features of the [Agave API](http://agaveapi.co) Systems Service. Prior to beginning this tutorial, you should have obtained a valid set of client application credentials. If you have not yet done so, please stop here and walk through the [Agave Authentication Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/auth/README.md) before going any further.


## Introduction  

Welcome to the Agave System Management Tutorial. In this tutorial we will cover how to register, manage, and share systems in the Agave API. This tutorial covers the various data, submission, and authentication protocols supported by Agave. In order to fully test out the systems service and all its implications, you would need to have access to servers with every permutation of supported protocols. Chances are that this is is not the case, so we have written this tutorial in such a way that you can follow along with the concepts, substituting your own protocols and auth scenarios where applicable. 

We provide several sample system descriptions in this folder which you can use as templates for describing your own systems. Simply adding your own authentication information and adding a unique system id is enough to make any of the execution or storage system descriptions valid. 

Once you complete the tutorial you will want do something with your registered systems. Please see the [Agave Data Management Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/files/README.md), [Agave App Management Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/apps/README.md), and [Agave Job Management Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/jobs/README.md) for further information.


## Prerequisites  

This tutorial assumes you have no prior experience with iPlant, system administration, or the Agave API. It assumes you have a basic linux competency and are familiar with things such as your $PATH, cp, ssh, and curl. If you are working on a Windows platform, you should be able to follow along using Git Bash, Cygwin, or win-bash. 

All examples in this tutorial utilize the Agave Command Line Interface ([Agave CLI](https://bitbucket.org/taccaci/foundation-cli)). The Agave CLI is a set of bash scripts that fully exercise the entire Agave API. You can download the latest version of the Agave CLI from Bitbucket using Git. The following commands will download the code and add the commands to your $PATH so you don't need to prefix them with their full path on your file system.

```
#!bash

$ git clone https://bitbucket.org/taccaci/foundation-cli.git
$ export PATH=$PATH:`pwd`/foundation-cli/bin
```

Once you download the Agave CLI and add it to your $PATH, the commands will be available to use from any directory simply by typing the name at the command line. They will also be available via Bash completion.

## Authenticate and get an access token
Lets start out by authenticating to Agave. We do this by retriving an access token (also known as a bearer token) from the Agave OAuth service. The access token will be added to the header of every call you make to Agave. It identifies both your individual identity as well as your client's identity to Agave. 

```
#!bash

$ auth-tokens-create -S -V
Consumer secret []: sdfaYISIDFU213123Qasd556azxcva
Consumer key []: pzfMa8EPgh8z4filrKcBscjMuDXAQa 
Agave tenant username []: nryan
Agave tenant password: 
Calling curl -sku "pzfMa8EPgh8z4filrKcBscjMuDXAQa:XXXXXX" -X POST -d "grant_type=client_credentials&username=nryan&password=XXXXXX&scope=PRODUCTION" -H "Content-Type:application/x-www-form-urlencoded" https://agave.iplantc.org/token
Token successfully refreshed and cached for 3600 seconds
{
    "access_token": "bg1f2f732db7842ccm847b15edt5f0",
    "expires_in": 3600,
    "token_type": "bearer"
}
```

## Finding and managing systems

By default, iPlant provides a shared account on two execution systems at [Texas Advanced Computing Center](http://tacc.utexas.edu) and one on the [Open Science Grid](http://opensciencegrid.org) that you can use freely to run applications. iPlant also provides you a free account on one storage system, the [iPlant Data Store](http://www.iplantcollaborative.org/discover/data-store), which gives you 1 TB of space by default. You can see these systems by querying the systems service.

```
#!bash

$ systems-list -V
Calling curl -sk -H "Authorization: Bearer b64f2f718db7842ddb847b15ed35f0" https://agave.iplantc.org/systems/2.0?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r7f460",
  "result" : [ {
    "id" : "lonestar4.tacc.teragrid.org",
    "name" : "TACC Lonestar",
    "type" : "EXECUTION",
    "description" : "The TACC Dell Linux Cluster (Lonestar) is a powerful, multi-use cyberinfrastructure HPC and remote visualization resource.\\n\\nLonestar contains 22,656 cores within 1,888 Dell PowerEdgeM610 compute blades (nodes), 16 PowerEdge R610 compute-I/Oserver-nodes,...",
    "status" : "UP",
    "public" : true,
    "default" : false,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/lonestar4.tacc.teragrid.org"
      }
    }
  }, {
    "id" : "stampede.tacc.utexas.edu",
    "name" : "TACC Stampede",
    "type" : "EXECUTION",
    "description" : "Stampede is intended primarily for parallel applications scalable to tens of thousands of cores.  Normal batch queues will enable users to run simulations up to 24 hours.  Jobs requiring run times and more cores than allowed by the normal queues will be r...",
    "status" : "UP",
    "public" : true,
    "default" : false,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/stampede.tacc.utexas.edu"
      }
    }
  }, {
    "id" : "data.iplantcollaborative.org",
    "name" : "iPlant Data Store",
    "type" : "STORAGE",
    "description" : "The iPlant Data Store is where your data are stored. The Data Store is cloud-based and is the central repository from which data is accessed by all of iPlant's technologies.",
    "status" : "UP",
    "public" : true,
    "default" : true,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/data.iplantcollaborative.org"
      }
    }
  }, {
    "id" : "condor.opensciencegrid.org",
    "name" : "Open Science Grid",
    "type" : "EXECUTION",
    "description" : "The Open Science Grid (OSG) advances science through open distributed computing. The OSG is a multi-disciplinary partnership to federate local, regional, community and national cyberinfrastructures to meet the needs of research and academic communities at...",
    "status" : "UP",
    "public" : false,
    "default" : false,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/condor.opensciencegrid.org"
      }
    }
  }
```
The response above contains summary information on each system. You can obtain the full detailed description of any system by calling the systems service with the system id. Let's look at OSG's Condor execution system as an example.

```
#!bash

$ systems-list -V condor.opensciencegrid.org
Calling curl -sk -H "Authorization: Bearer b64f2f718db7842ddb847b15ed35f0" https://agave.iplantc.org/systems/2.0/condor.opensciencegrid.org?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r7f460",
  "result" : {
    "id" : "condor.opensciencegrid.org",
    "uuid" : "0001384806792914-5056a550b8-0001-006",
    "name" : "Open Science Grid",
    "status" : "UP",
    "type" : "EXECUTION",
    "description" : "The Open Science Grid (OSG) advances science through open distributed computing. The OSG is a multi-disciplinary partnership to federate local, regional, community and national cyberinfrastructures to meet the needs of research and academic communities at all scales.",
    "site" : "opensciencegrid.org",
    "revision" : 1,
    "public" : false,
    "lastModified" : "2013-11-18T14:33:13.000-06:00",
    "executionType" : "CONDOR",
    "scheduler" : "CONDOR",
    "environment" : "/condor/scratch",
    "startupScript" : "./bashrc",
    "maxSystemJobs" : 2147483647,
    "maxSystemJobsPerUser" : 2147483647,
    "workDir" : "/condor/scratch/",
    "scratchDir" : "/condor/scratch/",
    "queues" : [ {
      "name" : "condorqueue",
      "default" : false,
      "maxJobs" : 5,
      "maxUserJobs" : -1,
      "maxNodes" : -1,
      "maxProcessorsPerNode" : -1,
      "maxMemoryPerNode" : 2,
      "customDirectives" : null
    } ],
    "login" : {
      "host" : "iplant-condor.tacc.utexas.edu",
      "port" : 22,
      "protocol" : "SSH",
      "proxy" : null,
      "auth" : {
        "type" : "PASSWORD"
      }
    },
    "storage" : {
      "host" : "iplant-condor.tacc.utexas.edu",
      "port" : 22,
      "protocol" : "SFTP",
      "rootDir" : "/",
      "homeDir" : "/home/iplant",
      "mirror" : true,
      "proxy" : null,
      "auth" : {
        "type" : "PASSWORD"
      }
    },
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/condor.opensciencegrid.org"
      },
      "roles" : {
        "href" : "https://agave.iplantc.org/systems/2.0/condor.opensciencegrid.org/roles"
      },
      "credentials" : {
        "href" : "https://agave.iplantc.org/systems/2.0/condor.opensciencegrid.org/credentials"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/2.0/data/?q={\"associationIds\":\"0001384806792914-5056a550b8-0001-006\"}"
      }
    }
  }
}
```

The detailed system description above contains 4 areas you should note.  

1. `queues`: this is a list of the queues available on the system. Each queue definition allows you to provide quota information that will be enforced as part of app registration and job submission. In this example, all queue information is provided. The only required information is the queue name.
2. `login`: this is the connectivity information that Agave needs to submit jobs to the execution system. Notice that the actual credentials are not returned from the service.   Agave supports several authentication protocols: SSH, SSH with tunneling, GSISSH, and LOCAL. LOCAL connectivity is only used in conjunction with an Agave On-Premise setup. You do not need to worry about that in this tutuorial. See examples of each configuration in the systems/execution directory.
3. `storage`: this is the connectivity information that Agave needs to move data to and from the system. As with the Login stanza, several protocols are supported: SFTP, SFTP with tunneling, GridFTP, IRODS, FTP, and LOCAL. Again, LOCAL connectivity is only used in conjunction with an Agave On-Premise setup. You do not need to worry about that in this tutuorial. See examples of each configuration in the systems/storage directory.
4. `_links`: Agave is, for the most part, a [hypermedia](http://en.wikipedia.org/wiki/Hypermedia) API. The every response that it gives provides references to the other resources associated with the response object. In the example above, you see references to the object itself and separeate references to the collections of roles, credentials, and metadata associated with the object. This gives you a basic discovery mechanism for navigating the API without need for a separate discovery service.

The system above was an execution system. The other type of system is a storage system. Let's see what a storage system description looks like.

```
#!bash

$ systems-list -V data.iplantcollaborative.org
Calling curl -sk -H "Authorization: Bearer 13547fdf119926ca2b5753681a372249" https://agave.iplantc.org/systems/2.0/data.iplantcollaborative.org?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r7f460",
  "result" : {
    "site" : "iplantcollaborative.org",
    "lastModified" : "2013-11-12T07:08:30.000-06:00",
    "status" : "UP",
    "type" : "STORAGE",
    "id" : "data.iplantcollaborative.org",
    "revision" : 4,
    "default" : true,
    "description" : "The iPlant Data Store is where your data are stored. The Data Store is cloud-based and is the central repository from which data is accessed by all of iPlant's technologies.",
    "name" : "iPlant Data Store",
    "uuid" : "0001384260598633-5056a550b8-0001-006",
    "public" : true,
    "storage" : {
      "mirror" : true,
      "port" : 1247,
      "homeDir" : "/",
      "protocol" : "IRODS",
      "host" : "data.iplantcollaborative.org",
      "proxy" : null,
      "resource" : "bitol",
      "rootDir" : "/iplant/home",
      "auth" : {
        "type" : "PASSWORD"
      },
      "zone" : "iplant"
    },
    "_links" : {
      "roles" : {
        "href" : "https://agave.iplantc.org/systems/2.0/data.iplantcollaborative.org/roles"
      },
      "credentials" : {
        "href" : "https://agave.iplantc.org/systems/2.0/data.iplantcollaborative.org/credentials"
      },
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/data.iplantcollaborative.org"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/2.0/data/?q={\"associationIds\":\"0001384260598633-5056a550b8-0001-006\"}"
      }
    }
  }
}
```

Unlike the OSG Condor system, the description of the iPlant Data Store does not have stanzas for queue or login information. Storage systems are just that, strictly used for storage. Something common to both system descriptions you should notice, however, is the storage stanza. Here, as in the OSG Condor system description, we find a defintion of the `rootDir` and `homeDir`. These fields are important to the utilization of a storage system. They specify the virtual `/` (root) and `~` (home) directories on the remote system. While each storage system has its own root and home directories, you may not want to expose those to the people accessing the system through Agave. You may, instead, want to limit access to a specific user folder or mounted directory. That is the purpose of these accounts. All data requests made to a registered system through Agave are first resolved against the virtual root and home directories given in that system's storage stanza. If you have every configured a FTP server or used the `chroot` command on Linux, this concept should be familiar to you.

You can also narrow your search by specifying a system type, whether it is a your default system, and whether or not it is a public or private system in the url query. The following examples show each scenario.


```

#!bash
$ systems-list -V -E
Calling curl -sk -H "Authorization: Bearer ffd795119c43af953f8b43ebb14839a" https://agave.iplantc.org/systems/2.0/?type=execution&pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r1aa8c",
  "result" : [ {
    "id" : "lonestar4.tacc.teragrid.org",
    "name" : "TACC Lonestar",
    "type" : "EXECUTION",
    "description" : "The TACC Dell Linux Cluster (Lonestar) is a powerful, multi-use cyberinfrastructure HPC and remote visualization resource.\n\nLonestar contains 22,656 cores within 1,888 Dell PowerEdgeM610 compute blades (nodes), 16 PowerEdge R610 compute-I/Oserver-nodes,...",
    "status" : "UP",
    "public" : true,
    "default" : false,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/lonestar4.tacc.teragrid.org"
      }
    }
  }, {
    "id" : "stampede.tacc.utexas.edu",
    "name" : "TACC Stampede",
    "type" : "EXECUTION",
    "description" : "Stampede is intended primarily for parallel applications scalable to tens of thousands of cores.  Normal batch queues will enable users to run simulations up to 24 hours.  Jobs requiring run times and more cores than allowed by the normal queues will be r...",
    "status" : "UP",
    "public" : true,
    "default" : false,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/stampede.tacc.utexas.edu"
      }
    }
  } ]
}
```
This returns all execution systems.

```

#!bash
$ systems-list -V -S
Calling curl -sk -H "Authorization: Bearer ffd795119c43af953f8b43ebb14839a" https://agave.iplantc.org/systems/2.0/?type=storage&pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r1aa8c",
  "result" : [ {
    "id" : "data.iplantcollaborative.org",
    "name" : "iPlant Data Store",
    "type" : "STORAGE",
    "description" : "The iPlant Data Store is where your data are stored. The Data Store is cloud-based and is the central repository from which data is accessed by all of iPlant's technologies.",
    "status" : "UP",
    "public" : true,
    "default" : true,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/data.iplantcollaborative.org"
      }
    }
  } ]
}
```
This returns all storage systems.

```

#!bash
$ systems-list -V -P
Calling curl -sk -H "Authorization: Bearer ffd795119c43af953f8b43ebb14839a" https://agave.iplantc.org/systems/2.0/?public=true&pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r1aa8c",
  "result" : [ {
    "id" : "lonestar4.tacc.teragrid.org",
    "name" : "TACC Lonestar",
    "type" : "EXECUTION",
    "description" : "The TACC Dell Linux Cluster (Lonestar) is a powerful, multi-use cyberinfrastructure HPC and remote visualization resource.\n\nLonestar contains 22,656 cores within 1,888 Dell PowerEdgeM610 compute blades (nodes), 16 PowerEdge R610 compute-I/Oserver-nodes,...",
    "status" : "UP",
    "public" : true,
    "default" : false,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/lonestar4.tacc.teragrid.org"
      }
    }
  }, {
    "id" : "stampede.tacc.utexas.edu",
    "name" : "TACC Stampede",
    "type" : "EXECUTION",
    "description" : "Stampede is intended primarily for parallel applications scalable to tens of thousands of cores.  Normal batch queues will enable users to run simulations up to 24 hours.  Jobs requiring run times and more cores than allowed by the normal queues will be r...",
    "status" : "UP",
    "public" : true,
    "default" : false,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/stampede.tacc.utexas.edu"
      }
    }
  }, {
    "id" : "data.iplantcollaborative.org",
    "name" : "iPlant Data Store",
    "type" : "STORAGE",
    "description" : "The iPlant Data Store is where your data are stored. The Data Store is cloud-based and is the central repository from which data is accessed by all of iPlant's technologies.",
    "status" : "UP",
    "public" : true,
    "default" : true,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/data.iplantcollaborative.org"
      }
    }
  } ]
}
```
This returns all public systems.

```

#!bash
$ systems-list -V -D
Calling curl -sk -H "Authorization: Bearer ffd795119c43af953f8b43ebb14839a" https://agave.iplantc.org/systems/2.0/?default=true&pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r1aa8c",
  "result" : [ {
    "id" : "data.iplantcollaborative.org",
    "name" : "iPlant Data Store",
    "type" : "STORAGE",
    "description" : "The iPlant Data Store is where your data are stored. The Data Store is cloud-based and is the central repository from which data is accessed by all of iPlant's technologies.",
    "status" : "UP",
    "public" : true,
    "default" : true,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/data.iplantcollaborative.org"
      }
    }
  } ]
}
```
This returns the system(s) you have set as your default.

## Adding systems for private use

While iPlant does provide you with several systems you can use, you may want to augment these systems with your own systems or access the iPlant systems, but using your own account. There are two ways to add systems to Agave: cloning and regsitering.

### Cloning a system

The fastest way to add a system is to copy an existing system and rename it for your own personal use. This is the purpose of the clone functionality. 

```
#!bash

$ systems-clone -V stampede.tacc.utexas.edu
Calling curl -sk -H "Authorization: Bearer 13547fdf119926ca2b5753681a372249" -X PUT -d "action=clone&id=stampede-nryan" https://agave.iplantc.org/systems/2.0/stampede.tacc.utexas.edu?pretty=true

{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r${buildNumber}",
  "result" : {
    "id" : "nryan-stampede",
    "uuid" : "0001388520343225-b0b0b0bb0b-0001",
    "name" : "TACC Stampede",
    "status" : "UP",
    "type" : "EXECUTION",
    "description" : "Stampede is intended primarily for parallel applications scalable to tens of thousands of cores.  Normal batch queues will enable users to run simulations up to 24 hours.  Jobs requiring run times and more cores than allowed by the normal queues will be run in a special queue after approval of TACC staff.  Serial and development queues will also be configured. In addition, users will be able to run jobs using thousands of the Intel Xeon Phi coprocessors via the same queues to support massively parallel workflows.",
    "site" : "tacc.xsede.org",
    "revision" : 1,
    "public" : false,
    "lastModified" : "2013-12-31T14:05:43.225-06:00",
    "executionType" : "HPC",
    "scheduler" : "SLURM",
    "environment" : null,
    "startupScript" : "./bashrc",
    "maxSystemJobs" : 2147483647,
    "maxSystemJobsPerUser" : 2147483647,
    "workDir" : "",
    "scratchDir" : "",
    "queues" : [ {
      "name" : "normal",
      "default" : true,
      "maxJobs" : 100,
      "maxUserJobs" : -1,
      "maxNodes" : -1,
      "maxProcessorsPerNode" : -1,
      "maxMemoryPerNode" : 2048,
      "customDirectives" : "#SBATCH -A TG-MCB110022"
    } ],
    "login" : {
      "host" : "stampede.tacc.utexas.edu",
      "port" : 2222,
      "protocol" : "GSISSH",
      "proxy" : null
    },
    "storage" : {
      "host" : "data3.stampede.tacc.utexas.edu",
      "port" : 2811,
      "protocol" : "GRIDFTP",
      "rootDir" : "/",
      "homeDir" : null,
      "mirror" : true,
      "proxy" : null
    },
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/stampede-nryan"
      },
      "roles" : {
        "href" : "https://agave.iplantc.org/systems/2.0/stampede-nryan/roles"
      },
      "credentials" : {
        "href" : "https://agave.iplantc.org/systems/2.0/stampede-nryan/credentials"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/2.0/data/?q={\"associationIds\":\"0001388520343225-b0b0b0bb0b-0001\"}"
      }
    }
  }
}
```

In the example above you the existing Stampede system was cloned for our own use and given the id *nryan-stampede*. System id is arbitrary, but it must be unique. Once it is cloned, we can add our own login and storage credentials to it to login.

### Registering a system

If the system we want to use isn't already present in your list of systems, you can define your own. You can edit the samples in the `execution` and `storage` folder to define your own systems. If you don't have a server avaiable, you can grab a vm from the iPlant's Atmosphere Cloud.

```
#!bash

$ systems-addupdate -V -F systems/storage/sftp-password.json
Calling curl -sk -H "Authorization: Bearer 13547fdf119926ca2b5753681a372249" -X POST -F "fileToUpload=@systems/storage/sftp-password.json" https://agave.iplantc.org/systems/2.0/?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r${buildNumber}",
  "result" : {
    "id" : "demo.storage.example.com",
    "uuid" : "0001388520565047-b0b0b0bb0b-0001-006",
    "name" : "Demo sftp server",
    "status" : "UP",
    "type" : "STORAGE",
    "description" : "My example system using sftp to move data.",
    "site" : "example.com",
    "revision" : 1,
    "public" : false,
    "lastModified" : "2013-12-31T14:09:25.074-06:00",
    "storage" : {
      "host" : "ssh.example.com",
      "port" : 22,
      "protocol" : "SFTP",
      "rootDir" : "/home/demo",
      "homeDir" : "/",
      "mirror" : true,
      "proxy" : null,
      "auth" : {
        "type" : "PASSWORD"
      }
    },
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/demo.storage.example.com"
      },
      "roles" : {
        "href" : "https://agave.iplantc.org/systems/2.0/demo.storage.example.com/roles"
      },
      "credentials" : {
        "href" : "https://agave.iplantc.org/systems/2.0/demo.storage.example.com/credentials"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/2.0/data/?q={\"associationIds\":\"0001388520565047-b0b0b0bb0b-0001-006\"}"
      }
    }
  }
}

```

Now that you have a system registered, it is available to you and you alone. To see how to share your system with one or more other users and grant them various roles on that system, see the *System Permissions* section below.

At this point, take some time testing out the various settings available in the system description such as batch queues, quotas, schedulers, and storage root and home directories.

## Default systems

At the beginning of this tutorial we showed you how to search for systems a variety of ways. One of which was listing only your default systems. Your default systems are what Agave uses when you don't explicitly specify a system when interacting with the other services. For example, when you don't specify a system in the URL for the Files service, Agave assumes you mean your default system and uses that connectivity information and context. When you register an application with the Apps service and don't specify a `deploymentSystem` value, Agave uses your default storage system.

Default systems are optional, but can be extremely handy to use when you will primarily be interacting with a single system. For example, if your application has a single storage system that it uses to store, share, and archive data, setting that as your default storage system can save some time and effort constructing URLs as well as confusion remembering where things are located.

By default (no pun intended) your default storage system is iPlant Data Store (data.iplantcollaborative.org). Since you cannot register applications to run on public systems without special permissions, you do not have a default execution system.

Setting a default system can be done with a single command.

```

#!bash
$ systems-setdefault -V systest-stampede
Calling curl -sk -H "Authorization: Bearer ffd795119c43af953f8b43ebb14839a" -X PUT -d "action=setDefault" https://agave.iplantc.org/systems/2.0/systest-stampede?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r1aa8c",
  "result" : {
    "id" : "systest-stampede",
    "uuid" : "0001388740888728-5056a550b8-0001-006",
    "name" : "TACC Stampede",
    "status" : "UP",
    "type" : "EXECUTION",
    "description" : "Stampede is intended primarily for parallel applications scalable to tens of thousands of cores.  Normal batch queues will enable users to run simulations up to 24 hours.  Jobs requiring run times and more cores than allowed by the normal queues will be run in a special queue after approval of TACC staff.  Serial and development queues will also be configured. In addition, users will be able to run jobs using thousands of the Intel Xeon Phi coprocessors via the same queues to support massively parallel workflows.",
    "site" : "tacc.xsede.org",
    "revision" : 2,
    "public" : false,
    "lastModified" : "2014-01-03T10:13:58.000-06:00",
    "executionType" : "HPC",
    "scheduler" : "SLURM",
    "environment" : null,
    "startupScript" : "./bashrc",
    "maxSystemJobs" : 2147483647,
    "maxSystemJobsPerUser" : 2147483647,
    "workDir" : "",
    "scratchDir" : "",
    "queues" : [ {
      "name" : "normal",
      "default" : false,
      "maxJobs" : 100,
      "maxUserJobs" : -1,
      "maxNodes" : 256,
      "maxProcessorsPerNode" : 16,
      "maxMemoryPerNode" : 2048,
      "customDirectives" : "#SBATCH -A TG-MCB110022"
    }, {
      "name" : "largemem",
      "default" : true,
      "maxJobs" : 100,
      "maxUserJobs" : -1,
      "maxNodes" : 16,
      "maxProcessorsPerNode" : 16,
      "maxMemoryPerNode" : 2048,
      "customDirectives" : "#SBATCH -A TG-MCB110022"
    } ],
    "login" : {
      "host" : "stampede.tacc.utexas.edu",
      "port" : 2222,
      "protocol" : "GSISSH",
      "proxy" : null,
      "auth" : {
        "type" : "X509",
        "server" : {
          "name" : "XSEDE MyProxy Server",
          "endpoint" : "myproxy.teragrid.org",
          "port" : 7512,
          "protocol" : "MYPROXY"
        }
      }
    },
    "storage" : {
      "host" : "gridftp.stampede.tacc.xsede.org",
      "port" : 2811,
      "protocol" : "GRIDFTP",
      "rootDir" : "/home1/00475/dooley",
      "homeDir" : null,
      "mirror" : true,
      "proxy" : null,
      "auth" : {
        "type" : "X509",
        "server" : {
          "name" : "XSEDE MyProxy Server",
          "endpoint" : "myproxy.teragrid.org",
          "port" : 7512,
          "protocol" : "MYPROXY"
        }
      }
    },
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/systest-stampede"
      },
      "roles" : {
        "href" : "https://agave.iplantc.org/systems/2.0/systest-stampede/roles"
      },
      "credentials" : {
        "href" : "https://agave.iplantc.org/systems/2.0/systest-stampede/credentials"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/2.0/data/?q={\"associationIds\":\"0001388740888728-5056a550b8-0001-006\"}"
      }
    }
  }
}
```
Now if we again query for our default systems, we see that our private system nryan-stampede is listed.

```

#!bash
$ systems-list -V -D
Calling curl -sk -H "Authorization: Bearer ffd795119c43af953f8b43ebb14839a" https://agave.iplantc.org/systems/2.0/?default=true&pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r1aa8c",
  "result" : [ {
    "id" : "systest-stampede",
    "name" : "TACC Stampede",
    "type" : "EXECUTION",
    "description" : "Stampede is intended primarily for parallel applications scalable to tens of thousands of cores.  Normal batch queues will enable users to run simulations up to 24 hours.  Jobs requiring run times and more cores than allowed by the normal queues will be r...",
    "status" : "UP",
    "public" : false,
    "default" : false,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/systest-stampede"
      }
    }
  }, {
    "id" : "data.iplantcollaborative.org",
    "name" : "iPlant Data Store",
    "type" : "STORAGE",
    "description" : "The iPlant Data Store is where your data are stored. The Data Store is cloud-based and is the central repository from which data is accessed by all of iPlant's technologies.",
    "status" : "UP",
    "public" : true,
    "default" : true,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/data.iplantcollaborative.org"
      }
    }
  } ]
}
```

## System Roles

Collaborating with others and sharing data is a fundamental concern for Agave. As such, every file, directory, system, job, metadata, schema, etc have access controls built in. By adding and removing access controls on a user-by-user basis, you can control who has access to resources.

You can grant various levels of access to users by assigning them roles on your systems. Available roles are `user`, `publisher`, `admin`, and `owner`. System roles are separate from permissions in other services. Having write permissions on an app will not allow users to publish apps on your system unless they have the `publisher` role on that system. Having read permission on a file will not allow a user to download the file without having a `user` role on the system where the file resides. By default, all users have `user` access on all public storage and execution systems.

Assigning system roles is similar to assigning permissions on other resources. Setting a new user role overwrites the existing role. Assigning an empty role or a role of `none` will remove all user roles on the system.

Let's see what roles are currently on our private system `stampede-nryan`.

```

#!bash
$ systems-roles-list -V systest-stampede
Calling curl -sk -H "Authorization: Bearer ffd795119c43af953f8b43ebb14839a" https://agave.iplantc.org/systems/2.0/systest-stampede/roles/?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r1aa8c",
  "result" : [ {
    "username" : "systest",
    "role" : "ADMIN",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/systest-stampede/roles/systest"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/systems/2.0/systest-stampede"
      },
      "credentials" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/systest"
      }
    }
  } ]
}

```

By default the person who registered the system has owner permission. This cannot be changed or removed. Once you register a system, you own it until it is deleted.

Now let's grant another user access to our system.

```

#!bash
$ systems-roles-addupdate -V -u mock -r user systest-stampede
Calling curl -sk -H "Authorization: Bearer ffd795119c43af953f8b43ebb14839a" -X POST -d "role=user" https://agave.iplantc.org/systems/2.0/systest-stampede/roles/systest?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r1aa8c",
  "result" : [ {
    "username" : "mock",
    "role" : "USER",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/systest-stampede/roles/mock"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/systems/2.0/systest-stampede"
      },
      "credentials" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/mock"
      }
    }
  } ]
}
```
Now user `mock` has `user` role on the system. This allows him to browse files and run jobs.

> Notice that no new authentication credentials were added when we granted someone a role on our system. Granting the user a role does not physically create an account on the remote system, it simply allows them to use an existing system using whatever authentication credentials were used to register the system. If you need to add multiple user credentials to a system, consider creating internal user accounts and assigning individual credentials for each internal user on each system they need access to.

Removing a role is just as you might expect.

```

#!bash
$ systems-roles-addupdate -V -u mock -r none systest-stampede
Calling curl -sk -H "Authorization: Bearer ffd795119c43af953f8b43ebb14839a" -X POST -d "role=none" https://agave.iplantc.org/systems/2.0/systest-stampede/roles/systest?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r1aa8c",
  "result" : [ {
    "username" : "mock",
    "role" : "NONE",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/systest-stampede/roles/mock"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/systems/2.0/systest-stampede"
      },
      "credentials" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/mock"
      }
    }
  } ]
}
```

The response gives the permissions of the user after the update. Listing the system permissions no longer lists user `mock`.


```

#!bash
$ systems-roles-list -V systest-stampede
Calling curl -sk -H "Authorization: Bearer ffd795119c43af953f8b43ebb14839a" https://agave.iplantc.org/systems/2.0/systest-stampede/roles/?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r1aa8c",
  "result" : [ {
    "username" : "systest",
    "role" : "ADMIN",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/2.0/systest-stampede/roles/systest"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/systems/2.0/systest-stampede"
      },
      "credentials" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/systest"
      }
    }
  } ]
}
```