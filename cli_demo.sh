###############################################
#				AUTHENTICATION
###############################################

# authenticate and get a token
$> auth-tokens-create -V -S
Consumer secret []: my_client_secret
Consumer key []: my_client_key
Agave tenant username []: testuser
Agave tenant password: 
Calling curl -sku "my_client_secret:XXXXXX" -X POST -d "grant_type=client_credentials&username=testuser&password=XXXXXX&scope=PRODUCTION" -H "Content-Type:application/x-www-form-urlencoded" https://129.114.60.211/token
Token successfully stored
{
    "access_token": "56e13e12abd0eb8f776b18513622cc", 
    "expires_in": 3580, 
    "refresh_token": "b0afbcd8357c93ba4a043d285544ba4", 
    "token_type": "bearer"
}



###############################################
#				APP DISCOVERY
###############################################


# find some apps
$> apps-list 
wc-demo-1.00
head-demo-1.00

# search for an app
$> apps-list -n wc
wc-demo-1.00

# find details about an app
# Q: we should probably allow admins to see all apps when they do a general listing
$> apps-list -V wc-demo-1.00
Calling curl -sku "testuser:XXXXXX" https://agave.iplantc.org/apps/2.0/wc-demo-1.00?pretty=true
{
  "status" : "success",
  "message" : "",
  "version" : "2.0.0-SNAPSHOT-rf64a967",
  "result" : {
    "id" : "wc-demo-1.00",
    "name" : "wc-demo",
    "icon" : "",
    "uuid" : "0001379535988467-c29d64962-0001-app",
    "parallelism" : "SERIAL",
    "version" : "1.00",
    "revision" : 1,
    "public" : false,
    "helpURI" : "http://www.gnu.org/s/coreutils/manual/html_node/wc-invocation.html",
    "label" : "wc condor",
    "shortDescription" : "Count words in a file",
    "longDescription" : "",
    "tags" : [ "textutils", "gnu" ],
    "ontology" : [ "http://sswapmeet.sswap.info/algorithms/wc" ],
    "executionType" : "CONDOR",
    "executionSystem" : "demo.execute.example.com",
    "deploymentPath" : "apps/wc-1.00",
    "deploymentSystem" : "demo.storage.example.com",
    "templatePath" : "wrapper.sh",
    "testPath" : "wrapper.sh",
    "checkpointable" : false,
    "lastModified" : "2013-07-06T10:20:24.000-05:00",
    "modules" : [ "purge", "load TACC" ],
    "available" : true,
    "inputs" : [ {
      "id" : "query1",
      "value" : {
        "validator" : "",
        "default" : "apps/wc-1.00/picksumipsum.txt",
        "visible" : true,
        "required" : true
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
   "parameters":[
      {
         "id":"printLongestLine",
         "value":{
            "default":false,
            "type":"string",
            "validator":"",
            "visible":true,
            "required":true
         },
         "details":{
            "label":"Print the length of the longest line",
            "description":"Command option -L"
         },
         "semantics":{
            "ontology":[
               "xs:boolean"
            ]
         }
      }
   ],
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/apps/2.0/wc-demo-1.00"
      },
      "executionSystem" : {
        "href" : "https://agave.iplantc.org/systems/2.0/condor.opensciencegrid.org"
      },
      "storageSystem" : {
        "href" : "https://agave.iplantc.org/systems/2.0/demo.storage.example.com"
      },
      "owner" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/sterry1"
      },
      "permissions" : {
        "href" : "https://agave.iplantc.org/apps/2.0/wc-demo-1.00/pems"
      }
    }
  }
}


###############################################
#				DATA MANAGEMENT
###############################################


# see other systems
# Q: is there a way to make it easier to find storage vs execution systems?
# Q: how do we query for just storage systems?
# Q: how can we tell which one is the default system?
$> systems-list
demo.execute.example.com
demo.storage.example.com
data.iplantcollaborative.org

# see if your input is there
$> files-list -S demo.storage.example.com
.
.bash_history
.bash_logout
.bash_profile
.bashrc
.pki
.viminfo

$> files-mkdir -S demo.storage.example.com -N inputs

$> files-list -S demo.storage.example.com inputs
.

# nothing in there, so upload some data
$> files-upload -S demo.storage.example.com -F files/picksumipsum.txt inputs

$> files-history

# see it is there
$> files-list -V -S demo.storage.example.com inputs/fastq/example.fq
Calling curl -sku "testuser:XXXXXX" https://agave.iplantc.org/files/2.0/listings/system/demo.storage.example.com/inputs/fastq/example.fq?pretty=true
{
  "status" : "success",
  "message" : "",
  "version" : "2.0.0-SNAPSHOT-rf64a967",
  "result" : [ {
    "name" : "example.fq",
    "path" : "inputs/fastq/example.fq",
    "lastModified" : "2013-09-21T16:56:12.000-05:00",
    "length" : 132,
    "permisssions" : "ALL",
    "format" : "raw",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/files/2.0/system/demo.storage.example.com/inputs/fastq/example.fq"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/2.0/demo.storage.example.com"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/2.0/search/?query=rel:https://agave.iplantc.org/files/2.0/system/demo.storage.example.com/inputs/fastq/example.fq"
      }
    }
  } ]
}


# my bad. copy to other system
files-import -V -U "agave://demo.storage.example.com/inputs/fastq/example.fq" testuser/inputs/fasta/
Calling curl -ku "testuser:63725d6b16d35940232b4b136a234a0c" -X POST -d "urlToIngest=agave://demo.storage.example.com/slurm.submit" https://129.114.60.211/io-V1/files/media/testuser?pretty=true
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   821  100   764  100    57    182     13  0:00:04  0:00:04 --:--:--   182
{
  "status" : "success",
  "message" : "",
  "version" : "2.0.0-SNAPSHOT-rf64a967",
  "result" : {
    "name" : "slurm.submit",
    "path" : "testuser",
    "lastModified" : "2013-07-09T14:19:49.000-05:00",
    "length" : -1,
    "permisssions" : "ALL",
    "format" : "raw",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://129.114.60.211/v2/io/system/demo.storage.example.com/testuser"
      },
      "system" : {
        "href" : "https://agave.iplantc.org/systems/2.0/demo.storage.example.com"
      },
      "metadata" : {
        "href" : "https://agave.iplantc.org/meta/2.0/search/?query=rel:https://129.114.60.211/v2/io/system/demo.storage.example.com/testuser"
      }
    }
  }
}

# see the file in the other location
files-list testuser/inputs/fasta
.
example.fq



###############################################
#				JOB SUBMISSION
###############################################


# run a job
$> jobs-submit -V -F submit.json 
Calling curl -sku "testuser:XXXXXX" https://agave.iplantc.org/jobs/2.0/0001379854320857-5056831b44-0001-job?pretty=true
{
  "status" : "success",
  "message" : "",
  "version" : "2.0.0-SNAPSHOT-rf64a967",
  "result" : {
    "id" : "0001379854320857-5056831b44-0001-job",
    "name" : "demo-1",
    "owner" : "testuser",
    "executionSystem" : "condor.opensciencegrid.org",
    "appId" : "wc-demo-1.00",
    "processors" : 1,
    "requestedTime" : "00:05:00",
    "memory" : 4,
    "callbackUrl" : null,
    "archive" : true,
    "retries" : 0,
    "localId" : "114",
    "archivePath" : "/testuser/archive/acm-bcb/demo-1",
    "archiveSystem" : "demo.storage.example.com",
    "outputPath" : null,
    "status" : "QUEUED",
    "submitTime" : "2013-09-22T07:52:21.000-05:00",
    "startTime" : null,
    "endTime" : null,
    "inputs" : [ {
      "query1" : "testuser/inputs/fasta/example.fq"
    } ],
    "parameters" : [ ],
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/2.0/0001379854320857-5056831b44-0001-job"
      },
      "application" : {
        "href" : "https://agave.iplantc.org/apps/2.0/wc-demo-1.00"
      },
      "executionSystem" : {
        "href" : "https://agave.iplantc.org/systems/2.0/condor.opensciencegrid.org"
      },
      "archiveSystem" : {
        "href" : "https://agave.iplantc.org/systems/2.0/demo.storage.example.com"
      },
      "archiveData" : {
        "href" : "https://agave.iplantc.org/jobs/2.0/136/outputs/listings"
      },
      "owner" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/testuser"
      },
      "permissions" : {
        "href" : "https://agave.iplantc.org/jobs/2.0/0001379854320857-5056831b44-0001-job/pems"
      },
      "history" : {
        "href" : "https://agave.iplantc.org/jobs/2.0/0001379854320857-5056831b44-0001-job/history"
      }
    }
  }
}


# monitor the job
$> jobs-list -V 0001379854320857-5056831b44-0001-job
Calling curl -sku "testuser:XXXXXX" https://agave.iplantc.org/jobs/2.0/0001379854320857-5056831b44-0001-job?pretty=true
{
  "status" : "success",
  "message" : "",
  "version" : "2.0.0-SNAPSHOT-rf64a967",
  "result" : {
    "id" : "0001379854320857-5056831b44-0001-job",
    "name" : "demo-1",
    "owner" : "testuser",
    "executionSystem" : "condor.opensciencegrid.org",
    "appId" : "wc-demo-1.00",
    "processors" : 1,
    "requestedTime" : "00:05:00",
    "memory" : 4,
    "callbackUrl" : null,
    "archive" : true,
    "retries" : 0,
    "localId" : "114",
    "archivePath" : "/testuser/archive/acm-bcb/demo-1",
    "archiveSystem" : "demo.storage.example.com",
    "outputPath" : null,
    "status" : "QUEUED",
    "submitTime" : "2013-09-22T07:52:21.000-05:00",
    "startTime" : null,
    "endTime" : null,
    "inputs" : [ {
      "query1" : "testuser/inputs/fasta/example.fq"
    } ],
    "parameters" : [ ],
    "_links" : {
      "self" : {
        "href" : "https://agave.iplantc.org/jobs/2.0/0001379854320857-5056831b44-0001-job"
      },
      "application" : {
        "href" : "https://agave.iplantc.org/apps/2.0/wc-demo-1.00"
      },
      "executionSystem" : {
        "href" : "https://agave.iplantc.org/systems/2.0/condor.opensciencegrid.org"
      },
      "archiveSystem" : {
        "href" : "https://agave.iplantc.org/systems/2.0/demo.storage.example.com"
      },
      "archiveData" : {
        "href" : "https://agave.iplantc.org/jobs/2.0/136/outputs/listings"
      },
      "owner" : {
        "href" : "https://agave.iplantc.org/profiles/2.0/testuser"
      },
      "permissions" : {
        "href" : "https://agave.iplantc.org/jobs/2.0/0001379854320857-5056831b44-0001-job/pems"
      },
      "history" : {
        "href" : "https://agave.iplantc.org/jobs/2.0/0001379854320857-5056831b44-0001-job/history"
      }
    }
  }
}

# stalk the job
$> jobs-history 0001379854320857-5056831b44-0001-job
Job accepted and queued for submission.
Attempt 1 to stage job inputs
Identifying input files for staging
Staging testuser/inputs/fasta/example.fq to execution system
Copy in progress
Job inputs staged to execution system
Attempt [1] Preparing job for execution and staging binaries to execution system
Condor job successfully placed into queue
Job started running
Job completed execution
Beginning to archive output.
Archiving agave://condor.opensciencegrid.org//condor/scratch/testuser/job-136-demo-1/wc-demo-1.00 to agave://demo.storage.example.com//testuser/archive/acm-bcb/demo-1
Job output archiving completed successfully.
Job completed.

# really stalk the job
$> jobs-history -V 0001379854320857-5056831b44-0001-job
Calling curl -sku "testuser:XXXXXX" https://agave.iplantc.org/jobs/2.0/0001379854320857-5056831b44-0001-job/history?pretty=true
{
  "status" : "success",
  "message" : "",
  "version" : "2.0.0-SNAPSHOT-rf64a967",
  "result" : [ {
    "created" : "2013-09-22T07:52:00.000-05:00",
    "status" : "PENDING",
    "description" : "Job accepted and queued for submission."
  }, {
    "created" : "2013-09-22T07:52:09.000-05:00",
    "status" : "PROCESSING_INPUTS",
    "description" : "Attempt 1 to stage job inputs"
  }, {
    "created" : "2013-09-22T07:52:09.000-05:00",
    "status" : "PROCESSING_INPUTS",
    "description" : "Identifying input files for staging"
  }, {
    "created" : "2013-09-22T07:52:09.000-05:00",
    "status" : "STAGING_INPUTS",
    "description" : "Staging testuser/inputs/fasta/example.fq to execution system"
  }, {
    "progress" : {
      "averageRate" : 0,
      "totalFiles" : 1,
      "source" : "testuser/inputs/fasta/example.fq",
      "totalActiveTransfers" : 0,
      "totalBytes" : 132,
      "totalBytesTransferred" : 132
    },
    "created" : "2013-09-22T07:52:09.000-05:00",
    "status" : "STAGING_INPUTS",
    "description" : "Copy in progress"
  }, {
    "created" : "2013-09-22T07:52:11.000-05:00",
    "status" : "STAGED",
    "description" : "Job inputs staged to execution system"
  }, {
    "created" : "2013-09-22T07:52:17.000-05:00",
    "status" : "SUBMITTING",
    "description" : "Attempt [1] Preparing job for execution and staging binaries to execution system"
  }, {
    "created" : "2013-09-22T07:52:21.000-05:00",
    "status" : "QUEUED",
    "description" : "Condor job successfully placed into queue"
  }, {
    "created" : "2013-09-22T07:53:18.000-05:00",
    "status" : "RUNNING",
    "description" : "Job started running"
  }, {
    "created" : "2013-09-22T07:53:26.000-05:00",
    "status" : "CLEANING_UP",
    "description" : "Job completed execution"
  }, {
    "created" : "2013-09-22T07:53:35.000-05:00",
    "status" : "ARCHIVING",
    "description" : "Beginning to archive output."
  }, {
    "progress" : {
      "averageRate" : 0,
      "totalFiles" : 8,
      "source" : "agave://condor.opensciencegrid.org//condor/scratch/testuser/job-136-demo-1/wc-demo-1.00",
      "totalActiveTransfers" : 1,
      "totalBytes" : 4010,
      "totalBytesTransferred" : 4010
    },
    "created" : "2013-09-22T07:53:35.000-05:00",
    "status" : "ARCHIVING",
    "description" : "Archiving agave://condor.opensciencegrid.org//condor/scratch/testuser/job-136-demo-1/wc-demo-1.00 to agave://demo.storage.example.com//testuser/archive/acm-bcb/demo-1"
  }, {
    "created" : "2013-09-22T07:53:48.000-05:00",
    "status" : "ARCHIVING_FINISHED",
    "description" : "Job output archiving completed successfully."
  }, {
    "created" : "2013-09-22T07:53:50.000-05:00",
    "status" : "FINISHED",
    "description" : "Job completed."
  } ]
}

# view job output
$> files-list testuser/archive/acm-bcb/demo-1
.
condorSubmit
example.fq
job.err
job.out
output.tar.gz
runtime.log
transfer.tar.gz


# download job output
$> files-get testuser/archive/acm-bcb/demo-1/output.tar.gz
.
condorSubmit
example.fq
job.err
job.out
output.tar.gz
runtime.log
transfer.tar.gz




###############################################
#				DATA SHARING
###############################################


# download piece of job output with files service
$> files-get testuser/archive/acm-bcb/demo-1/job.out

# share file/folder with public
$> files-pems-update -U public -P READ testuser/archive/acm-bcb/demo-1/job.out

# test public download
$> curl -sk "curl -k https://129.114.60.211/files/download/testuser/system/demo.storage.example.com/testuser/archive/acm-bcb/demo-1/job.out"

# unshare file/folder with public
$> files-pems-update -U public -P NONE testuser/archive/acm-bcb/demo-1/job.out

# 404 on public download
$> curl -k https://129.114.60.211/io-V1/files/download/testuser/system/demo.storage.example.com/testuser/archive/acm-bcb/demo-1/job.out
{"status":"error","message":"User does not have access to view the requested resource","version":"2.0.0-SNAPSHOT-rf64a967","result":null}

# create posit
$> postits-create -s testuser -m 1 https://agave.iplantc.org/files/2.0/media/testuser/archive/acm-bcb/demo-1/job.out
API key for authenticating, its recommended to insert : 
https://agave.iplantc.org/postits/2.0/b399e223fcc3581145a7affd136fd232

# test public download
$> curl -sk https://agave.iplantc.org/postits/2.0/b399e223fcc3581145a7affd136fd232
./
./test.sh
./.agave.archive
./condorSubmit
./wrapper.sh
./transfer_wrapper.sh
./app.json
./example.fq
{"status":"success","message":"","version":"2.1.8-SNAPSHOT-r${buildNumber}","result":{}}wc_out.txt

# 404 on now expired postit
$> curl -sk https://agave.iplantc.org/postits/2.0/b399e223fcc3581145a7affd136fd232
{"status":"error","message":"Postit key has already been redeemed.","result":"","version":"2.2.0-r8316"}

