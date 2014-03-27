DESCRIPTION
==========

This is a template that I created to simplify the development of cross-platform
tools written in Qt/C++. It uses CMake, and forms a nice, solid base on which to
get started with a project, so that you don't need to worry about setting up the
build system, installers, etc...

Suggestions for improvement are very welcome. The licence for the template
itself is ISC. Essentially, do what you like with it. I hope you find it useful.

* A basic example application is included.

* Just tweak your project name and version number in the top-level CMakeLists
  file and you're good to go.

* A `defines.h` file is generated, containing your application name and version.
  You can easily add to this.

* By default, no need to add each of your source files to a CMakeLists file,
  even if you organise them into subdirectories. The price you pay for this is
  needing to invoke `cmake` whenever you add a new source file. This may become
  a pain in teams, but it's trivial to change.

* A Qt resources file is ready and waiting for you to add images or other
  resources to your project.  It's already compiled-in by default.

* The `test` directory is set up for you to make it easy for you to start
  writing unit tests right from the start.

* An application icon file is added to your project in Windows, and you can
  easily overwrite the default one.

* For Windows, supports both WinGW and Visual Studio compilers.

* For Windows, there is a choice between NSIS and WiX-based installers.  Both
  are automatically configured with your choice of project name from the
  top-level CMakeLists file.  When you have chosen which you will use, it is
  straight-forward to remove everything relating to the other one: just edit
  `win/CMakeLists.txt`.

BUILDING IN LINUX
=================

As with any CMake project, create a `build` folder, enter the directory, and
invoke cmake and make:

    mkdir build
    cd build
    cmake ..
    make -j <num-jobs>

Where `<num-jobs>` is the number of jobs to run in parallel (usually the number
of cores plus one).

BUILDING IN WINDOWS
===================

Dependencies
------------

### The Qt Libraries
http://qt-project.org/downloads

You can use either the MinGW version, or one of the Visual Studio versions.

### CMake
http://www.cmake.org/cmake/resources/software.html

### NSIS or WiX
http://nsis.sourceforge.net
http://wixtoolset.org

Targets
-------

In Windows, there are two additional "targets" defined in CMake configuration:
* *install*: This target installs the application and the DLLs it depends
  on into the `dist` directory. This is to simplify testing and packaging the
  application. The list of files to install is in `win/CMakeLists.txt`.
* *installer*: This target compiles the WiX installer, but will only be
  available if WiX was found in the PATH, or the `WIX_PATH` CMake variable is
  defined.

Building
--------

### Using QtCreator (Visual Studio or MinGW)

* Open QtCreator.
* File -> Open File or Project
* Open the top-level CMakeLists.txt file in the project folder.
* Choose a build location.
* Click "Run CMake".
* Click "Finish".
* If you want to enable the WiX installer:
    * On the left bar, click "Projects".
    * Next to "Edit build configuration", click "Add" -> "Clone Selected".
    * Name the configuration "installer".
    * Under "Build Steps", expand Details, and check "install" and "installer".
* Click the Build button in the bottom-left-hand corner, shaped like a hammer.

### Using the command-line

#### Visual Studio 2010

* Create a `build` directory in the source directory.
* Open a VS 2010 Command Prompt, and change into the build directory.
* Ensure that the following are on the PATH:
    * CMake's cmake.exe
    * Qt's qmake.exe
    * WiX's candle.exe (if you want the WiX installer)
* Enter the following commands:

```
cmake -G "NMake Makefiles" ..
nmake install
```

* To build the WiX installer, also run:

```
nmake installer
```

#### MinGW

* Create a `build` directory in the source directory.
* Open a Qt MinGW Command Prompt, and change into the build directory.
* Ensure that the following are on the PATH:
    * CMake's cmake.exe
    * Qt's qmake.exe
    * WiX's candle.exe (if you want the WiX installer)
* Enter the following commands:

```
cmake -G "MinGW Makefiles" ..
mingw32-make install
```

* To build the WiX installer, also run:

```
mingw32-make installer
```

### WiX Installer

The WiX Installer is more advanced, and better integrated into Windows. It is
also more complex, and gaining a thorough understanding of how it works requires
time and patience. It may be worth your while reading up on WiX and the Windows
Installer framework in order to reach a deeper understanding. However, I've done
the hard work for you, and unless you have very complex requirements, you should
be able to simply modify this script without any ill effects.

Before the installer will compile successfully, you must generate a fresh UUID
(e.g. using `uuidgen` in Linux), and place this in the `win/installer.cmake.wxs`
file in place of the `YOUR-GENERATED-UUID-HERE` placeholder.

Note that the WiX source file by default expects that your project was built
with Visual Studio 2010, and will attempt to package the Visual Studio 2010
runtime DLLs.  You'll need to modify it by hand if you use a different version
of Visual Studio, or MinGW.  This is very straight-forward.

IMPORTANT: The `installer.cmake.wxs` file is processed by CMake before it is
passed to WiX, and the processed file is placed in the build directory. If
you wish to make any modifications to the installer, make sure that you edit
`installer.cmake.wxs` in the source directory, and not `installer.wxs` in the
build directory, which will be overwritten!

### NSIS Installer

The NSIS installer is quite simple, and it's relatively easy to understand
exactly what it's doing. However, you need to take greater care in ensuring
that whatever is installed is also correctly uninstalled. Also, MSI installers
(such as WiX) are increasingly becoming the norm, especially in corporate
environments, because of their thorough integration with Windows.

In the build directory, you will find an `installer.nsi` file. This is an NSIS
script. Right-click, and click "Compile NSIS Script".  By default, the script
expects that your project was compiled with MinGW, and will attempt to package
the MinGW runtime DLLs.  It is straight-forward to change this.

IMPORTANT: Never modify the `installer.nsi` file found in the build directory,
because it will be overwritten whenever CMake is run.  Always modify the
`installer.nsi.cmake` file in the `win` directory instead.
