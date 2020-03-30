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
	tar cf $(DISTNAME).tar $(DISTNAME)
	gzip -f -9 $(DISTNAME).tar
	tar cf $(DISTNAME).zip $(DISTNAME)
	rm -r $(DISTNAME)

.PHONY: clean
clean: test-pre-clean
	rm -f $(DISTNAME).tar.gz $(DISTNAME).zip
	rm VERSION-FILE

install: installdirs
	$(INSTALL_PROGRAM) todo.sh $(DESTDIR)$(bindir)/todo.sh
	$(INSTALL_DATA) todo_completion $(DESTDIR)$(datarootdir)/todo
	[ -e $(DESTDIR)$(sysconfdir)/todo/config ] || \
	    sed "s/^\(export[ \t]*TODO_DIR=\).*/\1~\/.todo/" todo.cfg > $(DESTDIR)$(sysconfdir)/todo/config

uninstall:
	rm -f $(DESTDIR)$(bindir)/todo.sh
	rm -f $(DESTDIR)$(datarootdir)/todo
	rm -f $(DESTDIR)$(sysconfdir)/todo/config

	rmdir $(DESTDIR)$(datarootdir)
	rmdir $(DESTDIR)$(sysconfdir)/todo

installdirs:
	mkdir -p $(DESTDIR)$(bindir) \
	         $(DESTDIR)$(sysconfdir)/todo \
	         $(DESTDIR)$(datarootdir)

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

