# Agave Auth Tutorial
*******

> This tutorial provides a brief overview of how to create an account and authenticate to the [Agave API](http://agaveapi.co). This material is also available as part of the  [Quickstart Tutorial](https://bitbucket.org/taccaci/agave-samples/src/master/QUICKSTART.md). This should be the first step for any developer getting started with Agave.

## Introduction  

Welcome to the Agave Auth Tutorial. In this tutorial we will cover the basic steps needed to get an account and authenticate to the rest of the [Agave API](http://agaveapi.co). 

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
Before interacting with any of the Agave services, you first need to get a user account. Agave is a multi-tenant API meaning there are multiple organizations using their own, distinct virutal instances of the services. This tutorial assumes you are using the [iPlant Collaborative](http://iplantcollaborative.org) tenant and, as such requires an iPlant account. If you are using another tenant, you would first need to obtain an account from the organization managing your tenant of Agave. If you don't knows who your tenant provider is, ask the people who told you about Agave or just create an iPlant account and use that. It's free, takes less than 5 minutes to set up, comes with free storage and cycles, and will let you walk through this tutorial right away.

To get an iPlant account, visit the [iPlant User Management Portal](https://user.iplantcollaborative.org/register/), fill out the registration form, and click on the link in the registration email. Please note that it can take a couple minutes for the registration email to arrive. This is the longest part of the process, so if you don't see it right away, go check your [Facebook](http://facebook.com/profile.php?=7332236) page. By the time you're done, your account will be ready.

## Get your client credentials
In the last step you created a user account. Your user account identifies you to the web applications you interact with. A username and password is sufficient for interacting with an application because the application has a user interface, so it knows that the authenticated user is the same  one interacting with it. The Agave API is not driven by a web interface, however, so simply providing it a username and password is not sufficient. Agave needs to know both the user on whose behalf it is acting as well as the application or service that is making the call. Whereas every person has a single iPlant user account, they may leverage multiple services to do their daily work. They may start out using the [Discovery Environment](https://de.iplantcollaborative.org) to kick of an analysis, then switch to [MyPlant](https://my-plant.org/) to discuss some results, then receive an email that new data has been shared with them, click a shortened url that allows them to download that directly to their desktop, edit the file locally, and save it in a local folder that syncs with their iPlant [cloud storage](http://www.iplantcollaborative.org/discover/data-store) in the background. 

In each of the above interactions, the user is the same, but the context with which they are interacting with the iPlant infrastructure is different. The situation is further complicated when 3rd party applications are used to leverage the infrastructure. As the fundamental integration point for external applications with the iPlant cyberinfrastructure, Agave needs to track both the users and client applications  with whom it interacts. It does this through the issuance of client credentials.

Agave uses [OAuth2](http://oauth.net/2) to authenticate the client applications that call it and make authorization decisions about what protected resources they have permission to access. A discussion of OAuth is out of the context of this tutorial. You can read more about it on the [OAuth2](http://oauth.net/2) website or from the websites of any of the many other service providers using it today. In this section, we will walk you through getting your client credentials so we can stay focused on learning how to interact with the Agave's services.

In order to interact with any of the Agave services, you will need to first get a set of client credentials so you can authenticate. You can get your client credentials from the [Agave API Store](https://agave.iplantc.org/store). 

1. In a browser, visit [https://agave.iplantc.org/store](https://agave.iplantc.org/store).
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
Now that you have an account and your client credentials, you can start interacting with Agave. First up, let's trade your client credentials for an access token (also known as a bearer token). The access token will be added to the header of every call you make to Agave. It identifies both your individual identity as well as your client's identity to Agave. 

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

The command above illustrates three conventions we will use throughout the rest of this tutorial. First, the `-S` option tells the command to cache the access token locally. The access token will be written to a file (`~/.agave`) in your home directory and reused on subsequent calls to Agave. This means that in the remainder of the tutorials, authentication will be automatically handled for us because we already have a token to use.

The second convention is the use of the `-V` option. This tells the CLI to print *very verbose* output. With this option, the CLI will show the curl command used to call the API as well as the full response including metadata.

The third convention is simply the use of the CLI. Agave provides [client SDK](http://agaveapi.co/client-sdk/) in multiple languages. Providing code equivalents to every tutorial in every SDK is out of scope of this tutorial, which is meant to quickly show you conceptually and procedurally how to use Agave. While language specific versions would no doubt be instructive, for clarity and brevity, we focus here on the pure REST API to Agave and leave the language-specific versions of this tutorial for the individual client SDK projects.

Now that you have your client credentials in place, you are ready to move on to the service-specific tutorials.