# ============================================================================ #
#
#  Author       : dmike
#  Date         : 20 August 2017
#  Description  : create object files and link them
#
# ============================================================================ #
# ============================================================================ #
# Initialize local variables
# This variables are read from include Makefile
# ============================================================================ #
src :=
dirs:=
libs:=
cflags:=
inp_dir:= $(addprefix $(src_main_root)/,$(marker))
out_dir:= $(addprefix $(target_main_root)/,$(marker))
built_in:= built-in.o

PHONY:= __internal_build
__internal_build: 
# ============================================================================ #
# Include, if present, local makefile in which are defined the files and the
# directories contained in the upmost dir:
#   src -> all source files
#   dirs -> all directories
#   libs -> all static libs
#   deps -> possible project dependencies
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
cc_build_libs:=
dirs_built_in:= 

ifneq ($(strip $(cflags)),$(empty))
cflags := $(patsubst -I%,-I$(addprefix $(src_main_root)/,%),$(cflags))
endif

ifneq ($(strip $(dirs)),$(empty))
dirs := $(sort $(patsubst %/,%,$(dirs)))
cflags += $(patsubst %,-I$(addprefix $(inp_dir)/,%),$(dirs))
dirs_built_in += $(addprefix $(out_dir)/,$(addsuffix /$(built_in),$(dirs)))
endif

ifneq ($(strip $(libs)),$(empty))
libs := $(patsubst %/,%,$(libs))
libs := $(filter-out $(dirs),$(libs))
cflags += $(patsubst %,-I$(addprefix $(inp_dir)/,%),$(libs))
cflags += -L$(out_dir) $(addprefix -l,$(libs))
cc_build_libs += $(addprefix $(out_dir)/,$(patsubst %,%.a,$(addprefix lib,$(libs))))
endif

__internal_build : $(cc_build_objects) $(cc_build_libs)

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
$(dirs_built_in): $(out_dir)/%/$(built_in): %
	@:
# ============================================================================ #
# LD into one object file
# ============================================================================ #
quiet_cmd_ld = LD	$@
color_cmd_ld = $(c_blue)$(quiet_cmd_ld)
cmd_ld = $(LD) -r -o $@ $^
$(cc_build_objects): mkbuild = $(debug)$(MAKE) -f $(root)/scripts/cc/_build_object.mk marker=$(addprefix $(marker)/,$@)
$(cc_build_objects) : $(obj_in) $(dirs_built_in)
	$(call cmd,ld)

# ============================================================================ #
# Static Lib build process
# ============================================================================ #
#TODO
$(cc_build_libs): mkbuild = $(debug)$(MAKE) -f $(root)/scripts/cc/_build_static_lib.mk marker=$(addprefix $(marker)/,$(patsubst %.a,%,$(notdir $@)))
$(cc_build_libs):
	$(mkbuild)

# ============================================================================ #
# Recursive subdirs walk
# ============================================================================ #
PHONY += $(dirs) 
$(dirs): out_sub_dir = $(addprefix $(out_dir)/,$@)

$(dirs): 
	$(if $(call file-exists,$(out_sub_dir)),,$(MKDIR) -p $(out_sub_dir))
	$(mkbuild)

.PHONY: $(PHONY)