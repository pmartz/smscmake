This is a set of scripts to ease the task of creating initial CMake caches (CMakeCache.txt).

### Install Instructions ###

  1. Checkout the source into some directory `<DIR>`.
  1. Add `<DIR>` to your system PATH.
  1. Add an environment variable SMSCMAKE\_DIR and set its value to `<DIR>`.
  1. Copy the file `<DIR>`/extra/sms-cache-local.txt to `<DIR>`/sms-cache-local.txt
  1. Edit `<DIR>`/sms-cache-local.txt. Set the paths of all your dependencies. Modify any other variable values as desired.

### Usage Instructions ###

To create an initial CMakeCache.txt:
  1. In a shell, `cd` to a project directory containing CMakeLists.txt.
  1. Create s subdirectory `<BLD>` and `cd` into it.
  1. Issue the command `smscmake`.

To regenerate project/makefiles from an existing cache:
```
> smscmake /f
```

### Command Line ###> smscmake [options] [path-to-project-root]

If path-to-project-root is absent, ".." is used.

All command line options
  * *`/3`*             OpenGL3 project and deps (JAG, etc).
  * *`/c <cache>`*     Preload cache with this CMake script. Default: cmake_cache.txt rem                   Must be located in SMSCMAKE_DIR (set as env var).
  * *`/f`*             Fast mode. Just issue the CMake command.
  * *`/i <instdir>`*   Project installation dir.
  * *`/n`*             Use nmake generator. Default: VS2012/64
  * *`/s`*             Create static libs. Default: shared

=== Description of files ===

  * *smscmake.bat* Parses batch file options and creates a CMake.exe command line.
  * *sms-cache.txt* A CMake script to populate the CMakeCache.txt. You should not need to make local changes to this file, but modifications to support building new projects or including new dependencies should be submitted as a patch file attached to an issue.
  * *extra/sms-cache-local.txt* A template for local / personal CMake settings, primarily the install locations of various dependencies.```