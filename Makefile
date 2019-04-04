EXECUTABLE_NAME = coupage
REPO = https://github.com/Kota4822/Coupage
VERSION = 0.92.0

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(EXECUTABLE_NAME)
BUILD_PATH = .build/release/$(EXECUTABLE_NAME)
CURRENT_PATH = $(PWD)
RELEASE_TAR = $(REPO)/archive/$(VERSION).tar.gz

.PHONY: install build uninstall format_code publish release

install: build
	mkdir -p $(PREFIX)/bin
	cp -f $(BUILD_PATH) $(INSTALL_PATH)

build:
	swift build --disable-sandbox -c release
