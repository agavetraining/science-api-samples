Agave App Management Tutorial
=============================

---

> This tutorial provides a brief overview of how to use several of the most commonly used features of the [Agave API](http://agaveapi.co) Apps service. Prior to beginning this tutorial, you should have obtained a valid set of client application credentials. If you have not yet done so, please stop here and walk through the [Agave Authentication Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/auth/README.md) before going any further.

Introduction
------------

Welcome to the Agave App Management Tutorial. In this tutorial we will cover how to register, publish, share, and execute your binary applications using the Agave API. This tutorial utilizes both public and private systems accessible through Agave. Publishing apps into the public space require admin privileges, so feel free to skip that section if you do not have admin privileges on your tenant.

If you have not registered any systems of your own, please walk through the [Agave System Management Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/systems/README.md) before continuing this tutorial. We will be using the systems you register in this tutorial.

Prerequisites
-------------

This tutorial assumes you have no prior experience with iPlant, system administration, or the Agave API. It assumes you have a basic linux competency and are familiar with things such as your $PATH, cp, ssh, and curl. If you are working on a Windows platform, you should be able to follow along using Git Bash, Cygwin, or win-bash.

All examples in this tutorial utilize the Agave Command Line Interface ([Agave CLI](https://bitbucket.org/taccaci/foundation-cli)). The Agave CLI is a set of bash scripts that fully exercise the entire Agave API. You can download the latest version of the Agave CLI from Bitbucket using Git. The following commands will download the code and add the commands to your $PATH so you don't need to prefix them with their full path on your file system.

```
#!bash

$ git clone https://bitbucket.org/taccaci/foundation-cli.git agave-cli
$ export PATH=$PATH:`pwd`/agave-cli/bin
```

Once you download the Agave CLI and add it to your $PATH, the commands will be available to use from any directory simply by typing the name at the command line.

Authenticate and get an access token
------------------------------------

Lets start out by authenticating to Agave. We do this by retriving an access token (also known as a bearer token) from the Agave OAuth service. The access token will be added to the header of every call you make to Agave. It identifies both your individual identity as well as your client's identity to Agave.

```
#!bash

$ auth-tokens-create -S -V
Consumer secret []: sdfaYISIDFU213123Qasd556azxcva
Consumer key []: pzfMa8EPgh8z4filrKcBscjMuDXAQa
Agave tenant username []: testuser
Agave tenant password:
Calling curl -sku "pzfMa8EPgh8z4filrKcBscjMuDXAQa:XXXXXX" -X POST -d "grant_type=client_credentials&username=testuser&password=XXXXXX&scope=PRODUCTION" -H "Content-Type:application/x-www-form-urlencoded" https://agave.iplantc.org/token
Token successfully refreshed and cached for 3600 seconds
{
    "access_token": "bg1f2f732db7842ccm847b15edt5f0",
    "expires_in": 3600,
    "token_type": "bearer"
}
```

Before we begin...
------------------

Before we dig into our app tutorial, let's cover a few assumptions Agave makes about your app and its execution that may not hold in other execution services and environments.

### Assumptions Agave makes about your app

> Your code works on the execution system or you are able to detect when it does not. 
	
Agave handles the setup, execution, and teardown of your app. It does not attempt to figure out what the resulting logs or output means. Executing an app, to Agave, is fulfilling a takeout order. It does not need to know why the customer wants the food, nor does it really care. It is just there to fill the orders for the people that do want food. Once it leaves the window, its up to the customer to make use of it however they choose.
	
> Your code is already built to run on the execution system, or you will handle building an executable as part of the execution of your app. > 'uff said.

> The default environment of the account used to login to the execution system is what the app will run with unless you tell it differently. 

Many of Agave's users come to us with codes they have been running manually and simply want an easier way to share the app with others, manage data, and leverage the tools provided by the iPlant Discovery Environment or another science gateway. It would be cruel of us to wipe their meticulously crafted environment, so we don't. We assume that whatever you have in place is sufficent and, if not, that you or the consumers of your app will provided the information needed to make it so.

### Notable differences between Agave and other execution services

> Your code can live anywhere 

Agave will stage in all your app's assets prior to execution, so, provided your binaries are compatible, or your code is in an interpreted language, you can build once and run anywhere.
		
> *You* probably care about the scheduler and execution system when you are getting things running, but the users of your app probably don't. 

You know your app as well as anyone else, and you want to see it used as effectively as possible. That's why, when you're getting it running, you may want to know about the execution system, environment, scheduler, data protocols, file system(s), etc that all impact how your app runs. Once you have it running, those things are no longer variables, and the end users of your app probably don't need or want to think about them. You can hide as much or as little of this information from the user as you want. You can also require some or all of this information to be provided by the user when desired.

> You have better things to do with your time that sit at your computer...well, sit at your computer and wait data to transfer, your app to start running, your app to finish running, and data to move back somewhere.

Agave just assumes that's all part of what it means to execute an app, so it handles it all out of the box. When we talk about science-as-a-service, that means handling the setup, execution, and cleanup of a computational experiment as well as the long-term management of its derived data as a basic unit of functionality. Agave assumes you want to think about the science that moves you, rather than the silicon that moves your data, so to that end, app execution is something you can fire and forget about.


Finding and managing apps
-------------------------

By default, iPlant provides a collection of public apps that run on systems at [Texas Advanced Computing Center](http://tacc.utexas.edu) and the [Open Science Grid](http://opensciencegrid.org) that you can use freely to run applications. iPlant also provides you a free account on one storage system, the [iPlant Data Store](http://www.iplantcollaborative.org/discover/data-store), which gives you 1 TB of space by default. You can see these systems by querying the systems service.

```
#!bash

$ systems-list -V
Calling curl -sk -H "Authorization: Bearer b64f2f718db7842ddb847b15ed35f0" https://agave.iplantc.org/systems/v2?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r4081e",
  "result" : [ {
    "id" : "docker.iplantcollaborative.org",
    "name" : "Demo Docker VM",
    "type" : "EXECUTION",
    "description" : "Rodeo VM used for Docker demonstrations and tutorials.",
    "status" : "UP",
    "public" : true,
    "default" : false,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/v2/docker.iplantcollaborative.org"
      }
    }
  }, {
    "id" : "lonestar4.tacc.teragrid.org",
    "name" : "TACC Lonestar (Public)",
    "type" : "EXECUTION",
    "description" : "The TACC Dell Linux Cluster (Lonestar) is a powerful, multi-use cyberinfrastructure HPC and remote visualization resource. Lonestar contains 22,656 cores within 1,888 Dell PowerEdgeM610 compute blades (nodes), 16 PowerEdge R610 compute-I/Oserver-nodes, an...",
    "status" : "UP",
    "public" : true,
    "default" : false,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/v2/lonestar4.tacc.teragrid.org"
      }
    }
  }, {
    "id" : "stampede.tacc.utexas.edu",
    "name" : "TACC Stampede (Public)",
    "type" : "EXECUTION",
    "description" : "Stampede is intended primarily for parallel applications scalable to tens of thousands of cores. Normal batch queues will enable users to run simulations up to 24 hours. Jobs requiring run times and more cores than allowed by the normal queues will be run...",
    "status" : "UP",
    "public" : true,
    "default" : false,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/v2/stampede.tacc.utexas.edu"
      }
    }
  }, {
    "id" : "rodeo.storage.demo",
    "name" : "Demo Storage VM",
    "type" : "STORAGE",
    "description" : "Rodeo VM used for storage demos.",
    "status" : "UP",
    "public" : true,
    "default" : false,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/v2/rodeo.storage.demo"
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
        "href" : "https://agave.iplantc.org/systems/v2/data.iplantcollaborative.org"
      }
    }
  }, {
    "id" : "condor.opensciencegrid.org",
    "name" : "Open Science Grid",
    "type" : "EXECUTION",
    "description" : "The Open Science Grid (OSG) advances science through open distributed computing. The OSG is a multi-disciplinary partnership to federate local, regional, community and national cyberinfrastructures to meet the needs of research and academic communities at...",
    "status" : "UP",
    "public" : true,
    "default" : false,
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/v2/condor.opensciencegrid.org"
      }
    }
  } ]
}
```

The response above contains summary information on each system. You can obtain the full detailed description of any system by calling the systems service with the system id. Let's look at OSG's Condor execution system as an example.

```
#!bash

$ systems-list -V condor.opensciencegrid.org
Calling curl -sk -H "Authorization: Bearer b64f2f718db7842ddb847b15ed35f0" https://agave.iplantc.org/systems/v2/condor.opensciencegrid.org?pretty=true
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
        "href" : "https://agave.iplantc.org/systems/v2/condor.opensciencegrid.org"
      },
      "roles" : {
        "href" : "https://agave.iplantc.org/systems/v2/condor.opensciencegrid.org/roles"
      },
      "credentials" : {
        "href" : "https://agave.iplantc.org/systems/v2/condor.opensciencegrid.org/credentials"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/v2/data/?q={\"associationIds\":\"0001384806792914-5056a550b8-0001-006\"}"
      }
    }
  }
}
```

The detailed system description above contains 4 areas you should note.

1. `queues`: this is a list of the queues available on the system. Each queue definition allows you to provide quota information that will be enforced as part of app registration and job submission. In this example, all queue information is provided. The only required information is the queue name.
2. `login`: this is the connectivity information that Agave needs to submit jobs to the execution system. Notice that the actual credentials are not returned from the service. Agave supports several authentication protocols: SSH, SSH with tunneling, GSISSH, and LOCAL. LOCAL connectivity is only used in conjunction with an Agave On-Premise setup. You do not need to worry about that in this tutuorial. See examples of each configuration in the systems/execution directory.
3. `storage`: this is the connectivity information that Agave needs to move data to and from the system. As with the Login stanza, several protocols are supported: SFTP, SFTP with tunneling, GridFTP, IRODS, FTP, and LOCAL. Again, LOCAL connectivity is only used in conjunction with an Agave On-Premise setup. You do not need to worry about that in this tutuorial. See examples of each configuration in the systems/storage directory.
4. `_links`: Agave is, for the most part, a [hypermedia](http://en.wikipedia.org/wiki/Hypermedia) API. The every response that it gives provides references to the other resources associated with the response object. In the example above, you see references to the object itself and separeate references to the collections of roles, credentials, and metadata associated with the object. This gives you a basic discovery mechanism for navigating the API without need for a separate discovery service.

The system above was an execution system. The other type of system is a storage system. Let's see what a storage system description looks like.

```
#!bash

$ systems-list -V data.iplantcollaborative.org
Calling curl -sk -H "Authorization: Bearer 13547fdf119926ca2b5753681a372249" https://agave.iplantc.org/systems/v2/data.iplantcollaborative.org?pretty=true
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
        "href" : "https://agave.iplantc.org/systems/v2/data.iplantcollaborative.org/roles"
      },
      "credentials" : {
        "href" : "https://agave.iplantc.org/systems/v2/data.iplantcollaborative.org/credentials"
      },
      "self" : {
        "href" : "https://agave.iplantc.org/systems/v2/data.iplantcollaborative.org"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/v2/data/?q={\"associationIds\":\"0001384260598633-5056a550b8-0001-006\"}"
      }
    }
  }
}
```

Unlike the OSG Condor system, the description of the iPlant Data Store does not have stanzas for queue or login information. Storage systems are just that, strictly used for storage. Something common to both system descriptions you should notice, however, is the storage stanza. Here, as in the OSG Condor system description, we find a defintion of the `rootDir` and `homeDir`. These fields are important to the utilization of a storage system. They specify the virtual `/` (root) and `~` (home) directories on the remote system. While each storage system has its own root and home directories, you may not want to expose those to the people accessing the system through Agave. You may, instead, want to limit access to a specific user folder or mounted directory. That is the purpose of these accounts. All data requests made to a registered system through Agave are first resolved against the virtual root and home directories given in that system's storage stanza. If you have every configured a FTP server or used the `chroot` command on Linux, this concept should be familiar to you.

Adding systems for private use
------------------------------

While iPlant does provide you with several systems you can use, you may want to augment these systems with your own systems or access the iPlant systems, but using your own account. There are two ways to add systems to Agave: cloning and regsitering.

### Cloning a system

The fastest way to add a system is to copy an existing system and rename it for your own personal use. This is the purpose of the clone functionality.

```
#!bash

$ systems-clone -V stampede.tacc.utexas.edu
Calling curl -sk -H "Authorization: Bearer 13547fdf119926ca2b5753681a372249" -X PUT -d "action=clone&id=stampede-testuser" https://agave.iplantc.org/systems/v2/stampede.tacc.utexas.edu?pretty=true

{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r${buildNumber}",
  "result" : {
    "id" : "stampede-testuser",
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
        "href" : "https://agave.iplantc.org/systems/v2/stampede-testuser"
      },
      "roles" : {
        "href" : "https://agave.iplantc.org/systems/v2/stampede-testuser/roles"
      },
      "credentials" : {
        "href" : "https://agave.iplantc.org/systems/v2/stampede-testuser/credentials"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/v2/data/?q={\"associationIds\":\"0001388520343225-b0b0b0bb0b-0001\"}"
      }
    }
  }
}


```

In the example above you the existing Stampede system was cloned for our own use and given the name *stampede-testuser*. System name is arbitrary, but it must be unique. Once it is cloned, we can add our own login and storage credentials to it to login.

### Registering a system

If the system we want to use isn't already present in your list of systems, you can define your own. You can edit the samples in the systems/execution and systems/storage folder to define your own system. If you don't have a server avaiable, you can grab a vm from the iPlant's Atmosphere Cloud.

```
#!bash

$ systems-addupdate -V -F systems/storage/sftp-password.json
Calling curl -sk -H "Authorization: Bearer 13547fdf119926ca2b5753681a372249" -X POST -F "fileToUpload=@systems/storage/sftp-password.json" https://agave.iplantc.org/systems/v2/?pretty=true
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
      "rootDir" : "/home/testuser",
      "homeDir" : "/",
      "mirror" : true,
      "proxy" : null,
      "auth" : {
        "type" : "PASSWORD"
      }
    },
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/systems/v2/demo.storage.example.com"
      },
      "roles" : {
        "href" : "https://agave.iplantc.org/systems/v2/demo.storage.example.com/roles"
      },
      "credentials" : {
        "href" : "https://agave.iplantc.org/systems/v2/demo.storage.example.com/credentials"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/v2/data/?q={\"associationIds\":\"0001388520565047-b0b0b0bb0b-0001-006\"}"
      }
    }
  }
}

```

Now that you have a system registered, it is available to you and you alone. To see how to share your system with one or more other users and grant them various roles on that system, see the [System Management Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/systems/README.md).

Moving and managing data
------------------------

The Agave Files service gives you a consistent interface for managing data across multiple storage systems. Let's look at a couple examples of how this works. We will start out by doing a simple directory listing to see what is in our home folder. The iPlant Data Store is a public, shared storage system. Because of this, the registered `rootDir` and `homeDir` are both the folder containing all the individual user home folders. In the following examples, this is why we specify the username in the path.

```
#!bash

$ files-list -V -S data.iplantcollaborative.org testuser
Calling curl -sk -H "Authorization: Bearer 13547fdf119926ca2b5753681a372249" https://agave.iplantc.org/files/v2/listings/system/data.iplantcollaborative.org/testuser?pretty=true
{
    "message": null,
    "result": [
        {
            "_links": {
                "self": {
                    "href": "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser"
                },
                "system": {
                    "href": "https://agave.iplantc.org/systems/v2/data.iplantcollaborative.org"
                }
            },
            "format": "folder",
            "lastModified": "2012-08-03T10:06:08.000-05:00",
            "length": 0,
            "name": ".",
            "path": "testuser",
            "permisssions": "READ",
            "type": "file"
        }
    ],
    "status": "success",
    "version": "2.0.0-SNAPSHOT-r${buildNumber}"
}

```

Now let's upload a file.

```
#!bash

$ files-upload -V -S data.iplantcollaborative.org -F files/picksumipsum.txt testuser
Calling curl -k -H "Authorization: Bearer 13547fdf119926ca2b5753681a372249" -X POST -F "fileToUpload=@files/picksumipsum.txt" https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser?pretty=true
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  4383  100   946  100  3437    136    495  0:00:06  0:00:06 --:--:--     0
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r${buildNumber}",
  "result" : {
    "name" : "picksumipsum.txt",
    "path" : "testuser/picksumipsum.txt",
    "lastModified" : "2012-08-03T10:06:08.000-05:00",
    "length" : 0,
    "permisssions" : "READ",
    "format" : "raw",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/picksumipsum.txt"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/data.iplantcollaborative.org"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/v2/data?q={\"associationIds\":\"0001388523424806-b0b0b0bb0b-0001-002\"}"
      },
      "history" : {
        "href" : "https://agave.iplantc.org/files/v2/history/system/data.iplantcollaborative.org/testuser/picksumipsum.txt"
      }
    }
  }
}

```

And make sure it's there.

```
#!bash

$ files-list -V -S data.iplantcollaborative.org testuser/picksumipsum.txt
Calling curl -sk -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" https://agave.iplantc.org/files/v2/listings/system/data.iplantcollaborative.org/testuser/picksumipsum.txt?pretty=true
{
    "message": null,
    "result": [
        {
            "_links": {
                "history": {
                    "href": "https://agave.iplantc.org/files/v2/history/system/data.iplantcollaborative.org/testuser/picksumipsum.txt"
                },
                "metadata": {
                    "href": "https://agave.iplantc.org/meta/v2/data?q={\"associationIds\":\"0001388523718882-b0b0b0bb0b-0001-002\"}"
                },
                "self": {
                    "href": "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/picksumipsum.txt/picksumipsum.txt"
                },
                "system": {
                    "href": "https://agave.iplantc.org/systems/v2/data.iplantcollaborative.org"
                }
            },
            "format": "raw",
            "lastModified": "2013-12-31T14:57:05.000-06:00",
            "length": 3235,
            "name": "picksumipsum.txt",
            "path": "testuser/picksumipsum.txt",
            "permisssions": "READ",
            "type": "file"
        }
    ],
    "status": "success",
    "version": "2.0.0-SNAPSHOT-r${buildNumber}"
}

```

Now let's copy it to the storage system we registered in the previous section.

```
#!bash

$ files-upload -V -S demo.storage.example.com -F files/picksumipsum.txt
Calling curl -k -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" -X POST -F "fileToUpload=@files/picksumipsum.txt" https://agave.iplantc.org/files/v2/media/system/demo.storage.example.com/?pretty=true
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  4325  100   888  100  3437      9     35  0:01:38  0:01:37  0:00:01     0
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r${buildNumber}",
  "result" : {
    "name" : "picksumipsum.txt",
    "path" : "picksumipsum.txt",
    "lastModified" : "2013-12-31T15:14:31.000-06:00",
    "length" : 4096,
    "permisssions" : "ALL",
    "format" : "raw",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/demo.storage.example.com/picksumipsum.txt"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/demo.storage.example.com"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/v2/data?q={\"associationIds\":\"0001388524468032-b0b0b0bb0b-0001-002\"}"
      },
      "history" : {
        "href" : "https://agave.iplantc.org/files/v2/history/system/demo.storage.example.com/picksumipsum.txt"
      }
    }
  }
}

```

And make sure it's there as well.

```
#!bash

$ files-list -V -S demo.storage.example.com picksumipsum.txt
Calling curl -sk -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" https://agave.iplantc.org/files/v2/listings/system/demo.storage.example.com/picksumipsum.txt?pretty=true
{
    "message": null,
    "result": [
        {
            "_links": {
                "history": {
                    "href": "https://agave.iplantc.org/files/v2/history/system/demo.storage.example.com/picksumipsum.txt"
                },
                "metadata": {
                    "href": "https://agave.iplantc.org/meta/v2/data?q={\"associationIds\":\"0001388524468032-b0b0b0bb0b-0001-002\"}"
                },
                "self": {
                    "href": "https://agave.iplantc.org/files/v2/media/system/demo.storage.example.com/picksumipsum.txt/picksumipsum.txt"
                },
                "system": {
                    "href": "https://agave.iplantc.org/systems/v2/demo.storage.example.com"
                }
            },
            "format": "raw",
            "lastModified": "2013-12-31T15:20:49.000-06:00",
            "length": 3235,
            "name": "picksumipsum.txt",
            "path": "picksumipsum.txt",
            "permisssions": "READ_WRITE",
            "type": "file"
        }
    ],
    "status": "success",
    "version": "2.0.0-SNAPSHOT-r${buildNumber}"
}
```

How about importing data from the web. Pretty much the same thing. We'll tell Agave to go grab a URL and download it for us so we don't need to wait around.

```
#!bash

$ files-import -V -S demo.storage.example.com -U "http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM313800&targ=self&view=full&form=text" -N GSM313800.txt
Calling curl -sk -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" -X POST -d "urlToIngest=http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM313800&targ=self&view=full&form=text" -d "fileName=GSM313800.txt&" https://agave.iplantc.org/files/v2/media/system/demo.storage.example.com/?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r${buildNumber}",
  "result" : {
    "name" : "GSM313800.txt",
    "path" : "",
    "lastModified" : "2013-12-31T15:14:31.000-06:00",
    "length" : -1,
    "permisssions" : "ALL",
    "format" : "raw",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/demo.storage.example.com/GSM313800.txt"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/demo.storage.example.com"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/v2/data?q={\"associationIds\":\"0001388524943090-b0b0b0bb0b-0001-002\"}"
      },
      "history" : {
        "href" : "https://agave.iplantc.org/files/v2/history/system/demo.storage.example.com/GSM313800.txt"
      }
    }
  }
}

```

You can watch the progress of this file by tracking the file's history.

```
#!bash

$ files-history -V -S demo.storage.example.com GSM313800.txt
Calling curl -sk -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" https://agave.iplantc.org/files/v2/history/system/demo.storage.example.com/GSM313800.txt?pretty=true
{
    "message": null,
    "result": [
        {
            "created": "2013-12-31T15:22:23.000-06:00",
            "description": "File/folder queued for staging",
            "status": "STAGING_QUEUED"
        },
        {
            "created": "2013-12-31T15:22:23.000-06:00",
            "description": "File/folder queued for staging",
            "status": "STAGING_QUEUED"
        },
        {
            "created": "2013-12-31T15:22:23.000-06:00",
            "description": "File/folder queued for staging",
            "status": "STAGING_QUEUED"
        },
        {
            "created": "2013-12-31T15:22:31.000-06:00",
            "description": "Transfer in progress",
            "progress": {
                "averageRate": 0,
                "source": "http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM313800",
                "totalActiveTransfers": 0,
                "totalBytes": 0,
                "totalBytesTransferred": 19332,
                "totalFiles": 1
            },
            "status": "STAGING"
        },
        {
            "created": "2013-12-31T15:22:40.000-06:00",
            "description": "Staging completed successfully",
            "status": "STAGING_COMPLETED"
        },
        {
            "created": "2013-12-31T15:22:40.000-06:00",
            "description": "Prepairing file for processing",
            "status": "PREPROCESSING"
        },
        {
            "created": "2013-12-31T15:22:40.000-06:00",
            "description": "Transform completed successfully",
            "status": "TRANSFORMING_COMPLETED"
        },
        {
            "created": "2013-12-31T15:22:40.000-06:00",
            "description": "Your scheduled transfer of http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM313800 completed staging. You can access the raw file on Demo sftp server (demo.storage.example.com) SFTP at /home/testuser/GSM313800.txt or via the API at https://agave.iplantc.org/files/v2//media/system/demo.storage.example.com/GSM313800.txt.",
            "status": "TRANSFORMING_COMPLETED"
        }
    ],
    "status": "success",
    "version": "2.0.0-SNAPSHOT-r${buildNumber}"
}
```

Copying data between systems is just as easy. No need to worry about the fact that the accounts and protocols used by each may be different. Just specify your source file or folder as an Agave URL and the Files service will handle the rest.

```
#!bash

$ files-import -V -U "agave://demo.storage.example.com/GSM313800.txt" -S data.iplantcollaborative.org testuser
Calling curl -sk -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" -X POST -d "urlToIngest=agave://demo.storage.example.com/GSM313800.txt" https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r${buildNumber}",
  "result" : {
    "name" : "GSM313800.txt",
    "path" : "testuser",
    "lastModified" : "2012-08-03T10:06:08.000-05:00",
    "length" : -1,
    "permisssions" : "READ",
    "format" : "raw",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/GSM313800.txt"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/data.iplantcollaborative.org"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/v2/data?q={\"associationIds\":\"0001388525440624-b0b0b0bb0b-0001-002\"}"
      },
      "history" : {
        "href" : "https://agave.iplantc.org/files/v2/history/system/data.iplantcollaborative.org/testuser/GSM313800.txt"
      }
    }
  }
}
```

Sharing your data with another user is as simple as the following command

```
#!bash

$ files-pems-update -V -U rclemens -P READ -S demo.storage.example.com GSM313800.txt
Calling curl -sk -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" -X POST -d "username=rclemens&permission=READ" https://agave.iplantc.org/files/v2/pems/system/demo.storage.example.com/GSM313800.txt?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r${buildNumber}",
  "result" : [ {
    "username" : "rclemens",
    "internalUsername" : "rclemens",
    "permission" : {
      "read" : true,
      "write" : false,
      "execute" : false
    },
    "_links" : {
      "parent" : {
        "href" : "https://agave.iplantc.org/files/v2/pems/system/demo.storage.example.com/GSM313800.txt"
      },
      "profile" : {
        "href" : "https://agave.iplantc.org/profiles/v2/rclemens"
      }
    }
  } ]
}
```

To make your data publicy available, grant the `public` user READ permissions.

```
#!bash

$ files-pems-update -V -U world -P READ -S demo.storage.example.com GSM313800.txt
Calling curl -sk -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" -X POST -d "username=public&permission=READ" https://agave.iplantc.org/files/v2/pems/system/demo.storage.example.com/GSM313800.txt?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r${buildNumber}",
  "result" : [ {
    "username" : "public",
    "internalUsername" : "public",
    "permission" : {
      "read" : true,
      "write" : false,
      "execute" : false
    },
    "_links" : {
      "parent" : {
        "href" : "https://agave.iplantc.org/files/v2/pems/system/demo.storage.example.com/GSM313800.txt"
      },
      "profile" : {
        "href" : "https://agave.iplantc.org/profiles/v2/public"
      }
    }
  } ]
}
```

Your data will be available as a public url.

```
#!bash

curl -O https://agave.iplantc.org/files/v2/download/testuser/system/demo.storage.example.com/GSM313800.txt
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 19332  100 19332    0     0   3635      0  0:00:05  0:00:05 --:--:--  5833
```

Finding app
-----------

Agave's Apps service provides a way for you to discover and manage app. An app can be any executable code from a shell script to a complex workflow. The Apps service gives you a uniform way to describe, discover, and share apps as simple REST services. Let's see what apps are available to us right now.

```
#!bash

$  apps-list -V
Calling curl -sk -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" https://agave.iplantc.org/apps/v2/?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r${buildNumber}",
  "result" : [ {
    "id" : "wc-1.00",
    "name" : "wc",
    "version" : "1.00",
    "revision" : 1,
    "executionHost" : "condor.opensciencegrid.org",
    "shortDescription" : "Count words in a file",
    "public" : false,
    "lastModified" : "2013-11-19T09:49:29.000-06:00",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/apps/v2/wc-1.00"
      }
    }
  } ]
}
```

We see several apps are available to us right off the bat. Let's look at the wc-1.00 app is greater detail.

```
#!bash

$ apps-list -V wc-1.00
Calling curl -sk -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" https://agave.iplantc.org/apps/v2/wc-1.00?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r${buildNumber}",
  "result" : {
    "id" : "wc-1.00",
    "name" : "wc",
    "icon" : null,
    "uuid" : "0001384876168811-b0b0b0bb0b-0001-005",
    "parallelism" : "SERIAL",
    "defaultProcessorsPerNode" : null,
    "defaultMemoryPerNode" : null,
    "defaultNodeCount" : null,
    "defaultMaxRunTime" : null,
    "defaultQueue" : null,
    "version" : "1.00",
    "revision" : 1,
    "public" : false,
    "helpURI" : "http://www.gnu.org/s/coreutils/manual/html_node/wc-invocation.html",
    "label" : "wc condor",
    "shortDescription" : "Count words in a file",
    "longDescription" : "",
    "tags" : [ "gnu", "textutils" ],
    "ontology" : [ "\"http://sswapmeet.sswap.info/algorithms/wc" ],
    "executionType" : "CONDOR",
    "executionSystem" : "condor.opensciencegrid.org",
    "deploymentPath" : "/testuser/applications/wc-1.00",
    "deploymentSystem" : "data.iplantcollaborative.org",
    "templatePath" : "/wrapper.sh",
    "testPath" : "/wrapper.sh",
    "checkpointable" : true,
    "lastModified" : "2013-11-19T09:49:29.000-06:00",
    "modules" : [ "\"load TACC\"", "purge" ],
    "available" : true,
    "inputs" : [ {
      "id" : "query1",
      "value" : {
        "validator" : "",
        "default" : "read1.fq",
        "visible" : true,
        "required" : false
      },
      "details" : {
        "label" : "File to count words in: ",
        "description" : "",
        "visible" : true
      },
      "semantics" : {
        "minCardinality" : 1,
        "ontology" : [ "http://sswapmeet.sswap.info/util/TextDocument" ],
        "fileTypes" : [ "text-0" ]
      }
    } ],
    "parameters" : [ ],
    "outputs" : [ {
      "id" : "outputWC",
      "value" : {
        "validator" : "",
        "default" : "wc_out.txt"
      },
      "details" : {
        "label" : "Text file",
        "description" : "Results of WC"
      },
      "semantics" : {
        "minCardinality" : 1,
        "maxCardinality" : 1,
        "ontology" : [ "http://sswapmeet.sswap.info/util/TextDocument" ],
        "fileTypes" : [ "" ]
      }
    } ],
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/apps/v2/wc-1.00"
      },
      "executionSystem" : {
        "href" : "https://agave.iplantc.org/systems/v2/condor.opensciencegrid.org"
      },
      "storageSystem" : {
        "href" : "https://agave.iplantc.org/systems/v2/data.iplantcollaborative.org"
      },
      "owner" : {
        "href" : "https://agave.iplantc.org/profiles/v2/testuser"
      },
      "permissions" : {
        "href" : "https://agave.iplantc.org/apps/v2/wc-1.00/pems"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/v2/data/?q={\"associationIds\":\"0001384876168811-b0b0b0bb0b-0001-005\"}"
      }
    }
  }
}
```

The detailed app description above contains 3 areas you should note.

1. *default* *: The application defaults of queue, nodes, parameters per node, memory per node, and run time give you the sensible defaults the app publisher provided as a guide when running the app. When these are present, you generally do not need to specify them when you submit a job to run this app.
2. *inputs*: This section contains the descriptions of the inputs needed to run the job. It tells you what fields are required, optional, and provided for you (hidden).
3. *parameters*: This section contains the parameters and command line flags needed to run the app. It tells you the primitive types expected, available values, default values, etc. Like the input descriptions, it also tells you what fields are required, optional, and provided for you (hidden).
4. *_links*: Again with the hypermedia stuff...Here you will find links to the system where this app should run, the system where the app assets actually live, as well as metadata and permissions about this app.

iPlant provided a growing catalog of actively curated apps that run on their public system which are available for use by anyone with an iPlant account. It is also possible for you to register and share your own apps. The process of doing this is covered in depth in the [App Management Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/apps/README.md). We refer you there for more information.

Runing a job
------------

So far we have learned about how to find and create storage and executions systems. We learned how to move data around. We discovered how to find apps we can run. Now it's time to do some work.

Agave handles all the details of orchestrating an app execution for you. You just need to provide it the id of the app you want to run, give the job a name, and specify the inputs and parameters the app needs to run. Optionally, you can tell Agave if and where you want the job results to be archived and subscribe to notifications ()in the form of emails or webhooks) to specific job events.

Two sample job submissions are included in the jobs folder. Let's go ahead and submit one and see what happens.

```
#!bash

$ jobs-submit -V -F jobs/pyplot-demo-advanced_submit.json
```

Running the above command returned a JSON description of the job. The job id is what we really care about now.

### Monitoring job status

Once we submit a job, Agave will handle staging the input files, submitting the job to a remote scheduler, montoring its status, archiving the outputs, and cleaning up after itself. Depending on how busy the execution system is when you submit your job and how large your input and output data is, this can take a while. To track the status of your job, you can use the above job id to query the Jobs service.

```
#!bash

$ jobs-submit -V -F jobs/wc-1.00-submit.json
Calling curl -sk -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" -X POST -F "fileToUpload=@jobs/pyplot-demo-advanced_submit.json" https://agave.iplantc.org/jobs/v2/?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r58f7c",
  "result" : {
    "id" : "0001415036208350-5056a550b8-0001-007",
    "name" : "pyplot-demo test",
    "owner" : "testuser",
    "appId" : "demo-pyplot-demo-advanced-0.1.0u1",
    "executionSystem" : "docker.iplantcollaborative.org",
    "batchQueue" : "debug",
    "nodeCount" : 1,
    "processorsPerNode" : 1,
    "memoryPerNode" : 1.0,
    "maxRunTime" : "24:00:00",
    "archive" : false,
    "retries" : 0,
    "localId" : null,
    "outputPath" : null,
    "status" : "PENDING",
    "submitTime" : "2014-11-03T11:36:48.364-06:00",
    "startTime" : null,
    "endTime" : null,
    "inputs" : {
      "dataset" : "agave://data.iplantcollaborative.org/testuser/inputs/pyplot/testdata.csv"
    },
    "parameters" : {
      "chartType" : "bar",
      "height" : "512",
      "showLegend" : "true",
      "xlabel" : "The X Axis Label",
      "background" : "#d96727",
      "width" : "1024",
      "unpackInputs" : "false",
      "separateCharts" : "false",
      "showXLabel" : "true",
      "ylabel" : "The Y Axis Label",
      "showYLabel" : "true"
    },
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007"
      },
      "app" : {
        "href" : "https://agave.iplantc.org/apps/v2/demo-pyplot-demo-advanced-0.1.0u1"
      },
      "executionSystem" : {
        "href" : "https://agave.iplantc.org/systems/v2/docker.iplantcollaborative.org"
      },
      "archiveData" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/outputs/listings"
      },
      "owner" : {
        "href" : "https://agave.iplantc.org/profiles/v2/testuser"
      },
      "permissions" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/pems"
      },
      "history" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/history"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/v2/data/?q={\"associationIds\":\"0001415036208350-5056a550b8-0001-007\"}"
      },
      "notifications" : {
        "href" : "https://agave.iplantc.org/notifications/v2/?associatedUuid=0001415036208350-5056a550b8-0001-007"
      }
    }
  }
}
```

There is also a way to return just the job status if bandwidth is an issue.

```
#!bash

$ jobs-status -V 0001415036208350-5056a550b8-0001-007
Calling curl -sk -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/status?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r58f7c",
  "result" : {
    "id" : "0001415036208350-5056a550b8-0001-007",
    "status" : "FINISHED",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007"
      }
    }
  }
}
```

For even more detailed information, you can query for the job history. This tracks every event and status change associated with the job.

```
#!bash

$ jobs-history -V 0001415036208350-5056a550b8-0001-007
Calling curl -sk -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/history?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r58f7c",
  "result" : [ {
    "created" : "2014-11-03T11:36:48.000-06:00",
    "status" : "PENDING",
    "description" : "Job accepted and queued for submission."
  }, {
    "created" : "2014-11-03T11:36:49.000-06:00",
    "status" : "PROCESSING_INPUTS",
    "description" : "Attempt 1 to stage job inputs"
  }, {
    "created" : "2014-11-03T11:36:49.000-06:00",
    "status" : "PROCESSING_INPUTS",
    "description" : "Identifying input files for staging"
  }, {
    "created" : "2014-11-03T11:36:50.000-06:00",
    "status" : "STAGING_INPUTS",
    "description" : "Staging agave://data.iplantcollaborative.org/dooley/inputs/pyplot/testdata.csv to remote job directory"
  }, {
    "progress" : {
      "averageRate" : 3212,
      "totalFiles" : 1,
      "source" : "agave://data.iplantcollaborative.org/dooley/inputs/pyplot/testdata.csv",
      "totalActiveTransfers" : 0,
      "totalBytes" : 3212,
      "totalBytesTransferred" : 3212
    },
    "created" : "2014-11-03T11:36:50.000-06:00",
    "status" : "STAGING_INPUTS",
    "description" : "Copy in progress"
  }, {
    "created" : "2014-11-03T11:36:51.000-06:00",
    "status" : "STAGED",
    "description" : "Job inputs staged to execution system"
  }, {
    "created" : "2014-11-03T11:36:55.000-06:00",
    "status" : "SUBMITTING",
    "description" : "Preparing job for submission."
  }, {
    "created" : "2014-11-03T11:36:55.000-06:00",
    "status" : "SUBMITTING",
    "description" : "Attempt 1 to submit job"
  }, {
    "created" : "2014-11-03T11:37:03.000-06:00",
    "status" : "RUNNING",
    "description" : "Job started running"
  }, {
    "created" : "2014-11-03T11:37:08.000-06:00",
    "status" : "CLEANING_UP"
  }, {
    "created" : "2014-11-03T11:37:08.000-06:00",
    "status" : "QUEUED",
    "description" : "HPC job successfully placed into queue"
  }, {
    "created" : "2014-11-03T11:37:46.000-06:00",
    "status" : "CLEANING_UP",
    "description" : "Job completion detected by process monitor."
  }, {
    "created" : "2014-11-03T11:37:47.000-06:00",
    "status" : "FINISHED",
    "description" : "Job completed. Skipping archiving at user request."
  } ]
}
```

### Receiving job notifications

Often times, we don't have time to sit around waiting for a job to complete. There are also times when we want other applications (ours or other people's) to take action once our job completes. In these situations, notifications come in handy. Agave allows you to subscribe to notifications on any event anywhere in the API. The Jobs service has special support for notifications in that it allows you to include them as part of a job submission request. The `jobs/pyplot-demo-advanced_submit.json` job submission example illustrates this.

```
#!JSON

"notifications": [
   	{
   		"url" : "http://requestb.in/11pbi6m1?job_id=${JOB_ID}&status=${JOB_STATUS}",
   		"event": "*",
   		"persistent": true
   	},
   	{
   		"url" : "testuser@mlb.com",
   		"event": "FINISHED"
   	}
]
```

In the example above, the notifications stanza includes two notification objects. The latter provides an email address where a message will be sent with the job details once the job reaches a FINISHED status. The former provides a webhook that utilizes two template variables, `JOB_ID` and `JOB_STATUS`, which will be resolved at run time into the job's id and the job status. Unlike the email notification, no specific event is specified, rather the wildcard charater, `*`, is provided. This tells Agave to send a notification on every job event. The persistent field tells Agave to reuse the notification indefinitely rather than expire it after the first invocation.

### Access job output

Agave handles the archiving and staging of your job data for you by default. Depending on where you told it to stage your data in your job request, it may or may not be easy to remember where to look for your results. To make this easier for you, the Jobs service provides a simple way for you to find and download your output data at any time.

```
#!BASH

$ jobs-output -V  0001415036208350-5056a550b8-0001-007
Calling curl -sk -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/outputs/listings/?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r58f7c",
  "result" : [ {
    "name" : ".agave.archive",
    "path" : "/.agave.archive",
    "lastModified" : "2014-11-03T11:36:55.000-06:00",
    "length" : 122,
    "permission" : "NONE",
    "mimeType" : "application/octet-stream",
    "format" : "unknown",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/outputs/media/.agave.archive"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/docker.iplantcollaborative.org"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007"
      }
    }
  }, {
    "name" : "app.json",
    "path" : "/app.json",
    "lastModified" : "2014-11-03T11:36:55.000-06:00",
    "length" : 7813,
    "permission" : "NONE",
    "mimeType" : "application/octet-stream",
    "format" : "unknown",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/outputs/media/app.json"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/docker.iplantcollaborative.org"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007"
      }
    }
  }, {
    "name" : "lib",
    "path" : "/lib",
    "lastModified" : "2014-11-03T11:36:55.000-06:00",
    "length" : 4096,
    "permission" : "NONE",
    "mimeType" : "text/directory",
    "format" : "folder",
    "type" : "dir",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/outputs/media/lib"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/docker.iplantcollaborative.org"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007"
      }
    }
  }, {
    "name" : "output",
    "path" : "/output",
    "lastModified" : "2014-11-03T11:37:01.000-06:00",
    "length" : 4096,
    "permission" : "NONE",
    "mimeType" : "text/directory",
    "format" : "folder",
    "type" : "dir",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/outputs/media/output"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/docker.iplantcollaborative.org"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007"
      }
    }
  }, {
    "name" : "pyplot-demo-test.err",
    "path" : "/pyplot-demo-test.err",
    "lastModified" : "2014-11-03T11:37:06.000-06:00",
    "length" : 478,
    "permission" : "NONE",
    "mimeType" : "application/octet-stream",
    "format" : "unknown",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/outputs/media/pyplot-demo-test.err"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/docker.iplantcollaborative.org"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007"
      }
    }
  }, {
    "name" : "pyplot-demo-test.out",
    "path" : "/pyplot-demo-test.out",
    "lastModified" : "2014-11-03T11:37:05.000-06:00",
    "length" : 6932,
    "permission" : "NONE",
    "mimeType" : "application/octet-stream",
    "format" : "unknown",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/outputs/media/pyplot-demo-test.out"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/docker.iplantcollaborative.org"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007"
      }
    }
  }, {
    "name" : "pyplot-demo-test.pid",
    "path" : "/pyplot-demo-test.pid",
    "lastModified" : "2014-11-03T11:36:58.000-06:00",
    "length" : 5,
    "permission" : "NONE",
    "mimeType" : "application/octet-stream",
    "format" : "unknown",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/outputs/media/pyplot-demo-test.pid"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/docker.iplantcollaborative.org"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007"
      }
    }
  }, {
    "name" : "pyplot-demo_test.ipcexe",
    "path" : "/pyplot-demo_test.ipcexe",
    "lastModified" : "2014-11-03T11:36:55.000-06:00",
    "length" : 2804,
    "permission" : "NONE",
    "mimeType" : "application/octet-stream",
    "format" : "unknown",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/outputs/media/pyplot-demo_test.ipcexe"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/docker.iplantcollaborative.org"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007"
      }
    }
  }, {
    "name" : "README.txt",
    "path" : "/README.txt",
    "lastModified" : "2014-11-03T11:36:55.000-06:00",
    "length" : 0,
    "permission" : "NONE",
    "mimeType" : "text/plain",
    "format" : "unknown",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/outputs/media/README.txt"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/docker.iplantcollaborative.org"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007"
      }
    }
  }, {
    "name" : "test",
    "path" : "/test",
    "lastModified" : "2014-11-03T11:36:55.000-06:00",
    "length" : 4096,
    "permission" : "NONE",
    "mimeType" : "text/directory",
    "format" : "folder",
    "type" : "dir",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/outputs/media/test"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/docker.iplantcollaborative.org"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007"
      }
    }
  }, {
    "name" : "testdata.csv",
    "path" : "/testdata.csv",
    "lastModified" : "2014-11-03T11:36:49.000-06:00",
    "length" : 3212,
    "permission" : "NONE",
    "mimeType" : "application/octet-stream",
    "format" : "unknown",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/outputs/media/testdata.csv"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/docker.iplantcollaborative.org"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007"
      }
    }
  }, {
    "name" : "wrapper.sh",
    "path" : "/wrapper.sh",
    "lastModified" : "2014-11-03T11:36:55.000-06:00",
    "length" : 1943,
    "permission" : "NONE",
    "mimeType" : "application/x-sh",
    "format" : "unknown",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/outputs/media/wrapper.sh"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/docker.iplantcollaborative.org"
      },
      "parent" : {
        "href" : "https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007"
      }
    }
  } ]
}
```

Downloading the data is just as easy.

```
#!BASH

$ jobs-output -V -P /output/testdata/bar.png -D  0001415036208350-5056a550b8-0001-007
Calling curl -k -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" -o "transfer.tar.gz" https://agave.iplantc.org/jobs/v2/0001415036208350-5056a550b8-0001-007/outputs/media/transfer.tar.gz
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 43821    0 43821    0     0  58892      0 --:--:-- --:--:-- --:--:-- 58899
Successfully downloaded /output/testdata/bar.png from job 0001415036208350-5056a550b8-0001-007 to bar.png
```

Sharing your work with the world
--------------------------------

Often times you will want to share your data, jobs, metadata, etc. with a third party person, service, or application. The sharing permissions built into every Agave service are helpful when the third party has API access as well, but they're less useful when the third party cannot authenticate to Agave and you're not comfortable making your data public to the world. This is why the PostIts service exists.

PostIts are preauthenticated, disposable URLs. Similar to [tinyurl](http://tinyurl.com) or [bit.ly](http://bit.ly), they provide a way for you to create an obfuscated url that references an Agave resource. What differentiates the PostIt service is the ability for you to pre-authenticate the URLS you generate so you gave give external users access to a specific resource using a specific HTTP method (GET, PUT, POST, DELETE) for a fixed number of requests or amount of time without them having to authentiated. Once the PostIt reaches its limits, it expires and is no longer valid. Let's create a postit to the file we uploaded earlier.

```
#!BASH

$ postits-create -V -m 2 https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/picksumipsum.txt
Calling curl -sk -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" -X POST -d "method=GET" -d "url=https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/picksumipsum.txt" https://agave.iplantc.org/postits/v2/?pretty=true
{
	"status": "success",
	"message": "",
	"result": {
		"creator": "dooley",
		"internalUsername": null,
		"authenticated": true,
		"created": "2014-11-03T11:47:07-06:00",
		"expires": "2014-12-03T11:47:07-06:00",
		"remainingUses": 2,
		"postit": "e95750f6968ca031bcfb43588dcc623b",
		"noauth": false,
		"url": "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/picksumipsum.txt",
		"method": "GET",
		"_links": {
			"self": {
				"href": "https://agave.iplantc.org/postits/v2/e95750f6968ca031bcfb43588dcc623b"
			},
			"profile": {
				"href": "https://agave.iplantc.org/profiles/v2/dooley"
			}
		}
	},
	"version": "2.0.0-SNAPSHOT-rb491f"
}
```

This returns a PostIt that we can use 2 times before it expires. Let's test that out.

```
#!BASH

$ curl -sk https://agave.iplantc.org/postits/v2/e95750f6968ca031bcfb43588dcc623b

$ curl -sk https://agave.iplantc.org/postits/v2/e95750f6968ca031bcfb43588dcc623b

$ curl -sk https://agave.iplantc.org/postits/v2/e95750f6968ca031bcfb43588dcc623b
```

PostIts are great to use to email links around, pass to third party services, or use as a convenient way to work securely with third parties you don't trust.

- list systems
- clone app
- edit app json
- register app
- run job
- edit wrapper script
- run job
- clone app
- run job
- share app
- add notifications
