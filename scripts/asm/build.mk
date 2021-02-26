# ============================================================================ #
#
#  Author       : dmike
#  Date         : 22 Feb 2021
#  Description  : This is a specific plugin from asm language. Iterates over
#  				all the source file linking them together in object files.
#
# ============================================================================ #

PHONY:= __build
__build: __init_build


quiet_cmd_init_build = $(call LOG,$(INFO),== ASM build in $(marker))
color_cmd_init_build = $(c_cyang)$(quiet_cmd_init_build)
cmd_init_build =

PHONY += __init_build
__init_build:
	$(call cmd,init_build)

quiet_cmd_end_build = $(call LOG,$(INFO),== ASM build out $(marker))
color_cmd_end_build = $(c_cyang)$(quiet_cmd_end_build)
cmd_end_build =

PHONY += asm_build_target
__build : asm_build_target

asm_target := $(addprefix $(target_root)/,$(project_name))

include $(root)/scripts/asm/_build_object.mk

quiet_cmd_out = OUT	$@
color_cmd_out = $(c_green)$(quiet_cmd_out)
cmd_out = $(LD) $(ldflags) $^ -o $@
$(asm_target): $(asm_build_objects) #all obj files ,libs and project deps
	$(call cmd,out)


asm_build_target: $(asm_target)
	$(call cmd,end_build)

.PHONY: $(PHONY)
