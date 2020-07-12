# ================================================================= #
#
#  Author       : dmike
#  Date         : 12,July 2020
#  Description  : Remove all files created by kernel driver compilation
#
# ============================================================================ #

# ============================================================================ #
# Default target
# ============================================================================ #
PHONY := cc_clean
# ============================================================================ #
# include utils variable
# ============================================================================ #
include $(root)/scripts/include.mk

obj_dir := $(root)/$(marker)
obj_clean_suffix := *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions built-in.a \
	modules.order Module.symvers *.mod
obj_clean := $(wildcard $(addprefix $(obj_dir)/, $(obj_clean_suffix)))
# ============================================================================ #
# Define begin and end clean command
# ============================================================================ #
quiet_cmd_init_clean = $(call LOG,$(INFO),== Kernel driver Clean in $(marker))
color_cmd_init_clean = $(c_cyang)$(quiet_cmd_init_clean)
cmd_init_clean =
quiet_cmd_end_clean = $(call LOG,$(INFO),== Kernel Clean out $(marker))
color_cmd_end_clean = $(c_cyang)$(quiet_cmd_end_clean)
cmd_end_clean =
# ============================================================================ #
# Init target
# ============================================================================ #
PHONY += __cc_clean_init
cc_clean: __cc_clean_init $(obj_clean)
	$(call cmd,end_clean)

__cc_clean_init:
	$(call cmd,init_clean)

PHONY += $(obj_clean)
$(obj_clean):
	$(call cmd,rm)

.PHONY : $(PHONY)
