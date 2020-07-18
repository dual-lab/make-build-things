# ============================================================================ #
#
#  Author       : dmike
#  Date         : 18 July 2020
#  Description  : This is a specific plugin for installing kernel driver outside
#  								kernel source tree.
#
# ============================================================================ #

module_dir := $(root)/$(marker)

PHONY:= __install
__install: __init_install

# ============================================================================ #
# Include utilities function
# ============================================================================ #
include $(root)/scripts/include.mk

quiet_cmd_init_install = $(call LOG,$(INFO),== Kernel Driver install in $(marker))
color_cmd_init_install = $(c_cyang)$(quiet_cmd_init_install)
cmd_init_install =

PHONY += __init_install
__init_install:
	echo 'init install'
	$(call cmd,init_install)

quiet_cmd_end_install = $(call LOG,$(INFO),== Kernel Driver install out $(marker))
color_cmd_end_install = $(c_cyang)$(quiet_cmd_end_install)
cmd_end_install =

PHONY += module_install
__install : module_install
	$(call cmd,end_install)

module_install:
	$(call makekernel,$(KERNELDIR),$(module_dir),modules_install)

.PHONY: $(PHONY)
