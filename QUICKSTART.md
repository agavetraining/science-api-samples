# Agave Samples Quickstart Tutorial
==============================

<div style="padding:10px; background: #0298c3; color:#FFF">This tutorial provides a brief overview of how to use several of the most commonly used features of the <a href="http://agaveapi.co">Agave API</a>. For more in-depth coverage of individual topics, please consult the tutorials found in the subfolders of the Agave Samples project. Each of those tutorials provides more detailed examples of interacting with a specific Agave service along with working sample data.</div>

## Introduction  

Welcome to the Agave Samples Quickstart Tutorial. In this tutorial we will cover the basic steps needed to get an account, create your own virutal data center, move data into, out of, and between storage systems within your data center, run and track jobs, and share those results with other people. 

## Prerequisites  

This tutorial assumes you have no prior experience with iPlant, system administration, or the Agave API. It assumes you have a basic linux competency and are familiar with things such as your $PATH, cp, ssh, and curl. If you are working on a Windows platform, you should be able to follow along using Git Bash, Cygwin, or win-bash. 

All examples in this tutorial utilize the Agave Command Line Interface ([Agave CLI](https://bitbucket.org/taccaci/foundation-cli)). The Agave CLI is a set of bash scripts that fully exercise the entire Agave API. You can download the latest version of the Agave CLI from Bitbucket using Git. The following commands will download the code and add the commands to your $PATH so you don't need to prefix them with their full path on your file system.

```
#!bash

$ git clone https://bitbucket.org/taccaci/foundation-cli.git
$ export PATH=$PATH:`pwd`/foundation-cli/bin
```

Once you download the Agave CLI and add it to your $PATH, the commands will be available to use from any directory simply by typing the name at the command line. They will also be available via Bash completion.

## Get an account
Before we do anything else, you will need to get a user account for your Agave API. Agave is multi-tenant, so there are multiple organizations that use it. This tutorial assumes you are using the [iPlant Collaborative](http://iplantcollaborative.org) tenant and, as such would need to get an iPlant account. If you are using another tenant, you would first need to obtain an account from the organization managing your tenant of Agave. If you don't knows who your tenant provider is, ask the people who told you about Agave or just create an iPlant account and use that. It's free, takes just a couple minutes to set up, comes with free storage and cycles, and will let you walk through this tutorial right away.

To get an iPlant account, visit the [iPlant User Management Portal](https://user.iplantcollaborative.org/register/), fill out the registration form, and click on the link in the registration email. Please note that it can take a couple minutes for the registration email to arrive. This is the longest part of the process, so if you don't see it right away, go check your [Facebook](http://facebook.com/profile.php?=7332236) page. By the time you're done, your account will be ready.

## Get your client credentials
In the last section you created a user account. Your user account identifies you to the web applications you interact with. A username and password is sufficient for interacting with an application because the application has a user interface, so it knows that the authenticated user is the same  one interacting with it. The Agave API is not driven by a web interface, however, so simply providing it a username and password is not sufficient. Agave needs to know both the user on whose behalf it is acting as well as the application or service that is making the call. Whereas every person has a single iPlant user account, they may leverage multiple services to do their daily work. They may start out using the [Discovery Environment](https://de.iplantcollaborative.org) to kick of an analysis, then switch to [MyPlant](https://my-plant.org/) to discuss some results, then receive an email that new data has been shared with them, click a shortened url that allows them to download that directly to their desktop, edit the file locally, and save it in a local folder that syncs with their iPlant [cloud storage](http://www.iplantcollaborative.org/discover/data-store) in the background. 

In each of the above interactions, the user is the same, but the context with which they are interacting with the iPlant infrastructure is different. The situation is further complicated when 3rd party applications are used to leverage the infrastructure. As the fundamental integration point for external applications with the iPlant cyberinfrastructure, Agave needs to track both the users and client applications  with whom it interacts. It does this through the issuance of client credentials.

Agave uses [OAuth2](http://oauth.net/2) to authenticate the client applications that call it and make authorization decisions about what protected resources they have permission to access. A discussion of OAuth is out of the context of this tutorial. You can read more about it on the [OAuth2](http://oauth.net/2) website or from the websites of any of the many other service providers using it today. In this section, we will walk you through getting your client credentials so we can stay focused on learning how to interact with the Agave's services.

In order to interact with any of the Agave services, you will need to first get a set of client credentials so you can authenticate. You can get your client credentials from the [Agave API Store](https://agave.iplantc.org). 

1. In a browser, visit [https://agave.iplantc.org](https://agave.iplantc.org).
1. Login to the site using your iPlant username and password.
1. Register a new client application by clicking on the *My Applications* tab and filling out the form.
1. Subscribe to all the APIs you want to use(all of them for this tutorial).
	a. Click on the *APIs* tab at the top of the page.
	a. For each API listed on the page, clicking on the name to open up that API's details page.
	a. Select the name of the application you just created from the *Applications* dropdown box on the right side of the page.
	a. Select the unlimited tier from the *Tiers* dropdown box on the right side of the page.
	a. Click the *Subscribe* button to subscribe for that API.
	a. Return to the APIs page and repeat the process for the rest of the APIs.
1. Click on the *My Subscriptions* tab at the top of the page to visit your subscriptions page.
2. Select the application you created in step 3 from the *Applications With Subscriptions* dropdown box.
3. Click the *Generate* button in the Production section to generate your client credentials.
4. Copy your client secret and client key. These are your client credentials. You will need them in the next section.

## Authenticate and get an access token
Now that you have an account and your client credentials, you can start interacting with Agave. First up, let's trade your client credentials for an access token (also known as a bearer token). The access token will be added to the header of every call to you make to Agave. It identifies both your individual identity as well as your client's identity to Agave. 

```
#!bash

$ auth-tokens-create -S -V
Consumer secret []: sdfaYISIDFU213123Qasd556azxcva
Consumer key []: pzfMa8EPgh8z4filrKcBscjMuDXAQa 
Agave tenant username []: nryan
Agave tenant password: 
Calling curl -sku "pzfMa8EPgh8z4filrKcBscjMuDXAQa:XXXXXX" -X POST -d "grant_type=client_credentials&username=dooley&password=XXXXXX&scope=PRODUCTION" -H "Content-Type:application/x-www-form-urlencoded" https://agave.iplantc.org/token
Token successfully refreshed and cached for 3600 seconds
{
    "access_token": "bg1f2f732db7842ccm847b15edt5f0",
    "expires_in": 3600,
    "token_type": "bearer"
}
```

The command above illustrates three conventions we will use throughout the rest of this tutorial. First, the `-S` option tells the command to cache the access token locally. The access token will be written to a file (`~/.agave`) in your home directory and reused on subsequent calls to Agave. This means that in the remainder of the tutorials, authentication will be automatically handled for us because we already have a token to use.

The second convention is the use of the `-V` option. This tells the CLI to print *very verbose* output. With this option, the CLI will show the curl command used to call the API as well as the full response including metadata.

The third convention is simply the use of the CLI. Agave provides [client SDK](http://agaveapi.co/client-sdk/) in multiple languages. Providing code equivalents to every tutorial in every SDK is out of scope of this tutorial, which is meant to quickly show you conceptually and procedurally how to use Agave. While language specific versions would no doubt be instructive, for clarity and brevity, we focus here on the pure REST API to Agave and delegate the language-specific versions of this tutorial to the individual client SDK projects.

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


## Adding systems for private use

While iPlant does provide you with several systems you can use, you may want to augment these systems with your own systems or access the iPlant systems, but using your own account. There are two ways to add systems to Agave: cloning and regsitering.

### Cloning a system

The fastest way to add a system is to copy an existing system and rename it for your own personal use. This is the purpose of the clone functionality. 

```
#!bash

$ systems-clone -V stampede.tacc.utexas.edu
```

In the example above you the existing Stampede system was cloned for our own use and given the name *stampede-nryan*. System name is arbitrary, but it must be unique. Once it is cloned, we can add our own login and storage credentials to it to login.

### Registering a system

If the system we want to use isn't already present in your list of systems, you can define your own. You can edit the samples in the systems/execution and systems/storage folder to define your own system. If you don't have a server avaiable, you can grab a vm from the iPlant's Atmosphere Cloud.

```
#!bash

$ systems-addupdate -V -F systems/storage/sftp-password.json
```

Now that you have a system registered, it is available to you and you alone. To see how to share your system with one or more other users and grant them various roles on that system, see the [System Management Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/systems/README.md).


## Moving and managing data

The Agave Files service gives you a consistent interface for managing data across multiple storage systems. Let's look at a couple examples of how this works. We will start out by doing a simple directory listing to see what is in our home folder. The iPlant Data Store 

```
#!bash

$ files-list -V -S data.iplantcollaborative.org nryan
```

Now let's upload a file.

```
#!bash

$ files-upload -V -S data.iplantcollaborative.org -F files/picksumipsum.txt nryan
```

And make sure it's there.

```
#!bash

$ files-list -V -S data.iplantcollaborative.org nryan/picksumipsum.txt
```

Now let's copy it to the storage system we registered in the previous section.

```
#!bash

$ files-upload -V -S demo.storage.example.com -F files/picksumipsum.txt 
```

And make sure it's there as well.

```
#!bash

$ files-upload -V -S demo.storage.example.com picksumipsum.txt 
```

How about importing data from the web. Pretty much the same thing. We'll tell Agave to go grab a URL and download it for us so we don't need to wait around.

```
#!bash

$ files-import -V -S demo.storage.example.com -U "http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM313800&targ=self&view=full&form=text" -N GSM313800.txt
```

You can watch the progress of this file by tracking the file's history.

```
#!bash

$ files-history -V -S demo.storage.example.com GSM313800.txt
```

Copying data between systems is just as easy. No need to worry about the fact that the accounts and protocols used by each may be different. Just specify your source file or folder as an Agave URL and the Files service will handle the rest.

```
#!bash

$ files-import -V -U "agave://demo.storage.example.com/GSM313800.txt" -S data.iplantcollaborative.org nryan
```

Sharing your data with another user is as simple as the following command

```
#!bash

$ files-pems-addupdate -V -U rclemens -P READ -S demo.storage.example.com GSM313800.txt
```

To make your data publicy available, grant the `world` user READ permissions.

```
#!bash

$ files-pems-addupdate -V -U world -P READ -S demo.storage.example.com GSM313800.txt
```

Your data will be available as a public url.

```
#!bash

https://agave.iplantc.org/files/2.0/download/nryan/system/demo.storage.example.com/GSM313800.txt
```

## Finding app

Agave's Apps service provides a way for you to discover and manage app. An app can be any executable code from a shell script to a complex workflow. The Apps service gives you a uniform way to describe, discover, and share apps as simple REST services. Let's see what apps are available to us right now.

```
#!bash

$ apps-list -V
```

We see several apps are available to us right off the bat. Let's look at the wc-1.00 app is greater detail.

```
#!bash

$ apps-list -V wc-1.00
Calling curl -sk -H "Authorization: Bearer f650e12db120bab3c08e64257c0c99" https://agave.iplantc.org/apps/2.0/wc-1.00?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-re2f32",
  "result" : {
    "id" : "wc-1.00",
    "name" : "wc",
    "icon" : null,
    "uuid" : "0001384807414674-5056a550b8-0001-005",
    "parallelism" : "SERIAL",
    "defaultProcessorsPerNode" : null,
    "defaultMemoryPerNode" : null,
    "defaultNodeCount" : null,
    "defaultMaxRunTime" : null,
    "defaultQueue" : null,
    "version" : "1.00",
    "revision" : 3,
    "public" : false,
    "helpURI" : "http://www.gnu.org/s/coreutils/manual/html_node/wc-invocation.html",
    "label" : "wc condor",
    "shortDescription" : "Count words in a file",
    "longDescription" : "",
    "tags" : [ "gnu", "textutils" ],
    "ontology" : [ "http://sswapmeet.sswap.info/algorithms/wc" ],
    "executionType" : "CONDOR",
    "executionSystem" : "osg-dooley",
    "deploymentPath" : "/dooley/applications/wc-1.00",
    "deploymentSystem" : "data.iplantcollaborative.org",
    "templatePath" : "/wrapper.sh",
    "testPath" : "/wrapper.sh",
    "checkpointable" : true,
    "lastModified" : "2013-11-18T17:51:09.000-06:00",
    "modules" : [ "load TACC", "purge" ],
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
        "href" : "https://agave.iplantc.org/apps/2.0/wc-1.00"
      },
      "executionSystem" : {
        "href" : "https://agave.iplantc.org/systems/2.0/osg-dooley"
      },
      "storageSystem" : {
        "href" : "https://agave.iplantc.org/systems/2.0/data.iplantcollaborative.org"
      },
      "owner" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/dooley"
      },
      "permissions" : {
        "href" : "https://agave.iplantc.org/apps/2.0/wc-1.00/pems"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/2.0/data/?q={\"associationIds\":\"0001384807414674-5056a550b8-0001-005\"}"
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


## Runing a job

So far we have learned about how to find and create storage and executions systems. We learned how to move data around. We discovered how to find apps we can run. Now it's time to do some work.

Agave handles all the details of orchestrating an app execution for you. You just need to provide it the id of the app you want to run, give the job a name, and specify the inputs and parameters the app needs to run. Optionally, you can tell Agave if and where you want the job results to be archived and subscribe to notifications ()in the form of emails or webhooks) to specific job events. 

Two sample job submissions are included in the jobs folder. Let's go ahead and submit one and see what happens.

```
#!bash

$ jobs-submit -V -F jobs/wc-1.00-submit.json
```

Running the above command returned a JSON description of the job. The job id is what we really care about now.

### Monitoring job status

Once we submit a job, Agave will handle staging the input files, submitting the job to a remote scheduler, montoring its status, archiving the outputs, and cleaning up after itself. Depending on how busy the execution system is when you submit your job and how large your input and output data is, this can take a while. To track the status of your job, you can use the above job id to query the Jobs service.

```
#!bash

$ jobs-list -V <JOB_ID>
```

There is also a way to return just the job status if bandwidth is an issue.

```
#!bash

$ jobs-status -V <JOB_ID>
```

For even more detailed information, you can query for the job history. This tracks every event and status change associated with the job.

```
#!bash

$ jobs-history -V <JOB_ID>
```

### Receiving job notifications

Often times, we don't have time to sit around waiting for a job to complete. There are also times when we want other applications (ours or other people's) to take action once our job completes. In these situations, notifications come in handy. Agave allows you to subscribe to notifications on any event anywhere in the API. The Jobs service has special support for notifications in that it allows you to include them as part of a job submission request. The `head-5.97-submit.json` job submission example illustrates this. 

```
#!JSON

"notifications": [
   	{ 
   		"url" : "http://requestb.in/11pbi6m1?job_id=${JOB_ID}&status=${JOB_STATUS}",
   		"event": "*",
   		"persistent": true
   	},
   	{ 
   		"url" : "nryan@mlb.com",
   		"event": "FINISHED"
   	}
]
```

In the example above, the notifications stanza includes two notification objects. The latter provides an email address where a message will be sent with the job details once the job reaches a FINISHED status. The former provides a webhook that utilizes two template variables, `JOB_ID` and `JOB_STATUS`, which will be resolved at run time into the job's id and the job status. Unlike the email notification, no specific event is specified, rather the wildcard charater, `*`, is provided. This tells Agave to send a notification on every job event. The persistent field tells Agave to reuse the notification indefinitely rather than expire it after the first invocation.

### Access job output

Agave handles the archiving and staging of your job data for you by default. Depending on where you told it to stage your data in your job request, it may or may not be easy to remember where to look for your results. To make this easier for you, the Jobs service provides a simple way for you to find and download your output data at any time.

```
#!BASH

$ jobs-output -V <JOB_ID>
```

Downloading the data is just as easy.

```
#!BASH

$ jobs-output -V -D -P <RELATIVE_PATH> <JOB_ID>
```

## Sharing your work with the world

Often times you will want to share your data, jobs, metadata, etc. with a third party person, service, or application. The sharing permissions built into every Agave service are helpful when the third party has API access as well, but they're less useful when the third party cannot authenticate to Agave and you're not comfortable making your data public to the world. This is why the PostIts service exists.

PostIts are preauthenticated, disposable URLs. Similar to [tinyurl](http://tinyurl.com) or [bit.ly](http://bit.ly), they provide a way for you to create an obfuscated url that references an Agave resource. What differentiates the PostIt service is the ability for you to pre-authenticate the URLS you generate so you gave give external users access to a specific resource using a specific HTTP method (GET, PUT, POST, DELETE) for a fixed number of requests or amount of time without them having to authentiated. Once the PostIt reaches its limits, it expires and is no longer valid. Let's create a postit to the file we uploaded earlier.


```
#!BASH

$ postits-create -V -n 2 https://agave.iplantc.org/files/2.0/media/system/data.iplantcollaborative.org/nryan/picksumipsum.txt
```

This returns a PostIt that we can use 2 times before it expires. Let's test that out.

```
#!BASH

$ curl -sk https://agave.iplantc.org/postits/2.0/<POSTIT_NONCE>

$ curl -sk https://agave.iplantc.org/postits/2.0/<POSTIT_NONCE>

$ curl -sk https://agave.iplantc.org/postits/2.0/<POSTIT_NONCE>
```

PostIts are great to use to email links around, pass to third party services, or use as a convenient way to work securely with third parties you don't trust.