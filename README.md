[![Build Status](https://travis-ci.org/slydetector/simply-nzedb.svg?branch=master)](https://travis-ci.org/slydetector/simply-nzedb)

# Simply nZEDb

Set up your own nZEDb usenet indexer in no time at all. 
This is a docker based installation based on the super-slim alpine linux distro.

## Requirements
- Linux box (64-bit x86 based distro - Debian, Ubuntu, whatever)
- [docker 1.11+](https://docs.docker.com/engine/installation/)
- python 2.7
- [virtualenv](https://virtualenv.pypa.io/en/stable/installation/)
- git

## Installation
### Step 1 - Command line setup

**ProTip:** Setup docker to run [without having to use sudo](http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo) unless you like typing in your password again and again.

```sh
git clone https://github.com/slydetector/simply-nzedb.git nzedb
cd nzedb

# Create a virtualenv for docker-compose
bin/build_virtualenv

# Create a copy of the *single* config file
cp etc/simply_nzedb.conf.example etc/simply_nzedb.conf

# Update config file with usenet, irc, socks, etc settings
vim etc/simply_nzedb.conf

# Setup the ./data dir which contains nzedb config, nzbs, mysql data, log files, etc
bin/setup_data_dir

# Start up nzedb to do initial setup
[sudo] bin/start_nzedb
```

### Step 2 - Automated web setup
```sh
# This will run through the web setup for you using settings from simply_nzedb.conf.
# Logs are in web_setup.log
bin/web_setup
```

### Step 3 - Sane defaults
```sh
# Update settings db table with locations of various executables like ffmpeg, mediainfo, etc
# and subscribe to alt.binaries.teevee for verification
[sudo] bin/apply_defaults

# Restart to pick up changes
[sudo] bin/start_nzedb
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
[sudo] bin/attach_tmux
```
Go to ```http://<hostname>:8800/browse?t=5000``` and you should see some TV releases soon.

Congratulations, you've just accomplished the hardest part of running nZEDb, setting it up!

## TODO
- More documentation
- PreDB auto-population

## Acknowledgements
- Based on work from [alp-nzedb](https://github.com/MichaelLindsey/alp-nzedb)
- Hats off to the guys moving [nZEDb](https://nzedb.github.io/) forward.

