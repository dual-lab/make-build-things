# ============================================================================ #
#
#  Author       : dmike
#  Date         : 20 August 2017
#  Description  : This is a specific plugin from c language. Iterates over
#  				all the source file linking them together in object files.
#
# ============================================================================ #

# ============================================================================ #
# Initialize local variables
# This variables are read from include Makefile
# ============================================================================ #
src :=
dirs:=
libs:=
cflags:=
# ============================================================================ #
# Define the default recipe. With the following conditional
#       |--(T)-->|Build executable|---- |
#       |                                |
#      /\                                |
#  MAKELEVEL = 2                         |--o
#      \/                                |
#       |                                |
#       |--(F)-->|Build object files|-- |
# ============================================================================ #
PHONY:=
ifeq ($(MAKELEVEL),2)
cc_target := $(addprefix $(target_main_root),$(project_name))
PHONY += cc_build_target
cc_build_target: $(cc_target)

$(cc_target): #all obj files ,libs and project deps
	@echo $(CC) $(cflags) $(CFLAGS)
endif
PHONY += cc_build_object


.PHONY: $(PHONY)
