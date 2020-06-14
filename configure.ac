#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([Parallel Network Scanner], [1.14.1], [pen@lysator.liu.se], [pnscan], [https://github.com/ptrrkssn/pnscan])

AC_CONFIG_SRCDIR([pnscan.c])
AC_CONFIG_HEADERS([config.h])

AC_CONFIG_AUX_DIR([aux])

# Checks for programs.
AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_MAKE_SET

# Checks for libraries.
AC_CHECK_LIB([pthread], [pthread_create])
AC_CHECK_LIB([socket], [connect])
AC_CHECK_LIB([nsl], [gethostbyname])

# Checks for header files.
AC_CHECK_HEADERS([arpa/inet.h fcntl.h locale.h netdb.h netinet/in.h stdlib.h string.h sys/socket.h sys/time.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.
AC_FUNC_MALLOC
AC_CHECK_FUNCS([atexit gethostbyaddr gethostbyname inet_ntoa memset setlocale socket strdup strerror])

AC_CONFIG_FILES([Makefile pkgs/Makefile.port])
AC_OUTPUT
