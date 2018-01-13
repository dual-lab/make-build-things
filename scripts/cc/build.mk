# ============================================================================ #
#
#  Author       : dmike
#  Date         : 20 August 2017
#  Description  : This is a specific plugin from c language. Iterates over
#  				all the source file linking them together in object files.
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
# ============================================================================ #
# Define the default recipe. With the following conditional
#       |--(T)-->|Build executable|---- |
#       |                                |
#      /\                                |
#  MAKELEVEL = 2                         |--o
#      \/                                |
#       |                                |
#       |--(F)-->|Build object files|-- |
# ============================================================================ #
PHONY:= __build
__build: __init_build

quiet_cmd_init_build = $(call LOG,$(INFO),== CC build in $(marker))
color_cmd_init_build = $(c_cyang)$(quiet_cmd_init_build)
cmd_init_build =
PHONY += __init_build
__init_build:
	$(call cmd,init_build)
quiet_cmd_end_build = $(call LOG,$(INFO),== CC build out $(marker))
color_cmd_end_build = $(c_cyang)$(quiet_cmd_end_build)
cmd_end_build =
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
cc_build_objects:= $(addsuffix /$(built_in),$(dirs_built_in))

ifeq ($(MAKELEVEL),2)
PHONY += cc_build_target
__build : cc_build_target

cc_target := $(addprefix $(target_root)/,$(project_name))
cc_build_target: $(cc_target)
	$(call cmd ,end_build)
quiet_cmd_out = OUT	 $@
color_cmd_out = $(c_green)$(quiet_cmd_out)
cmd_out = $(CC) $(cflags) $(CFLAGS) $^ -o $@
$(cc_target): $(cc_build_objects) #all obj files ,libs and project deps
	$(call cmd,out)
else
__build : $(cc_build_objects)
	$(call cmd ,end_build)
endif
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
