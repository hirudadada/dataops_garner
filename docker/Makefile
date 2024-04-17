include Makefile.env

.PHONY: print.env

print.env:
	@echo "Environment variables in make process:"
	@$(foreach V,$(sort $(.VARIABLES)), $(if $(filter-out environment% default automatic,$(origin $V)),$(warning $V=$($V) )))

.PHONY: build.rel push.rel run.rel image.rel
build.rel:
	@$(MAKE) -C build/rel build
push.rel:
	@$(MAKE) -C build/rel push
run.rel:
	@$(MAKE) -C build/rel run
image.rel:
	@$(MAKE) -C build/rel image

.PHONY: build.dev push.dev run.dev image.dev
build.dev:
	@$(MAKE) -C build/dev build
push.dev:
	@$(MAKE) -C build/dev push
run.dev:
	@$(MAKE) -C build/dev run
image.dev:
	@$(MAKE) -C build/dev image

.PHONY: prune clean
prune:
	@${CONTAINER_CLI} image prune -f
	clean: prune

.PHONY: up down down.rm ps logs
up:
	@${CONTAINER_CLI} compose up -d
down:
	@${CONTAINER_CLI} compose down
down.rm:
	@${CONTAINER_CLI} compose down --remove-orphans -v
ps:
	@${CONTAINER_CLI} compose ps -a
logs:
	@${CONTAINER_CLI} compose log -f

.PHONY: up.apm shell.apm.restart.apm logs.apm
up.apm:
	@${CONTAINER_CLI} compose up apm -d
shell.apm:
	@${CONTAINER_CLI} compose exec -it apm /bin/sh
restart.apm:
	@${CONTAINER_CLI} compose restart apm
logs.apm:
	@${CONTAINER_CLI} compose logs apm -f

.PHONY: up.app.db1 shell.app.db1.restart.app.db1 logs.app.db1
up.app.db1:
	@${CONTAINER_CLI} compose up app.db1 -d
shell.app.db1:
	@${CONTAINER_CLI} compose exec -it app.db1 /bin/sh
restart.app.db1:
	@${CONTAINER_CLI} compose restart app.db1
logs.app.db1:
	@${CONTAINER_CLI} compose logs app.db1 -f

.PHONY: up.app shell.app restart.app logs.app
up.app:
	@${CONTAINER_CLI} compose up app -d
shell.app:
	@${CONTAINER_CLI} compose exec -it app /bin/sh
restart.app:
	@${CONTAINER_CLI} compose restart app
logs.app:
	@${CONTAINER_CLI} compose logs app -f

.PHONY: prep.elastic
prep.elastic:
	@echo "Setup fleet policies for apm agent"
	@./deploy/elastic/scripts/setup_package_policy.sh

.PHONY: start
start:
	@$(MAKE) prep.elastic &
	@$(MAKE) up
