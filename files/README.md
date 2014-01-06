# Agave Data Managment Tutorial
*******

> This tutorial provides a brief overview of how to use several of the most commonly used features of the [Agave API](http://agaveapi.co) Files Service. Prior to beginning this tutorial, you should have obtained a valid set of client application credentials. If you have not yet done so, please stop here and walk through the [Agave Authentication Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/auth/README.md) before going any further.


## Introduction  

Welcome to the Agave Data Management Tutorial. In this tutorial we will cover how to move, manage, and track data using the Agave API. This tutorial utilizes both public and private systems accessible through Agave. The public systems should be visible to you right away as an iPlant user. The private systems are systems you defined representing storage and execution systems you own, rent, or in some other way have access to. If you have not registered any systems of your own, you can walk through the [Agave System Management Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/systems/README.md) and do so. This tutorial should give you a clear understanding of how data management in Agave works with or without your own private system(s).

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

## Managing data

The Agave Files service gives you a consistent interface for managing data across multiple storage systems. Let's look at a couple examples of how this works. We will start out by doing a simple directory listing to see what is in our home folder. 

Terminology varies from storage system to storage system. Traditional POSIX files sytems refer to files and folder. Object stores such as [OpenStack Swift](http://swift.openstack.org/‎) and [Amazon S3](http://aws.amazon.com/s3/) refer to objects and buckets. [IRODS](https://www.irods.org) refers to data objects and collections. For the purpose of clarity, we will leverage POSIX terminology and refer to files and folder. 

> The iPlant Data Store is a public, shared storage system. Because of this, the registered `rootDir` and `homeDir` are both the folder containing all the individual user home folders. In the following examples, this is why we specify the username in the path.


### Directory listings

Listing directory uniform regardless of the protocol or location of the remote server. Below we will list the contents of our home directories on an IRODS system, data.iplantcollaborative.org, and a gridftp system, stampede-nyran.


```
#!bash

$ files-list -V -S data.iplantcollaborative.org nryan
Calling curl -sk -H "Authorization: Bearer d6aff3d85ad8ff97e8e36d3d32e59a" https://agave.iplantc.org/files/2.0/listings/system/data.iplantcollaborative.org/nryan?pretty=true
{
    "message": null,
    "result": [
        {
            "_links": {
                "self": {
                    "href": "https://agave.iplantc.org/files/2.0/media/system/data.iplantcollaborative.org/nryan"
                },
                "system": {
                    "href": "https://agave.iplantc.org/systems/2.0/data.iplantcollaborative.org"
                }
            },
            "format": "folder",
            "lastModified": "2012-08-03T06:30:12.000-05:00",
            "length": 0,
            "name": ".",
            "path": "nryan",
            "permisssions": "ALL",
            "system": "data.iplantcollaborative.org",
            "type": "file"
        }
    ],
    "status": "success",
    "version": "2.0.0-SNAPSHOT-r5e1fd"
}

```

```
#!bash

$ files-list -V -S nryan-stampede 
Calling curl -sk -H "Authorization: Bearer d6aff3d85ad8ff97e8e36d3d32e59a" https://agave.iplantc.org/files/2.0/listings/system/data.iplantcollaborative.org/nryan?pretty=true
{
    "message": null,
    "result": [
        {
            "_links": {
                "self": {
                    "href": "https://agave.iplantc.org/files/2.0/media/system/data.iplantcollaborative.org/nryan"
                },
                "system": {
                    "href": "https://agave.iplantc.org/systems/2.0/data.iplantcollaborative.org"
                }
            },
            "format": "folder",
            "lastModified": "2012-08-03T06:30:12.000-05:00",
            "length": 0,
            "name": ".",
            "path": "nryan",
            "permisssions": "ALL",
            "system": "data.iplantcollaborative.org",
            "type": "file"
        },
        {
            "_links": {
                "self": {
                    "href": "https://agave.iplantc.org/files/2.0/media/system/nryan-stampede//.bash_history"
                },
                "system": {
                    "href": "https://agave.iplantc.org/systems/2.0/nryan-stampede"
                }
            },
            "format": "raw",
            "lastModified": "2014-01-03T16:42:22.000-06:00",
            "length": 1318,
            "mimeType": "application/binary",
            "name": ".bash_history",
            "path": "/.bash_history",
            "permissions": "EXECUTE",
            "type": "file"
        },
        {
            "_links": {
                "self": {
                    "href": "https://agave.iplantc.org/files/2.0/media/system/nryan-stampede//.profile"
                },
                "system": {
                    "href": "https://agave.iplantc.org/systems/2.0/nryan-stampede"
                }
            },
            "format": "raw",
            "lastModified": "2012-12-16T18:36:14.000-06:00",
            "length": 435,
            "mimeType": "application/binary",
            "name": ".profile",
            "path": "/.profile",
            "permissions": "WRITE",
            "type": "file"
        },
        {
            "_links": {
                "self": {
                    "href": "https://agave.iplantc.org/files/2.0/media/system/nryan-stampede//.ssh"
                },
                "system": {
                    "href": "https://agave.iplantc.org/systems/2.0/nryan-stampede"
                }
            },
            "format": "folder",
            "lastModified": "2013-02-07T21:41:45.000-06:00",
            "length": 4096,
            "mimeType": "",
            "name": ".ssh",
            "path": "/.ssh",
            "permissions": "WRITE",
            "type": "dir"
        }
    ],
    "status": "success",
    "version": "2.0.0-SNAPSHOT-r5e1fd"
}
```

Looking at the above responses, you will see that they are consistent from one system to another. Standard information includes format (see the [Agave Data Transforms Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/transforms/README.md)), last modified timestamp in [ISO8601](http://en.wikipedia.org/wiki/ISO_8601) format, file length, mime-type where available, name, path relative to the system's virtual root, unix-style permission, and type (file, folder, etc). You will also see a `_links` object. This is the hypermedia portion of the response. It is a part of all Agave responses and contains links to resources and collections related to the current object.

### Creating directories

Creating a directory is a recursive operation by default. Unlike the default unix behavior, when you create a directory in Agave, any missing intermediate directories are also created relative to the path you specify. Let's create a new directory in our default storage system, data.iplantcollaborative.org.

```

#!bash

files-mkdir -V -N foodir/bardir nryan
Calling curl -sk -H "Authorization: Bearer f316ed9f76c4865cc3a72d14de2e48d9" -X PUT -d "action=mkdir&path=foodir/bardir" https://agave.iplantc.org/files/2.0/media/nryan?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r912c5",
  "result" : { }
}
```

Trying to create a directory that already exists will return a 400 error letting you know it could not create the directory.


### Uploading data

Uploading data to a remote system is a synchronous activity. When you import a file you are uploading it via a HTTP POST to the Agave Files service, which in turn in establishing a proxy connection and streaming the file to the remote system. Let's upload the sample file in our `files` directory.

```

#!bash
$ files-upload -V -S nryan-stampede -F ./picksumipsum.txt 
Calling curl -k -H "Authorization: Bearer 945bcc5bbc396c14320ad2d658677a6" -X POST -F "fileToUpload=@./picksumipsum.txt" https://agave.iplantc.org/files/2.0/media/system/nryan-stampede/?pretty=true
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  4294    0   857  100  3437     83    336  0:00:10  0:00:10 --:--:--     0
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r2f2c2",
  "result" : {
    "name" : "picksumipsum.txt",
    "path" : "picksumipsum.txt",
    "lastModified" : "2014-01-05T03:56:47.000-06:00",
    "length" : 4096,
    "permisssions" : "WRITE",
    "format" : "raw",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/files/2.0/media/system/nryan-stampede/picksumipsum.txt"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/2.0/nryan-stampede"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/2.0/data?q={\"associationIds\":\"0001388894207138-5056a550b8-0001-002\"}"
      },
      "history" : {
        "href" : "https://agave.iplantc.org/files/2.0/history/system/nryan-stampede/picksumipsum.txt"
      }
    }
  }
}

```

Since the upload is a synchronous call, your data will immediately be available to query.

### Transferring data

As mentioned above, data uploads are done over HTTP. This is useful when moving data between your local computer and remote system, but has some drawbacks.

* Your local computer must remain active the whole time.
* HTTP is one of the poorer performing data movement protocols.
* The data may not be on your local computer.
* The data may be prohibitively ( > 1GB )  large.  
* Your local network may be slow or unreliable.

When possible, we recommend using Agave's asynchronous transfer capabilities. When you request an asynchronous transfer, you tell Agave the source and destination of a file or folder you want to transfer and Agave manages and monitors the transfer for you. Agave will optimize the transfer as it goes, retry it if it fails, and monitor the transfer so you can track the progress. 

We show two examples of file imports below. The first example shows how to transfer a file from a public, non-Agave URL. The second example shows how to transfer data between Agave systems.


```

#!bash
$ files-import -V -U "http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM313800&targ=self&view=full&form=text" -N GSM313800.txt nryan/foodir
Calling curl -sk -H "Authorization: Bearer 945bcc5bbc396c14320ad2d658677a6" -X POST -d "urlToIngest=http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM313800&targ=self&view=full&form=text" -d "fileName=GSM313800.txt&" https://agave.iplantc.org/files/2.0/media/nryan/foodir?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r2f2c2",
  "result" : {
    "name" : "GSM313800.txt",
    "path" : "nryan/foodir",
    "lastModified" : "2014-01-04T21:49:02.000-06:00",
    "length" : -1,
    "permisssions" : "ALL",
    "format" : "raw",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/files/2.0/media/system/data.iplantcollaborative.org/nryan/foodir/GSM313800.txt"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/2.0/data.iplantcollaborative.org"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/2.0/data?q={\"associationIds\":\"0001388893209105-5056a550b8-0001-002\"}"
      },
      "history" : {
        "href" : "https://agave.iplantc.org/files/2.0/history/system/data.iplantcollaborative.org/nryan/foodir/GSM313800.txt"
      }
    }
  }
}

```

Notice in this example, Agave is handling an asyncronous transfer from another HTTP server. It does not know in advance how large the file is, so the initial length is set to -1. This will be updated as the transfer proceeds.


```

#!bash
$ files-import -V -U "agave://nryan-stampede/picksumipsum.txt" -N GSM313800.txt nryan/foodir
Calling curl -sk -H "Authorization: Bearer 945bcc5bbc396c14320ad2d658677a6" -X POST -d "urlToIngest=agave://nryan-stampede/picksumipsum.txt" -d "fileName=GSM313800.txt&" https://agave.iplantc.org/files/2.0/media/nryan/foodir?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r2f2c2",
  "result" : {
    "name" : "GSM313800.txt",
    "path" : "nryan/foodir",
    "lastModified" : "2014-01-04T21:49:02.000-06:00",
    "length" : -1,
    "permisssions" : "ALL",
    "format" : "raw",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/files/2.0/media/system/data.iplantcollaborative.org/nryan/foodir/GSM313800.txt"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/2.0/data.iplantcollaborative.org"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/2.0/data?q={\"associationIds\":\"0001388893209105-5056a550b8-0001-002\"}"
      },
      "history" : {
        "href" : "https://agave.iplantc.org/files/2.0/history/system/data.iplantcollaborative.org/nryan/foodir/GSM313800.txt"
      }
    }
  }
}
```

In this example, Agave is handling an asyncronous transfer from one Agave system, the one you registered, to another Agave system, the iPlant Data Store. The two systems have different data protocols, authentication mechansims, and are hosted in different data centers, but Agave handles all of this for you and transfers the file in the background.

You can transfer any file or folder between Agave systems in this matter. Agave will take care of everything for you and, if you set up a notification like we will see in the *Notifications* section or the [Notifications and Events](https://bitbucket.org/taccaci/agave-samples/src/master/notifications/README.md) tutorial, alert you or your application when the transfer completes.


### Copying data

Whereas transferring data with Agave is the process of moving data between systems, copying data is the process of duplicating a file or folder within a single remote system. Copying is a synchronous call meaning that the server will wait for the operation to complete before responding. Like directory creation and delete operations, copying is recursive by default. The process of copying a file or directory is identical.

When copying a file or directory, the destination path is relative to the path given in the url.

```

#!bash
files-copy -V -D nryan/foodir/bardir nryan/foodir/picksumipsum.txt
Calling curl -sk -H "Authorization: Bearer 945bcc5bbc396c14320ad2d658677a6" -X PUT -d "action=copy&path=nryan/foodir/bardir" https://agave.iplantc.org/files/2.0/media/nryan/foodir/picksumipsum.txt?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r2f2c2",
  "result" : { }
}
```

### Moving data

Moving data is analagous to the unix `mv` command. It is effectively equivalent to a copy followed by a delete of the original file. Moving data requires you to specify the full path to which the file or directory should be moved. Let's move the file we copied.

```

#!bash
$ files-move -V -D nryan/foodir/bardir/picksumipsum2.txt nryan/foodir/bardir/picksumipsum.txt
Calling curl -sk -H "Authorization: Bearer 945bcc5bbc396c14320ad2d658677a6" -X PUT -d "action=move&path=nryan/foodir/bardir/picksumipsum2.txt" https://agave.iplantc.org/files/2.0/media/nryan/foodir/bardir/picksumipsum.txt?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r912c5",
  "result" : { }
}
```

### Renaming data

Renaming data is nearly identical to moving it. The difference being that the path specified is relative to the parent directory of the file or folder given in the URL. Let's rename the file we just moved back to its original name.

```

#!bash
$ files-rename -V -D nryan/foodir/bardir/picksumipsum.txt nryan/foodir/bardir/picksumipsum2.txt
Calling curl -sk -H "Authorization: Bearer 945bcc5bbc396c14320ad2d658677a6" -X PUT -d "action=move&path=nryan/foodir/bardir/picksumipsum.txt" https://agave.iplantc.org/files/2.0/media/nryan/foodir/bardir/picksumipsum2.txt?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r912c5",
  "result" : { }
}
```


### Monitoring data transfers

When you transfer data between systems, registered or not, the actual transfer may take some time to complete depending on the transfer protocols, network, and server performance at the time. To check the status of the transfer, you can query the file or folder's history. 

```

#!bash
$ files-history -V nryan/foodir/picksumipsum.txt
iPlant Agave API v2.0
Agave client command line interface (revision 2.0-r58aceca0)

Calling curl -sk -H "Authorization: Bearer a756ec98f659789aa2deae765d24f6b7" https://agave.iplantc.org/files/2.0/history/nryan/foodir/picksumipsum.txt?pretty=true
{
    "message": null,
    "result": [
        {
            "created": "2014-01-04T20:47:13.000-06:00",
            "description": "File/folder queued for staging",
            "status": "STAGING_QUEUED"
        },
        {
            "created": "2014-01-04T20:47:14.000-06:00",
            "description": "File/folder queued for transform",
            "status": "TRANSFORMING_QUEUED"
        },
        {
            "created": "2014-01-04T20:47:21.000-06:00",
            "description": "Attempting to apply transform raw",
            "status": "TRANSFORMING"
        },
        {
            "created": "2014-01-04T20:47:21.000-06:00",
            "description": "Transforming file/folder",
            "status": "TRANSFORMING"
        },
        {
            "created": "2014-01-04T20:47:21.000-06:00",
            "description": "Attempting to apply transform raw",
            "status": "TRANSFORMING"
        },
        {
            "created": "2014-01-04T20:47:21.000-06:00",
            "description": "Transforming file/folder",
            "status": "TRANSFORMING"
        },
        {
            "created": "2014-01-04T20:47:21.000-06:00",
            "description": "Your scheduled transfer of http://129.114.60.211/picksumipsum.txt has completed successfully. You can access this file on data.iplantcollaborative.org at /nryan/foodir/picksumipsum.txt or through the API at https://agave.iplantc.org/files/2.0//media/system/iPlant Data Store (data.iplantcollaborative.org) IRODS/nryan/foodir/picksumipsum.txt.",
            "status": "TRANSFORMING_COMPLETED"
        },
        {
            "created": "2014-01-04T20:47:21.000-06:00",
            "description": "Your scheduled transfer of http://129.114.60.211/picksumipsum.txt has completed successfully. You can access this file on data.iplantcollaborative.org at /nryan/foodir/picksumipsum.txt or through the API at https://agave.iplantc.org/files/2.0//media/system/iPlant Data Store (data.iplantcollaborative.org) IRODS/nryan/foodir/picksumipsum.txt.",
            "status": "TRANSFORMING_COMPLETED"
        }
    ],
    "status": "success",
    "version": "2.0.0-SNAPSHOT-r2f2c2"
}
```
The output above shows the history of our file import. The history is a list of every event that Agave has performed on the file. When the original import request was made, Agave began to stage the data. A staging event was recorded and the real time progress of the transfer was updated in real time. When the transfer completed, the data passed through the transforming queue and finally completed. Every step in the process was recorded as an event on that file. Later, when we add, update, and remove user permissions on this file, those events will be recorded as well. Thus, the files history service maintains a full provenance of the file or folder's lifetime.

> The history service will keep track of everything that Agave does to a file or directory. It will not include information about events that happen outside of Agave. Thus, if you interact with the iPlant Data Store via iCommands or the iPlant Discovery Environment, those actions will not appear in Agave's history of the file or directory.

### Data Transfer Notifications

As mentioned above, transfers often time take quite a while to complete due to a variety of reason. Agave allows you to schedule a transfer and know that it will be completed for you without you having to sit around and watch it to completion. The history service allows you to poll Agave for the status of the transfer, but often times, polling is less than desireable. Also, you may want regular notifications at various points in the transfer lifecycle. In this situation, you can schedule notifications to be alerted of different file states. Notifications can be set at any time during the transfer lifecycle. Let's schedule another transfer and set an email update for completion.

```

#!bash
$ files-import -V -U "agave://nryan-stampede/picksumipsum.txt" -N GSM313800.txt nryan/foodir
Calling curl -sk -H "Authorization: Bearer 945bcc5bbc396c14320ad2d658677a6" -X POST -d "urlToIngest=agave://nryan-stampede/picksumipsum.txt" -d "fileName=GSM313800.txt&" https://agave.iplantc.org/files/2.0/media/nryan/foodir?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r2f2c2",
  "result" : {
    "name" : "GSM313800.txt",
    "path" : "nryan/foodir",
    "lastModified" : "2014-01-04T21:49:02.000-06:00",
    "length" : -1,
    "permisssions" : "ALL",
    "format" : "raw",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/files/2.0/media/system/data.iplantcollaborative.org/nryan/foodir/GSM313800.txt"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/2.0/data.iplantcollaborative.org"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/2.0/data?q={\"associationIds\":\"0001388893209105-5056a550b8-0001-002\"}"
      },
      "history" : {
        "href" : "https://agave.iplantc.org/files/2.0/history/system/data.iplantcollaborative.org/nryan/foodir/GSM313800.txt"
      }
    }
  }
}
$ notifications-addupdate -V -U "nyran@mlb.com" -E "*" -P false -A 0001388893209105-5056a550b8-0001-002
Calling: curl -sk -H "Authorization: Bearer 1925eb84e2502c1a917ef393d8688de" -X POST -d "event=*&persistent=false&associatedUuid=0001388893209105-5056a550b8-0001-002&url=nryan@mlb.com" https://agave.iplantc.org/notifications/2.0/?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r84d28",
  "result" : {
    "id" : "0001388961716382-5056a550b8-0001-011",
    "owner" : "nryan",
    "url" : "nryan@mlb.com",
    "associatedUuid" : "0001388895607302-5056a550b8-0001-002",
    "event" : "*",
    "responseCode" : null,
    "attempts" : 0,
    "lastSent" : "2014-01-05T16:41:56.978-06:00",
    "success" : false,
    "persistent" : true,
    "created" : "2014-01-05T16:41:56.382-06:00",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/notifications/2.0/0001388961716382-5056a550b8-0001-011"
      },
      "file" : {
        "href" : "https://agave.iplantc.org/files/2.0/media/system/data.iplantcollaborative.org/nryan/foodir/picksumipsum.txt"
      }
    }
  }
}
```

Now when the files completes, an email will be sent to the given email address, `nryan@mlb.com`.


### Deleting data

Deleting a file or directory, just like directory creation, works recursively by default. To delete our test folder, `bardir`, and all its contents, we request a DELETE on the file or directory url.


```

#!bash
$ files-delete -V nryan/foodir/bardir
Calling curl -sk -H "Authorization: Bearer d08c8a58f298983297bb2429999db86" -X DELETE https://agave.iplantc.org/files/2.0/media/nryan/foodir/bardir?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r2f2c2",
  "result" : { }
}
```

### Downloading data

We have focused mostly on pushing data around and managing it on remote systems. Pulling data works the same way. We can retrieve any file by calling a HTTP GET on a remote file. Directory downloads are not currently supported.

```

#!bash
$ files-get -V nryan/foodir/bardir/picksumipsum.txt
Calling curl -k -H "Authorization: Bearer d08c8a58f298983297bb2429999db86"  -O https://agave.iplantc.org/files/2.0/media/nryan/foodir/bardir/picksumipsum.txt
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3235    0  3235    0     0   1530      0 --:--:--  0:00:02 --:--:--  1530
```


## Data permissions and publication

Collaborating with others and sharing data is a fundamental concern for Agave. As such, every file, directory, system, job, metadata, schema, etc have access controls built in. By adding and removing access controls on a user-by-user basis, you can control who has access to resources. 

> Earlier we mentioned how Agave can only keep track of what it knows about. If a file or folder is changed outside of Agave, Agave will not be aware of the change and, thus, cannot record the change in its history. This is also true for permissions. If a unix, iRODS, or object store permission was changed manually outside of Agave, even those Agave will behave accordingly, the change will not be acknowledged in the file or directory's history. This is important to remember when you use Agave as one of several mechanisms to access and manage your data.


### Checking permissions

Let's start out by checking the current permissions on the `picksumipsum.txt` file we uploaded earlier.


```

#!bash
$ files-pems-list -V nryan/foodir/picksumipsum.txt
Calling curl -sk -H "Authorization: Bearer d08c8a58f298983297bb2429999db86" https://agave.iplantc.org/files/2.0/pems/nryan/foodir/picksumipsum.txt?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r2f2c2",
  "result" : [ {
    "username" : "nryan",
    "internalUsername" : "nryan",
    "permission" : {
      "read" : true,
      "write" : true,
      "execute" : true
    },
    "_links" : {
      "parent" : {
        "href" : "https://agave.iplantc.org/files/2.0/pems/system/data.iplantcollaborative.org/nryan/foodir/picksumipsum.txt"
      },
      "profile" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/nryan"
      }
    }
  } ]
}
```

We see that, by default, we are the only ones with access to the file. This is true of all data you upload or transfer into Agave. You cannot remove your ownership of a file you create and you cannot reduce your permissions. It is yours for life. 

You retain ownership of that data granting  file we uploaded earlier.

### Granting permissions

Now let's grant another user access to the `picksumipsum.txt`.

```

#!bash
$ files-pems-update -V -U mock -P read nryan/foodir/picksumipsum.txt
Calling curl -sk -H "Authorization: Bearer d08c8a58f298983297bb2429999db86" -X POST -d "username=mock&permission=read" https://agave.iplantc.org/files/2.0/pems/nryan/foodir/picksumipsum.txt?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r2f2c2",
  "result" : [ {
    "username" : "mock",
    "internalUsername" : "mock",
    "permission" : {
      "read" : true,
      "write" : false,
      "execute" : false
    },
    "_links" : {
      "parent" : {
        "href" : "https://agave.iplantc.org/files/2.0/pems/system/data.iplantcollaborative.org/nryan/foodir/picksumipsum.txt"
      },
      "profile" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/mock"
      }
    }
  } ]
}
```
Here we have granted read permission on the file. Setting permissions will always return an object with the updated permissions of the user to whom you just granted the permissions. Available permission values are  READ, WRITE, EXECUTE, READ_WRITE, READ_EXECUTE, WRITE_EXECUTE, ALL, and NONE.

Listing the file permissions shows that you and the `mock` user both have permissions to the file.

```

#!bash
$ files-pems-list -V nryan/foodir/picksumipsum.txt
Calling curl -sk -H "Authorization: Bearer 6c97f07db3bbcf21f169db6352871" https://agave.iplantc.org/files/2.0/pems/nryan/foodir/picksumipsum.txt?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r2f2c2",
  "result" : [ {
    "username" : "nryan",
    "internalUsername" : "nryan",
    "permission" : {
      "read" : true,
      "write" : true,
      "execute" : true
    },
    "_links" : {
      "parent" : {
        "href" : "https://agave.iplantc.org/files/2.0/pems/system/data.iplantcollaborative.org/nryan/foodir/picksumipsum.txt"
      },
      "profile" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/nryan"
      }
    }
  }, {
    "username" : "mock",
    "internalUsername" : "mock",
    "permission" : {
      "read" : true,
      "write" : true,
      "execute" : true
    },
    "_links" : {
      "parent" : {
        "href" : "https://agave.iplantc.org/files/2.0/pems/system/data.iplantcollaborative.org/nryan/foodir/picksumipsum.txt"
      },
      "profile" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/mock"
      }
    }
  } ]
}
```

Updating permissions is identical to adding them. When yo uupdate a permission it overwrites the previous permission. In the example below, we grant WRITE permission to the same user as before and see that the user no longer has read access to the file.

```

#!bash
$ files-pems-update -V -U mock -P write nryan/foodir/picksumipsum.txt
Calling curl -sk -H "Authorization: Bearer 6c97f07db3bbcf21f169db6352871" -X POST -d "username=mock&permission=write" https://agave.iplantc.org/files/2.0/pems/nryan/foodir/picksumipsum.txt?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r2f2c2",
  "result" : [ {
    "username" : "mock",
    "internalUsername" : "mock",
    "permission" : {
      "read" : false,
      "write" : true,
      "execute" : false
    },
    "_links" : {
      "parent" : {
        "href" : "https://agave.iplantc.org/files/2.0/pems/system/data.iplantcollaborative.org/nryan/foodir/picksumipsum.txt"
      },
      "profile" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/mock"
      }
    }
  } ]
}
```

### Revoking permissions

Revoking a user's permissions on a file or directory is done by granting them an empty permission value or a value of `NONE`.

```

#!bash
$ files-pems-update -V -U mock -P none nryan/foodir/picksumipsum.txt
Calling curl -sk -H "Authorization: Bearer 6c97f07db3bbcf21f169db6352871" -X POST -d "username=mock&permission=none" https://agave.iplantc.org/files/2.0/pems/nryan/foodir/picksumipsum.txt?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r2f2c2",
  "result" : [ {
    "username" : "mock",
    "internalUsername" : "mock",
    "permission" : {
      "read" : false,
      "write" : false,
      "execute" : false
    },
    "_links" : {
      "parent" : {
        "href" : "https://agave.iplantc.org/files/2.0/pems/system/data.iplantcollaborative.org/nryan/foodir/picksumipsum.txt"
      },
      "profile" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/mock"
      }
    }
  } ]
}
```
As we mentioned before, you cannot remove your ownership on a file or directory and the response from the service when setting a user permission always returns the current permissions of a user. As we see above, the user no longer has any permissions, which is shown by the response. When we query for a list of permissions for the file again, we see once again that only we have permissions.

```

#!bash
$ files-pems-list -V nryan/foodir/picksumipsum.txt
Calling curl -sk -H "Authorization: Bearer 6c97f07db3bbcf21f169db6352871" https://agave.iplantc.org/files/2.0/pems/nryan/foodir/picksumipsum.txt?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r2f2c2",
  "result" : [ {
    "username" : "nryan",
    "internalUsername" : "nryan",
    "permission" : {
      "read" : true,
      "write" : true,
      "execute" : true
    },
    "_links" : {
      "parent" : {
        "href" : "https://agave.iplantc.org/files/2.0/pems/system/data.iplantcollaborative.org/nryan/foodir/picksumipsum.txt"
      },
      "profile" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/nryan"
      }
    }
  } ]
}
```

### Publishing data

Agave also supports a special set of ACL that allow data to be made available to all registered users and to the general public. Granting the `world` user permission is a catchall for any registered user. Granting `world` read access allows anyone to read the file. Granting `write` access allows anyone to edit the file, etc.

The `public` user is a special user enabling non-authenticated access to a file or folder. When you grant the `public` user read access to a file or folder, it is available to the general public, without any authentication, through a special url.

Let's make our `picksumipsum.txt` file public and test the public download.

```
#!bash
$ files-pems-update -V -U public -P read nryan/foodir/picksumipsum.txt
Calling curl -sk -H "Authorization: Bearer 6c97f07db3bbcf21f169db6352871" -X POST -d "username=public&permission=read" https://agave.iplantc.org/files/2.0/pems/nryan/foodir/picksumipsum.txt?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r2f2c2",
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
        "href" : "https://agave.iplantc.org/files/2.0/pems/system/data.iplantcollaborative.org/nryan/foodir/picksumipsum.txt"
      },
      "profile" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/public"
      }
    }
  } ]
}
```
```
#!bash
$ curl -sk https://agave.iplantc.org/files/2.0/download/system/data.iplantcollaborative.org/nryan/nryan/foodir/picksumipsum.txt
```

### Publishing data with PostIts

In situations where you want to share data with others, but do not want to make the data publicly available, you can use the PostIts service to create a preauthenticated, disposable URL that you can share with others. For a more in-depth discussion of PostIts, see the [PostIts Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/postits/README.md). The following example creates a PostIt allowing anyone to perform a HTTP GET (download) of the `picksumipsum.txt` file exactly once in the next 30 days.

```

#!bash
$ postits-create -V https://agave.iplantc.org/files/2.0/media/system/data.iplantcollaborative.org/nryan/foodir/picksumipsum.txt
Calling curl -sk -H "Authorization: Bearer 1925eb84e2502c1a917ef393d8688de" -X POST -d "method=GET" -d "url=https://agave.iplantc.org/files/2.0/media/system/data.iplantcollaborative.org/nryan/foodir/picksumipsum.txt" https://agave.iplantc.org/postits/2.0/?pretty=true
{
	"status": "success",
	"message": "",
	"result": {
		"creator": "/nryan",
		"internalUsername": null,
		"authenticated": true,
		"created": "2014-01-05T16:09:17-06:00",
		"expires": "2014-02-04T16:09:17-06:00",
		"remainingUses": 1,
		"postit": "35dbe086d31b2ea940f5818d68797f6f",
		"url": "https://agave.iplantc.org/files/2.0/media/system/data.iplantcollaborative.org/nryan/foodir/picksumipsum.txt",
		"method": "GET",
		"_link": {
			"self": {
				"href": "https://agave.iplantc.org/postits/2.0/35dbe086d31b2ea940f5818d68797f6f"
			},
			"profile": {
				"href": "https://agave.iplantc.org/profiles/2.0//nryan"
			}
		}
	},
	"version": "2.0.0-SNAPSHOT-r4c047"
}
```
Let's validate that the PostIt works.

```

#!bash
$ curl -sk -o picksumipsum.txt https://agave.iplantc.org/postits/2.0/1ba188b74c34916401aa08010a3db2a2
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3235  100  3235    0     0   2108      0  0:00:01  0:00:01 --:--:--  2108```
```

And that it expired immediately after use.

```

#!bash
$ curl -sk https://agave.iplantc.org/postits/2.0/1ba188b74c34916401aa08010a3db2a2 | python -mjson.tool
{
    "message": "Postit key has already been redeemed.",
    "result": "",
    "status": "error",
    "version": "2.0.0-SNAPSHOT-r4c047"
}
```