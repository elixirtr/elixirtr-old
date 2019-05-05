VERSION := $(strip $(shell [ -d .git ] && git describe --always --tags --dirty))
LAST_TAGGED_VERSION := $(strip $(shell [ -d .git ] && git describe --always --tags --abbrev=0 | sed -e 's/^v//'))
BUILD_DATE := $(shell date -u +"%Y-%m-%dT%H:%M:%S%Z")
VCS_URL := $(shell [ -d .git ] && git config --get remote.origin.url)
VCS_REF := $(strip $(shell [ -d .git ] && git rev-parse --short HEAD))
IS_TAG := $(shell [ -d .git ] && git describe --exact-match HEAD)
VCS_REF_MSG := $(shell if [ "$(IS_TAG)" != "" ]; then git tag -l -n1 $(IS_TAG) | awk '{$$1 = ""; print $$0;}'; else git log --format='%s' -n 1 $(VCS_REF); fi)

check-version:
	$(info $(VERSION))
ifneq (,$(findstring dirty,$(VERSION)))
	$(error Working copy dirty, aborting)
endif

fetch-dependencies:
	mix --version
	@mix deps.get

docker-build: fetch-dependencies
	docker build \
		--build-arg BUILD_DATE="$(BUILD_DATE)" \
		--build-arg VERSION="$(VERSION)" \
		--build-arg VCS_URL="$(VCS_URL)" \
		--build-arg VCS_REF="$(VCS_REF)" \
		--build-arg VCS_REF_MSG="$(VCS_REF_MSG)" \
		--compress \
		-t kakkoyun/elixirtr:latest .

docker-push: check-version
ifeq (v$(LAST_TAGGED_VERSION),$(VERSION))
	docker tag kakkoyun/elixirtr:latest kakkoyun/elixirtr:$(LAST_TAGGED_VERSION)
endif
	docker push kakkoyun/elixirtr
# heroku container:push web

docker-run: docker-build
	docker-compose -f docker-build-compose.yml up

.PHONY: check-version fetch-dependencies docker-build docker-push docker-run

# docker-release: docker-push
# 	heroku container:release web

# .PHONY: docker-release
