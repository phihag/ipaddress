FROM lovato/python-2.6.6
# Dockerfile to run tests under python2.6

# docker build -t ipaddress-python2.6 . -f test-python2.6.Dockerfile

ADD . .
RUN python test_ipaddress.py
CMD python test_ipaddress.py
