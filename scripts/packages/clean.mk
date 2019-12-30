# ============================================================================ #
#
#  Author       : dmike
#  Date         : 26 Dic 2019
#  Description  : Clean plugin for project with package projects
#
# ============================================================================ #

PHONY := __clean
__clean: __init_clean

quiet_cmd_init_clean = $(call LOG,$(INFO),== Packages Clean)
color_cmd_init_clean = $(c_cyang)$(quiet_cmd_init_clean)
cmd_init_clean =

PHONY += __init_clean
__init_clean:
	$(call cmd,init_clean)

quiet_cmd_end_clean = $(call LOG,$(INFO),== Packages Clean)
color_cmd_end_clean = $(c_cyang)$(quiet_cmd_end_clean)
cmd_end_clean =

PHONY += packages_clean
__clean: packages_clean

include $(root)/scripts/packages/_packages_walk.mk

packages_clean: packages_walking
	$(call cmd,end_clean)

.PHONY: $(PHONY)
