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

.PHONY: up.dev.db shell.dev.db.restart.dev.db logs.dev.db
up.dev.db:
	@${CONTAINER_CLI} compose up dev.db -d
shell.dev.db:
	@${CONTAINER_CLI} compose exec -it dev.db /bin/sh
restart.dev.db:
	@${CONTAINER_CLI} compose restart dev.db
logs.dev.db:
	@${CONTAINER_CLI} compose logs dev.db -f

.PHONY: up.dev shell.dev.restart.dev logs.dev
up.dev:
	@${CONTAINER_CLI} compose up dev -d
shell.dev:
	@${CONTAINER_CLI} compose exec dev /bin/sh
restart.dev:
	@${CONTAINER_CLI} compose restart dev
logs.dev:
	@${CONTAINER_CLI} compose logs dev -f

.PHONY: prep.elastic
prep.elastic:
	@echo "Setup fleet policies for apm agent"
	@./deploy/elastic/scripts/setup_package_policy.sh

.PHONY: start
start:
	@$(MAKE) prep.elastic &
	@$(MAKE) up
