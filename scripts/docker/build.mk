# ============================================================================ #
#
#  Author       : dmike
#  Date         : 16 June 2019
#  Description  : 
#
# ============================================================================ #

PHONY := __build
__build: __init_build

# ============================================================================ #
# Include utilities function
# ============================================================================ #
include $(root)/scripts/include.mk

quiet_cmd_init_build = $(call LOG,$(INFO),== Docker build in $(marker))
color_cmd_init_build = $(c_cyang)$(quiet_cmd_init_build)
cmd_init_build =

PHONY += __init_build
__init_build:
	$(call cmd,init_build)

quiet_cmd_end_build = $(call LOG,$(INFO),== Docker build out $(marker))
color_cmd_end_build = $(c_cyang)$(quiet_cmd_end_build)
cmd_end_build =

PHONY += docker_build_target
__build: docker_build_target

docker_target := $(addprefix $(target_main_root)/,Dockerfile)
# ============================================================================ #
# makedockerfile can be override inside the src_main_root/Makefile
# 
# 
# 'docker_build_target: override makedockerfile = do something different'
# 
# 
# 
# so to use this build process to create custom image based on other
# ============================================================================ #
docker_build_target: makedockerfile = $(debug)echo "FROM scratch\nADD $(project_name).tar /\n$(docker_custom_cmd)\nCMD [\"/usr/bin/bash\"]" > $@
docker_build_target: $(docker_target)
	$(call cmd,end_build)

# ============================================================================ #
# Include file containing the docker_pre_build rule
# ============================================================================ #
include $(src_main_root)/$(marker)/Makefile

$(docker_target): $(docker_pre_build)
	$(makedockerfile)

.PHONY: $(PHONY)