# ============================================================================ #
#
#  Author       : dmike
#  Date         : 27 Dic 2019
#  Description  : internal script that walk the package tree
#
# ============================================================================ #

deps :=
inp_dir:= $(addprefix $(src_main_root)/,$(marker))

PHONY += __internal_walking
__internal_walking: packages_walking

# ============================================================================ #
# Include, if present, local makefile in which are defined the packages
# to build
#   deps -> package project to build
# ============================================================================ #
include $(inp_dir)/Makefile

# ============================================================================ #
# Include utilities function
# ============================================================================ #
include $(root)/scripts/include.mk

PHONY += packages_walking
packages_walking: $(deps)

quiet_cmd_action_pack = $(call LOG,$(INFO),== Walk package $@)
color_cmd_action_pack = $(c_yellow)$(quiet_cmd_action_pack)
cmd_action_pack = echo "override me"

PHONY += $(deps)
$(deps):
	$(call cmd,action_pack)

