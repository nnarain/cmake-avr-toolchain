# CMake AVR Project Template

This is a project template for using the avr-gcc toolchain with cmake.

What's included?
----------------

* AVR cmake toolchain file
* Template CMakeLists.txt file
* CMake module to find Arduino Core

Requirements
------------

* AVR toolchain installed on your system

Usage
-----

* clone this repo
* delete the .git folder created
* Modify .gitignore and CMakeLists.txt as need
* Initialize your own git repo (or other version control)

```bash
~$ git clone https://github.com/nnarain/cmake-avr-template.git
~$ mv cmake-avr-template/ myproject
~$ cd myproject
~$ rm -rf .git
~$ git init
```