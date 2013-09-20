ipaddress
=========

Python 3.3's ipaddress for Python 2.6 and 2.7.

Note that you must pass in unicode objects when constructing from a character representation!

Correct:

ipaddress.ip_address(u'1.2.3.4')

Wrong:

ipaddress.ip_address('1.2.3.4')
ipaddress.ip_address(b'1.2.3.4')
