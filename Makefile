# Makefile for pnscan

DESTDIR=/usr/local

BINDIR=$(DESTDIR)/bin
MANDIR=$(DESTDIR)/man
MAN1DIR=$(MANDIR)/man1

TAR=tar
GZIP=gzip
MAKE=make
INSTALL=./install-sh


## FreeBSD
BSD_CC=cc -Wall -g -O
BSD_LDOPTS=-Wl,-s 
BSD_LIBS=-lpthread

## Solaris 8 with Gcc 3.0
GSO_CC=gcc -Wall -g -O -pthreads
GSO_LDOPTS=
GSO_LIBS= -lnsl -lsocket

## Solaris 8 with Forte C 6.2
SOL_CC=cc -mt -O
SOL_LDOPTS=
SOL_LIBS= -lpthread -lnsl -lsocket

## Linux 2.4 with Gcc 2.96
LNX_CC=gcc -Wall -g -O
LNX_LDOPTS=-Wl,-s 
LNX_LIBS=-lpthread -lnsl

T64_CC=cc -pthread -O
T64_LDOPTS=
T64_LIBS= -lpthread


OBJS = pnscan.o bm.o version.o


default:
	@echo 'Use "make SYSTEM" where SYSTEM may be:'
	@echo '   lnx      (Linux with GCC)'
	@echo '   gso      (Solaris with GCC v3)'
	@echo '   sol      (Solaris with Forte C)'
	@echo '   t64      (Tru64 Unix with Compaq C)'
	@echo '   bsd      (FreeBSD)'
	@exit 1

auto build:
	@$(MAKE) `uname -s`

t64 tru64 osf1 digitalunix:
	@$(MAKE) all CC="$(T64_CC)" LIBS="$(T64_LIBS)" LDOPTS="$(T64_LDOPTS)"

lnx linux Linux:
	@$(MAKE) all CC="$(LNX_CC)" LIBS="$(LNX_LIBS)" LDOPTS="$(LNX_LDOPTS)"

bsd freebsd FreeBSD:
	@$(MAKE) all CC="$(BSD_CC)" LIBS="$(BSD_LIBS)" LDOPTS="$(BSD_LDOPTS)"

gso:
	@$(MAKE) all CC="$(GSO_CC)" LIBS="$(GSO_LIBS)" LDOPTS="$(GSO_LDOPTS)"

sol solaris SunOS:
	@$(MAKE) all CC="$(SOL_CC)" LIBS="$(SOL_LIBS)" LDOPTS="$(SOL_LDOPTS)"

all: pnscan

man: pnscan.1 ipsort.1

pnscan.1:	pnscan.sgml
	docbook2man pnscan.sgml

ipsort.1:	ipsort.sgml
	docbook2man ipsort.sgml

pnscan: $(OBJS)
	$(CC) $(LDOPTS) -o pnscan $(OBJS) $(LIBS)


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

