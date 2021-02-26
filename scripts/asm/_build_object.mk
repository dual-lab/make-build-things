# ============================================================================ #
#
#  Author       : dmike
#  Date         : 22 Feb 2021
#  Description  : create object files and link them
#
# ============================================================================ #
# ============================================================================ #
# Initialize local variables
# This variables are read from include Makefile
# ============================================================================ #
src :=
dirs:=
asmflags:=
inp_dir:= $(marker)
out_dir:= $(addsuffix $(marker:$(src_root)%=%),$(target_root))
built_in:= built-in.o

PHONY:= __internal_build
__internal_build: 
# ============================================================================ #
# Include, if present, local makefile in which are defined the files and the
# directories contained in the upmost dir:
#   src -> all source files
#   dirs -> all directories
#   libs -> all static libs
# ============================================================================ #
include $(inp_dir)/Makefile
# ============================================================================ #
# Include utilities function
# ============================================================================ #
include $(root)/scripts/include.mk
# ============================================================================ #
# Format and sort inclued objects
# ============================================================================ #
obj_in := $(addprefix $(out_dir)/,$(patsubst %.S,%.o,$(src)))
asm_build_objects:= $(addsuffix /$(built_in),$(out_dir))
dirs_built_in:= 

__internal_build : $(asm_build_objects)

# ============================================================================ #
# Static pattern rule to create object file
# ============================================================================ #
quiet_cmd_asm = ASM	$@
color_cmd_asm = $(c_yellow)$(quiet_cmd_asm)
cmd_asm = $(ASM) $(ASMFLAGS) $(asmflags) -o $@ $<
out_stem := $(addprefix $(out_dir)/,%.o)
inp_stem := $(addprefix $(inp_dir)/,%.S)
$(obj_in): $(out_stem) : $(inp_stem) | $(hdr_stem) 
	$(call cmd,asm)

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
$(asm_build_objects): mkbuild = $(debug)$(MAKE) -f $(root)/scripts/asm/_build_object.mk marker=$(addprefix $(marker)/,$@)
$(asm_build_objects) : $(obj_in) $(dirs_built_in)
	$(call cmd,ld)


# ============================================================================ #
# Recursive subdirs walk
# ============================================================================ #
PHONY += $(dirs) 
$(dirs): out_sub_dir = $(addprefix $(out_dir)/,$@)

$(dirs): 
	$(if $(call file-exists,$(out_sub_dir)),,$(MKDIR) -p $(out_sub_dir))
	$(mkbuild)

.PHONY: $(PHONY)