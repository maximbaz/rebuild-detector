BIN := rebuild-detector
VERSION := 4.4.0

.PHONY: release
release:
	rm -rf release
	mkdir -p release
	git archive -o "release/$(BIN)-$(VERSION).tar.gz" --format tar.gz --prefix "$(BIN)-$(VERSION)/" "$(VERSION)"
	gpg --detach-sign --yes "release/$(BIN)-$(VERSION).tar.gz"
