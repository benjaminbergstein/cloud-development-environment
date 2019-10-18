# devbox

My dev environment running on DigitalOcean infrastructure.

# Usage

## Set up

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
