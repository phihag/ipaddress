default: test

test:
	flake8 ipaddress.py test_ipaddress.py
	python test_ipaddress.py

pypi:
	python setup.py sdist bdist_wheel upload

clean:
	rm -rf -- build dist ipaddress.egg-info

.PHONY: default test clean pypi

