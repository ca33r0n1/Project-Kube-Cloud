# Aura Cloud (Previously base-image)
[![Docker Repository on Quay](https://quay.io/repository/ca33r0n1as/auraside-base/status?token=d24690dc-0c9b-4538-a127-6eb6a3269be3 "Docker Repository on Quay")](https://quay.io/repository/ca33r0n1as/auraside-base)

AuraCloud is the current Docker image that we use for cloud mass deployment of server software.




## Authors

- [@ca33r0n1](https://www.github.com/ca33r0n1) - Cheif Technology Officer - Lead Developer of this Project


## Acknowledgements

 - [Itzg's Minecraft Docker Image](https://github.com/itzg/docker-minecraft-server) - This is a bible for anything to do with this project. It contains a lot of settings and files that we use in our own deployment. They also host multiple diffrent versions of Minecraft Docker Images including Proxies, Bedrock and MC Utils.

## Environment Variables

To run this project, you will need to add the following environment variables to your .env file

`WEBURL` This is the web server that is hosting the static server contect. AuraSide uses [https://cdn.auraside.com](https://cdn.auraside.com) to host static file content. This will not work locally unless you get you IP Whitelisted on the server or find a way to send your OAuth2 Key with a request. 

`servertype` It's the type of the server. This will either be `game`,`proxy` or `software`. 

`servergroup` is what we use to group the files in a set folder to help keep the static web server tidy.  Current examples are currently `squidgame`, `proxy` `squidgame-hub` and `quickmatch`.

`jenkinskey` This is a very important variable that must be filled if you want to be able to automatically download the latest version of files directly from our CI [Jenkins](https://jenkins.auraside.com).
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

Please see the example install.sh script here : [SquidGame Installer Script](https://cdn.auraside.com/squidgame/game-install.sh)

## Support

For support, email ca33r0n1@auraside.com or join our ping @Ca33r0n1 in Teams.
