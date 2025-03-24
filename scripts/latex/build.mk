# ============================================================================ #
#
#  Author       : dmike
#  Date         : 23 Mar 2024
#  Description  : build plugin for project LaTex project
#
# ============================================================================ #
main_tex:=
included_tex:=
cls_tex:=
pkg_tex:=
texflags:= -shell-escape -halt-on-error -interaction batchmode -output-directory $(target_root)
inp_dir:= $(marker)
out_dir:= $(target_root)


PHONY := __build
__build: __init_build

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
include $(inp_dir)/Makefile

include $(root)/scripts/include.mk

quiet_cmd_init_build = $(call LOG,$(INFO),== LaTex build)
color_cmd_init_build = $(c_cyang)$(quiet_cmd_init_build)
cmd_init_build =

PHONY += __init_build
__init_build:
	$(call cmd,init_build)

quiet_cmd_end_build = $(call LOG,$(INFO),== LaTex build)
color_cmd_end_build = $(c_cyang)$(quiet_cmd_end_build)
cmd_end_build =

PHONY += latex_build
__build: latex_build

##
## Install resource + class + package into build directory
quiet_cmd_install = INSTALL	$@
color_cmd_install = $(c_magenta)$(quiet_cmd_install)
cmd_install = $(INSTALL) -D -m 644 $? $@

cls_tex_out:= $(addprefix $(target_root)/,$(cls_tex))
pkg_tex_out:= $(addprefix $(target_root)/,$(pkg_tex))
res_tex_out:= $(addprefix $(target_root)/,$(res_tex))
incl_tex_out:= $(addprefix $(target_root)/,$(included_tex))

$(res_tex_out): $(addprefix $(target_root)/,%) : %
	$(call cmd,install)

$(cls_tex_out): $(cls_tex)
	$(call cmd,install)

$(pkg_tex_out): $(pkg_tex)
	$(call cmd,install)

$(incl_tex_out): $(included_tex)
	$(call cmd,install)
##
##

tex_out:= $(addprefix $(target_root)/,$(main_tex:.tex=$(FTEX)))
quiet_cmd_ctex = CTEX	$@
color_cmd_ctex = $(c_yellow)$(quiet_cmd_ctex)
cmd_ctex = $(CTEX) $(texflags) $<

$(tex_out): $(main_tex) $(included_tex) $(cls_tex_out) $(pkg_tex_out) $(res_tex_out) $(incl_tex_out)
	$(call cmd,ctex)

PHONY += __fix_reference
__fix_reference: $(main_tex) $(tex_out)
	$(call cmd,ctex)

latex_build: $(tex_out) __fix_reference
	$(call cmd,end_build)


.PHONY: $(PHONY)

