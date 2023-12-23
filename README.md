# VCCProjectSimpleTemplateCPPComplex
## Versioning Common Codebase Project / Versioning Coding Cooperation Project

## Assumption
All platform (Window, Linux, MacOS).
Already install VSCode, debugger, g++, googletest.

## Usage
To config, follow command in Makefile.
Change dll name in dynamic_library_test.cpp.
Remove all README and LICENCE.
Remove .git folder and create your own git response.
Pending to finalize after VCC project generator finished.

## install google test on window

prerequirment
1. install CHOCOLATEY


Main

1. cmd

2. git clone https://github.com/google/googletest.git

3. 

cd googletest

mkdir build

cd build

cmake -G "MinGW Makefiles" ..

make -j4

4. go to googletest/googletest/build/lib

5. copy 4 .a files to  C:\msys64\mingw64\lib

6. go to googletest/googletest/include

7. copy gtest to C:\msys64\mingw64\include

8. go to googletest/googlemock/include

9. copy gmock to C:\msys64\mingw64\include


## Release Log

### 2023-12-23 Compile VCCProjectSimpleTemplateDLL and VCCProjectSimpleTemplateEXE to VCCProjectSimpleTemplateCPPComplex

### 2023-12-06 First Release
Initialization