DEPS := node_modules
DEPS_BIN := $(DEPS)/.bin

JSCS := $(DEPS_BIN)/jscs
MOCHA := $(DEPS_BIN)/mocha
BABEL := $(DEPS_BIN)/babel
JSHINT := $(DEPS_BIN)/jshint
CHOKIDAR := $(DEPS_BIN)/chokidar

TARGET := dist
SRC = $(shell find src -type f -name '*.js')
TESTS = $(shell find test -type f -name '*.js')

default: clean $(DEPS) lint test $(TARGET)

clean:
	@echo -----------------------------------------
	@echo Cleaning up compiled assets
	@echo -----------------------------------------
	rm -rf $(TARGET)
	@echo -----------------------------------------
	@echo Cleaning up dependencies
	@echo -----------------------------------------
	rm -rf $(DEPS)

lint:
	@echo -----------------------------------------
	@echo Checking code style
	@echo -----------------------------------------
	@$(JSCS) $(SRC)
	@$(JSCS) $(TESTS)
	@echo -----------------------------------------
	@echo Searching for potential code issues
	@echo -----------------------------------------
	@$(JSHINT) $(SRC)
	@$(JSHINT) $(TESTS)

test:
	@echo -----------------------------------------
	@echo Testing
	@echo -----------------------------------------
	$(MOCHA) $(TESTS)

watch:
	@echo -----------------------------------------
	@echo Watching src, test, and node_modules
	@echo -----------------------------------------
	$(CHOKIDAR) 'src/**' 'test/**' 'node_modules/**' --follow-symlinks --initial --silent -c 'make test'

$(DEPS):
	@echo -----------------------------------------
	@echo Installing dependencies
	@echo -----------------------------------------
	npm install

$(TARGET): $(SRC:src/%.js=$(TARGET)/%.js)
	@echo
	@echo Successfully compiled all assets with $(BABEL)

$(TARGET)/%.js: src/%.js
	@mkdir -p $(@D)
	@$(BABEL) $< -o $@

.PHONY: default clean deps lint test watch
