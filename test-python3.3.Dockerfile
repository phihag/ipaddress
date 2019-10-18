FROM python:3.3-alpine
# Dockerfile to run tests under python3.3

# docker build -t ipaddress-python3.3 . -f test-python3.3.Dockerfile

ADD . .
RUN python test_ipaddress.py
CMD python test_ipaddress.py
