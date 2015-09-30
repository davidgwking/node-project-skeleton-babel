DEPS := node_modules
DEPS_BIN := $(DEPS)/.bin

JSCS := $(DEPS_BIN)/jscs
MOCHA := $(DEPS_BIN)/mocha
BABEL := $(DEPS_BIN)/babel
JSHINT := $(DEPS_BIN)/jshint
NODEMON := $(DEPS_BIN)/nodemon
BABEL_NODE := $(DEPS_BIN)/babel-node

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

server:
	@echo -----------------------------------------
	@echo Running server
	@echo -----------------------------------------
	$(BABEL_NODE) --stage 2 -- src/server.js

watch:
	@echo -----------------------------------------
	@echo Running server with file watching enabled
	@echo -----------------------------------------
	$(NODEMON) --exec make server

test:
	@echo -----------------------------------------
	@echo Running tests
	@echo -----------------------------------------
	$(MOCHA) $(TESTS)

watch-test:
	@echo -----------------------------------------
	@echo Running tests with file watching enabled
	@echo -----------------------------------------
	$(NODEMON) --exec make test

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

.PHONY: default clean lint server watch test watch-test
