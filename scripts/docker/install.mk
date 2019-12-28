# ############################################################################ #
#
#  Author       : dmike
#  Date         : 22,June 2019
#  Description  : Docker plugin install rule
#
# ############################################################################ #
tag:= latest
PHONY := _install
_install: __init_install

# ============================================================================ #
# Include utilities function
# ============================================================================ #
include $(root)/scripts/include.mk

quiet_cmd_init_install = $(call LOG,$(INFO),== Docker install in $(marker))
color_cmd_init_install = $(c_cyang)$(quiet_cmd_init_install)
cmd_init_install =

PHONY += __init_install
__init_install:
	$(call cmd,init_install)

quiet_cmd_end_install = $(call LOG,$(INFO),== Docker install out $(marker))
color_cmd_end_install = $(c_cyang)$(quiet_cmd_end_install)
cmd_end_install =

PHONY += install_target
_install: install_target

include $(root)/scripts/$(marker)/build.mk

quiet_cmd_docker = $(call LOG,$(INFO),== Docker install $(marker))
color_cmd_docker = $(c_green)$(quiet_cmd_docker)
cmd_docker = $(DOCKER) build --tag $(project_name):$(tag) $(target_main_root)

install_target: $(docker_target)
	$(call cmd,docker)
	$(call cmd,end_install)

.PHONY : $(PHONY)
