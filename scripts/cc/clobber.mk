# ============================================================================ #
#
#  Author       : dmike
#  Date         : 5,April 2017
#  Description  : This is a specific plugin from c language. It iterates
# 				  over all the target project's directories finding the object
#				  files.
#
# ============================================================================ #

# ============================================================================ #
# Default target
# ============================================================================ #
PHONY := cc_clobber
cc_clobber:

include $(root)/scripts/cc/clean.mk
# ============================================================================ #
# Define begin and end clobber command
# ============================================================================ #
quiet_cmd_init_clobber = $(call LOG,$(INFO),== CC Clobber in $(marker))
color_cmd_init_clobber = $(c_cyang)$(quiet_cmd_init_clobber)
cmd_init_clobber =
quiet_cmd_end_clobber = $(call LOG,$(INFO),== CC Clobber out $(marker))
color_cmd_end_clobber = $(c_cyang)$(quiet_cmd_end_clobber)
cmd_end_clobber =
# ============================================================================ #
# Init target
# ============================================================================ #
PHONY += __cc_clobber_init
cc_clobber : __cc_clobber_init cc_clean
	$(call cmd,end_clobber)

__cc_clobber_init:
	$(call cmd,init_clobber)

.PHONY : $(PHONY)
