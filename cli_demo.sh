###############################################
#				AUTHENTICATION
###############################################

# authenticate and get a token
$> auth-tokens-create -V -S
Consumer secret []: my_client_secret
Consumer key []: my_client_key
Agave tenant username []: dooley
Agave tenant password: Calling curl -sku "my_client_secret:XXXXXX" -X POST -d "grant_type=client_credentials&username=dooley&password=XXXXXX&scope=PRODUCTION" -H "Content-Type:application/x-www-form-urlencoded" https://129.114.60.211/token
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
$> apps-list -V wsa-1.00
Calling curl -sku "dooley:XXXXXX" https://129.114.60.211/v2/apps/wc-demo-1.00?pretty=true
{
  "status" : "success",
  "message" : "",
  "version" : "2.1.8-SNAPSHOT-r8477",
  "result" : {
    "id" : "wc-demo-1.00",
    "name" : "wca",
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
    "executionSystem" : "condor.opensciencegrid.org",
    "deploymentPath" : "/sterry1/applications/wc-demo-1.00",
    "deploymentSystem" : "data.iplantcollaborative.org",
    "templatePath" : "wrapper.sh",
    "testPath" : "test.sh",
    "checkpointable" : false,
    "lastModified" : "2013-07-06T10:20:24.000-05:00",
    "modules" : [ "purge", "load TACC" ],
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
        "href" : "https://129.114.60.211/v2/apps/wc-demo-1.00"
      },
      "executionSystem" : {
        "href" : "https://129.114.60.211/v2/systems/condor.opensciencegrid.org"
      },
      "storageSystem" : {
        "href" : "https://129.114.60.211/v2/systems/data.iplantcollaborative.org"
      },
      "owner" : {
        "href" : "https://129.114.60.211/v2/profiles/sterry1"
      },
      "permissions" : {
        "href" : "https://129.114.60.211/v2/apps/wc-demo-1.00/pems"
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
lonestar4.tacc.teragrid.org
irods.storage.example.com
condor.execute.example.com
sftp.dooley.example.com
gsissh.execute.example.com
data.iplantcollaborative.org
ranger.tacc.teragrid.org
trestles.sdsc.teragrid.org
local.execute.example.com
condor.opensciencegrid.org
sang-execute
blacklight.psc.teragrid.org
stampede.tacc.utexas.edu
ssh.execute.example.com
sang-storage
gridftp.storage.example.com
sftp.storage.example.com
my.cloned.system
ftp.storage.example.com

# see if your input is there
$> files-list -S sftp.storage.example.com
.
.bash_history
.bash_logout
.bash_profile
.bashrc
.pki
.viminfo
agave_icon.png
applications
download.rand
download.zero
inputs
irods3.2.tgz
sftp-file
slurm.submit
this_is_sftp_system
vaughn

$> files-list -S sftp.storage.example.com inputs
.
fasta

$> files-list -S sftp.storage.example.com inputs/fastq
.
 
# not there, so upload some data
# Q: the response to this command does not seem to work. I'd expect some sort of tracking id so I can tell when the transfer is done.
$> files-upload -S lonestar -F acmbcb.fa inputs/fastq

# see it is there
$> files-list -V -S sftp.storage.example.com inputs/fastq/example.fq
Calling curl -sku "dooley:XXXXXX" https://129.114.60.211/v2/files/listings/system/sftp.storage.example.com/inputs/fastq/example.fq?pretty=true
{
  "status" : "success",
  "message" : "",
  "version" : "2.1.8-SNAPSHOT-r8477",
  "result" : [ {
    "name" : "example.fq",
    "path" : "inputs/fastq/example.fq",
    "lastModified" : "2013-09-21T16:56:12.000-05:00",
    "length" : 132,
    "permisssions" : "EXECUTE",
    "format" : "raw",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://129.114.60.211/v2/files/system/sftp.storage.example.com/inputs/fastq/example.fq"
      },
      "system" : {
        "href" : "https://129.114.60.211/v2/systems/sftp.storage.example.com"
      },
      "metadata" : {
        "href" : "https://129.114.60.211/v2/meta/search/?query=rel:https://129.114.60.211/v2/files/system/sftp.storage.example.com/inputs/fastq/example.fq"
      }
    }
  } ]
}


# my bad. copy to other system
# Q: this command doesn't see intuitive. it's a transfer, yet we're doing an import? Can we make this a little clearer?
files-import -V -U "agave://sftp.storage.example.com/inputs/fastq/example.fq" dooley/inputs/fasta/
Calling curl -ku "dooley:63725d6b16d35940232b4b136a234a0c" -X POST -d "urlToIngest=agave://sftp.storage.example.com/slurm.submit" https://129.114.60.211/io-V1/files/media/dooley?pretty=true
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   821  100   764  100    57    182     13  0:00:04  0:00:04 --:--:--   182
{
  "status" : "success",
  "message" : "",
  "version" : "2.1.8-SNAPSHOT-r8477",
  "result" : {
    "name" : "slurm.submit",
    "path" : "dooley",
    "lastModified" : "2013-07-09T14:19:49.000-05:00",
    "length" : -1,
    "permisssions" : "ALL",
    "format" : "raw",
    "type" : "file",
    "_links" : {
      "self" : {
        "href" : "https://129.114.60.211/v2/io/system/data.iplantcollaborative.org/dooley"
      },
      "system" : {
        "href" : "https://129.114.60.211/v2/systems/data.iplantcollaborative.org"
      },
      "metadata" : {
        "href" : "https://129.114.60.211/v2/meta/search/?query=rel:https://129.114.60.211/v2/io/system/data.iplantcollaborative.org/dooley"
      }
    }
  }
}

# see the file in the other location
files-list dooley/inputs/fasta
.
example.fq



###############################################
#				JOB SUBMISSION
###############################################


# run a job
$> jobs-submit -V -F submit.json 
Calling curl -sku "dooley:XXXXXX" https://129.114.60.211/v2/jobs/0001379854320857-5056831b44-0001-job?pretty=true
{
  "status" : "success",
  "message" : "",
  "version" : "2.1.8-SNAPSHOT-r8477",
  "result" : {
    "id" : "0001379854320857-5056831b44-0001-job",
    "name" : "demo-1",
    "owner" : "dooley",
    "executionSystem" : "condor.opensciencegrid.org",
    "appId" : "wc-demo-1.00",
    "processors" : 1,
    "requestedTime" : "00:05:00",
    "memory" : 4,
    "callbackUrl" : null,
    "archive" : true,
    "retries" : 0,
    "localId" : "114",
    "archivePath" : "/dooley/archive/acm-bcb/demo-1",
    "archiveSystem" : "data.iplantcollaborative.org",
    "outputPath" : null,
    "status" : "QUEUED",
    "submitTime" : "2013-09-22T07:52:21.000-05:00",
    "startTime" : null,
    "endTime" : null,
    "inputs" : [ {
      "query1" : "dooley/inputs/fasta/example.fq"
    } ],
    "parameters" : [ ],
    "_links" : {
      "self" : {
        "href" : "https://129.114.60.211/v2/jobs/0001379854320857-5056831b44-0001-job"
      },
      "application" : {
        "href" : "https://129.114.60.211/v2/apps/wc-demo-1.00"
      },
      "executionSystem" : {
        "href" : "https://129.114.60.211/v2/systems/condor.opensciencegrid.org"
      },
      "archiveSystem" : {
        "href" : "https://129.114.60.211/v2/systems/data.iplantcollaborative.org"
      },
      "archiveData" : {
        "href" : "https://129.114.60.211/v2/jobs/136/outputs/listings"
      },
      "owner" : {
        "href" : "https://129.114.60.211/v2/profiles/dooley"
      },
      "permissions" : {
        "href" : "https://129.114.60.211/v2/jobs/0001379854320857-5056831b44-0001-job/pems"
      },
      "history" : {
        "href" : "https://129.114.60.211/v2/jobs/0001379854320857-5056831b44-0001-job/history"
      }
    }
  }
}


# monitor the job
$> jobs-list -V 0001379854320857-5056831b44-0001-job
Calling curl -sku "dooley:XXXXXX" https://129.114.60.211/v2/jobs/0001379854320857-5056831b44-0001-job?pretty=true
{
  "status" : "success",
  "message" : "",
  "version" : "2.1.8-SNAPSHOT-r8477",
  "result" : {
    "id" : "0001379854320857-5056831b44-0001-job",
    "name" : "demo-1",
    "owner" : "dooley",
    "executionSystem" : "condor.opensciencegrid.org",
    "appId" : "wc-demo-1.00",
    "processors" : 1,
    "requestedTime" : "00:05:00",
    "memory" : 4,
    "callbackUrl" : null,
    "archive" : true,
    "retries" : 0,
    "localId" : "114",
    "archivePath" : "/dooley/archive/acm-bcb/demo-1",
    "archiveSystem" : "data.iplantcollaborative.org",
    "outputPath" : null,
    "status" : "QUEUED",
    "submitTime" : "2013-09-22T07:52:21.000-05:00",
    "startTime" : null,
    "endTime" : null,
    "inputs" : [ {
      "query1" : "dooley/inputs/fasta/example.fq"
    } ],
    "parameters" : [ ],
    "_links" : {
      "self" : {
        "href" : "https://129.114.60.211/v2/jobs/0001379854320857-5056831b44-0001-job"
      },
      "application" : {
        "href" : "https://129.114.60.211/v2/apps/wc-demo-1.00"
      },
      "executionSystem" : {
        "href" : "https://129.114.60.211/v2/systems/condor.opensciencegrid.org"
      },
      "archiveSystem" : {
        "href" : "https://129.114.60.211/v2/systems/data.iplantcollaborative.org"
      },
      "archiveData" : {
        "href" : "https://129.114.60.211/v2/jobs/136/outputs/listings"
      },
      "owner" : {
        "href" : "https://129.114.60.211/v2/profiles/dooley"
      },
      "permissions" : {
        "href" : "https://129.114.60.211/v2/jobs/0001379854320857-5056831b44-0001-job/pems"
      },
      "history" : {
        "href" : "https://129.114.60.211/v2/jobs/0001379854320857-5056831b44-0001-job/history"
      }
    }
  }
}

# stalk the job
$> jobs-history 0001379854320857-5056831b44-0001-job
Job accepted and queued for submission.
Attempt 1 to stage job inputs
Identifying input files for staging
Staging dooley/inputs/fasta/example.fq to execution system
Copy in progress
Job inputs staged to execution system
Attempt [1] Preparing job for execution and staging binaries to execution system
Condor job successfully placed into queue
Job started running
Job completed execution
Beginning to archive output.
Archiving agave://condor.opensciencegrid.org//condor/scratch/dooley/job-136-demo-1/wc-demo-1.00 to agave://data.iplantcollaborative.org//dooley/archive/acm-bcb/demo-1
Job output archiving completed successfully.
Job completed.

# really stalk the job
$> jobs-history -V 0001379854320857-5056831b44-0001-job
Calling curl -sku "dooley:XXXXXX" https://129.114.60.211/v2/jobs/0001379854320857-5056831b44-0001-job/history?pretty=true
{
  "status" : "success",
  "message" : "",
  "version" : "2.1.8-SNAPSHOT-r8477",
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
    "description" : "Staging dooley/inputs/fasta/example.fq to execution system"
  }, {
    "progress" : {
      "averageRate" : 0,
      "totalFiles" : 1,
      "source" : "dooley/inputs/fasta/example.fq",
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
      "source" : "agave://condor.opensciencegrid.org//condor/scratch/dooley/job-136-demo-1/wc-demo-1.00",
      "totalActiveTransfers" : 1,
      "totalBytes" : 4010,
      "totalBytesTransferred" : 4010
    },
    "created" : "2013-09-22T07:53:35.000-05:00",
    "status" : "ARCHIVING",
    "description" : "Archiving agave://condor.opensciencegrid.org//condor/scratch/dooley/job-136-demo-1/wc-demo-1.00 to agave://data.iplantcollaborative.org//dooley/archive/acm-bcb/demo-1"
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
# Q: using this because the job output command wasn't working
$> files-list dooley/archive/acm-bcb/demo-1
.
condorSubmit
example.fq
job.err
job.out
output.tar.gz
runtime.log
transfer.tar.gz


# download job output
# Q: again using this because the job output command wasn't working
$> files-get dooley/archive/acm-bcb/demo-1/output.tar.gz
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
# Q: again, job output service wasn't working. i see a pattern here
$> files-get dooley/archive/acm-bcb/demo-1/job.out

# share file/folder with public
# Q: this was jacked when I tried to do it. I couldn't assign public permission to anything. I pushed a patch so this now works. 
# Q: how would people know about public and world readable permissions? Should we have a files-publish or files-pems-publish command instead?
$> files-pems-update -U public -P READ dooley/archive/acm-bcb/demo-1/job.out

# test public download
# Q: this didn't work because we lost the public download service from v2 and all services require auth now. I went ahead and added the public download service back and bounced the service.
$> curl -sk "curl -k https://129.114.60.211/files/download/dooley/system/data.iplantcollaborative.org/dooley/archive/acm-bcb/demo-1/job.out"

# unshare file/folder with public
# Q: referencing above, should we have a files-unpublish or files-pems-unpublish command to make this a bit clearer?
$> files-pems-update -U public -P NONE dooley/archive/acm-bcb/demo-1/job.out

# 404 on public download
$> curl -k https://129.114.60.211/io-V1/files/download/dooley/system/data.iplantcollaborative.org/dooley/archive/acm-bcb/demo-1/job.out
{"status":"error","message":"User does not have access to view the requested resource","version":"2.1.8-SNAPSHOT-r8477","result":null}

# create posit
$> postits-create -s dooley -m 1 https://129.114.60.211/v2/files/media/dooley/archive/acm-bcb/demo-1/job.out
API key for authenticating, its recommended to insert : 
https://129.114.60.211/v2/postits/b399e223fcc3581145a7affd136fd232

# test public download
$> curl -sk https://129.114.60.211/v2/postits/b399e223fcc3581145a7affd136fd232
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
$> curl -sk https://129.114.60.211/v2/postits/b399e223fcc3581145a7affd136fd232
{"status":"error","message":"Postit key has already been redeemed.","result":"","version":"2.2.0-r8316"}

