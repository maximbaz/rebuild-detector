BIN := rebuild-detector

PREFIX ?= /usr
LIB_DIR = $(DESTDIR)$(PREFIX)/lib
BIN_DIR = $(DESTDIR)$(PREFIX)/bin
SHARE_DIR = $(DESTDIR)$(PREFIX)/share

.PHONY: release
release: tag sign

.PHONY: tag
tag:
	[ -n "$(VERSION)" ] || { echo >&2 "VERSION is not set"; exit 1; }
	git tag -s $(VERSION) -m $(VERSION)

.PHONY: sign
sign:
	[ -n "$(VERSION)" ] || { echo >&2 "VERSION is not set"; exit 1; }
	rm -rf release
	mkdir -p release
	git archive -o "release/$(BIN)-$(VERSION).tar.gz" --format tar.gz --prefix "$(BIN)-$(VERSION)/" "$(VERSION)"
	gpg --detach-sign --yes "release/$(BIN)-$(VERSION).tar.gz"
	rm "release/$(BIN)-$(VERSION).tar.gz"

.PHONY: docs
docs:
	marked-man -i README.md -o "$(BIN).7"
	gzip "$(BIN).7"

.PHONY: install
install:
	install -Dm755 -t "$(BIN_DIR)/" checkrebuild
	install -Dm644 -t "$(SHARE_DIR)/licenses/$(BIN)" LICENSE
	install -Dm644 -t "$(SHARE_DIR)/libalpm/hooks" "$(BIN).hook"
	install -Dm644 -t "$(SHARE_DIR)/man/man7" "$(BIN).7.gz"
	install -dm755 "$(SHARE_DIR)/man/man1"
	ln -Tsf "/usr/share/man/man7/$(BIN).7.gz" "$(SHARE_DIR)/man/man1/checkrebuild.1.gz"
