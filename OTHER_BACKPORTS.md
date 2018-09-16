There are three backports of ipaddress in the wild:

phihag/ipaddress ([ipaddress on PyPI](https://pypi.org/project/ipaddress/)):
> First commit:  2013-02-03<br>
> First release: 2013-02-04<br>
> Latest commit: 2018-06-10 (as of June 2018)

kwi/py2-ipaddress ([py2-ipaddress on PyPI](https://pypi.org/project/py2-ipaddress/))
> First commit:  2013-08-08<br>
> First release: 2013-08-08<br>
> Latest commit: 2015-07-14

sk-/backport_ipaddress ([backport_ipaddress on PyPI](https://pypi.org/project/backport_ipaddress/))
> First commit:  2014-08-15<br>
> First release: 2014-09-01<br>
> Latest commit: 2014-08-16 (!)

In addition, judging by http://pypi-ranking.info/search/ipaddress/ , this backport has about 5 times as many downloads as the other two combined (yes, some of those could be updates, but in my experience new downloads absolutely dwarf updates).

sk-/backport_ipaddress is a fork of kwi/py2-ipaddress. As you can see from the above dates, the project has basically never been updated after being released. So I'm just going to focus on my ipaddress vs py2-ipaddress. Mine has nearly 40x the download count.

As you can also see from the above stats, py2-ipaddress has not been updated for over two years. Sure, it's a backport and thus does not necessitate frequent updating, but for instance cPython has fixed a couple of bugs just recently, and they are certainly still present in py2-ipaddress. In contrast, I can and do regularly sync. Upstream cPython code is in the upstream branch and just gets merged, so you can sync if you need the bleeding-edge ipaddress code (but a pull request or issue would be fine too if that's what you need).

But I don't think it's even necessary to argument from metadata, when the technical facts speak for themselves:

ipaddress (my backport) replicates the Python 3.3+ experience. It works on Python 2.6, 2.7, 3.2, and in theory 3.3+, whereas py2-ipaddress is 2.6/2.7 only. In particular, these two lines are equivalent with my backport and the official Python 3.3+ module:

    ipaddress.ip_address(u'8.9.10.11')
    ipaddress.ip_address(b'\x08\x09\x0a\x0b')  # packed representation

The other backport (py2-ipaddress), however, has decided that bytestrings ought to be treated as if the'd be unicode strings. This means that

    ipaddress.ip_address(b'\x3a\x3a\x31\x32')

**returns `ipaddress.IPv4Address(u'58.58.49.50')` in Python 3 and my backport, but `ipaddress.IPv6Address(u'::12')` with py2-ipaddress**.

Since the original use case for the ipaddress module was network and firewall management code, it's needless to say that this incompatibility would have disastrous consequences.

It is possible to initialize from a packed representation in py2-ipaddress. As far as I understand, the correct code would be:

    def ip_address(packed):
        assert isinstance(packed, bytes)
        try:  # py2-ipaddress
            return ipaddress.ip_address(bytearray(packed)))
        except TypeError:  # py 3.3+ ipaddress (or my backport)
            return ipaddress.ip_address(packed)

In my opinion, a backport should not necessitate additional workarounds like this.

[Another incompability](https://github.com/maxmind/GeoIP2-python/issues/41) of py2-ipaddress is that `packed` property returns a `bytearray` object with that backport. Again, this backports strives to be compatible to the Python 3.3+ ipaddress.

I have discussed with the py2-ipaddress folks at length, but as far as I understand their position is that they're writing py2-only code anyways, and thus don't have to care about py3/py2-ipaddress compatibility. Apparently, their code is also consistently confused between unicode strings and byte strings. They simply write `ipaddress.ip_address(bytearray(packed)))` to initialize from a packed representation, since they don't expect their code to ever be ported to Python 3.

I prefer not to write new Python 2-only code in 2016 - with a ticking time bomb to boot, since 2to3ing py2-ipaddress code or outright running it under Python 3.5 would not throw any errors or warnings, and might even work sometimes.

**I want to enable new Python 3 code to run on Python 2.x**. Therefore, even if it wasn't for all these other reasons, and even if py2-ipaddress had been released 6 months earlier instead of 6 months later than my package, py2-ipaddress still would not be an option for me.
