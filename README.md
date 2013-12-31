iPlant Agave API Demo Samples
===================================================

This project contains a collection of json samples that can be used as templates for interacting with the Agave API. By editing the samples and leveraging the CLI, you can quickly bootstrap your users, systems, and apps and begin running jobs and managing yoru data and metadata quickly.


Requirements
=================

The only requirement to follow along with the included samples is the [Agave CLI](https://bitbucket.org/taccaci/foundation-cli "Agave CLI"). You can download the Agave CLI [here](https://bitbucket.org/taccaci/foundation-cli "Agave CLI"):

	
	
Installation
=================

No installation is necessary. Just download the Agave CLI and add the bin directory to your classpath and you're ready to go.

	export PATH=$PATH:/path/to/foundation-cli/bin
	

Contents
=================

	- README.md						This file
	- QUICKSTART.md					An end-to-end overview of commonly used features
	+ apps
		- README.md					Information on registering apps
		+ head-1.00					A simple head app fully wrapped and ready to register
		+ wc-1.00					A bare bones wc app fully wrapped and ready to register
	+ files
		- README.md					Information on managing and moving data
		- picksumipsum.txt 			Simple text file used in the examples
	+ jobs
		- README.md					Information on running and managing jobs
		- head-5.97-submit.json		Detailed job description ready to submit
		- wc-1.00-submit.json		Bare bones job description ready to submit
	+ jobs
		- README.md					Information on running and managing jobs
		- head-5.97-submit.json		Detailed job description ready to submit
		- wc-1.00-submit.json		Bare bones job description ready to submit
	+ metadata
		- README.md					Information on managing metadata	
		- complex_meta.json			Structured metadata the validates against the provided schemata
		- schemata.json				Valid json schema metadata definition
		- simple_meta.json			Simple key-value metadata entry
	+ notifications
		- README.md					Information on managing notifications
		- email_notif.json			Template for one-off email notifications
		- webhook_notif.json		Template for persistent webhook notifications
	+ systems
		+ execution
			- README.md				Information on managing execution systems
			- condor.json			Sample condor system
			- gsissh-cred.json 		Sample gsissh system with provided credential
			- gsissh-myproxy.json 	Sample gsissh system using myproxy for credential mgmt
			- ssh-password.json 	Sample ssh system
			- ssh-tunnel.json	Sample ssh system accessible via proxy tunnel
		+ storage
			- README.md			Information on managing storage systems
			- ftp.json			Sample ftp system
			- gridftp-cred.json Sample gridftp system with provided credential
			- gridftp-myproxy.json Sample gridftp system using myproxy for credential mgmt
			- irods.json		Sample irods system
			- sftp-password.json Sample sftp system
			- sftp-tunnel.json	Sample sftp system accessible via proxy tunnel
		
		
