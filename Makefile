PREFIX   ?= /usr/local
OBJDIR    = obj
LIBDIR   ?= lib
SRCDIR    = src
DESTDIR   ?=
GPR_FILES = gnat/*.gpr
LIBRARY_TYPE = dynamic

MAJOR   = 0
MINOR   = 1
REV     = 0
VERSION = $(MAJOR).$(MINOR).$(REV)
DBUSADA = libadaaugeas-$(VERSION)

SO_LIBRARY   = libadaaugeas.so.$(VERSION)

PREPARE := $(shell mkdir -p $(OBJDIR) $(LIBDIR))

all: gpr build_lib

build_lib:
	gnatmake -Padaaugeas

gpr:
	gnatprep -b gnat/adaaugeas.gpr.gp gnat/adaaugeas.gpr -DInvoked_By_Makefile \
       '-DIncludedir="$(PREFIX)/include"' '-DLibdir="$(PREFIX)/$(LIBDIR)"' \
       '-DAlidir="$(PREFIX)/$(LIBDIR)"' '-DLibrary_Type="${LIBRARY_TYPE}"'
	gnatprep -b adaaugeas.gpr.gp adaaugeas.gpr -DInvoked_By_Makefile \
       '-DVersion="$(VERSION)"' '-DLibdir="$(LIBDIR)"' \
       '-DLibrary_Type="${LIBRARY_TYPE}"'

build_check:    
	gnatmake -Padaaugeas_tests

install: install_lib

install_lib: build_lib
	install -d $(DESTDIR)$(PREFIX)/include/adaaugeas
	install -d $(DESTDIR)$(PREFIX)/$(LIBDIR)/adaaugeas
	install -d $(DESTDIR)$(PREFIX)/share/gpr
	install -m 644 $(SRCDIR)/*.ad[bs] $(DESTDIR)$(PREFIX)/include/adaaugeas
	install -m 444 $(LIBDIR)/*.ali $(DESTDIR)$(PREFIX)/$(LIBDIR)/adaaugeas
	install -m 644 $(GPR_FILES) $(DESTDIR)$(PREFIX)/share/gpr
	install -m 644 $(LIBDIR)/$(SO_LIBRARY) $(DESTDIR)$(PREFIX)/$(LIBDIR)
	cd $(DESTDIR)$(PREFIX)/$(LIBDIR) && ln -sf $(SO_LIBRARY) libadaaugeas.so

test: build_lib build_check
	./runner

clean:
	@rm -rf $(OBJDIR)
	@rm -rf $(LIBDIR)
	@rm -rf runner

