# rebuild-detector

This tool helps you find Arch Linux packages that were built against older versions of dependencies and therefore need to be rebuilt to function properly.

Supported checks:

- `ldd`: An executable is linked against a non-existent shared library
- `python`: A package was built against an older Python version
- `perl`: A package was built against an older Perl version
- `ruby`: A package was built against an older Ruby version
- `haskell`: A package was built against an older Haskell version

## Installation

```sh
pacman -S rebuild-detector
```

## Usage

Run `checkrebuild` to see which packages need to be rebuilt. If you see no output, it means there is nothing to rebuild.

Use verbose mode `checkrebuild -v` to get a bit more information about why these packages are flagged.

By default only packages from local repos (`file://`) are checked, if you want to include additional repos, use `-i` flag like so: `checkrebuild -i repo1 -i repo2`

## What do I do if a package is flagged?

First things first, run `checkrebuild -v` to see exactly why the package is flagged.

If a package is missing a `.so` file, this means the binary is linked against a library that is not present on your computer. It can happen for two reasons:

1. You are missing a dependency entirely
2. The binary is linked against an older version of the installed dependency

The first case cannot be solved by rebuilding the package. Sometimes it can be fixed by installing a missing dependency, but especially if a binary was built by someone else (typical for `-bin` packages) there is nothing you can do.

The second case happens when a package was not flagged in the past, but is suddenly flagged after an update. In this case, `checkrebuild -v` might show that the missing library is e.g. `*-7.so` but you currently have `*-8.so` installed on your computer. This is the case `rebuild-detector` was built for: rebuild the flagged package and the error should be gone.

If you cannot fix the package, the only thing you can do is to ignore it altogether, i.e. next time run `checkrebuild | grep -v broken-pkg`.

## Pacman hook

A pacman hook is included in the distribution as well. For performance reasons, the `ldd` check is only executed against direct dependencies of the packages that are being updated in this pacman transaction.

This can be replicated manually by passing the list of such packages on stdin, e.g. `printf 'pkg1\npkg2' | checkrebuild`. Just remember, this feature is intended for detecting packages that get broken by upgrading `pkg1` and `pkg2`, so in this case `ldd` will not be checking binaries in `pkg1` and `pkg2` themselves, but rather the binaries of all packages who directly depend on `pkg1` or `pkg2`.
