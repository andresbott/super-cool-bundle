PWD_DIR := ${CURDIR}

default: help

#==========================================================================================
##@ Testing
#==========================================================================================
test: ## run unit tests
	@mvn test

.PHONY: verify
verify: ## run the full maven check gate (compile, test, package)
	@mvn verify

#==========================================================================================
##@ Building
#==========================================================================================
package: ## build the OSGi bundle jar into target/
	@mvn clean package

install: ## build and install the bundle into the local maven repo (~/.m2)
	@mvn clean install

#==========================================================================================
##@ Release
#==========================================================================================

.PHONY: check-branch
check-branch:
	@current_branch=$$(git symbolic-ref --short HEAD) && \
	if [ "$$current_branch" != "main" ]; then \
		echo "Error: You are on branch '$$current_branch'. Please switch to 'main'."; \
		exit 1; \
	fi

.PHONY: check-git-clean
check-git-clean: # check if git repo is clean
	@git diff --quiet

tag: check-git-clean check-branch ## create a git tag to publish a new release (JitPack + GitHub release)
	@[ "${version}" ] || ( echo ">> version is not set, usage: make tag version=\"1.2.3\" "; exit 1 )
	@git tag -d $(version) || true
	@git tag -a $(version) -m "Release version: $(version)"
	@git push --delete origin $(version) || true
	@git push origin $(version) || true

clean: ## clean build env
	@mvn clean

#==========================================================================================
#  Help
#==========================================================================================
.PHONY: help
help: # Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
