PYTHON ?= python3

.PHONY: test build check clean

test:
	$(PYTHON) -m pytest -q

build:
	$(PYTHON) -m scripts.build --output build

check: test build

clean:
	rm -rf build .pytest_cache
