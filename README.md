ipaddress
=========

This is a backport of Python 3's ipaddress module to Python 2. It
supports Python 2.6, 2.7, ..., 3.2.

Please refer to the [official Python 3 documentation]
(http://docs.python.org/3/library/ipaddress) for more
information on the module.

Usage notes
-----------

This backport aims to follow Python 3 semantics as closely as
possible. In particular, the textual form of IP addresses, networks,
and interfaces uses the `unicode` type, not `str`. Thus, you must pass
unicode objects when constructing an ipaddress object:

```python
>>> ipaddress.ip_address(u'1.2.3.4')
IPv4Address(u'1.2.3.4')
```
or
```python
>>> from __future__ import unicode_literals
>>> ipaddress.ip_address('1.2.3.4')
IPv4Address(u'1.2.3.4')
```
but not:
```python
>>> ipaddress.ip_address('1.2.3.4')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "ipaddress.py", line 163, in ip_address
    ' a unicode object?' % address)
ipaddress.AddressValueError: '1.2.3.4' does not appear to be an IPv4 or IPv6 address. Did you pass in a bytes (str in Python 2) instead of a unicode object?
```

`str` objects are used for the packed representation of IP
addresses:
```python
>>> ipaddress.ip_address(b'\x08\x09\x0a\x0b')
IPv4Address(u'8.9.10.11')
>>> ipaddress.ip_address(u'192.168.17.143').packed
'\xc0\xa8\x11\x8f'
```

One catch: `str()` on ipaddress objects must return a `str`, so you
can't do a round-trip via `str()`:

```python
>>> addr = ipaddress.ip_address('4.5.6.7')
>>> ipaddress.ip_address(str(addr))
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "ipaddress.py", line 163, in ip_address
    ' a unicode object?' % address)
ipaddress.AddressValueError: '4.5.6.7' does not appear to be an IPv4 or IPv6 address. Did you pass in a bytes (str in Python 2) instead of a unicode object?
```
Instead, use the `unicode()` builtin:
```python
>>> ipaddress.ip_address(unicode(addr))
IPv4Address(u'4.5.6.7')
```

Comparison with other backports
-------------------------------

There are two other backports of the ipaddress module:

  * https://bitbucket.org/kwi/py2-ipaddress/
  * https://github.com/sk-/backport_ipaddress

They both support a more familiar Python 2 interface, accepting `str`
objects as textual representation. That means they need a different
way to represent the packed form of IP addresses, so they use the
`bytearray` builtin type.

Thus:

  * if you want semantics closer to Python 3, and can live with the
    requirement to pass `unicode` objects rather than `str`, you
    probably want this backport

  * if you want more familiar Python 2 semantics and are not concerned
    with working under Python 3, one of the other backports would
    probably work better for you
