
################################################################################
# ===================================================================== info = #
################################################################################

# this is a make example and doubles as dot-case installer script

# --------------------------------------------------------------- references ---
#
# - https://www.gnu.org/software/make/manual/html_node/Standard-Targets.html
# - https://tech.davis-hansson.com/p/make/
# - https://www.gnu.org/software/make/manual/html_node/One-Shell.html
# - https://stackoverflow.com/questions/32153034/oneshell-not-working-properly-in-makefile
# - https://makefiletutorial.com/

# -------------------------------------------------------------------- notes ---
#
# makefile
# - use "$$" for escaping variable
# - use "-" to ignore errors (make)
# - use "@" to not print the command
# - $(MAKEFILE_LIST) is an environment variable (name of Makefile) thats available during Make.
# - phony is used to make sure there is no similar file(s) such as <target> that cause the make recipe not to work
# - oneshell not POSIX standard; supported make > 3.82; use gmake rather than make to ensure oneshell works
#
# awk
# - FS = awks field separator. use it in the beginning of execution. i.e. FS = ","
#
# npm semver
# - patch use @semver $$(git describe --tags --abbrev=0) -i patch
# - minor use @semver $$(git describe --tags --abbrev=0) -i minor

################################################################################
# ============================================================ configuration = #
################################################################################

# ------------------------------------------------------------------ targets ---

# defaults
MENU := all clean test

# helpers
MENU += help readme

# main
MENU += build-debian

# load phony
.PHONY: $(MENU)

# ------------------------------------------------------------ settings ----- #

# set default target
.DEFAULT_GOAL := help

# set fast fail so targets fail on error
# .SHELLFLAGS := -eu -o pipefail -c

# set default shell to run makefile
# SHELL := /bin/bash									# system default
# SHELL := /usr/local/bin/bash				# homebrew default bash

# sets all lines in the recipe to be passed in a single shell invocation
.ONESHELL:

# ------------------------------------------------------------ check version ---

# enforce make 4+
# ifeq ($(origin .RECIPEPREFIX), undefined)
#   $(error this make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later. use `brew install make` and run `gmake`)
# endif

# ---------------------------------------------------- environment variables ---

# load current shell env vars into makefile shell env
export

################################################################################
# ======================================================= makefile functions = #
################################################################################

# note that define can only take single line or rule

define func_print_arrow
	# ==> $(1)
endef

define func_print_header
	# ============================================= ### $(1) ###
endef

define func_check_file_regex
	cat $(1) || grep "$(2)"
endef

define func_check_command
	command -V $(1) || printf "$(2)"
endef

define func_print_tab
	printf "%s\t\t%s\t\t%s\n" $(1) $(2) $(3)
endef

################################################################################
# ===================================================================== main = #
################################################################################

##@ Helpers

help:														## display this help
	@awk 'BEGIN { FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"; } \
		/^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2; } \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5); } \
		END { printf ""; }' $(MAKEFILE_LIST)

readme:													## show information and notes
	$(call func_print_header,show readme)
	@touch README.md
	@cat README.md

##@ Menu

# core commands

build-debian:										## builds debian container
	$(call func_print_header,build graph-easy docker on debian base)
	@echo ":: build debian container :: output as graph-easy-docker"
	docker build -f ./Dockerfile -t graph-easy-docker .
	@echo "to run container use : docker run graph-easy-docker"
