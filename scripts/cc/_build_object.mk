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
# Include source,lib and dirs that have to be built
# ============================================================================ #
include $(inp_dir)/Makefile
# ============================================================================ #
# Include utilities function
# ============================================================================ #
include $(root)/scripts/include.mk
# ============================================================================ #
# Format and sort inclued objects
# ============================================================================ #
# TODO
obj_in := $(addprefix $(out_dir)/,$(patsubst %.c,%.o,$(src)))
dirs_built_in:= $(out_dir)

ifneq ($(strip $(dirs)),$(empty))
dirs := $(sort $(patsubst %/,%,$(dirs)))
dirs_built_in += $(addprefix, $(out_dir)/,$(dirs))
endif
cc_build_objects = $(addsuffix /$(built_in),$(dirs_built_in))

__internal_build : $(cc_build_objects)

# ============================================================================ #
# Static pattern rule to create object file
# ============================================================================ #
quiet_cmd_cc = CC	$@
color_cmd_cc = $(c_yellow)$(quiet_cmd_cc)
cmd_cc = $(CC) $(cflags) -c -o $@ $^
out_stem := $(addprefix $(out_dir)/,%.o)
inp_stem := $(addprefix $(inp_dir)/,%.c)
$(obj_in): $(out_stem) : $(inp_stem)
	$(call cmd,cc)
# ============================================================================ #
# LD into one object file
# ============================================================================ #
quiet_cmd_ld = LD	$@
color_cmd_ld = $(c_blue)$(quiet_cmd_ld)
cmd_ld = $(LD) -r -o $@ $^
$(cc_build_objects) : $(obj_in)
	$(call cmd,ld)


.PHONY: $(PHONY)