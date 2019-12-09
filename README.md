# Alfresco 6.0.7 + ONLYOFFICE + HTTPS Docker

This will install Alfresco 6.0.7 + ONLYOFFICE docker compose on your server with HTTPS. Please note, that you need to obtain valid CA-signed SSL certificate for your domain.

- Copy repository to your machine.
- Give `install.sh` executable rights using `chmod +x install.sh` and run it `./install.sh`.
- Name your certificate `server.crt`, your private key `server.key` and put them in same dir with `install.sh` script.
- Make sure you installed Docker and Docker Compose, use these guides if needed:

   * https://docs.docker.com/install/linux/docker-ce/ubuntu/
   * https://docs.docker.com/compose/install/

This installation needs some time to complete, it was tested on Ubuntu 18.04, please be patient!

- After installation please open `https://your_domain_name/alfresco/s/admin` (default credentials are admin/admin).
- ONLYOFFICE Configuration -> Document Editing Service address field should be set as `https://your_domain_name:8443/` -> Save.

Optionally you can enable JWT on Document Server side:

- Use command `docker ps` to show all running containers.

- Enter Document Server container using `docker exec -it document_server_container_id bash`.

- Edit `/etc/onlyoffice/documentserver/local.json` as follows:

      "token": {
        "enable": {
          "request": {
            "inbox": true,
            "outbox": true
          },
          "browser": true
        },
        "inbox": {
          "header": "Authorization"
        },
        "outbox": {
          "header": "Authorization"
        }
      },
      "secret": {
        "inbox": {
          "string": "secret"
        },
        "outbox": {
          "string": "secret"
        },
        "session": {
          "string": "secret"
        }

- After you change any data in `local.json` config don't forget to restart Document Server services using `supervisorctl restart all` in docker container. 
- You need to set same `secret` on Document Server side and in Alfresco ONLYOFFICE Configuration.

# Alfresco Docker 201806-GA

*Production-ready* composition based in official [Docker Composition](https://github.com/Alfresco/acs-community-deployment/tree/master/docker-compose) provided by Alfresco.

## Containers

* alfresco 6.0.7-ga 
* share 6.0.b
* postgres 10.1
* solr6 (alfresco-search-services-1.1.1)

## Components

* AOS 1.2.0
* api-explorer 6.0.7-ga

# How to use this composition

Data wil be persisted automatically in `data` folder. Once launched, Docker will create three subfolders for following services:

* `alf-repo-data` for Content Store
* `postgres-data` for Database
* `solr-data` for Indexes

For Linux hosts, set `solr-data` folder permissions to user with UID 1001, as `alfresco-search-services` is using an container user named `solr` with UID 1001.

## Start Docker

Start docker and check the ports are correctly bound.

```bash
$ docker-compose up -d
$ docker ps
docker_httpd     80/tcp, 
                 0.0.0.0:443->443/tcp
docker_alfresco  1137-1139/tcp, 
                 1445/tcp, 8080/tcp, 
                 0.0.0.0:143->1143/tcp, 
                 0.0.0.0:21->2121/tcp, 
                 0.0.0.0:25->2525/tcp
postgres:10.1    0.0.0.0:5432->5432/tcp
alfresco/alfresco-search-services:1.1.1   8983/tcp
docker_share     8080/tcp
```

### Viewing System Logs

You can view the system logs by issuing the following.

```bash
$ docker-compose logs -f
```

## Access

Use the following username/password combination to login.

 - User: admin
 - Password: admin

Alfresco and related web applications can be accessed from the below URIs when the servers have started.

```
https://localhost/share
https://localhost/alfresco
https://localhost/solr
https://localhost/api-explorer
```

## Further configuration

### Deploying additional Addons

You can copy additional Alfresco addons to following paths.

```
alfresco/modules/amps
alfresco/modules/jars
share/modules/amps_share
share/modules/jars
```

After you `rebuild` the image, they will be available within the Alfresco instance.

### Adding configuration to repository

You can set additional properties to repository configuration by including these lines in file `alfresco/Dockerfile`

```bash
# Add services configuration to alfresco-global.properties
RUN echo -e '\n\
property=value\n\
\n\
' >> /usr/local/tomcat/shared/classes/alfresco-global.properties
```

### Using real SSL certificates

Default SSL certificates are *self-generated*. You can include your certificates at `https/assets` folder

### Using plain HTTP

You can use plain HTTP by using `docker-compose-http.yml` Docker Compose

```
$ docker-compose -f docker-compose-http.yml` up
```

With this option, following services are available:

```
http://localhost/share
http://localhost/alfresco
http://localhost/solr
http://localhost/api-explorer
```
