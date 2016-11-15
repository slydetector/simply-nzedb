#!/bin/bash
#
# Allow changing id of mysql user and group because the hardcoded
# id in the mysql image is a PITA with host volumes (having to use sudo
# to remove files, etc).
if [ -e "/mysql_user" ]; then
  source /mysql_user

  if ! id --user $PUID; then 
    echo "Changing mysql user to uid $PUID"
    usermod --uid $PUID mysql
  fi

  if ! id --group $PGID;  then
    echo "Changing mysql group to gid $PGID"
    groupmod --gid $PGID mysql
  fi

fi

source /docker-entrypoint.sh

