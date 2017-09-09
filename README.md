[![Build Status](https://travis-ci.org/slydetector/simply-nzedb.svg?branch=master)](https://travis-ci.org/slydetector/simply-nzedb)
[![](https://img.shields.io/docker/pulls/slydetector/simply-nzedb.svg)](https://hub.docker.com/r/slydetector/simply-nzedb 'DockerHub')
[![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.png)](https://gitter.im/simply-nzedb/Lobby)

# Simply nZEDb

Set up your own nZEDb usenet indexer in no time at all. 
This is a docker based installation based on the super-slim alpine linux distro.

## Requirements
- Linux (64-bit x86 based distro - Debian, Ubuntu, whatever) or macOS 10+
- [docker 1.11+](https://docs.docker.com/engine/installation/)
- git
- [make](http://stackoverflow.com/questions/11934997/how-to-install-make-in-ubuntu)
- python 2.7
- [virtualenv](https://virtualenv.pypa.io/en/stable/installation/)

## Installation
### Step 1 - Command line setup

**ProTip:** Setup docker to run [without having to use sudo](http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo) unless you like typing in your password again and again.

```sh
$ git clone https://github.com/slydetector/simply-nzedb.git nzedb
$ cd nzedb

# Create a python virtualenv for docker-compose
$ make venv

# Create a copy of the *single* config file
$ cp etc/simply_nzedb.conf.example etc/simply_nzedb.conf

# Update config file with usenet, irc, socks, etc settings
$ vim etc/simply_nzedb.conf

# Setup the ./data dir which contains nzedb config, nzbs, mysql data, log files, etc
$ bin/setup_data_dir

# Start up nzedb to do initial setup
$ [sudo] make start 
```

### Step 2 - Automated web setup
```sh
# This will run through the web setup for you using settings from simply_nzedb.conf.
# Logs are in web_setup.log
$ bin/web_setup
```

### Step 3 - Sane defaults
```sh
# Update settings db table with locations of various executables like ffmpeg, mediainfo, etc
# and subscribe to alt.binaries.teevee for verification
$ [sudo] bin/apply_defaults

# Restart to pick up changes
$ [sudo] make start
```

### Step 4 - Verification
```sh
# Attach to tmux and verify things are working by
# next'ing through the windows.
#
# Cheat sheet for getting around in tmux:
#
# Key         Action
# --------------------------------------
# Ctrl-a n    Next window
# Ctrl-a c    Create new window
# Ctrl-a d    Detach from tmux
# 
$ [sudo] make attach
```
Go to ```http://<hostname>:8800/browse?t=5000``` and you should see some TV releases soon.

Congratulations, you've just accomplished the hardest part of running nZEDb, setting it up!

## Commands
Run ``make`` to see what else you can do.

```
$ make 
Welcome to simply-nzedb!

Core commands:

  attach - attach to nzedb's tmux session
  backup - backup database. nzedb must be running
  help - print this help
  logs - print container logs
  mysql - mysql client
  mysqltuner - run mysql tuner
  pull - pull the latest version
  restore - restore last database backup. nzedb must be running
  shell - shell into the nzedb container
  start - start nzedb (restarts if it is already running)
  status - shows running containers
  stop - stops nzedb

Developer commands:

  build - build docker images locally instead of downloading from docker hub
  test - run acceptance tests
```

## Upgrading to a newer version of nZEDb
See [UPGRADE.md](https://github.com/slydetector/simply-nzedb/blob/master/UPGRADE.md) for version specific upgrade instructions.

- Run ```make backup``` or you'll probably regret things if things go horribly wrong
- Run ```git pull``` to update to the latest docker files
- Run ```make pull``` to pull the latest docker images
- Run ```make start``` to restart nZEDb. The database schema is updated if necessary when starting up.

If after an upgrade, ```make attach``` fails, it is usually an indication that the database is getting updated or running migration steps. Use ```make logs | less -R``` to check on the progress and try again in a few minutes.

## Customizing MySQL
You can customize mysql settings by creating ```data/etc_mysql_conf.d/nzedb.cnf```. e.g.
```
[mysqld]
key_buffer_size = 2G
innodb_buffer_pool_size = 8G
group_concat_max_len = 32768
```

## TODO
- PreDB auto-population

## Acknowledgements
- Based on work from [alp-nzedb](https://github.com/MichaelLindsey/alp-nzedb)
- Hats off to the guys moving [nZEDb](https://nzedb.github.io/) forward.

## Help!
Try the [Gitter chat room](https://gitter.im/simply-nzedb/Lobby)
