###############################################################################
# User settings
###############################################################################
VENV			 = .venv
PYTHON			 = $(VENV)/bin/python
PIP				 = $(VENV)/bin/pip

VERSION			 = 1.0.0

#######################################
# Sphinx
#######################################
SPHINXOPTS		?=
SPHINXBUILD		?= $(VENV)/bin/sphinx-build
SOURCEDIR		 = source
BUILDDIR		 = build

#######################################
# sphinx-autobuild
#######################################
SPHINXAUTOBUILD	?= sphinx-autobuild
PORT			?= 8000

#######################################
# Docker
#######################################
DOCKER			 = docker
BUILD_IMAGE		 = sphinx-nginx
RUN_PORT		 = 8080

BUILD_FLAGS		 = --tag $(BUILD_IMAGE):$(VERSION)
BUILD_FLAGS		+= --rm

RUN_FLAGS		 = --name sphinx-nginx
RUN_FLAGS		+= --detach
RUN_FLAGS		+= --rm
RUN_FLAGS		+= --publish $(RUN_PORT):80

###############################################################################
# Rules
###############################################################################
all: build run

$(VENV):
	python3 -m venv $@
	$(PIP) install -r requirements.txt

.PHONY: requirements.txt
requirements.txt:
	$(PIP) freeze > $@

#######################################
# Sphinx
#######################################
help: $(VENV)
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

%: Makefile $(VENV)
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

#######################################
# sphinx-autobuild
#######################################
autobuild: html $(VENV)
	@$(SPHINXAUTOBUILD) $(SOURCEDIR) $(BUILDDIR)/html --port $(PORT)

#######################################
# Docker
#######################################
.PHONY: build
build: html
	$(DOCKER) build $(BUILD_FLAGS) .
	$(DOCKER) tag $(BUILD_IMAGE):$(VERSION) $(BUILD_IMAGE):latest

.PHONY: run
run:
	$(DOCKER) run $(RUN_FLAGS) $(BUILD_IMAGE):latest

.PHONY: clean
clean:
	rm -rf $(VENV) $(BUILDDIR)
	$(DOCKER) image prune --all --force
