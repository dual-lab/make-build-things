# ============================================================================ #
#
#  Author       : dmike
#  Date         : 22, Feb 2021
#  Description  : This is a specific plugin from asm language. It iterates
# 				  over all the target project's directories finding the object
#				  files.
#
# ============================================================================ #

# ============================================================================ #
# Default target
# ============================================================================ #
PHONY := asm_clobber
asm_clobber:

include $(root)/scripts/asm/clean.mk
# ============================================================================ #
# Define begin and end clobber command
# ============================================================================ #
quiet_cmd_init_clobber = $(call LOG,$(INFO),== ASM Clobber in $(marker))
color_cmd_init_clobber = $(c_cyang)$(quiet_cmd_init_clobber)
cmd_init_clobber =
quiet_cmd_end_clobber = $(call LOG,$(INFO),== ASM Clobber out $(marker))
color_cmd_end_clobber = $(c_cyang)$(quiet_cmd_end_clobber)
cmd_end_clobber =
# ============================================================================ #
# Init target
# ============================================================================ #
PHONY += __asm_clobber_init
asm_clobber : __asm_clobber_init asm_clean
	$(call cmd,end_clobber)

__asm_clobber_init:
	$(call cmd,init_clobber)

.PHONY : $(PHONY)
