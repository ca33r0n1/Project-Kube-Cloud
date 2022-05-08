pipeline { 
agent any 
    stages {
      stage ('Prepare'){
        echo 'Downloading GIT Project'
        git credentialsId: 'ca33r0n1ssh', url: 'git@github.com:auraside/AuraCloud.git'
        
      }
      
      stage ('Build') { 
        	sh '''#!/bin/sh
			docker build -t quay.auraside.com/ca33r0n1/auraside-cloud:master .
			docker push quay.auraside.com/ca33r0n1/auraside-cloud:master'''
        }
    }           
 }
