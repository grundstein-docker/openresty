.PHONY: \
	all \
	dev \
	build \
	run \
	debug \
	logs \
	rm \
	stop \
	backup \
	help

# TASKS

all: help

dev: run logs

build:
	@./cli.sh build

run:
	@./cli.sh run

debug:
	@./cli.sh debug

logs:
	@./cli.sh logs

rm:
	@./cli.sh remove

stop:
	@./cli.sh stop

ip:
	@./cli.sh ip

# help output
help:
	@./cli.sh help