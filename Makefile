BIN := rebuild-detector

ifndef VERSION
$(error VERSION is not set)
endif

.PHONY: release
release:
	rm -rf release
	mkdir -p release
	git archive -o "release/$(BIN)-$(VERSION).tar.gz" --format tar.gz --prefix "$(BIN)-$(VERSION)/" "$(VERSION)"
	gpg --detach-sign --yes "release/$(BIN)-$(VERSION).tar.gz"
