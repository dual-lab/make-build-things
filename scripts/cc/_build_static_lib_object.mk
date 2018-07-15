# ============================================================================ #
#
#  Author       : dmike
#  Date         : 07 July 2018
#  Description  :  build object files in a static lib project
#
# ============================================================================ #
# Initialize local variables
# This variables are read from include Makefile
# ============================================================================ #
src :=
dirs:=
cflags:=
inp_dir:= $(addprefix $(src_main_root)/,$(marker))
out_dir:= $(addprefix $(target_main_root)/,$(marker))
built_in_suffix:= _built-in.o
built_in:= $(addsuffix $(built_in_suffix),$(notdir $(marker)))

PHONY:= __internal_static_lib_obj_build
__internal_static_lib_obj_build:

# ============================================================================ #
# Include, if present, local makefile in which are defined the files and the
# directories contained in the upmost dir:
#   src -> all source files
#   dirs -> all directories
# ============================================================================ #
include $(inp_dir)/Makefile
# ============================================================================ #
# Include utilities function
# ============================================================================ #
include $(root)/scripts/include.mk
# ============================================================================ #
# Format and sort inclued objects
# ============================================================================ #
obj_in := $(addprefix $(out_dir)/,$(patsubst %.c,%.o,$(src)))
pre_in := $(addprefix $(out_dir)/,$(patsubst %.c,%.d,$(src)))
cc_build_objects:= $(addsuffix /$(built_in),$(out_dir))
dirs_built_in:= 

ifneq ($(strip $(cflags)),$(empty))
cflags := $(patsubst -I%,-I$(addprefix $(src_main_root)/,%),$(cflags))
endif

ifneq ($(strip $(dirs)),$(empty))
dirs := $(sort $(patsubst %/,%,$(dirs)))
built_ins := $(addsuffix $(built_in_suffix), $(dirs))
cflags += $(patsubst %,-I$(addprefix $(inp_dir)/,%),$(dirs))
dirs_built_in += $(addprefix $(out_dir)/,$(addsuffix /$(built_ins),$(dirs)))
dirs_doubled := $(join $(dirs)/,$(dirs))
endif

__internal_static_lib_obj_build: $(cc_build_objects)

# ============================================================================ #
# Static pattern rule to generate prerequisites
# ============================================================================ #
pre_out_stem:= $(addprefix  $(out_dir)/,%.d)
pre_inp_stem := $(addprefix $(inp_dir)/,%.c)
$(pre_in): $(pre_out_stem): $(pre_inp_stem)
	$(call cmd,gen)

# ============================================================================ #
# Static pattern rule to create object file
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
# LD into one object file
# ============================================================================ #
quiet_cmd_ld = LD	$@
color_cmd_ld = $(c_blue)$(quiet_cmd_ld)
cmd_ld = $(LD) -r -o $@ $^
$(cc_build_objects): mkbuild = $(debug)$(MAKE) -f $(root)/scripts/cc/_build_static_lib_object.mk marker=$(addprefix $(marker)/,$(notdir $@))
$(cc_build_objects) : $(obj_in) $(dirs_built_in)
	$(call cmd,ld)
# ============================================================================ #
# Recursive subdirs walk
# ============================================================================ #
PHONY += $(dirs_doubled) 
$(dirs_doubled): out_sub_dir = $(addprefix $(out_dir)/,$(notdir $@))

$(dirs_doubled): 
	$(if $(call file-exists,$(out_sub_dir)),,$(MKDIR) -p $(out_sub_dir))
	$(mkbuild)

.PHONY: $(PHONY)