.PHONY: release

release:
	rm -rf release
	mkdir -p release
	tar -czf rebuild-detector.tar.gz checkrebuild LICENSE rebuild-detector.hook
	gpg --detach-sign --yes rebuild-detector.tar.gz
	mv rebuild-detector.tar.gz* release
