# Toxicglue fossil docker container

![Fossil](https://fossil-scm.org/home/logo) 

This is a simple docker container for [Fossil](https://fossil-scm.org) with support for multiple repositories.

- Docker images (Docker hub): [https://hub.docker.com/repository/docker/toxicglue/fossil](https://hub.docker.com/repository/docker/toxicglue/fossil)
- Source code and bug tracking (GitHub) : [https://github.com/toxicglue/fossil](https://github.com/toxicglue/fossil)

**username:** admin

**password:** admin1234


## Description

- Multiple repositories support 
- Small and secure Alpine linux (total size of the image is about 50 MB)
- Persistent docker volume (for data store)
- Simple backup (the repository is a single sqlite file)
- Easy configuration with ENV variables
- Run as a the "fossil" user

---
## About fossil
[Fossil](https://fossil-scm.org) is a simple, version control, bug tracking, wiki, forum, chat and blogging software.

The solution is a single binary (about 3Mb in size !), and all storage is handled in a local sqlite-database. 

Characteristic for Fossil is the small footprint (size and ram) and the speed.


---
## Run container

To start a container on port:80, you simply enter this:

```bash
sudo docker run -d -p 80:8181 -v fossil-volume:/data/repos --name fossil toxicglue/fossil:latest
```

---
## docker-compose


```yaml
version: "3.3"
services:
  fossil:
    image: toxicglue/fossil:latest
    container_name: fossil
    environment:
       - REPOS=source.fossil
       - PROJECT_NAME=Repository
       - USERNAME=admin
       - PASSWORD=admin1234
       - HTTPS_PROXY=1
    volumes:
      - fossil-volume:/data/repos
    ports:
      - 8181:8181
    restart: unless-stopped
volumes:
    fossil-volume:
```

---
## ENV variables

There are some **optional** ENV variables that could be used.

| **REPOS**          | Name of the repository (default: fossil.fossil)                                    |
| **PASSWORD**       | Password for the repository (default: admin1234)                                   |
| **USERNAME**       | Admin username for the repository (default: admin)                                 |
| **PROJECT_NAME**   | Project name for the repository                                                    |
| **PROJECT_DESC**   | Project description for the repository                                             |
| **HTTPS_PROXY**    | A non empty value (ex: MULTI_REPO=1) will enable https proxy.                      |
|                    | Should be enabled if you have some kind of proxy, like nginx proxy manager         |                                                       
| **MULTI_REPO**     | A non empty value (ex: MULTI_REPO=1) will enable support                           |      
|                    | for multiple repos (like github)                                                   |

---
## Misc scenarios 

### Add a new repository

You can create new repositories from docker command line.

In this example we create en new repository (site) called: myproject.fossil with admin as the owner.
Please change the repository name and owner for your own need.

```bash
sudo docker container exec fossil fossil init -A admin myproject.fossil

```

### Add existing repository

If you have an existing repository you can add it to your fossil docker volume, this way.

```bash

# Step-1: fetch the fossil docker volume path
docker volume inspect --format '{{ .Mountpoint }}' fossil_fossil-volume

# Step-2: copy fossil repos to fossil docker volume 
cp <previous_fossil.fossil> <fossil_volume_path>/<previous_fossil.fossil>

```

### Backup a repository


---
## Links

[https://fossil-scm.org/home/doc/trunk/www/index.wiki](https://fossil-scm.org/home/doc/trunk/www/index.wiki)

