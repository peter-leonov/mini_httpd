# Makefile for mini_httpd

# CONFIGURE: If you are using a SystemV-based operating system, such as
# Solaris, you will need to uncomment this definition.
#SYSV_LIBS =    -lnsl -lsocket

# CONFIGURE: If you want to compile in support for https, uncomment these
# definitions.  You will need to have already built OpenSSL, available at
# http://www.openssl.org/  If you're using FreeBSD you can just go to
# /usr/ports/security/openssl and do a make install.  Make sure the
# SSL_INCDIR and SSL_LIBDIR definitions here point to your OpenSSL
# installation's location.
#SSL_INCDIR =	/usr/local/include
#SSL_LIBDIR =	/usr/local/lib
#SSL_DEFS =	-DUSE_SSL
#SSL_INC =	-I$(SSL_INCDIR)
#SSL_LIBS =	-L$(SSL_LIBDIR) -lssl -lcrypto -lRSAglue -lrsaref

# CONFIGURE: If you want to try building an IPv6-enabled version of
# mini_httpd, uncomment these definitions.  Of course this will only
# succeed if your system supports IPv6.
#IPV6_DEFS =	-DUSE_IPV6
#IPV6_LIBS =	-L/usr/local/v6/lib -linet6


BINDIR =	/usr/local/bin
MANDIR =	/usr/local/man
CC =		gcc
CDEFS =		$(SSL_DEFS) $(SSL_INC) $(IPV6_DEFS)
CFLAGS =	-O $(CDEFS)
#CFLAGS =	-g $(CDEFS)
LDFLAGS =	-s
#LDFLAGS =	-g
LDLIBS =	$(SSL_LIBS) $(IPV6_LIBS) $(SYSV_LIBS)

all:		mini_httpd htpasswd

mini_httpd:	mini_httpd.o tdate_parse.o
	${CC} ${CFLAGS} ${LDFLAGS} mini_httpd.o tdate_parse.o -lcrypt ${LDLIBS} -o mini_httpd

mini_httpd.o:	mini_httpd.c version.h port.h mime_types.h
	${CC} ${CFLAGS} -c mini_httpd.c

tdate_parse.o:	tdate_parse.c
	${CC} ${CFLAGS} -c tdate_parse.c

mime_types.h: mime_types.txt
	rm -f mime_types.h
	sed < mime_types.txt > mime_types.h \
	  -e 's/#.*//' -e 's/[ 	]*$$//' -e '/^$$/d' \
	  -e 's/[ 	][ 	]*/", "/' -e 's/^/{ "/' -e 's/$$/" },/'


htpasswd:	htpasswd.o
	${CC} ${CFLAGS} htpasswd.o ${LDFLAGS} -lcrypt -o htpasswd

htpasswd.o:	htpasswd.c
	${CC} ${CFLAGS} -c htpasswd.c


install:	all
	rm -f ${BINDIR}/mini_httpd ${BINDIR}/htpasswd
	cp mini_httpd htpasswd ${BINDIR}
	rm -f ${MANDIR}/man8/mini_httpd.8 ${MANDIR}/man1/htpasswd.1
	cp mini_httpd.8 ${MANDIR}/man8
	cp htpasswd.1 ${MANDIR}/man1

clean:
	rm -f mini_httpd mime_types.h htpasswd *.o core core.* *.core

tar:
	@name=`sed -n -e '/SERVER_SOFTWARE/!d' -e 's,.*mini_httpd/,mini_httpd-,' -e 's, .*,,p' version.h` ; \
	  rm -rf $$name ; \
	  mkdir $$name ; \
	  tar cf - `cat FILES` | ( cd $$name ; tar xfBp - ) ; \
	  chmod 644 $$name/Makefile $$name/mime_types.txt ; \
	  chmod 755 $$name/contrib $$name/contrib/redhat-rpm ; \
	  tar cf $$name.tar $$name ; \
	  rm -rf $$name ; \
	  gzip $$name.tar
