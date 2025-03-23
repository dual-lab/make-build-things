# ============================================================================ #
#
#  Author       : dmike
#  Date         : 23 Mar 2025
#  Description  : Clean plugin for project with latex
#
# ============================================================================ #

PHONY := __clean
__clean: __init_clean

# ============================================================================ #
# Include, if present, local makefile in which are defined the files and the
# class or package used by tex files
#   main_tex -> entry document point
#   included_tex -> all file .tex included into main docs
#   cls_tex -> all custom class used by main tex doc
#   pkg_tex -> package included by main tex
#   texflags -> flag passed to latex compiler
#   res_tex -> all static resources that need to be copied into build dir
# ============================================================================ #
include $(marker)/Makefile
# ============================================================================ #
# include utils variable
# ============================================================================ #
include $(root)/scripts/include.mk

quiet_cmd_init_clean = $(call LOG,$(INFO),== LaTex Clean)
color_cmd_init_clean = $(c_cyang)$(quiet_cmd_init_clean)
cmd_init_clean =

PHONY += __init_clean
__init_clean:
	$(call cmd,init_clean)

quiet_cmd_end_clean = $(call LOG,$(INFO),== LaTex Clean)
color_cmd_end_clean = $(c_cyang)$(quiet_cmd_end_clean)
cmd_end_clean =

obj_tex:=

tex_out:= $(addprefix $(target_root)/,$(main_tex:.tex=$(FTEX)))
obj_tex += $(tex_out)

cls_tex_out:= $(addprefix $(target_root)/,$(cls_tex))
obj_tex += $(cls_tex_out)

pkg_tex_out:= $(addprefix $(target_root)/,$(pkg_tex))
obj_tex += $(pkg_tex_out)

res_tex_out:= $(addprefix $(target_root)/,$(res_tex))
obj_tex += $(res_tex_out)

incl_tex_out:= $(addprefix $(target_root)/,$(included_tex))
obj_tex += $(incl_tex_out)

PHONY += $(obj_tex)
$(obj_tex):
	$(call cmd,rm)

PHONY += latex_clean
__clean: latex_clean

latex_clean: $(obj_tex)
	$(call cmd,end_clean)

.PHONY: $(PHONY)
