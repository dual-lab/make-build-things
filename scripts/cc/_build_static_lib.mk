# ============================================================================ #
#
#  Author       : dmike
#  Date         : 01 July 2018
#  Description  : create a static lib
#
# ============================================================================ #
# Initialize local variables
# This variables are read from include Makefile
# ============================================================================ #
src :=
dirs:=
cflags:=
extract_name:= $(patsubst lib%,%,$(notdir $(marker)))
marker_nolib:= $(subst $(notdir $(marker)),$(extract_name),$(marker))
inp_dir:= $(addprefix $(src_main_root)/,$(marker_nolib))
out_dir:= $(addprefix $(target_main_root)/,$(marker_nolib))
static_lib := $(addprefix $(target_main_root)/,$(marker).a)
built_in_suffix:= _built-in.o

PHONY:= __internal_static_lib_build
__internal_static_lib_build:

# ============================================================================ #
# Include, if present, local makefile in which are defined the files and the
# directories contained in the upmost dir:
#   src -> all source files
#   cflags -> additional compiler flags
# ============================================================================ #
include $(inp_dir)/Makefile
# ============================================================================ #
# Include utilities function
# ============================================================================ #
include $(root)/scripts/include.mk

obj_in := $(addprefix $(out_dir)/,$(patsubst %.c,%.o,$(src)))
pre_in := $(addprefix $(out_dir)/,$(patsubst %.c,%.d,$(src)))

ifneq ($(strip $(cflags)),$(empty))
cflags := $(patsubst -I%,-I$(addprefix $(src_main_root)/,%),$(cflags))
endif

ifneq ($(strip $(dirs)),$(empty))
dirs := $(sort $(patsubst %/,%,$(dirs)))
built_in := $(addsuffix $(built_in_suffix), $(dirs))
cflags += $(patsubst %,-I$(addprefix $(inp_dir)/,%),$(dirs))
dirs_built_in += $(addprefix $(out_dir)/, $(addsuffix /$(built_in), $(dirs)))
dirs_doubled := $(join $(dirs)/,$(dirs))
endif

__internal_static_lib_build : $(static_lib)

$(out_dir):
	$(if $(call file-exists,$(out_dir)),,$(MKDIR) -p $@)

# ============================================================================ #
#  Recipe to generate prerequisites
# ============================================================================ #
pre_out_stem:= $(addprefix  $(out_dir)/,%.d)
pre_inp_stem := $(addprefix $(inp_dir)/,%.c)
$(pre_in): $(pre_out_stem): $(pre_inp_stem) |  $(out_dir) 
	$(call cmd,gen)

# ============================================================================ #
#  Recipe to generate object files
# ============================================================================ #
quiet_cmd_cc = CC	$@
color_cmd_cc = $(c_yellow)$(quiet_cmd_cc)
cmd_cc = $(CC) $(cflags) -c -o $@ $<
out_stem := $(addprefix $(out_dir)/,%.o)
inp_stem := $(addprefix $(inp_dir)/,%.c)
hdr_stem:= $(addprefix  $(out_dir)/,%.d)
$(obj_in): $(out_stem) : $(inp_stem) | $(hdr_stem) 
	$(call cmd,cc)

-include $(pre_in)

# ============================================================================ #
# Static patter rule for sub built-in.o files
# ============================================================================ #
$(dirs_built_in): $(out_dir)/%$(built_in_suffix): %
	@:

# ============================================================================ #
# Static lib rule 
# ============================================================================ #
quiet_cmd_ar = AR	$@
color_cmd_ar = $(c_yellow)$(quiet_cmd_ar)
cmd_ar = $(AR)  cr $@ $^
$(static_lib): $(obj_in) $(dirs_built_in)
	$(call cmd,ar)
	$(RANLIB) $@

# ============================================================================ #
# Recursive subdirs walk
# ============================================================================ #
PHONY += $(dirs_doubled) 
$(dirs_doubled): mkbuild = $(debug)$(MAKE) -f $(root)/scripts/cc/_build_static_lib_object.mk marker=$(addprefix $(marker_nolib)/,$(notdir $@))
$(dirs_doubled): out_sub_dir = $(addprefix $(out_dir)/,$(notdir $@))

$(dirs_doubled): 
	$(if $(call file-exists,$(out_sub_dir)),,$(MKDIR) -p $(out_sub_dir))
	$(mkbuild)


.PHONY: $(PHONY)