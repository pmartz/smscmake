@echo off


rem  **  Usage
rem  smscmake [Options]
rem
rem Options:
rem  /3             OpenGL3 project and deps (JAG, etc).
rem  /c <cache>     Preload cache with this CMake script. Default: cmake_cache.txt
rem                   Must be located in SMSCMAKE_DIR (set as env var).
rem  /f             Fast mode. Just issue the CMake command.
rem  /i <instdir>   Project installation dir.
rem  /n             Use nmake generator. Default: VS2012/64
rem  /s             Create static libs. Default: shared
rem


if %SMSCMAKE_DIR%=="" (
    echo Error: Must set SMSCMAKE_DIR in environment to point at smscmake installation
    echo    directory containing sms-cache.txt and sms-cache-local.txt.
)


set _pathToCMake=C:\Program Files (x86)\CMake 2.8\bin\cmake.exe

set _preloadCache=sms-cache.txt
set _generator="Visual Studio 11 Win64"
set _shared=ON


set _cmdline="%_pathToCMake%" .. --no-warn-unused-cli -Wno-dev
rem  **  Check for fast build.
if "%1"=="/f" goto :issuecmd



rem
rem  **  Parse command line options
rem

:optloop
  rem  **  OpenGL3 projects and deps
  if "%1"=="/3" (
    set _cmdline=%_cmdline% -DUSE_GL3:BOOL=ON
    shift
    goto :optloop
  )

  rem  **  Preload the cache.
  if "%1"=="/c" (
    set _preloadCache=%2
    shift
    shift
    goto :optloop
  )

  rem  **  Set the project installation directory.
  if "%1"=="/i" (
    set _cmdline=%_cmdline% -DCMAKE_INSTALL_PREFIX:PATH=%2
    shift
    shift
    goto :optloop
  )

  rem  **  Use the NMake generator instead of VS2012.
  if "%1"=="/n" (
    set _generator="NMake Makefiles"
    shift
    goto :optloop
  )

  rem  **  Build static libs instead of shared.
  if "%1"=="/s" (
    set _shared=OFF
    shift
    goto :optloop
  )
rem end of optloop



set _cmdline=%_cmdline% -C"%SMSCMAKE_DIR%\%_preloadCache%"

set _cmdline=%_cmdline% -G%_generator%
set _cmdline=%_cmdline% -DBUILD_SHARED_LIBS:BOOL=%_shared%



:issuecmd

@echo on
%_cmdline%
