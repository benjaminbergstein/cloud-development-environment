# devbox

My dev environment running on DigitalOcean infrastructure.

# Contents

- [Usage](https://github.com/benjaminbergstein/devbox#usage)
- [Set Up](https://github.com/benjaminbergstein/devbox#set-up)
- [Teardown](https://github.com/benjaminbergstein/devbox#teardown)
- [Github Access](https://github.com/benjaminbergstein/devbox#github-access)

# Usage

## Set up

### Prerequisites

1. [Install the Digital Ocean CLI](https://github.com/digitalocean/doctl)
2. [Generate an access token](https://cloud.digitalocean.com/account/api/tokens/new)
3. [Authenticate `doctl` with your access token](https://github.com/digitalocean/doctl#authenticating-with-digitalocean)

### Create the SSH key and droplet instance:

```
make -C digital-ocean deploy
```

### Wait a few minutes or run until the droplet has an IP:

```
make -C digital-ocean update
```

This updates the local JSON info file about the droplet.

### Set up the instance:

```
make -C digital-ocean setup
```

### SSH in to the instance:

```
make -C digital-ocean console
```

## Teardown

### Destroy the droplet and SSH key:

```
make -C digital-ocean destroy
```

## Github access.

To set up access to github repositories, simply copy your ssh private key to
`digital-ocean/files/id_rsa`. This file is gitignored to avoid committing this
secret to the repository.

If you do want to commit your ssh key to the repository, use [GPG](http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/) to encrypt it.

Once you have set up GPG, run:

```
gpg -e -r "YOUR-GPG-USER" ~/.ssh/your_id_rsa > digital-ocean/files/id_rsa.gpg
```

You can now safely commit the encrypted SSH key to the repository.

In order to decrypt the SSH key, the Makefile will export your GPG key and
upload along with other files to the droplet. It then imports the key and
decrypts the SSH key.
