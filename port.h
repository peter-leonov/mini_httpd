/* port.h - portability defines */

#if defined(__FreeBSD__)
# define FreeBSD
# define ARCH "FreeBSD"
#else
# if defined(linux)
#  define Linux
#  define ARCH "Linux"
# else
#  if defined(sun)
#   define Solaris
#   define ARCH "Solaris"
#  else
#   define UNKNOWN
#   define ARCH "UNKNOWN"
#  endif
# endif
#endif

#ifdef FreeBSD
# include <osreldate.h>
# define HAVE_DAEMON
# define HAVE_SETSID
# define HAVE_SETLOGIN
# define HAVE_WAITPID
# define HAVE_HSTRERROR
# define HAVE_TM_GMTOFF
# define HAVE_SENDFILE
# ifdef SO_ACCEPTFILTER
#  define HAVE_ACCEPT_FILTERS
#  if ( __FreeBSD_version >= 411000 )
#   define ACCEPT_FILTER_NAME "httpready"
#  else
#   define ACCEPT_FILTER_NAME "dataready"
#  endif
# endif /* SO_ACCEPTFILTER */
#endif /* FreeBSD */

#ifdef Linux
# define HAVE_DAEMON
# define HAVE_SETSID
# define HAVE_WAITPID
# define HAVE_SENDFILE
#endif /* Linix */

#ifdef Solaris
# define HAVE_SETSID
# define HAVE_WAITPID
# define HAVE_MEMORY_H
#endif /* Solaris */

#ifdef USE_IPV6
# define HAVE_SOCKADDR_IN6
# define HAVE_SOCKADDR_STORAGE
# define HAVE_GETADDRINFO
# define HAVE_GETNAMEINFO
# define HAVE_GAI_STRERROR
#endif /* USE_IPV6 */
