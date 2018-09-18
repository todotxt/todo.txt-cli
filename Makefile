#
# Makefile for todo.txt
#

SHELL = /bin/sh

INSTALL = /usr/bin/install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644

prefix = /usr/local

# The directory to install todo.sh in.
INSTALL_DIR = $(prefix)/bin

# The directory to install the config file in.
CONFIG_DIR = $(prefix)/etc

BASH_COMPLETION = $(prefix)/share

# Dynamically detect/generate version file as necessary
# This file will define a variable called VERSION.
.PHONY: .FORCE-VERSION-FILE
VERSION-FILE: .FORCE-VERSION-FILE
	@./GEN-VERSION-FILE
-include VERSION-FILE

# Maybe this will include the version in it.
todo.sh: VERSION-FILE

# For packaging
DISTFILES := todo.cfg todo_completion

DISTNAME=todo.txt_cli-$(VERSION)
dist: $(DISTFILES) todo.sh
	mkdir -p $(DISTNAME)
	cp -f $(DISTFILES) $(DISTNAME)/
	sed -e 's/@DEV_VERSION@/'$(VERSION)'/' todo.sh > $(DISTNAME)/todo.sh
	chmod +x $(DISTNAME)/todo.sh
	tar cf $(DISTNAME).tar $(DISTNAME)/
	gzip -f -9 $(DISTNAME).tar
	zip -9r $(DISTNAME).zip $(DISTNAME)/
	rm -r $(DISTNAME)

.PHONY: clean
clean: test-pre-clean
	rm -f $(DISTNAME).tar.gz $(DISTNAME).zip
	rm VERSION-FILE

install: installdirs
	$(INSTALL_PROGRAM) todo.sh $(DESTDIR)$(INSTALL_DIR)/todo.sh
	$(INSTALL_DATA) todo_completion $(DESTDIR)$(BASH_COMPLETION)/bash_completion.d/todo
	[ -e $(DESTDIR)$(CONFIG_DIR)/todo/config ] || \
	    sed "s/^\(export[ \t]*TODO_DIR=\).*/\1~\/.todo/" todo.cfg > $(DESTDIR)$(CONFIG_DIR)/todo/config

uninstall:
	rm -f $(DESTDIR)$(INSTALL_DIR)/todo.sh
	rm -f $(DESTDIR)$(BASH_COMPLETION)/bash_completion.d/todo
	rm -f $(DESTDIR)$(CONFIG_DIR)/todo/config

	rmdir $(DESTDIR)$(BASH_COMPLETION)/bash_completion.d
	rmdir $(DESTDIR)$(CONFIG_DIR)/todo

installdirs:
	mkdir -p $(DESTDIR)$(INSTALL_DIR) \
	         $(DESTDIR)$(CONFIG_DIR)/todo \
	         $(DESTDIR)$(BASH_COMPLETION)/bash_completion.d

#
# Testing
#
TESTS = $(wildcard tests/t[0-9][0-9][0-9][0-9]-*.sh)
#TEST_OPTIONS=--verbose

test-pre-clean:
	rm -rf tests/test-results "tests/trash directory"*

aggregate-results: $(TESTS)

$(TESTS): test-pre-clean
	cd tests && ./$(notdir $@) $(TEST_OPTIONS)

test: aggregate-results
	tests/aggregate-results.sh tests/test-results/t*-*
	rm -rf tests/test-results
    
# Force tests to get run every time
.PHONY: test test-pre-clean aggregate-results $(TESTS)
