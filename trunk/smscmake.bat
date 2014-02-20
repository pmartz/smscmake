@echo off



if %SMSCMAKE_DIR%=="" (
    echo Error: Must set SMSCMAKE_DIR in environment to point at smscmake installation
    echo    directory containing sms-cache.txt and sms-cache-local.txt.
    goto :end
)


set _pathToCMake=C:\Program Files (x86)\CMake 2.8\bin\cmake.exe

set _preloadCache=sms-cache.txt
set _generator="Visual Studio 11 Win64"
set _shared=ON
set _pathToProject=..


set _cmdline="%_pathToCMake%" --no-warn-unused-cli -Wno-dev

rem  **  Check for fast build.
if "%1"=="/f" (
    shift
    call :checkerrors
    goto :issuecmd
)



rem
rem  **  Parse command line options
rem

:optloop
  rem  **  Help text.
  if "%1"=="/h" (
    goto :usage
  )
  if "%1"=="/?" (
    goto :usage
  )

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

  rem  **  Explicit set debug postfix to 'd'.
  if "%1"=="/d" (
    set _cmdline=%_cmdline% -DSET_DEBUG_POSTFIX:BOOL=ON
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

  rem  **  Select OSG v3.1.7 build for OpenGL FFP.
  if "%1"=="/osg317" (
    set _cmdline=%_cmdline% -DUSE_OSG_317:BOOL=ON
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

call :checkerrors


set _cmdline=%_cmdline% -C"%SMSCMAKE_DIR%\%_preloadCache%"

set _cmdline=%_cmdline% -G%_generator%
set _cmdline=%_cmdline% -DBUILD_SHARED_LIBS:BOOL=%_shared%



:issuecmd

set _cmdline=%_cmdline% %_pathToProject%

@echo on
%_cmdline%
@echo off
goto :end



:checkerrors
if NOT "%1"=="" (
    set _pathToProject=%1
    shift
)

if NOT "%1"=="" (
    echo Error: Unknown command line options.
    echo %1
    goto :usage
)
goto:eof


:usage
  echo Usage
  echo   smscmake [Options] [pathToProject]
  echo.
  echo   If pathToProject is omitted, .. is assumed.
  echo.
  echo Options:
  echo   /h or /?       Display help text and exit.
  echo   /3             OpenGL3 project and deps (JAG, etc).
  echo   /c cachefile   Preload cache with this CMake script. Default: cmake_cache.txt
  echo                    Must be located in SMSCMAKE_DIR (set as env var).
  echo   /d             Explicitly set CMAKE_DEBUG_POSTFIX to 'd'. Otherwise, do
  echo                    not set CMAKE_DEBUG_POSTFIX and let it default.
  echo   /f             Fast mode. If present, all other options are ignored.
  echo   /i instdir     Project installation dir.
  echo   /n             Use nmake generator. Default: VS2012/64
  echo   /osg317        Use OSG v3.1.7 as a dependency. Default is v2.8.5.
  echo   /s             Create static libs. Default: shared


:end
