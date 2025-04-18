# ============================================================================ #
#
#  Author       : dmike
#  Date         : 27 Dic 2019
#  Description  : internal script that walk the package tree
#
# ============================================================================ #

deps :=
inp_dir:= $(marker)

PHONY += __internal_walking
__internal_walking: packages_walking

# ============================================================================ #
# Include, if present, local makefile in which are defined the packages
# to build
#   deps -> package project to build
# ============================================================================ #
include $(inp_dir)/Makefile

pkgs ?= $(deps)
# ============================================================================ #
# Include utilities function
# ============================================================================ #
include $(root)/scripts/include.mk

PHONY += packages_walking
packages_walking:  $(pkgs)

quiet_cmd_action_pack = $(call LOG,$(INFO),== Walk package $@)
color_cmd_action_pack = $(c_yellow)$(quiet_cmd_action_pack)
cmd_action_pack = $(MAKE) -C $(addprefix $(inp_dir)/,$@) -f $(addprefix $(inp_dir)/,$@/Makefile) $(MAKECMDGOALS)

PHONY += $(pkgs)
$(pkgs):
	$(call cmd,action_pack)

