PYTHON ?= python3

.PHONY: test build check clean stls

test:
	$(PYTHON) -m pytest -q

build:
	$(PYTHON) -m scripts.build --output build

stls:
	$(PYTHON) -m scripts.export_stls --output STLs

check: test build

clean:
	rm -rf build .pytest_cache
