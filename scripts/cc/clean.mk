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
# initialize used variables
# ============================================================================ #
src :=
dirs:=
clean_files:=
# ============================================================================ #
# Default target
# ============================================================================ #
PHONY := __cc_clean
__cc_clean: mkclean = $(debug)$(MAKE) -f $(root)/scripts/cc/clean.mk marker=$@
# ============================================================================ #
# include utils variable
# ============================================================================ #
include $(root)/scripts/include.mk
# ============================================================================ #
# Include, if present, local makefile in which are defined the files and the
# directories contained in the upmost dir:
#   src -> all source files
#   dirs -> all directories
#   clean-files -> optional file to be removed during clean recipe
#   clobber-files -> optional file to be removed during clobber recipe
#   deps -> possible project dependencies
# ============================================================================ #
-include $(src_test_root)/$(marker)/Makefile
obj_test := $(src)
obj_test_clean:= $(clean_files)
obj_test_dirs := $(dirs)
-include $(src_main_root)/$(marker)/Makefile
obj_main := $(src)
obj_main_clean:= $(clean_files)
obj_main_dirs := $(dirs)
# ============================================================================ #
# Join all the objects necessary to the clean recipe
# ============================================================================ #
obj_src   := $(wildcard $(sort $(addprefix $(target_test_root)/$(marker)/,$(obj_test))))  \
  $(wildcard $(sort $(addprefix  $(target_main_root)/$(marker)/,$(obj_main))))
obj_dir   := $(wildcard $(sort $(addprefix $(marker)/,$(obj_test_dirs))))  \
  $(wildcard $(sort $(addprefix $(marker)/,$(obj_main_dirs))))
obj_clean := $(wildcard $(sort $(addprefix $(src_test_root)/$(marker)/,$(obj_test_clean))))  \
  $(wildcard $(sort $(addprefix $(src_main_root)/$(marker)/,$(obj_main_clean))))
# ============================================================================ #
# Define begin and end clean command
# ============================================================================ #
quiet_cmd_init = $(call LOG,$(INFO),CC Clean Begin)
color_cmd_init = $(c_cyang)$(quiet_cmd_init)
cmd_init =
quiet_cmd_end = $(call LOG,$(INFO),CC Clean End)
color_cmd_end = $(c_cyang)$(quiet_cmd_end)
cmd_end =
# ============================================================================ #
# Init target
# ============================================================================ #
PHONY += __cc_init
__cc_clean: __cc_init $(deps) $(obj_dir) $(obj_src) $(obj_clean)
	$(call cmd,end)

__cc_init:
	$(call cmd,init)

PHONY += $(obj_clean)
$(obj_clean):
	$(call cmd,rm)

PHONY += $(obj_src)
$(obj_src):
	$(call cmd,rm)

PHONY += $(obj_dir)
$(obj_dir):
	$(mkclean)

PHONY += $(deps)
$(deps):
	$(call makeclean,$@,$@)

.PHONY : $(PHONY)
