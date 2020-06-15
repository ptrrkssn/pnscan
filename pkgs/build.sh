#!/usr/bin/bash
#
# {{{ CDDL HEADER
#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source. A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
# }}}

# Copyright 2020 OmniOS Community Edition (OmniOSce) Association.
. ../../lib/functions.sh

PROG=pnscan
VER=1.14.1
PKG=ooce/network/pnscan
SUMMARY="$PROG - Parallel Network Scanner 1.14.1"
DESC="$PROG is a program to scan IPv4 networks for open TCP services."

set_arch 64

set_mirror "$GITHUB/ptrrkssn/$PROG/archive"
set_checksum "none"

init
download_source v$VER $PROG $VER
prep_build
build
strip_install
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
