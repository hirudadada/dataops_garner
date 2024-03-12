include Makefile.env

.PHONY: env env.show
env:
	@printenv
env.show:
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

.PHONY: up down down.v ps logs
up:
	@${CONTAINER_CLI} compose up -d
down.rm:
	@${CONTAINER_CLI} compose down --remove-orphans
down:
	@${CONTAINER_CLI} compose down
ps:
	@${CONTAINER_CLI} compose ps -a
logs:
	@${CONTAINER_CLI} compose log -f

.PHONY: up.app.apm shell.app.apm.restart.app.apm logs.app.apm
up.app.apm:
	@${CONTAINER_CLI} compose up app.apm -d
shell.app.apm:
	@${CONTAINER_CLI} compose exec -it app.apm /bin/sh
restart.app.apm:
	@${CONTAINER_CLI} compose restart app.apm
logs.app.apm:
	@${CONTAINER_CLI} compose logs app.apm -f

.PHONY: up.app.db shell.app.db.restart.app.db logs.app.db
up.app.db:
	@${CONTAINER_CLI} compose up app.db -d
shell.app.db:
	@${CONTAINER_CLI} compose exec -it app.db /bin/sh
restart.app.db:
	@${CONTAINER_CLI} compose restart app.db
logs.app.db:
	@${CONTAINER_CLI} compose logs app.db -f

.PHONY: up.app shell.app restart.app logs.app
up.app:
	@${CONTAINER_CLI} compose up app -d
shell.app:
	@${CONTAINER_CLI} compose exec -it app /bin/sh
restart.app:
	@${CONTAINER_CLI} compose restart app
logs.app:
	@${CONTAINER_CLI} compose logs app -f
