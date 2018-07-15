# ============================================================================ #
#
#  Author       : dmike
#  Date         : 20 August 2017
#  Description  : This is a specific plugin from c language. Iterates over
#  				all the source file linking them together in object files.
#
# ============================================================================ #

PHONY:= __build
__build: __init_build

quiet_cmd_init_build = $(call LOG,$(INFO),== CC build in $(marker))
color_cmd_init_build = $(c_cyang)$(quiet_cmd_init_build)
cmd_init_build =

PHONY += __init_build
__init_build:
	$(call cmd,init_build)

quiet_cmd_end_build = $(call LOG,$(INFO),== CC build out $(marker))
color_cmd_end_build = $(c_cyang)$(quiet_cmd_end_build)
cmd_end_build =

PHONY += cc_build_target
__build : cc_build_target

cc_target := $(addprefix $(target_root)/,$(project_name))
cc_build_target: $(cc_target)
	$(call cmd ,end_build)

include $(root)/scripts/cc/_build_object.mk

quiet_cmd_out = OUT	$@
color_cmd_out = $(c_green)$(quiet_cmd_out)
cmd_out = $(CC) $(cflags) $(CFLAGS) $^ -o $@
$(cc_target): $(cc_build_objects) $(cc_build_libs) #all obj files ,libs and project deps
	$(call cmd,out)

.PHONY: $(PHONY)
