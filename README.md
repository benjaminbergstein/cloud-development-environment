# cloud-development-environment

Simple to set up & configurable development machine in the digital ocean.

# Contents

- [Usage](https://github.com/benjaminbergstein/devbox#usage)
- [First time set up](https://github.com/benjaminbergstein/devbox#first-time-set-up)
- [Launch a development environment](https://github.com/benjaminbergstein/devbox#launch)
- [Teardown](https://github.com/benjaminbergstein/devbox#teardown)

# Usage

## First-time set up

### Prerequisites

1. [Install the Digital Ocean CLI](https://github.com/digitalocean/doctl).
2. [Generate an access token](https://cloud.digitalocean.com/account/api/tokens/new).
3. [Authenticate `doctl` with your access token](https://github.com/digitalocean/doctl#authenticating-with-digitalocean).
4. Make sure you have [`make`](https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_chapter/make_1.html#SEC1) and [`curl`](https://curl.haxx.se/) installed.
5. Install [`jq`](https://stedolan.github.io/jq/).

### First-time Set Up

Run:

```
make install
```

This will create the files at `~/.cloud-development-environment` required for a basic development box.

#### Configuration

For Github access, copy your SSH private key to `~/.cloud-development-environment/files/id_rsa`

Add repositories you want cloned:

```
echo 'git@github.com:your/repo.git' >> ~/.cloud-development-environment/files/repos.txt
```

Add other files or dotfiles you want uploaded:

```
cp ~/.your-dotfiles ~/.cloud-development-environment/files
cp ../any/other/files  ~/.cloud-development-environment/files
```

## Launch

### Create the droplet and SSH key for shell access:

```
make create
```

### Run until droplet has an IP:

```
make update
```

This updates the local JSON info file about the droplet.

### Set up the instance:

```
make setup
```

Droplets can take a minute to be SSH-ready. You can check by running `make
console`. This instance can only be set up once the droplet is available for
SSH.

### SSH in to the instance:

```
make console
```

## Teardown

### Destroy the droplet and SSH key:

```
make destroy
```
