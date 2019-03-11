# Stonehenge

![Stonehenge logo](logos/stonehenge_logo_wide.svg)

Local development environment toolset on Docker supporting multiple projects.

[![Build Status](https://travis-ci.org/druidfi/stonehenge.svg?branch=master)](https://travis-ci.org/druidfi/stonehenge)

## Requirements

- macOS, Arch Linux or Ubuntu
- Docker 17.04.0+
- No other services listening port 80 or 443

## Included containers

- `andyshinn/dnsmasq` to route `*.docker.sh` to localhost
- `mailhog/mailhog` in [mailhog.docker.sh](http://mailhog.docker.sh) to catch emails
- `portainer/portainer` in [portainer.docker.sh](http://portainer.docker.sh) to manage your Docker
- `traefik` in [traefik.docker.sh](http://traefik.docker.sh) to handle all our reverse proxy needs

## Setup

Note: in some systems setup will prompt once for your password as it will setup DNS.

### Oneliner

```
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/druidfi/stonehenge/master/install.sh)"
```

### Or manually with Git

```
$ git clone -b master https://github.com/druidfi/stonehenge.git ~/stonehenge
$ cd ~/stonehenge
$ make up
```

## Stop or shutdown Stonehenge

Note: Stonehenge will be started on boot by default if not stopped before.

To stop Stonehenge:

```
$ make stop
```

Or totally to stop and remove Stonehenge:

```
$ make down
```

## Add alias

Add this line to your shell (bash, zsh, fish):

```
alias stonehenge='make -C ~/stonehenge'
```

Now you can run make targets from anywhere with the alias:

```
$ stonehenge up
```

## Example applications

- [Contenta CMS](examples/contentacms/README.md)
- [Drupal 8](examples/drupal8/README.md)
- [Ghost](examples/ghost/README.md)
- [Hugo](examples/hugo/README.md)
- [Symfony 4](examples/symfony/README.md)
- [Wordpress](examples/wordpress/README.md)

## Tested with

- Arch Linux
- macOS High Sierra 10.13.6
- macOS Mojave 10.14
- Manjaro 17.1.6 (Arch Linux)
- Ubuntu 16.04
- Ubuntu 17.10
- Ubuntu 18.04

## Fork and modify

To brand the toolset for your organization:

- Fork this repository
- Modify `.env` file e.g. like follows:
  - `COMPOSE_PROJECT_NAME=company_dev`
  - `DOCKER_DOMAIN=docker.company_dev.com`
  - `LOGO_URL=https://your-cool-logo.png`
  - `NETWORK_NAME=company_dev-network`
  - `PREFIX=company_dev`
- IMPORTANT! Let us know! <3

## TODO

- More examples
- Shell detection and autocreate the alias

## References

- [https://github.com/andyshinn/docker-dnsmasq](https://github.com/andyshinn/docker-dnsmasq)
- [https://github.com/mailhog/MailHog](https://github.com/mailhog/MailHog)
- [https://portainer.io/](https://portainer.io/)
- [https://traefik.io/](https://traefik.io/)

## License

The files in this archive are released under the MIT license. You can find a copy of this license in [LICENSE](LICENSE).
