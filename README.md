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

# Build the nzedb docker images - this will take a while
bin/build_nzedb

# Create a copy of the *single* config file
cp etc/simply_nzedb.conf.example etc/simply_nzedb.conf

# Update config file with usenet and irc settings
vim etc/simply_nzedb.conf

# Setup the ./data dir which contains nzedb config, nzbs, mysql data, log files, etc
bin/setup_data_dir

# Start up nzedb to do initial setup
bin/start_nzedb
```

### Step 2 - Web based setup
- In your web browser, go to `http://<hostname>:8800/install/`
- Read instructions and press **Go to step one: Pre flight check**
- All checks should be OK (green). Press **Step two: setup the database**
- Database Setup page - all required settings should already be populated. Press **Setup Database**
- Press **Step three: Setup openssl**
- Press **Verify openssl settings**
- Press **Step four: Setup news server connection**
- Usenet server settings should already be pre-populated from Step 1. Press **Test Primary Connection**
- Press **Step five: Save Settings**
- Press **Step six: Setup admin user**
- Admin user 
  - Enter `Username: nzedb`
  - Enter `Password: nzedb`
  - Enter `Email: your@email.address.com`
  - Press **Create Admin User**
- Press **Step seven: Set file paths**
- Leave pre-populated defaults - press **Set file paths**
- Nearly there..

### Step 3 - Sane defaults
```sh
# Update settings db table with locations of various executables like ffmpeg, mediainfo, etc
# and subscribe to alt.binaries.teevee for verification
bin/apply_defaults

# Restart to pick up changes
bin/start_nzedb
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
bin/attach_tmux
```
Go to ```http://<hostname>:8800/browse?t=5000``` and you should see some TV releases soon.

Congratulations, you've just accomplished the hardest part of running nZEDb, setting it up!

## TODO
- More documentation
- PreDB auto-population

## Acknowledgements
- Based on work from [alp-nzedb](https://github.com/MichaelLindsey/alp-nzedb)
- Hats off to the guys moving [nZEDb](https://nzedb.github.io/) forward.

