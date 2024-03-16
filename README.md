# Project Kloud

Project Kloud is the current Docker image that we use for cloud mass deployment of server software.

## Authors

- [@ca33r0n1](https://www.github.com/ca33r0n1)

## Acknowledgements

 - [Itzg's Minecraft Docker Image](https://github.com/itzg/docker-minecraft-server) - This is a bible for anything to do with this project. It contains a lot of settings and files that we use in our own deployment. They also host multiple diffrent versions of Minecraft Docker Images including Proxies, Bedrock and MC Utils.

## Environment Variables

`WEBURL` This is the web server that is hosting the static server contect. AuraSide uses [https://cdn.auraside.com](https://cdn.auraside.com) to host static file content. This will not work locally unless you get you IP Whitelisted on the server or find a way to send your OAuth2 Key with a request. 

`servertype` It's the type of the server. This will either be `game`,`proxy` or `software`. 

`servergroup` is what we use to group the files in a set folder to help keep the static web server tidy.  Current examples are currently `hub`, `proxy` `game` and `software`.

`jenkinskey` This is a very important variable that must be filled if you want to be able to automatically download the latest version of files directly from our CI [Jenkins](https://jenkins.dev-ops.tips).
## Deployment

To deploy this image to our cloud you will either need to request access from @Ca330rn1 or use one of the secrets that are stored in the Kuberneties cluster.

Once you have authenticated docker you can run this image with the the values changed below.

### Local Deployments
```bash
docker run -i -t -e servergroup=ChangeMe -e jenkinskey="Change Me" -p 25565:25565 quay.io/ca33r0n1as/auraside-base
```

### Cloud Deployments

```bash
Clone an exsisting deployment. This is pending a LOT of documentation.
```

## FAQ

### How do I generate a Jenkins Key?

Jenkins Key's can be obtained by creating an API Key within Jenkins. Your email will be your username and the key will be your password. We need to convert this information into a Basic Authentication Header. Best way i've found to do this is using this site https://www.debugbear.com/basic-auth-header-generator. Fill the information in and you will get something like this : `Basic am9obkBleGFtcGxlLmNvbTphYmMxMjM=` 

For the Jenkins Key we just drop the Basic from the begining and just use this bit `am9obkBleGFtcGxlLmNvbTphYmMxMjM=`

### What is the CDN?

The CDN is out Web Server that contains most of the static content that we use to deploy servers. Most configurations and other important things are uploaded into folders then that is used to deploy from. 


### How does this deploy applications?

So the runner.sh script that we invoke just calls the CDN and pulls down a the relevant installer script.

Please see the example install.sh script here: <LINK PENDING UPDATE>
### How do I connect to the console?

You will need to access Rancher (Helm) and use the Kubectl CMD (See Image below).
![image](https://user-images.githubusercontent.com/12416650/154968879-31ca3dfe-6e92-40b2-899b-fa036fc49501.png)

You will only be able to connect to containers in the 'default' namespace.

In the command line shell that you have created use this command: kubectl attach <Pod Name Here> -i
 
This will connect you to the same view as the View Log option you have.

## Support

This is offered with help your self support :D
