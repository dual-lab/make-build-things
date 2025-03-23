# ============================================================================ #
#
#  Author       : dmike
#  Date         : 23 Mar 2025
#  Description  : Clobber plugin for project with latex
#
# ============================================================================ #

PHONY := __clobber
__clobber: __init_clobber

include $(root)/scripts/latex/clean.mk

quiet_cmd_init_clobber = $(call LOG,$(INFO),== LaTex clobber)
color_cmd_init_clobber = $(c_cyang)$(quiet_cmd_init_clobber)
cmd_init_clobber =

PHONY += __init_clobber
__init_clobber:
	$(call cmd,init_clobber)

quiet_cmd_end_clobber = $(call LOG,$(INFO),== LaTex clobber)
color_cmd_end_clobber = $(c_cyang)$(quiet_cmd_end_clobber)
cmd_end_clobber =

obj_clobber:= $(tex_out:$(FTEX)=.log) $(tex_out:$(FTEX)=.aux) $(tex_out:$(FTEX)=.dvi) $(tex_out:$(FTEX)=.toc)

PHONY += $(obj_clobber)
$(obj_clobber):
	$(call cmd,rm)

__clobber: __clean $(obj_clobber)
	$(call cmd,end_clobber)

.PHONY: $(PHONY)
