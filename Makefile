pypi:
	python setup.py sdist bdist_wheel upload

clean:
	rm -rf -- build dist ipaddress.egg-info

.PHONY: clean pypi

