#
# Makefile for todo.txt
#

SHELL = /bin/sh

INSTALL = /usr/bin/install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644

prefix = /usr/local

# ifdef check allows the user to pass custom dirs
# as per the README

# The directory to install todo.sh in.
ifdef INSTALL_DIR
	bindir = $(INSTALL_DIR)
else
	bindir = $(prefix)/bin
endif

# The directory to install the config file in.
ifdef CONFIG_DIR
	sysconfdir = $(CONFIG_DIR)
else
	sysconfdir = $(prefix)/etc
endif

ifdef BASH_COMPLETION
	datarootdir = $(BASH_COMPLETION)
else
	datarootdir = $(prefix)/share/bash_completion.d
endif

# Dynamically detect/generate version file as necessary
# This file will define a variable called VERSION used in
# both todo.sh and this Makefile.
VERSION-FILE:
	@./GEN-VERSION-FILE
-include VERSION-FILE

# dist/build directory name
DISTNAME=todo.txt_cli-$(VERSION)

# files to copy unmodified into the dist directory
SRC_FILES := todo.cfg todo_completion

# path of SRC_FILES in the dist directory
OUTPUT_FILES := $(patsubst %, $(DISTNAME)/%, $(SRC_FILES))

# all dist files
DISTFILES := $(OUTPUT_FILES) $(DISTNAME)/todo.sh

# create the dist directory
$(DISTNAME): VERSION-FILE
	mkdir -p $(DISTNAME)

# copy SRC_FILES to the dist directory
$(OUTPUT_FILES): $(DISTNAME)/%: %
	cp -f $(*) $(DISTNAME)/

# generate todo.sh
$(DISTNAME)/todo.sh: VERSION-FILE
	sed -e 's/@DEV_VERSION@/'$(VERSION)'/' todo.sh > $(DISTNAME)/todo.sh
	chmod +x $(DISTNAME)/todo.sh

.PHONY: build
build: $(DISTNAME) $(DISTFILES)  ## create the dist directory and files

.PHONY: dist
dist: build   ## create the compressed release files
	tar cf $(DISTNAME).tar $(DISTNAME)
	gzip -f -9 $(DISTNAME).tar
	zip -r -9 $(DISTNAME).zip $(DISTNAME)
	rm -r $(DISTNAME)

.PHONY: clean
clean: test-pre-clean VERSION-FILE   ## remove dist directory and all release files
	rm -rf $(DISTNAME)
	rm -f $(DISTNAME).tar.gz $(DISTNAME).zip

.PHONY: install
install: build installdirs   ## local package install
	$(INSTALL_PROGRAM) $(DISTNAME)/todo.sh $(DESTDIR)$(bindir)/todo.sh
	$(INSTALL_DATA) $(DISTNAME)/todo_completion $(DESTDIR)$(datarootdir)/todo.sh
	[ -e $(DESTDIR)$(sysconfdir)/todo/config ] || \
	    sed "s/^\(export[ \t]*TODO_DIR=\).*/\1~\/.todo/" $(DISTNAME)/todo.cfg > $(DESTDIR)$(sysconfdir)/todo/config

.PHONY: uninstall
uninstall:   ## uninstall package
	rm -f $(DESTDIR)$(bindir)/todo.sh
	rm -f $(DESTDIR)$(datarootdir)/todo
	rm -f $(DESTDIR)$(sysconfdir)/todo/config

	rmdir $(DESTDIR)$(datarootdir)
	rmdir $(DESTDIR)$(sysconfdir)/todo

# create local installation directories
.PHONY: installdirs
installdirs:
	mkdir -p $(DESTDIR)$(bindir) \
	         $(DESTDIR)$(sysconfdir)/todo \
	         $(DESTDIR)$(datarootdir)

#
# Testing
#
TESTS = $(wildcard tests/t[0-9][0-9][0-9][0-9]-*.sh)
#TEST_OPTIONS=--verbose

# remove test detritus
test-pre-clean:
	rm -rf tests/test-results "tests/trash directory"*

# run tests and generate test result files
aggregate-results: $(TESTS)

$(TESTS): test-pre-clean
	cd tests && ./$(notdir $@) $(TEST_OPTIONS)

# run tests, print a test result summary, and remove generated test results
test: aggregate-results   ## run tests
	tests/aggregate-results.sh tests/test-results/t*-*
	rm -rf tests/test-results

# Force tests to get run every time
.PHONY: test test-pre-clean aggregate-results $(TESTS)

# generate list of targets from this Makefile
# looks for any lowercase target with a double hash mark (##) on the same line
# and uses the inline comment as the target description
.PHONY: help
.DEFAULT: help
help:                            ## list public targets
	@echo
	@echo todo.txt Makefile
	@echo
	@sed -ne '/^[a-z%-]\+:.*##/ s/:.*##/\t/p' $(word 1, $(MAKEFILE_LIST)) \
	 | column -t -s '	'
	@echo
