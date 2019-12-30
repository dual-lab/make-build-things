# ============================================================================ #
#
#  Author       : dmike
#  Date         : 26 Dic 2019
#  Description  : install plugin for project with package projects
#
# ============================================================================ #

PHONY := __install
__install: __init_install


quiet_cmd_init_install = $(call LOG,$(INFO),== Packages install)
color_cmd_init_install = $(c_cyang)$(quiet_cmd_init_install)
cmd_init_install =

PHONY += __init_install
__init_install:
	$(call cmd,init_install)

quiet_cmd_end_install = $(call LOG,$(INFO),== Packages install)
color_cmd_end_install = $(c_cyang)$(quiet_cmd_end_install)
cmd_end_install =

PHONY += packages_install
__install: packages_install

include $(root)/scripts/packages/_packages_walk.mk


packages_install: packages_walking
	$(call cmd,end_install)


.PHONY: $(PHONY)