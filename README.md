# VCCProjectSimpleTemplateCPP
### Versioning Common Codebase Project
It is member of Versioning Common Codebase Project.
All platform (Window, Linux, MacOS).

Highly recommand to use following to create c++ project
VCCProjectGenerator (https://github.com/s1155003185/VCCProjectGenerator)
VCCProjectGeneratorVSCodeExtension (https://github.com/s1155003185/VCCProjectGeneratorVSCodeExtension)

## Pre-Requirement
1. git
2. g++
3. make
4. gtest

## Build C++ project
Follow the instruction listed in Makefile

when compile enter following command in terminal:
To build debug
```
make debug -j10
```

To build release
```
make release -j10
```

Debug program is built in bin/Debug
Release program is built in bin/Release

## Execute C++ project in VScode
F5

## install google test on window

prerequirment
1. install CHOCOLATEY

Main

1. cmd
2. git clone https://github.com/google/googletest.git
3. 
```
cd googletest
mkdir build
cd build
cmake -G "MinGW Makefiles" ..
make -j4
```
4. go to googletest/googletest/build/lib
5. copy 4 .a files to  C:\msys64\mingw64\lib
6. go to googletest/googletest/include
7. copy gtest to C:\msys64\mingw64\include
8. go to googletest/googlemock/include
9. copy gmock to C:\msys64\mingw64\include

## Release Log

### 2024-05-05 Versioning Common Codebase Project Generator Release

### 2023-12-23 Compile VCCProjectSimpleTemplateDLL and VCCProjectSimpleTemplateEXE to VCCProjectSimpleTemplateCPPComplex

### 2023-12-06 First Release
Initialization
