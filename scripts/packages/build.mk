# ============================================================================ #
#
#  Author       : dmike
#  Date         : 26 Dic 2019
#  Description  : build plugin for project with package projects
#
# ============================================================================ #


PHONY := __build
__build: __init_build


quiet_cmd_init_build = $(call LOG,$(INFO),== Packages build)
color_cmd_init_build = $(c_cyang)$(quiet_cmd_init_build)
cmd_init_build =

PHONY += __init_build
__init_build:
	$(call cmd,init_build)

quiet_cmd_end_build = $(call LOG,$(INFO),== Packages build)
color_cmd_end_build = $(c_cyang)$(quiet_cmd_end_build)
cmd_end_build =

PHONY += packages_build
__build: packages_build

include $(root)/scripts/packages/_packages_walk.mk

packages_build: packages_walking
	$(call cmd,end_build)


.PHONY: $(PHONY)

