default: test lint

test:
	python test_ipaddress.py

lint:
	flake8 *.py

lint-if-2.7:
	@if python --version 2>&1 | grep -q ' 2\.7\.'; then $(MAKE) lint ; fi

pypi:
	python setup.py sdist bdist_wheel upload

release:
	if test -z "${VERSION}"; then echo VERSION missing; exit 1; fi
	sed -i "s#^\(__version__\s*=\s*'\)[^']*'\$$#\1${VERSION}'#" ipaddress.py
	sed -i "s#^\(\s*'version':\s*'\)[^']*\('.*\)\$$#\1${VERSION}\2#" setup.py
	git diff
	git add ipaddress.py setup.py
	git commit -m "release ${VERSION}"
	git tag "v${VERSION}"
	git push
	git push --tags
	$(MAKE) pypi

docker-test-all: docker-test-2.6 docker-test-2.7 docker-test-3.2 docker-test-3.3

docker-test-2.6:
	docker build -t ipaddress-python2.6 . -f test-python2.6.Dockerfile

docker-test-2.7:
	docker build -t ipaddress-python2.7 . -f test-python2.7.Dockerfile

docker-test-3.2:
	docker build -t ipaddress-python3.2 . -f test-python3.2.Dockerfile

docker-test-3.3:
	docker build -t ipaddress-python3.3 . -f test-python3.3.Dockerfile

clean:
	rm -rf -- build dist ipaddress.egg-info

.PHONY: default test clean pypi lint docker-test-all docker-test-2.6 docker-test-2.7 docker-test-3.2 docker-test-3.3 lint-if-2.7

