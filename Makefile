.PHONY: release

release:
	rm -rf release
	mkdir -p release
	tar -czf rebuild-detector.tar.gz checkrebuild LICENSE
	gpg --detach-sign --yes rebuild-detector.tar.gz
	mv rebuild-detector.tar.gz* release
