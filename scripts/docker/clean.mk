# ============================================================================ #
#
#  Author       : dmike
#  Date         : 21,June 2019
#  Description  : Clean logic for docker plugin.
#
# ============================================================================ #

# ============================================================================ #
# Default target
# ============================================================================ #
PHONY := docker_clean
# ============================================================================ #
# include utils variable
# ============================================================================ #
include $(root)/scripts/include.mk
# ============================================================================ #
# Join all the objects necessary to the clean recipe
# ============================================================================ #
obj_clean := $(addprefix $(target_root)/,Dockerfile)
# ============================================================================ #
# Define begin and end clean command
# ============================================================================ #
quiet_cmd_init_clean = $(call LOG,$(INFO),== Docker Clean in $(marker))
color_cmd_init_clean = $(c_cyang)$(quiet_cmd_init_clean)
cmd_init_clean =
quiet_cmd_end_clean = $(call LOG,$(INFO),== Docker Clean out $(marker))
color_cmd_end_clean = $(c_cyang)$(quiet_cmd_end_clean)
cmd_end_clean =
# ============================================================================ #
# Init target
# ============================================================================ #
PHONY += __docker_clean_init
docker_clean: __docker_clean_init $(obj_clean)
	$(call cmd,end_clean)

__docker_clean_init:
	$(call cmd,init_clean)

PHONY += $(obj_clean)
$(obj_clean):
	$(call cmd,rm)


PHONY += $(deps)
$(deps):
	$(call makeclean,$@,$@)

.PHONY : $(PHONY)
