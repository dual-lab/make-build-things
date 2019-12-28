# ============================================================================ #
#
#  Author       : dmike
#  Date         : 21,June 2019
#  Description  : Clobber logic for docker plugin.
#
# ============================================================================ #

# ============================================================================ #
# Default target
# ============================================================================ #
PHONY := docker_clobber
docker_clobber:

include $(root)/scripts/docker/clean.mk
# ============================================================================ #
# Define begin and end clobber command
# ============================================================================ #
quiet_cmd_init_clobber = $(call LOG,$(INFO),== Docker Clobber in $(marker))
color_cmd_init_clobber = $(c_cyang)$(quiet_cmd_init_clobber)
cmd_init_clobber =
quiet_cmd_end_clobber = $(call LOG,$(INFO),== Docker Clobber out $(marker))
color_cmd_end_clobber = $(c_cyang)$(quiet_cmd_end_clobber)
cmd_end_clobber =
# ============================================================================ #
# Init target
# ============================================================================ #
PHONY += __docker_clobber_init
docker_clobber : __docker_clobber_init docker_clean
	$(call cmd,end_clobber)

__docker_clobber_init:
	$(call cmd,init_clobber)

.PHONY : $(PHONY)
