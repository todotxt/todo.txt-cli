#
# Makefile for todo.txt
#

# Dynamically detect/generate version file as necessary
# This file will define a variable called VERSION.
.PHONY: .FORCE-VERSION-FILE
VERSION-FILE: .FORCE-VERSION-FILE
	@./GEN-VERSION-FILE
-include VERSION-FILE

# Maybe this will include the version in it.
todo.sh: VERSION-FILE

# For packaging
DISTFILES := README todo.cfg todo.sh

DISTNAME=todo.sh-$(VERSION)
dist: $(DISTFILES) todo.sh
	mkdir -p $(DISTNAME)
	cp -f $(DISTFILES) $(DISTNAME)/
	tar cf $(DISTNAME).tar $(DISTNAME)/
	gzip -f -9 $(DISTNAME).tar
	zip -9r $(DISTNAME).zip $(DISTNAME)/
	rm -r $(DISTNAME)

.PHONY: clean
clean:
	rm -f $(DISTNAME).tar.gz $(DISTNAME).zip

.PHONY: test
test:
	@echo "TBD!"
