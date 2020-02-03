# ============================================================================ #
#
#  Author       : dmike
#  Date         : 02 Febrary 2020
#  Description  : This is a specific plugin from golang language. Iterates over
#  				all the source file building the relative object files.
#
# ============================================================================ #

PHONY:= __build
__build: __init_build

quiet_cmd_init_build = $(call LOG,$(INFO),== Go build in $(marker))
color_cmd_init_build = $(c_cyang)$(quiet_cmd_init_build)
cmd_init_build =

PHONY += __init_build
__init_build:
	$(call cmd,init_build)

quiet_cmd_end_build = $(call LOG,$(INFO),== Go build out $(marker))
color_cmd_end_build = $(c_cyang)$(quiet_cmd_end_build)
cmd_end_build =

PHONY += go_build_target
__build : go_build_target

go_target := $(addprefix $(target_root)/,$(project_name))
go_build_target: $(go_target)
	$(call cmd ,end_build)

include $(root)/scripts/golang/_build_object.mk

quiet_cmd_out = OUT	$@
color_cmd_out = $(c_green)$(quiet_cmd_out)
cmd_out = $(GO) build -o $@ $<
$(go_target): $(main) $(go_build_objects) $(dirs_built_in) #all obj files ,libs and project deps
	$(call cmd,out)

.PHONY: $(PHONY)