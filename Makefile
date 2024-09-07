###############################################################################
# User settings
###############################################################################
VENV			 = .venv
PYTHON			 = $(VENV)/bin/python
PIP				 = $(VENV)/bin/pip

DOCKER			 = docker
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
SPHINXAUTOBUILD	?= $(VENV)/bin/sphinx-autobuild
PORT			?= 8000

#######################################
# Docker
#######################################
BUILD_IMAGE		 = sphinx-nginx

###############################################################################
# Rule
###############################################################################
all: build run

$(VENV):
	python3 -m venv $@

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
autobuild: Makefile $(VENV)
	@$(SPHINXAUTOBUILD) $(SOURCEDIR) $(BUILDDIR)/html --port $(PORT)

#######################################
# Docker
#######################################
.PHONY: build
build: html
	$(DOCKER) build --rm -t $(BUILD_IMAGE):$(VERSION) .
	$(DOCKER) tag $(BUILD_IMAGE):$(VERSION) $(BUILD_IMAGE):latest

.PHONY: run
run:
	$(DOCKER) run --rm --name sphinx-nginx -d -p 8080:80 $(BUILD_IMAGE):latest

.PHONY: clean
clean:
	rm -rf $(VENV) $(BUILDDIR)
	$(DOCKER) image prune -a -f
