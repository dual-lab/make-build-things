# ============================================================================ #
#
#  Author       : dmike
#  Date         : 12 July 2020
#  Description  : This is a specific plugin for building kernel driver outside
#  								kernel source tree.
#
# ============================================================================ #

module_dir := $(root)/$(marker)

PHONY:= __build
__build: __init_build

# ============================================================================ #
# Include utilities function
# ============================================================================ #
include $(root)/scripts/include.mk

quiet_cmd_init_build = $(call LOG,$(INFO),== Kernel Driver in $(marker))
color_cmd_init_build = $(c_cyang)$(quiet_cmd_init_build)
cmd_init_build =

PHONY += __init_build
__init_build:
	$(call cmd,init_build)

quiet_cmd_end_build = $(call LOG,$(INFO),== Kernel Driver build out $(marker))
color_cmd_end_build = $(c_cyang)$(quiet_cmd_end_build)
cmd_end_build =

PHONY += module_build
__build : module_build
	$(call cmd,end_build)

module_build:
	$(call makekernel,$(KERNELDIR),$(module_dir),modules)

.PHONY: $(PHONY)
