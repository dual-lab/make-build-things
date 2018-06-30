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
PHONY := cc_clean
cc_clean: mkclean = $(debug)$(MAKE) -f $(root)/scripts/cc/clean.mk marker=$@
# ============================================================================ #
# include utils variable
# ============================================================================ #
include $(root)/scripts/include.mk
# ============================================================================ #
# Include, if present, local makefile in which are defined the files and the
# directories contained in the upmost dir:
#   src -> all source files
#   dirs -> all directories
#   clean_files -> optional file to be removed during clean recipe
#   clobber_files -> optional file to be removed during clobber recipe
#   deps -> possible project dependencies
# ============================================================================ #
-include $(src_test_root)/$(marker)/Makefile
obj_test := $(patsubst %.c,%.o,$(src))
obj_test_d := $(obj_test:.o=.d)
obj_test_clean:= $(clean_files)
obj_test_dirs := $(dirs)
-include $(src_main_root)/$(marker)/Makefile
obj_main := $(patsubst %.c,%.o,$(src))
obj_main_d := $(obj_main:.o=.d)
obj_main_clean:= $(clean_files)
obj_main_dirs := $(dirs)
# ============================================================================ #
# Join all the objects necessary to the clean recipe
# ============================================================================ #
obj_src   := $(wildcard $(sort $(addprefix $(target_test_root)/$(marker)/,$(obj_test))))  \
  $(wildcard $(sort $(addprefix  $(target_test_root)/$(marker)/,$(obj_test_d)))) \
  $(wildcard $(sort $(addprefix  $(target_main_root)/$(marker)/,$(obj_main)))) \
  $(wildcard $(sort $(addprefix  $(target_main_root)/$(marker)/,$(obj_main_d))))
obj_dir   := $(sort $(addprefix $(marker)/,$(obj_test_dirs)))  \
  $(sort $(addprefix $(marker)/,$(obj_main_dirs)))
obj_clean := $(wildcard $(sort $(addprefix $(src_test_root)/$(marker)/,$(obj_test_clean))))  \
  $(wildcard $(sort $(addprefix $(src_main_root)/$(marker)/,$(obj_main_clean))))
# ============================================================================ #
# Define begin and end clean command
# ============================================================================ #
quiet_cmd_init_clean = $(call LOG,$(INFO),== CC Clean in $(marker))
color_cmd_init_clean = $(c_cyang)$(quiet_cmd_init_clean)
cmd_init_clean =
quiet_cmd_end_clean = $(call LOG,$(INFO),== CC Clean out $(marker))
color_cmd_end_clean = $(c_cyang)$(quiet_cmd_end_clean)
cmd_end_clean =
# ============================================================================ #
# Init target
# ============================================================================ #
PHONY += __cc_clean_init
cc_clean: __cc_clean_init $(deps) $(obj_dir) $(obj_src) $(obj_clean)
	$(call cmd,end_clean)

__cc_clean_init:
	$(call cmd,init_clean)

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
