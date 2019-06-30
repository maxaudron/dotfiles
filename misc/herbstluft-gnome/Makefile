#
# Global Settings
#

INSTALL = install
DESTDIR ?= /
PREFIX  ?= $(DESTDIR)/usr

PATH_herbstluft_GNOME = $(PREFIX)/bin/herbstluft-gnome
PATH_herbstluft_GNOME_DESKTOP = $(PREFIX)/share/applications/herbstluft-gnome.desktop
PATH_herbstluft_GNOME_SESSION = $(PREFIX)/share/gnome-session/sessions/herbstluft-gnome.session
PATH_herbstluft_GNOME_XSESSION = $(PREFIX)/share/xsessions/herbstluft-gnome.desktop
PATH_GNOME_SESSION_herbstluft = $(PREFIX)/bin/gnome-session-herbstluft

#
# Targets
#

all:
	@echo "Nothing to do"


install:
	$(INSTALL) -m0644 -D session/herbstluft-gnome-xsession.desktop $(PATH_herbstluft_GNOME_XSESSION)
	$(INSTALL) -m0644 -D session/herbstluft-gnome.desktop $(PATH_herbstluft_GNOME_DESKTOP)
	$(INSTALL) -m0644 -D session/herbstluft-gnome.session $(PATH_herbstluft_GNOME_SESSION)
	$(INSTALL) -m0755 -D session/herbstluft-gnome $(PATH_herbstluft_GNOME)
	$(INSTALL) -m0755 -D session/gnome-session-herbstluft $(PATH_GNOME_SESSION_herbstluft)



uninstall:
	rm -f $(PATH_herbstluft_GNOME)
	rm -f $(PATH_herbstluft_GNOME_DESKTOP)
	rm -f $(PATH_herbstluft_GNOME_SESSION)
	rm -f $(PATH_herbstluft_GNOME_XSESSION)
	rm -f $(PATH_GNOME_SESSION_herbstluft)



.PHONY: all install uninstall
