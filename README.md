# CMake AVR Project Template

This is a project template for using the avr-gcc toolchain with cmake.

What's included?
----------------

* AVR cmake toolchain file
* Template CMakeLists.txt file
* CMake module to find Arduino Core **TODO**

Requirements
------------

* AVR toolchain installed on your system


Flashing
--------

* uses avrdude

You can specify upload options when you generate your cmake project (Or just use the defaults).

```bash
~$ cd build
~$ cmake .. -DAVR_UPLOAD_BUAD=115200 -DAVR_UPLOAD_PORT=/dev/ttyACM0
```

And flash the device with:

```bash
~$ make flash-targetname
```
