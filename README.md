# Toxicglue fossil docker container

![Fossil](https://fossil-scm.org/home/logo) 

This is a simple docker container for [Fossil](https://fossil-scm.org) with support for multiple repositories.

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
       - PORT=8181
       - MULTI_REPO=
       - SINGLE_REPO=1
       - HTTPS_PROXY=
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

### PORT
Set PORT to your external port number. 

This is the port that makes fossil externally accessible.
This Example makes Fossil accessible from the port 80 (default web)

```yaml
PORT=80
```

---

### MULTI_REPO
Support for multiple repositories, like Github.

If this option is selected, then the parameter SINGLE_REPO has to be inactivated (```SINGLE_REPO=```)

**Activated :**

```yaml
MULTI_REPO=1
```

**Disabled :**
```yaml
MULTI_REPO=
```

---

### SINGLE_REPO
Default option. Only one repository will be used.
If this option is selected, then the parameter MULTI_REPO has to be inactivated (```MULTI_REPO=```)

**Activated :**

```yaml
SINGLE_REPO=1
```

**Disabled :**

```yaml
SINGLE_REPO=
```
---

### HTTPS_PROXY
Needs to be activated if you are using a proxy, like [Nginx Proxy Manager](https://nginxproxymanager.com/).

**Activated :**

```yaml
HTTPS_PROXY=1
```

**Disabled :**

```yaml
HTTPS_PROXY=
```

---
## Add a new repository

You can create new repositories from docker commandline.

In this example we create en new repository (site) called: myproject.fossil with admin as the owner.
Please change the repository name and owner for your own need.

```bash
sudo docker container exec fossil fossil init -A admin myproject.fossil

```

---
## Links

[https://fossil-scm.org/home/doc/trunk/www/index.wiki](https://fossil-scm.org/home/doc/trunk/www/index.wiki)

