# Agave Notification Management Tutorial
*******

> This tutorial provides a brief overview of how to use several of the most commonly used features of the [Agave API](http://agaveapi.co) Notifications Service. Prior to beginning this tutorial, you should have obtained a valid set of client application credentials. If you have not yet done so, please stop here and walk through the [Agave Authentication Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/auth/README.md) before going any further.


## Introduction  

Welcome to the Agave Notifications Management Tutorial. In this tutorial we will cover how to create and manage notifications in the Agave API. In order to get the most out of this tutorial, you should have a basic familiarity with the other Agave services so you can identify some of the situations under which you may want to create notifications. If you have not done so yet, the [Agave Data Management Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/files/README.md), [Agave App Management Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/apps/README.md), and [Agave Job Management Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/jobs/README.md) will help you get the perspective needed to get the most out of this tutorial.

We provide several sample notifications in this folder which you can use as templates for describing your own notifications. Substituting a valid UUID and event are sufficient to adapt these for your own use.

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

## Subscribing to job events

Notifications in Agave are just as they sound, notifications of events that occur on your resources and resources shared with you. Every action that occurs in Agave from a user creation to a job status change is an event. You can create a notification for any event. All you need is the UUID of the resource for which the notification applies, the event of interest, and a destination to notify when the event occurs. Agave support both email addresses and URLs as callback destinations. Agave also has a set of template variables that you can use to construct dynamic callback urls.

Most people who have interacted with HPC systems are familiar with job notifications already, so let's start there. In the [Agave Job Management Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/jobs/README.md) we learned how to submit and manage jobs. Jobs often times take a while to complete and we have better things to do that sit around waiting for them to finish, so let's set a notification to alert us when a job completes. First, let's get a list of our current jobs.

``` 

#!bash
$ jobs-list 
0001388554605053-b0b0b0bb0b-0001-007 QUEUED
```

Job `0001388554605053-b0b0b0bb0b-0001-007` is still queued up, so let's subscribe for a notification for that job. POSTing the following JSON will result in an email being sent to the given address when the job reaches a ``FINISHED`` state.

``` 

#!bash
$ notifications-addupdate -V -F notifications/email_notif.json
Calling curl -sk -H "Authorization: Bearer d143e138ab04ed9c32a5a608121ec8" -X POST -F "fileToUpload=@notifications/email_notif.json" https://agave.iplantc.org/notifications/v2/?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r84d28",
  "result" : {
    "id" : "0001389067207091-5056a550b8-0001-011",
    "owner" : "testuser",
    "url" : "nryan@mlb.com",
    "associatedUuid" : "0001388554605053-b0b0b0bb0b-0001-007",
    "event" : "FINISHED",
    "responseCode" : null,
    "attempts" : 0,
    "lastSent" : "2014-01-06T22:00:07.126-06:00",
    "success" : false,
    "persistent" : false,
    "created" : "2014-01-06T22:00:07.091-06:00",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/notifications/v2/0001389067207091-5056a550b8-0001-011"
      },
      "file" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/foodir/picksumipsum.txt"
      }
    }
  }
}
```

In the above example we use a JSON definition to tell the service what notification to create. We have the option of sending a url encoded form, raw JSON, or a file containing a JSON description in a multipart form upload. Let's set the same notification for the job with a url encoded form.

``` 

#!bash
$ notifications-addupdate -V -U "nyran@mlb.com" -E "FINISHED" -P false -A 0001388895607302-5056a550b8-0001-002
Calling curl -sk -H "Authorization: Bearer 1925eb84e2502c1a917ef393d8688de" -X POST -d "event=FINISHED&persistent=false&associatedUuid=0001388554605053-b0b0b0bb0b-0001-007&url=nyran@mlb.com" https://agave.iplantc.org/notifications/v2/?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r84d28",
  "result" : {
    "id" : "0001388963314803-5056a550b8-0001-011",
    "owner" : "testuser",
    "url" : "nyran@mlb.com",
    "associatedUuid" : "0001388554605053-b0b0b0bb0b-0001-007",
    "event" : "FINISHED",
    "responseCode" : null,
    "attempts" : 0,
    "lastSent" : "2014-01-05T17:08:34.818-06:00",
    "success" : false,
    "persistent" : true,
    "created" : "2014-01-05T17:08:34.803-06:00",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/notifications/v2/0001388963314803-5056a550b8-0001-011"
      },
      "file" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/foodir/picksumipsum.txt"
      }
    }
  }
}
```
This will result in the same behavior as before. Now the user will receive two notifications sent to the same email address when the job finishes.

Often times it's not you, but your application that wants notifications of job status changes. In that case you can set a callback url rather than an email address for Agave to POST to when the job reaches the desired state.

``` 

#!bash
$ notifications-addupdate -V -U "http://requestb.in/14p4qg31" -E "FINISHED" -P false -A 0001388895607302-5056a550b8-0001-002
Calling curl -sk -H "Authorization: Bearer a25aa5482984249454ad5bfd65778746" -X POST -d "event=FINISHED&persistent=false&associatedUuid=0001388895607302-5056a550b8-0001-002&url=http://requestb.in/14p4qg31" https://agave.iplantc.org/notifications/v2/?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r84d28",
  "result" : {
    "id" : "0001389068909915-5056a550b8-0001-011",
    "owner" : "testuser",
    "url" : "http://requestb.in/14p4qg31",
    "associatedUuid" : "0001388895607302-5056a550b8-0001-002",
    "event" : "FINISHED",
    "responseCode" : null,
    "attempts" : 0,
    "lastSent" : "2014-01-06T22:28:29.936-06:00",
    "success" : false,
    "persistent" : false,
    "created" : "2014-01-06T22:28:29.915-06:00",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/notifications/v2/0001389068909915-5056a550b8-0001-011"
      },
      "file" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/foodir/picksumipsum.txt"
      }
    }
  }
}
```

The above subscription will result in Agave making a POST request to `http://requestb.in/14p4qg31` when the job finishes. If you're building an application, the previous notification is helpful in situations where you generate a unique url for each job, but often times its easier to create a service that will process updates for every job notification. In that case, using Agave's notification template variables is helpful. Let's subscribe for a notification to be sent with some custom information included.

```

#!bash
$ notifications-addupdate -V -U 'http://requestb.in/14p4qg31?job_id=${JOB_ID}' -E "FINISHED" -P false -A 0001388895607302-5056a550b8-0001-002
Calling curl -sk -H "Authorization: Bearer a25aa5482984249454ad5bfd65778746" -X POST -d "event=FINISHED&persistent=false&associatedUuid=0001388895607302-5056a550b8-0001-002&url=http://requestb.in/14p4qg31?job_id=${JOB_ID}&status=${JOB_STATUS}" https://agave.iplantc.org/notifications/v2/?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r84d28",
  "result" : {
    "id" : "0001389069659307-5056a550b8-0001-011",
    "owner" : "testuser",
    "url" : "http://requestb.in/14p4qg31?job_id=${JOB_ID}",
    "associatedUuid" : "0001388895607302-5056a550b8-0001-002",
    "event" : "FINISHED",
    "responseCode" : null,
    "attempts" : 0,
    "lastSent" : "2014-01-06T22:40:59.338-06:00",
    "success" : false,
    "persistent" : false,
    "created" : "2014-01-06T22:40:59.307-06:00",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/notifications/v2/0001389069659307-5056a550b8-0001-011"
      },
      "file" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/foodir/picksumipsum.txt"
      }
    }
  }
}
```

Now the same endpoint will be called, but the job ID will be sent as a url variable. It's also possible to create catchall notifications by specifying a wildcard as the event. When you specify a wildcard event, a notification will be sent on every event. When doing this, you will probably want to add the job event (status change) to the URL so you know what event you are being notified about. The subscription below illustrates this situation.

```

#!bash
$ notifications-addupdate -V -U 'http://requestb.in/14p4qg31?job_id=${JOB_ID}&status=${JOB_STATUS}' -E "*" -P false -A 0001388895607302-5056a550b8-0001-002
Calling curl -sk -H "Authorization: Bearer a25aa5482984249454ad5bfd65778746" -X POST -d "event=*&persistent=false&associatedUuid=0001388895607302-5056a550b8-0001-002&url=http://requestb.in/14p4qg31?job_id=${JOB_ID}&status=${JOB_STATUS}" https://agave.iplantc.org/notifications/v2/?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r84d28",
  "result" : {
    "id" : "0001389070667170-5056a550b8-0001-011",
    "owner" : "testuser",
    "url" : "http://requestb.in/14p4qg31?job_id=${JOB_ID}",
    "associatedUuid" : "0001388895607302-5056a550b8-0001-002",
    "event" : "*",
    "responseCode" : null,
    "attempts" : 0,
    "lastSent" : "2014-01-06T22:57:47.189-06:00",
    "success" : false,
    "persistent" : true,
    "created" : "2014-01-06T22:57:47.170-06:00",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/notifications/v2/0001389070667170-5056a550b8-0001-011"
      },
      "file" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/foodir/picksumipsum.txt"
      }
    }
  }
}
```

## Persistent notifications

Up until now we have created events that expired immediately after they fired once. For many situations, like the ones described in the next section, we do not want the notifications to expire. Rather, we want them to continue to fire every time the event occurs. We can do this by setting the `persistent` field in the notification request to `true`.

```

#!bash
$ notifications-addupdate -V -U 'http://requestb.in/14p4qg31?app_id=${SYSTEM_ID}' -E "UPDATED" -P false -A 0001388740888728-5056a550b8-0001-006
Calling curl -sk -H "Authorization: Bearer a25aa5482984249454ad5bfd65778746" -X POST -d "event=UPDATED&persistent=false&associatedUuid=0001388740888728-5056a550b8-0001-006&url=http://requestb.in/14p4qg31?app_id=${SYSTEM_ID}" https://agave.iplantc.org/notifications/v2/?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r${buildNumber}",
  "result" : {
    "id" : "0001389076758754-b0b0b0bb0b-0001-011",
    "owner" : "testuser",
    "url" : "http://requestb.in/14p4qg31?app_id=${APP_ID}",
    "associatedUuid" : "0001388740888728-5056a550b8-0001-006",
    "event" : "UPDATED",
    "responseCode" : null,
    "attempts" : 0,
    "lastSent" : "2014-01-07T00:39:20.927-06:00",
    "success" : false,
    "persistent" : false,
    "created" : "2014-01-07T00:39:18.754-06:00",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/notifications/v2/0001389076758754-b0b0b0bb0b-0001-011"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/v2/testuser-stampede"
      }
    }
  }
}
```
In this example, we set a persistent notification for the system we created in the [Agave App Management Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/apps/README.md). After setting this notification, we will get a notification every time the system description is updated.

## Subscribing to related events

Job events and file transfer events are the most familiar uses of notifications, however several other uses can be equally as helpful. A few below are mentioned below:
* *App updates*: receive alerts when an application description changes.
* *File permission*: receive updates when permissions on a file or directory changes.
* *Metadata curation*: receive updates when metadata is added, updated, or removed from a resource.
* *System execution*: receive notifications whenever a job is run on a system.
* *File downloads*: receive alerts whenever someone downloads a file.
* *File updates*: receive alerts whenever a file or folder changes.
* *Usage quota violations*: receive alerts when a usage in a queue or system reaches the predefined quota.

## Searching notifications

You can list all notifications you have made by calling a HTTP GET on the notifications collection

```

#!bash
$ notifications-list -V
Calling curl -sk -H "Authorization: Bearer 560ecbd79c1e8f773afae7229e054d4" https://agave.iplantc.org/notifications/v2?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r84d28",
  "result" : [ {
    "id" : "0001389070667170-5056a550b8-0001-011",
    "url" : "http://requestb.in/14p4qg31?job_id=${JOB_ID}",
    "event" : "*",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/notifications/v2/0001389070667170-5056a550b8-0001-011"
      },
      "file" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/foodir/picksumipsum.txt"
      }
    }
  }, {
    "id" : "0001389069659307-5056a550b8-0001-011",
    "url" : "http://requestb.in/14p4qg31?job_id=${JOB_ID}",
    "event" : "FINISHED",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/notifications/v2/0001389069659307-5056a550b8-0001-011"
      },
      "file" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/foodir/picksumipsum.txt"
      }
    }
  }, {
    "id" : "0001389068909915-5056a550b8-0001-011",
    "url" : "http://requestb.in/14p4qg31",
    "event" : "FINISHED",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/notifications/v2/0001389068909915-5056a550b8-0001-011"
      },
      "file" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/foodir/picksumipsum.txt"
      }
    }
  }, {
    "id" : "0001389067207091-5056a550b8-0001-011",
    "url" : "nryan@mlb.com",
    "event" : "*",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/notifications/v2/0001389067207091-5056a550b8-0001-011"
      },
      "file" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/foodir/picksumipsum.txt"
      }
    }
  } ]
}
```

If you are looking for the notifications for a specific resource, add the assocatedUuid of the resource to the url.

```

#!bash
$ notifications-list -V -U 0001388895607302-5056a550b8-0001-002
Calling curl -sk -H "Authorization: Bearer 560ecbd79c1e8f773afae7229e054d4" https://agave.iplantc.org/notifications/v2/?associatedUuid=0001388895607302-5056a550b8-0001-002&pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r84d28",
  "result" : [ {
    "id" : "0001389070667170-5056a550b8-0001-011",
    "url" : "http://requestb.in/14p4qg31?job_id=${JOB_ID}",
    "event" : "*",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/notifications/v2/0001389070667170-5056a550b8-0001-011"
      },
      "file" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/foodir/picksumipsum.txt"
      }
    }
  }, {
    "id" : "0001389069659307-5056a550b8-0001-011",
    "url" : "http://requestb.in/14p4qg31?job_id=${JOB_ID}",
    "event" : "FINISHED",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/notifications/v2/0001389069659307-5056a550b8-0001-011"
      },
      "file" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/foodir/picksumipsum.txt"
      }
    }
  }, {
    "id" : "0001389068909915-5056a550b8-0001-011",
    "url" : "http://requestb.in/14p4qg31",
    "event" : "FINISHED",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/notifications/v2/0001389068909915-5056a550b8-0001-011"
      },
      "file" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/foodir/picksumipsum.txt"
      }
    }
  }, {
    "id" : "0001389067207091-5056a550b8-0001-011",
    "url" : "nryan@mlb.com",
    "event" : "*",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/notifications/v2/0001389067207091-5056a550b8-0001-011"
      },
      "file" : {
        "href" : "https://agave.iplantc.org/files/v2/media/system/data.iplantcollaborative.org/testuser/foodir/picksumipsum.txt"
      }
    }
  } ]
}
```

## Deleting notification subscriptions

If you need to cancel a notification, you can do so by simply calling a HTTP DELETE on the event id.

```

#!bash
$ notifications-delete -V 0001389067207091-5056a550b8-0001-011
Calling curl -sk -H "Authorization: Bearer 560ecbd79c1e8f773afae7229e054d4" -X DELETE https://agave.iplantc.org/notifications/v2/0001389067207091-5056a550b8-0001-011?pretty=true
{
  "status" : "success",
  "message" : null,
  "version" : "2.0.0-SNAPSHOT-r84d28",
  "result" : { }
}
```
