# ============================================================================ #
#
#  Author       : dmike
#  Date         : 18,July 2020
#  Description  : This is a specific plugin from kernel driver clobber recipe.
#
# ============================================================================ #

# ============================================================================ #
# Default target
# ============================================================================ #
PHONY := kdriver_clobber
kdriver_clobber:

include $(root)/scripts/k-driver/clean.mk
# ============================================================================ #
# Define begin and end clobber command
# ============================================================================ #
quiet_cmd_init_clobber = $(call LOG,$(INFO),== Kernel driver Clobber in $(marker))
color_cmd_init_clobber = $(c_cyang)$(quiet_cmd_init_clobber)
cmd_init_clobber =
quiet_cmd_end_clobber = $(call LOG,$(INFO),== Kernel driver Clobber out $(marker))
color_cmd_end_clobber = $(c_cyang)$(quiet_cmd_end_clobber)
cmd_end_clobber =
# ============================================================================ #
# Init target
# ============================================================================ #
PHONY += __kdriver_clobber_init
kdriver_clobber : __kdriver_clobber_init kdriver_clean
	$(call cmd,end_clobber)

__kdriver_clobber_init:
	$(call cmd,init_clobber)

.PHONY : $(PHONY)
