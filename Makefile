.PHONY: attach backup build help logs mysql restore shell start status stop test

COMPOSE="venv/bin/docker-compose"

help:
	@echo "Welcome to simply-nzedb!"
	@echo ""
	@echo "Core commands:"
	@echo ""
	@echo "  attach - attach to nzedb's tmux session"
	@echo "  backup - backup database. nzedb must be running"
	@echo "  help - print this help"
	@echo "  logs - print container logs"
	@echo "  mysql - mysql client"
	@echo "  mysqltuner - run mysql tuner"
	@echo "  pull - pull the latest version"
	@echo "  restore - restore last database backup. nzedb must be running"
	@echo "  shell - shell into the nzedb container"
	@echo "  start - start nzedb (restarts if it is already running)"
	@echo "  status - shows running containers"
	@echo "  stop - stops nzedb"
	@echo ""
	@echo "Developer commands:"
	@echo ""
	@echo "  build - build docker images locally instead of downloading from docker hub"
	@echo "  test - run acceptance tests"
	@echo ""

attach:
	@bin/attach_tmux

backup:
	@bin/backup_db

build:
	@bin/build_nzedb

logs:
	@$(COMPOSE) logs

mysql:
	@bin/mysql

mysqltuner:
	@bin/mysqltuner

pull:
	@$(COMPOSE) pull

restore:
	@bin/restore_db

shell:
	@bin/nzedb_shell

start:
	@bin/start_nzedb

status:
	@$(COMPOSE) ps

stop:
	@bin/stop_nzedb

test:
	@bin/acceptance_test

venv:
	@bin/build_virtualenv
