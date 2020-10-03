.PHONY: default clean clean_if_diff test release

clean = if [ ! -d "./builds" ]; then mkdir "builds"; else env echo "cleaning builds..." && rm -r builds; fi

default: test

builds:
	@if [ ! -d "./builds" ]; then mkdir "builds"; fi

clean:
	@$(call clean)

clean_if_diff:
	@[[ -z `git status -s -uall` ]] || $(call clean)

builds/looper_test: builds
	@echo "compiling test build..."
	@env LIBRARY_PATH="$(PWD)/lib_ext" crystal build src/looper.cr --error-trace -o builds/looper_test

test: clean_if_diff builds/looper_test
	@env LD_LIBRARY_PATH="$(PWD)/lib_ext" ./builds/looper_test

builds/looper: builds
	@echo "compiling release build..."
	@env LIBRARY_PATH="$(PWD)/lib_ext" crystal build --release --no-debug src/looper.cr -o builds/looper

release: clean_if_diff builds/looper
	@env LD_LIBRARY_PATH="$(PWD)/lib_ext" ./builds/looper
