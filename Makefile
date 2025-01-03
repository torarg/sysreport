NAME					=	sysreport
PREFIX					?=	/usr/local
CONFIG_PATH				=	${PREFIX}/share/$(NAME)
BIN_PATH				= 	${PREFIX}/bin/$(NAME)
PLUGINS_PATH			= 	$(CONFIG_PATH)/plugins
OPENBSD_PORTS_DIR		= 	/usr/ports/sysutils/$(NAME)
OPENBSD_PKG_DIR			= 	/usr/ports/packages/amd64/all
OPENBSD_SIGNED_PKG_DIR	= 	/usr/ports/packages/amd64/all/signed
OPENBSD_PKG_KEY			= 	~/keys/signify/1wilson-pkg.sec
OPENBSD_PKG_HOST		=	www

install:
	install -m 0755 -d $(CONFIG_PATH)
	install -m 0755 ./bin/$(NAME) $(BIN_PATH)
	cp -r ./plugins $(CONFIG_PATH)/
	chmod -R 755 $(PLUGINS_PATH)

uninstall:
	rm -r $(CONFIG_PATH) $(BIN_PATH)

all:

clean:

clean-openbsd-package:
	rm -fr /usr/ports/pobj/$(NAME)-*
	rm -fr rm  -r /usr/ports/plist/amd64/$(NAME)-*
	rm -fr /usr/ports/pobj/$(NAME)-*/
	rm -fr /usr/ports/packages/amd64/all/$(NAME)-*.tgz
	rm -fr /usr/ports/distfiles/$(NAME)-*.tar.gz
	rm -fr $(OPENBSD_PORTS_DIR)

openbsd-package: clean-openbsd-package
	cp -r openbsd_package/ $(OPENBSD_PORTS_DIR)
	cd /usr/ports/sysutils/$(NAME) && \
	  make clean && \
      make makesum && \
	  make build && \
	  make fake && \
	  make update-plist && \
	  make package
	pkg_sign -C -o $(OPENBSD_SIGNED_PKG_DIR) -S $(OPENBSD_PKG_DIR) -s signify2 -s $(OPENBSD_PKG_KEY)

publish-openbsd-package: openbsd-package
	scp $(OPENBSD_SIGNED_PKG_DIR)/$(NAME)-*.tgz www:
	ssh $(OPENBSD_PKG_HOST) "\
		doas cp $(NAME)-*.tgz /var/www/htdocs/pub/OpenBSD/snapshots/packages/amd64/ && \
		doas cp $(NAME)-*.tgz /var/www/htdocs/pub/OpenBSD/7.5/packages/amd64/ && \
		doas rm $(NAME)-*.tgz && \
		doas chown www /var/www/htdocs/pub/OpenBSD/snapshots/packages/amd64/$(NAME)-*.tgz && \
		doas chown www /var/www/htdocs/pub/OpenBSD/7.5/packages/amd64/$(NAME)-*.tgz"

bumpversion:
	VERSION=$$(head -1 < CHANGELOG.md | awk '{ print $$2 }')  && \
		sed -i "s/^V.*=.*$$/V				=	$$VERSION/g" openbsd_package/Makefile && \
		sed -i "s/^VERSION=.*$$/VERSION=$$VERSION/g" bin/$(NAME) && \
		git add openbsd_package/Makefile bin/$(NAME) && \
		git commit -m "bump version to $$VERSION"

release-tag:
	git tag $$VERSION

publish-tag:
	git push --tags

release: bumpversion release-tag publish-openbsd-package publish-tag
