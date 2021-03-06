# Functionality common to both top-level project makefile (project.mk)
# and component makefiles (component_wrapper.mk)
#

# Include project config makefile, if it exists.
#
# (Note that we only rebuild this makefile automatically for some
# targets, see project_config.mk for details.)
SDKCONFIG_MAKEFILE ?= $(abspath $(BUILD_DIR_BASE)/include/config/auto.conf)
-include $(SDKCONFIG_MAKEFILE)
export SDKCONFIG_MAKEFILE  # sub-makes (like bootloader) will reuse this path

#Handling of V=1/VERBOSE=1 flag
#
# if V=1, $(summary) does nothing and $(details) will echo extra details
# if V is unset or not 1, $(summary) echoes a summary and $(details) does nothing
V ?= $(VERBOSE)
ifeq ("$(V)","1")
summary := @true
details := @echo
else
summary := @echo
details := @true

# disable echoing of commands, directory names
MAKEFLAGS += --silent
endif

# General make utilities

# convenience variable for printing an 80 asterisk wide separator line
SEPARATOR:="*******************************************************************************"

# macro to remove quotes from an argument, ie $(call dequote,$(CONFIG_BLAH))
define dequote
$(subst ",,$(1))
endef
# " comment kept here to keep syntax highlighting happy


# macro to keep an absolute path as-is, but resolve a relative path
# against a particular parent directory
#
# $(1) path to resolve
# $(2) directory to resolve non-absolute path against
#
# Path and directory don't have to exist (definition of a "relative
# path" is one that doesn't start with /)
#
# $(2) can contain a trailing forward slash or not, result will not
# double any path slashes.
#
# example $(call resolvepath,$(CONFIG_PATH),$(CONFIG_DIR))
define resolvepath
$(if $(filter /%,$(1)),$(1),$(subst //,/,$(2)/$(1)))
endef
