# ============================================================================ #
#
#  Author       : dmike
#  Date         : 26 Dic 2019
#  Description  : Clobber plugin for project with package projects
#
# ============================================================================ #

PHONY := __clobber
__clobber: __init_clobber

quiet_cmd_init_clobber = $(call LOG,$(INFO),== Packages clobber)
color_cmd_init_clobber = $(c_cyang)$(quiet_cmd_init_clobber)
cmd_init_clobber =

PHONY += __init_clobber
__init_clobber:
	$(call cmd,init_clobber)

quiet_cmd_end_clobber = $(call LOG,$(INFO),== Packages clobber)
color_cmd_end_clobber = $(c_cyang)$(quiet_cmd_end_clobber)
cmd_end_clobber =

PHONY += packages_clobber
__clobber: packages_clobber

include $(root)/scripts/packages/_packages_walk.mk

packages_clobber: packages_walking
	$(call cmd,end_clobber)

.PHONY: $(PHONY)