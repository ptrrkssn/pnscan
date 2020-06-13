# Makefile for pkgs

PORTSDIR=/usr/ports
PORTSNAME=sysutils/pnscan

all:
	@echo "Use 'make port'"
	@exit 1

port:	Makefile.port pkg-descr
	mkdir -p "$(PORTSDIR)/$(PORTSNAME)"
	cp Makefile.port "$(PORTSDIR)/$(PORTSNAME)/Makefile"
	cp pkg-descr "$(PORTSDIR)/$(PORTSNAME)"
	(cd "$(PORTSDIR)/$(PORTSNAME)" && make distclean && make makesum && portlint -AC)


# Clean targets
maintainer-clean:	distclean

distclean:		clean
	rm -fr Makefile.port

clean mostlyclean:
	-rm -f *~ \#*
