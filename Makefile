include makefile-go/include.mk.inc

export GO_TEST_PARALLEL = 1

all: go/lint build go/test go/test/race

test: go/test/force

export GO_TARGET = .

NOT_DYNAMIC_ARG = not dynamic
DYNAMIC_ARG = dynamic

define CHECK_BUILD_BIN
${INCLUDE_ECHO} \
${INCLUDE_BUILD_OUT_NAME} \
${INCLUDE_BIN_DYNAMIC} \
function test_build_binary() { \
	local bin_name_to_check=""; \
	echo_info "Run test binary for $$PROJECT_NAME"; \
	if ! bin_name_to_check="$$(build_out_name)"; then \
		exit_with_err "Cannot get bin name: $$bin_name_to_check"; \
	fi; \
	local full_bin_path="$(BUILD_PATH)/$${bin_name_to_check}"; \
	if ! full_bin_path="$$(realpath "$$full_bin_path")"; then \
		exit_with_err "Cannot get bin name: $$bin_name_to_check"; \
	fi; \
	local should_dynamic="$${1:-}"; \
	local should_dynamic_msg="$$should_dynamic"; \
	if [[ "$$should_dynamic" == "$(NOT_DYNAMIC_ARG)" ]]; then \
		should_dynamic=""; \
	fi; \
	local expected_output_env="$${2:-}"; \
	if [ -z "$$expected_output_env" ]; then \
		exit_with_err "Pass empty output env variable name"; \
	fi; \
	local expected_output="$${!expected_output_env}"; \
	if ! check_dynamic_executable "$$full_bin_path" "$$should_dynamic"; then \
		exit_with_err "Incorrect linking should be $$should_dynamic_msg"; \
	fi; \
	local output="$$($$full_bin_path)"; \
	if [[ "$$output" != "$$expected_output" ]]; then \
		echo_err "Incorrect output for '$$full_bin_path'. Diff:"; \
		diff <(echo -n "$$expected_output") <(echo -n "$$output"); \
		exit 1; \
	fi; \
	echo_info "Output for '$$full_bin_path' correct!"; \
	exit 0; \
}; \
test_build_binary "$(1)" "$(2)"
endef

define expected_out_build
Build with 'no tags'

Variables:
  first='not set'
  second='not set'

Variables form pkg:
  PkgVar='not set'

getUser: 'Not dynamic'
endef

export expected_out_build

build: export PROJECT_NAME = main
build: go/build/current
	@$(call CHECK_BUILD_BIN,$(NOT_DYNAMIC_ARG),expected_out_build)

define expected_out_build_tags
Build with 'custom tags'

Variables:
  first='not set'
  second='not set'

Variables form pkg:
  PkgVar='not set'

getUser: 'Not dynamic'
endef

export expected_out_build_tags

build/tags: export PROJECT_NAME = main-tags
build/tags: export GO_BUILD_TAGS = first,second
build/tags: go/build/current
	@$(call CHECK_BUILD_BIN,$(NOT_DYNAMIC_ARG),expected_out_build_tags)

define expected_out_build_tags_one
Build with 'no tags'

Variables:
  first='not set'
  second='not set'

Variables form pkg:
  PkgVar='not set'

getUser: 'Not dynamic'
endef

export expected_out_build_tags_one

build/tags/one: export PROJECT_NAME = main-tags-one
build/tags/one: export GO_BUILD_TAGS = first
build/tags/one: go/build/current
	@$(call CHECK_BUILD_BIN,$(NOT_DYNAMIC_ARG),expected_out_build_tags_one)

define BUILD_VARIABLES_ALL
main.first=first set//||\
main.second=second//||\
github.com/makefile-inc/tests-go/pkg.PkgVar= pkg set
endef

define expected_out_build_vars
Build with 'no tags'

Variables:
  first='first set'
  second='second'

Variables form pkg:
  PkgVar=' pkg set'

getUser: 'Not dynamic'
endef

export expected_out_build_vars

build/vars: export PROJECT_NAME = main-vars
build/vars: export GO_BUILD_VARIABLES = ${BUILD_VARIABLES_ALL}
build/vars: go/build/current
	@$(call CHECK_BUILD_BIN,$(NOT_DYNAMIC_ARG),expected_out_build_vars)

define BUILD_VARIABLES_FIRST
main.first=first only set 
endef

define expected_out_build_vars_first
Build with 'no tags'

Variables:
  first='first only set '
  second='not set'

Variables form pkg:
  PkgVar='not set'

getUser: 'Not dynamic'
endef

export expected_out_build_vars_first

build/vars/first: export PROJECT_NAME = main-vars-first
build/vars/first: export GO_BUILD_VARIABLES = ${BUILD_VARIABLES_FIRST}
build/vars/first: go/build/current
	@$(call CHECK_BUILD_BIN,$(NOT_DYNAMIC_ARG),expected_out_build_vars_first)

define BUILD_VARIABLES_SECOND
main.second= second only set
endef

define expected_out_build_vars_second
Build with 'no tags'

Variables:
  first='not set'
  second=' second only set'

Variables form pkg:
  PkgVar='not set'

getUser: 'Not dynamic'
endef

export expected_out_build_vars_second

build/vars/second: export PROJECT_NAME = main-vars-second
build/vars/second: export GO_BUILD_VARIABLES = ${BUILD_VARIABLES_SECOND}
build/vars/second: go/build/current
	@$(call CHECK_BUILD_BIN,$(NOT_DYNAMIC_ARG),expected_out_build_vars_second)

define expected_out_build_dynamic
Build with 'no tags'

Variables:
  first='not set'
  second='not set'

Variables form pkg:
  PkgVar='not set'

getUser: '$(USER)'
endef

export expected_out_build_dynamic

build/dynamic: export PROJECT_NAME = main-dynamic
build/dynamic: export GO_BUILD_TAGS = dynamic
build/dynamic: export GO_BUILD_DYNAMIC = true
build/dynamic: go/build/current
	@$(call CHECK_BUILD_BIN,$(DYNAMIC_ARG),expected_out_build_dynamic)

define expected_out_build_dyn_tag_vars
Build with 'custom tags'

Variables:
  first='first set'
  second='second'

Variables form pkg:
  PkgVar=' pkg set'

getUser: '$(USER)'
endef

export expected_out_build_dyn_tag_vars

build/dyn-tag-vars: export PROJECT_NAME = main-dtv
build/dyn-tag-vars: export GO_BUILD_TAGS = dynamic,first,second
build/dyn-tag-vars: export GO_BUILD_VARIABLES = ${BUILD_VARIABLES_ALL}
build/dyn-tag-vars: export GO_BUILD_DYNAMIC = true
build/dyn-tag-vars: go/build/current
	@$(call CHECK_BUILD_BIN,$(DYNAMIC_ARG),expected_out_build_dyn_tag_vars)

define expected_out_build_example
Examples ran. Is nil: true
endef

export expected_out_build_example

build/example: export PROJECT_NAME = example
build/example: export GO_TARGET_MODULE = $(CURDIR)/example
build/example: go/build/current
	@$(call CHECK_BUILD_BIN,$(NOT_DYNAMIC_ARG),expected_out_build_example)

build/all-platforms: export PROJECT_NAME = main-all
build/all-platforms: go/build/all
	@${INCLUDE_ECHO} \
	declare -A arches; \
	arches["$(OS_LINUX)-$(ARCH_AMD)"]="ELF 64-bit LSB executable, x86-64"; \
	arches["$(OS_LINUX)-$(ARCH_ARM)"]="ELF 64-bit LSB executable, ARM aarch64"; \
	arches["$(OS_MACOS)-$(ARCH_AMD)"]="Mach-O 64-bit x86_64"; \
	arches["$(OS_MACOS)-$(ARCH_ARM)"]="Mach-O 64-bit arm64"; \
	for arch in "$${!arches[@]}"; do \
		full_path="$(BUILD_PATH)/$${PROJECT_NAME}-$$arch"; \
		if [ ! -x "$$full_path" ]; then \
			exit_with_err "$$full_path is not found or not executable for $$arch"; \
		fi; \
    	file_out=""; \
		if ! file_out="$$(file "$$full_path")"; then \
			exit_with_err "$$full_path cannot get file info for $$arch"; \
		fi; \
		if ! grep -q "$${arches[$$arch]}" <<<"$$file_out"; then \
			exit_with_err "Incorrect arch for $${arch}: $$file_out"; \
		fi; \
	done

makefile-go/test/ok/build: clean/build 
	@$(MAKE) build
	@$(MAKE) build/tags
	@$(MAKE) build/tags/one
	@$(MAKE) build/vars
	@$(MAKE) build/vars/first
	@$(MAKE) build/vars/second
	@$(MAKE) build/dynamic
	@$(MAKE) build/dyn-tag-vars
	@$(MAKE) build/example
	@$(MAKE) build/all-platforms

makefile-go/test/ok/run-tests: go/lint
	@${INCLUDE_ECHO} \
	for_check=(\
		" Run tests in $(CURDIR) " \
		" Run tests in $(CURDIR)/example " \
		"Tests in '$(CURDIR)' passed in" \
		"Tests in '$(CURDIR)/example' passed in" \
		"All tests passed in" \
	); \
	test_file=""; \
	if ! test_file="$$(mktemp)"; then \
		exit_with_err "Cannot create tmp file for test run"; \
	fi; \
	$(MAKE) go/test 2>&1 | tee "$$test_file"; \
	if [ "$${PIPESTATUS[0]}" != "0" ]; then \
		exit_with_err "go/test failed"; \
	fi; \
	sed -i $$'s/\033[[][^A-Za-z]*[A-Za-z]//g' "$$test_file"; \
	for pat in "$${for_check[@]}"; do \
		if ! grep -q "$$pat" "$$test_file"; then \
			exit_with_err "Pattern '$$pat' not found for go/test"; \
		fi; \
	done; \
	race_file=""; \
	if ! race_file="$$(mktemp)"; then \
		exit_with_err "Cannot create tmp file for race run"; \
	fi; \
	$(MAKE) go/test/race 2>&1 | tee "$$race_file"; \
	if [ "$${PIPESTATUS[0]}" != "0" ]; then \
		exit_with_err "go/test/race failed"; \
	fi; \
	sed -i $$'s/\033[[][^A-Za-z]*[A-Za-z]//g' "$$race_file"; \
	for_check+=("Run race tests..."); \
	for pat_r in "$${for_check[@]}"; do \
		if ! grep -q "$$pat_r" "$$race_file"; then \
			exit_with_err "Pattern '$$pat_r' not found for go/test/race"; \
		fi; \
	done

makefile-go/test/fail/run-tests: export DO_FAIL_TEST = true
makefile-go/test/fail/run-tests: export GO_TEST_FORCE_RESTART = true
makefile-go/test/fail/run-tests:
	@${INCLUDE_ECHO} \
	for_check=(\
		"$(CURDIR) tests failed!" \
		"$(CURDIR)/example tests failed!" \
		"In \"$(CURDIR)\" tests unsuccessful in" \
		"In \"$(CURDIR)/example\" tests unsuccessful in" \
		" Unsuccessful test TestFailFirst/Fail_test_first " \
		" Unsuccessful test TestFailExample/Fail_test_example " \
		"Tests FAILED in" \
	); \
	test_file=""; \
	if ! test_file="$$(mktemp)"; then \
		exit_with_err "Cannot create tmp file for test run"; \
	fi; \
	$(MAKE) go/test 2>&1 | tee "$$test_file"; \
	if [ "$${PIPESTATUS[0]}" == "0" ]; then \
		exit_with_err "go/test passed"; \
	fi; \
	sed -i $$'s/\033[[][^A-Za-z]*[A-Za-z]//g' "$$test_file"; \
	for pat in "$${for_check[@]}"; do \
		if ! grep -q "$$pat" "$$test_file"; then \
			exit_with_err "Pattern '$$pat' not found for go/test"; \
		fi; \
	done; \
	tail_file=""; \
	if ! tail_file="$$(tail -n 10 "$$test_file")"; then \
		exit_with_err "Cannot get tail for go/test"; \
	fi; \
	tail_pat="Unsuccessful tests:\nTestFailFirst\nTestFailSecond\nTestFailExample\nTestFailFirst\\/Fail_test_first\nTestFailSecond\\/Fail_test_first\nTestFailExample\\/Fail_test_example"; \
	if ! grep -Pzq "$$tail_pat" "$$test_file"; then \
		echo_err "Tail pattern not found"; \
		echo_err "Got tail:"; \
		echo_err "$$tail_file"; \
		exit 5; \
	fi