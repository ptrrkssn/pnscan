# Makefile for pnscan

# Some 'make' variants does not include CPPFLAGS when compiling, some do
.c.o:
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

DESTDIR=/usr/local

BINDIR=$(DESTDIR)/bin
MANDIR=$(DESTDIR)/man
MAN1DIR=$(MANDIR)/man1

TAR=tar
GZIP=gzip
MAKE=make
INSTALL=./install-sh

CFLAGS=-pthread -Wall -O2 -g
LDFLAGS=-pthread
LIBS=

## FreeBSD
BSD_CFLAGS=
BSD_LIBS=

## Solaris/OmniOS
SOL_CFLAGS=
SOL_LIBS=-lnsl -lsocket

## Linux
LNX_CFLAGS=
LNX_LIBS=

# True64
T64_CFLAGS=
T64_LIBS=


OBJS = pnscan.o bm.o version.o


auto build:
	@$(MAKE) `uname -s` || echo "Use 'make help' for list of targets."

help:
	@echo 'Use "make SYSTEM" where SYSTEM may be:'
	@echo '   lnx      (Linux with GCC)'
	@echo '   sol      (Solaris with GCC)'
	@echo '   solcc    (Solaris with Sun Studio C)'
	@echo '   t64      (Tru64 Unix with Compaq C)'
	@echo '   bsd      (FreeBSD)'
	@exit 1


t64 tru64 osf1 digitalunix:
	@$(MAKE) CFLAGS="$(CFLAGS) $(T64_CFLAGS)" LIBS="$(LIBS) $(T64_LIBS)" all

lnx linux Linux:
	@$(MAKE) CFLAGS="$(CFLAGS) $(LNX_CFLAGS)" LIBS="$(LIBS) $(LNX_LIBS)" all

bsd freebsd FreeBSD:
	@$(MAKE) CFLAGS="$(CFLAGS) $(BSD_CFLAGS)" LIBS="$(LIBS) $(BSD_LIBS)" all

sol solaris SunOS:
	@$(MAKE) CFLAGS="$(CFLAGS) $(SOL_CFLAGS)" LIBS="$(LIBS) $(SOL_LIBS)" all


all: pnscan

man: pnscan.1 ipsort.1

pnscan.1:	pnscan.sgml
	docbook2man pnscan.sgml

ipsort.1:	ipsort.sgml
	docbook2man ipsort.sgml

pnscan: $(OBJS)
	$(CC) $(LDFLAGS) -o pnscan $(OBJS) $(LIBS) 


version:
	(PACKNAME=`basename \`pwd\`` ; echo 'char version[] = "'`echo $$PACKNAME | cut -d- -f2`'";' >version.c)

clean distclean:
	-rm -f *.o *~ pnscan core manpage.* \#*

dist:	distclean version
	(PACKNAME=`basename \`pwd\`` ; cd .. ; $(TAR) cf - $$PACKNAME | $(GZIP) -9 >$$PACKNAME.tar.gz)



install:	install-bin install-man

install-bin: all
	$(INSTALL) -c -m 755 pnscan $(BINDIR)
	$(INSTALL) -c -m 755 ipsort $(BINDIR)

install-man: man
	$(INSTALL) -c -m 644 pnscan.1 $(MAN1DIR)
	$(INSTALL) -c -m 644 ipsort.1 $(MAN1DIR)


install-all install-distribution: install

push: 	clean
	git add -A && git commit -a && git push

pull:	clean
	git pull

