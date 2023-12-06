# <vcc:vccproj sync="FULL"/>

# command:
# make (same as make debug)
# make debug (build debug version and gtest)
# make release (build release version)
# make clean (remove all .o and executable files)

# Note: make command should start with tab instead of space, else throw exception
# Need to ensure these 2 in settings.json = false
# "editor.insertSpaces": true,
# "editor.detectIndentation": true,
# Note: cannot seperate object files as some sources only have hpp or h files. Object files will be reused by unittest
# Note: main.cpp need to be in root directory to avoid duplicate main function by unit test
# Note: files in .vscode is used for F5 only. if need to build Release vesrion, please use "make release"

# Field to change:
# PROJECT_NAME, DLL_PROJ_NAME, EXE_PROJ_NAME: project name
# DEBUG_FLAGS, RELEASE_FLAGS, DEBUG_COMPILE_OPTIONS, RELEASE_COMPILE_OPTIONS, GTEST_COMPILE_OPTIONS: flag for debug and release
# LFLAGS: library that not in the project, need to be handled in if case, as different platform has different paths 
# EXCLUDE_FOLDER: igore that folder when compile

# Gtest
# to add new gtest, follow unittest
# change project name for DLL project in dynamic_library_test.cpp

#------------------------------------------------------------------------------------------------------#
#------------------------------------------ Customize Begin  ------------------------------------------#
#------------------------------------------------------------------------------------------------------#
# <vcc:property action:"ALERT">
#----------------------------------#
#---------- Project Info ----------#
#----------------------------------#
PROJECT_NAME := Sample
DLL_PROJ_NAME := lib$(PROJECT_NAME)
EXE_PROJ_NAME := $(PROJECT_NAME)
# gtest
GTEST_PROJECT_NAME := unittest
GTEST_FOLDER := unittest

EXE_MAIN_CPP_FILES := main.cpp
DLL_MAIN_HPP_FILES := DllFunctions.h 
DLL_MAIN_CPP_FILES := DllEntryPoint.cpp DllFunctions.cpp
#----------------------------------#
#---------- Compile Info ----------#
#----------------------------------#
#---------- Compiler ----------#
CXX := g++
CXXVERSION := c++20
#---------- Flag ----------#
# must have CXXFLAGS for default compile flags, .cpp.o only use CXXFLAGS
DEBUG_FLAGS := -D__DEBUG__ -D__DEBUGLOG__
RELEASE_FLAGS :=
PRECOMPILE_FLAGS :=
DEBUG_COMPILE_OPTIONS := -Wall -Wextra -pthread -fPIC 
RELEASE_COMPILE_OPTIONS := -pthread -O3 -fPIC
GTEST_COMPILE_OPTIONS := -Wall -Wextra -pthread

#----------------------------------#
#----------- Directory  -----------#
#----------------------------------#

# Base Directory
# LFLAGS - keep empty and handle in if case
BASE := .
INC := include
SRC := src
LIB := lib
LFLAGS :=
DEBUG_FOLDER := bin/Debug
RELEASE_FOLDER := bin/Release

# exclude folder
ifeq ($(OS),Windows_NT)
EXCLUDE_FOLDER := .git% .svn% .vscode%
else
EXCLUDE_FOLDER := ./.git% ./.svn% ./.vscode%
endif
# </vcc:property>
#------------------------------------------------------------------------------------------------------#
#------------------------------------------- Customize End  -------------------------------------------#
#------------------------------------------------------------------------------------------------------#

#----------------------------------#
#---------- Compile Info ----------#
#----------------------------------#
#---------- General ----------#
DLL_COMPILE_FLAG := -shared
CXXFLAGS_PREFIX := -fdiagnostics-color=always -std=$(CXXVERSION)
#---------- Debug ----------#
CXXFLAGS_DEBUG_CONTENT := $(CXXFLAGS_PREFIX) $(DEBUG_COMPILE_OPTIONS) $(PRECOMPILE_FLAGS) $(DEBUG_FLAGS) -g
CXXFLAGS_DEBUG_DLL := $(CXXFLAGS_PREFIX) $(DEBUG_COMPILE_OPTIONS) $(DLL_COMPILE_FLAG) $(PRECOMPILE_FLAGS) $(DEBUG_FLAGS) -g
CXXFLAGS_DEBUG_EXE := $(CXXFLAGS_PREFIX) $(DEBUG_COMPILE_OPTIONS) $(PRECOMPILE_FLAGS) $(DEBUG_FLAGS) -g
#---------- Release ----------#
CXXFLAGS_RELEASE_DLL := $(CXXFLAGS_PREFIX) $(RELEASE_COMPILE_OPTIONS) $(DLL_COMPILE_FLAG) $(PRECOMPILE_FLAGS) $(RELEASE_FLAGS)
CXXFLAGS_RELEASE_EXE := $(CXXFLAGS_PREFIX) $(RELEASE_COMPILE_OPTIONS) $(PRECOMPILE_FLAGS) $(RELEASE_FLAGS)
#---------- GTEST ----------#
CXXFLAGS_GTEST := $(CXXFLAGS_PREFIX) $(GTEST_COMPILE_OPTIONS) $(PRECOMPILE_FLAGS) $(DEBUG_FLAGS) -g
GTESTFLAGS := -lgtest -lpthread
#---------- CXXFLAGS ----------#
CXXFLAGS := $(CXXFLAGS_DEBUG_CONTENT)

#----------------------------------#
#----------- Library  -----------#
#----------------------------------#
ifeq ($(LIB),)
LIBDIRS :=
else
LIBDIRS := -L$(LIB)
endif

#----------------------------------#
#----------- Directory  -----------#
#----------------------------------#
GTEST_EXCLUDE_FOLDER := $(EXCLUDE_FOLDER)
PROJECT_EXCLUDE_FOLDER := $(EXCLUDE_FOLDER) $(GTEST_FOLDER)%

#----------------------------------#
#----------- *.hpp,*.cpp-----------#
#----------------------------------#
ifeq ($(OS),Windows_NT)
#----------------------------------#
#----------- Win Version-----------#
#----------------------------------#
MAIN_EXE := $(EXE_PROJ_NAME).exe
MAIN_DLL := $(DLL_PROJ_NAME).dll
GTESTMAIN := $(GTEST_PROJECT_NAME).exe

# All Sub Directory - Source need *.cpp instead of directory
# g++ param
INCDIRS_SUB := $(filter-out $(EXCLUDE_FOLDER), $(patsubst $(shell CHDIR )\\%,-I%,$(shell DIR /A:D /B /S $(INC))))

# All directory to remove *.o
ALL_DIRECTORY := $(filter-out $(EXCLUDE_FOLDER), $(patsubst $(shell CHDIR )\\%,%,$(shell DIR /A:D /B /S $(BASE))))

# cpp
ALL_FILES := $(filter-out $(EXCLUDE_FOLDER), $(patsubst $(shell CHDIR )\\%,%,$(shell DIR /B /S *.h *.c *.hpp *.cpp)))

ALL_PROJECT_FILES :=  $(filter-out $(PROJECT_EXCLUDE_FOLDER), $(ALL_FILES))
ALL_PROJECT_FILES_EXE := $(filter-out $(DLL_MAIN_HPP_FILES) $(DLL_MAIN_CPP_FILES), $(ALL_PROJECT_FILES))
ALL_PROJECT_FILES_DLL := $(filter-out $(EXE_MAIN_CPP_FILES), $(ALL_PROJECT_FILES))

ALL_PROJECT_CPP_FILES_EXE := $(filter-out %.h %.c %.hpp, $(ALL_PROJECT_FILES_EXE))
ALL_PROJECT_CPP_FILES_DLL := $(filter-out %.h %.c %.hpp, $(ALL_PROJECT_FILES_DLL))
ALL_PROJECT_CPP_FOLDERS := *.cpp $(patsubst %, %$\\*.cpp, $(filter-out .%, $(sort $(dir $(filter-out %.h %.c %.hpp, $(ALL_PROJECT_FILES))))))

GTEST_FILES := $(filter-out $(GTEST_EXCLUDE_FOLDER) $(EXE_MAIN_CPP_FILES) $(DLL_MAIN_CPP_FILES) $(DLL_MAIN_HPP_FILES), $(ALL_FILES))
GTEST_CPP_FILES := $(filter-out %.h %.c %.hpp, $(GTEST_FILES))
GTEST_CPP_FOLDERS := $(patsubst %, %\\*.cpp, $(filter-out ./%, $(sort $(dir $(GTEST_CPP_FILES)))))

ALL_O_FILES := *.o $(patsubst %, %\\*.o, $(ALL_DIRECTORY))

# adjust to include base folder
INCDIRS = -I$(INC) $(INCDIRS_SUB)

# System Lib with -Lpath
#LFLAGS :=

# Command
RM			:= del /q /f
RMDIR		:= rmdir /s /q
MKDIR		:= mkdir

else
#----------------------------------#
#---------- Linus Version----------#
#----------------------------------#
MAIN_EXE := $(EXE_PROJ_NAME)
MAIN_DLL := $(DLL_PROJ_NAME).so
GTESTMAIN := $(GTEST_PROJECT_NAME)

# All Sub Directory - Source need *.cpp instead of directory
# g++ param
INCDIRS_SUB := $(filter-out $(EXCLUDE_FOLDER), $(patsubst %,-I%, $(shell find $(INC) -type d)))

# All directory to remove *.o
ALL_DIRECTORY := $(filter-out $(EXCLUDE_FOLDER),$(patsubst %, %, $(shell find $(BASE) -type d)))

# cpp
ALL_PROJECT_CPP_FILES := $(filter-out $(PROJECT_EXCLUDE_FOLDER), $(patsubst %,%, $(shell find $(SRC) -type f -name "*.cpp")))
ALL_PROJECT_FILES :=  $(filter-out $(PROJECT_EXCLUDE_FOLDER), $(patsubst %,%, $(shell find $(INC) -type f -name "*.h")))
ALL_PROJECT_FILES +=  $(filter-out $(PROJECT_EXCLUDE_FOLDER), $(patsubst %,%, $(shell find $(INC) -type f -name "*.hpp")))
ALL_PROJECT_FILES +=  $(filter-out $(PROJECT_EXCLUDE_FOLDER), $(patsubst %,%, $(shell find $(SRC) -type f -name "*.c")))
ALL_PROJECT_FILES +=  $(ALL_PROJECT_CPP_FILES)

ALL_PROJECT_CPP_FILES_EXE := $(EXE_MAIN_CPP_FILES) $(ALL_PROJECT_CPP_FILES)
ALL_PROJECT_CPP_FILES_DLL := $(DLL_MAIN_CPP_FILES) $(ALL_PROJECT_CPP_FILES)
ALL_PROJECT_FILES_EXE := $(EXE_MAIN_CPP_FILES) $(ALL_PROJECT_FILES)
ALL_PROJECT_FILES_DLL := $(DLL_MAIN_HPP_FILES) $(DLL_MAIN_CPP_FILES) $(ALL_PROJECT_FILES)
ALL_PROJECT_CPP_FOLDERS := *.cpp $(patsubst %, %/*.cpp, $(sort $(dir $(ALL_PROJECT_CPP_FILES))))

GTEST_FILES := $(filter-out $(GTEST_EXCLUDE_FOLDER), $(ALL_PROJECT_FILES)) 
GTEST_CPP_FILES := $(filter-out %.h %.c %.hpp, $(GTEST_FILES)) $(filter-out $(GTEST_EXCLUDE_FOLDER), $(patsubst %,%, $(shell find $(GTEST_FOLDER) -type f -name "*.cpp")))
GTEST_CPP_FOLDERS := $(patsubst %, %/*.cpp, $(sort $(dir $(GTEST_CPP_FILES))))

ALL_O_FILES := *.o $(patsubst %, %/*.o, $(ALL_DIRECTORY))

# adjust to include base folder
INCDIRS = $(INCDIRS_SUB)

# System Lib with -Lpath
#LFLAGS :=

# Command
RM := rm -f
RMDIR := rm -rf
MKDIR := mkdir -p
endif

ALL_PROJECT_O_FILES_EXE := $(ALL_PROJECT_CPP_FILES_EXE:.cpp=.o)
ALL_PROJECT_O_FILES_DLL := $(ALL_PROJECT_CPP_FILES_DLL:.cpp=.o)
GTEST_O_FILES := $(GTEST_CPP_FILES:.cpp=.o)

#------------------------------------------------------------------------------------------------------#
#------------------------------------------ Customize Begin  ------------------------------------------#
#------------------------------------------------------------------------------------------------------#
# <vcc:property action:"ALERT">

#----------------------------------#
#-------------- MAIN --------------#
#----------------------------------#
all: debug

# </vcc:property>
#------------------------------------------------------------------------------------------------------#
#------------------------------------------- Customize End  -------------------------------------------#
#------------------------------------------------------------------------------------------------------#

#----------------------------------#
#------------- Overall-------------#
#----------------------------------#
debug:
ifneq ($(DLL_PROJ_NAME),)
	$(MAKE) debug_dll
endif
ifneq ($(EXE_PROJ_NAME),)
	$(MAKE) debug_exe
endif
	$(MAKE) gtest
	@echo Build Debug Complete!

release:
	$(MAKE) clean_release
ifneq ($(DLL_PROJ_NAME),)
	$(MAKE) release_dll
endif
ifneq ($(EXE_PROJ_NAME),)
	$(MAKE) release_exe
endif
	@echo Build Release Complete!

#----------------------------------#
#-------------- DEBUG--------------#
#----------------------------------#

# need to seperate gtest process to get o file again
debug_dll: $(ALL_PROJECT_FILES_DLL) $(MAIN_DLL)

$(MAIN_DLL): $(ALL_PROJECT_CPP_FILES_DLL) $(ALL_PROJECT_O_FILES_DLL)
	@echo Build Debug Start
	$(CXX) $(CXXFLAGS_DEBUG_DLL) \
	$(ALL_PROJECT_CPP_FOLDERS) \
	$(INCDIRS) \
	$(LIBDIRS) \
	$(LFLAGS) \
	-o $(DEBUG_FOLDER)/$(MAIN_DLL)
	@echo Build DEBUG DLL Complete

debug_exe: $(ALL_PROJECT_FILES_DLL) $(MAIN_EXE)

$(MAIN_EXE): $(ALL_PROJECT_CPP_FILES_EXE) $(ALL_PROJECT_O_FILES_EXE)
	@echo Build Debug Start
	$(CXX) $(CXXFLAGS_DEBUG_EXE) \
	$(ALL_PROJECT_CPP_FOLDERS) \
	$(INCDIRS) \
	$(LIBDIRS) \
	$(LFLAGS) \
	-o $(DEBUG_FOLDER)/$(MAIN_EXE)
	@echo Build DEBUG EXE Complete

gtest: $(GTEST_FILES) $(GTESTMAIN)

$(GTESTMAIN): $(GTEST_CPP_FILES) $(GTEST_O_FILES)
	@echo Build gtest Start
	$(CXX) $(CXXFLAGS_GTEST) \
	$(GTEST_CPP_FOLDERS) \
	$(INCDIRS) \
	$(LIBDIRS) \
	$(LFLAGS) \
	-o ${DEBUG_FOLDER}/${GTESTMAIN} $(GTESTFLAGS)
	@echo Build gtest Complete
	${DEBUG_FOLDER}/${GTESTMAIN}

.cpp.o:
	$(CXX) $(CXXFLAGS_DEBUG_CONTENT) $(INCDIRS) -c $< -o $@

#----------------------------------#
#------------- RELEASE-------------#
#----------------------------------#

release_dll:
	$(CXX) $(CXXFLAGS_RELEASE_DLL) \
	$(ALL_PROJECT_CPP_FOLDERS) \
	$(INCDIRS) \
	$(LIBDIRS) \
	$(LFLAGS) \
	-o $(RELEASE_FOLDER)/$(MAIN_DLL)
	@echo Build RELEASE DLL Complete

release_exe:
	$(CXX) $(CXXFLAGS_RELEASE_EXE) \
	$(ALL_PROJECT_CPP_FOLDERS) \
	$(INCDIRS) \
	$(LIBDIRS) \
	$(LFLAGS) \
	-o $(RELEASE_FOLDER)/$(MAIN_EXE)
	@echo Build RELEASE EXE Complete

#----------------------------------#
#------------- Clean  -------------#
#----------------------------------#
.PHONY: clean clean_object clean_debug clean_release

clean: clean_object clean_debug clean_release
	@echo Clean All Complete

clean_object:
	$(RM) $(ALL_O_FILES)
	@echo Clean Object Complete

clean_debug:
	$(RMDIR) "$(DEBUG_FOLDER)"
	$(MKDIR) "$(DEBUG_FOLDER)"
	@echo Clean Debug Complete

clean_release:
	$(RMDIR) "$(RELEASE_FOLDER)"
	$(MKDIR) "$(RELEASE_FOLDER)"
	@echo Clean Release Complete
