DESCRIPTION
==========

This is a simple template that I put together in order to make it easy to
develop small cross-platform tools written in Qt/C++.  It uses CMake, and forms
a nice, solid base on which to get started.

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

* A working NSIS script is generated in Windows, so that you can quickly get
  started with an installer.

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

The full SDK is not required.

### CMake
http://www.cmake.org/cmake/resources/software.html

### MinGW
http://mingw.org

It's the `mingw-get-inst` installer that you want. There are other builds of
MinGW around. For instance, [Nuwen's MinGW](http://nuwen.net/mingw.html) is nice
and easy to install, but is configured for static linking of the GCC libraries.
Since Qt uses the shared libraries from MinGW, you'll still need to distribute
them, and your binaries will be larger than they need to be.

Pay attention to the version of GCC that is shipped with the installation. If
the project builds but crashes, try a version of GCC closer to that with which
Qt was built, as it may be an ABI issue.

Ensure you install the C++ compiler, and avoid installing MSYS unless you know
you need it, as it will often just complicate things.

### NSIS
http://nsis.sourceforge.net

Building
--------

Create a `build` directory in the root, open a command-line window, and enter
the following commands:

    cmake -G "MinGW Makefiles" ..
    make -j <num-jobs>

Where `<num-jobs>` is the number of jobs to run in parallel (usually the number
of cores plus one).

In the build directory, you will find an `installer.nsi` file. This is an NSIS
script. Right-click, and click "Compile NSIS Script".
