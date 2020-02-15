# rebuild-detector

This tool helps you find Arch Linux packages that were built against older versions of dependencies and therefore need to be rebuilt to function properly.

Supported checks:

- `ldd`: An executable is linked against a non-existent shared library
- `python`: A package was built against an older Python version
- `perl`: A package was built against an older Perl version
- `ruby`: A package was built against an older Ruby version
- `haskell`: A package was built against an older Haskell version

## Installation

The package is available on AUR: https://aur.archlinux.org/packages/rebuild-detector/

## Usage

Run `checkrebuild` to see which packages need to be rebuilt.

Use verbose mode `checkrebuild -v` to get a bit more information about why these packages are flagged.

By default only packages from local repos (`file://`) are checked, if you want to include additional repos, use `-i` flag like so: `checkrebuild -i repo1 -i repo2`

## Pacman hook

A pacman hook is included in the distribution as well. For performance reasons, the `ldd` check is only executed against direct dependencies of the packages that are being updated in this pacman transaction.
