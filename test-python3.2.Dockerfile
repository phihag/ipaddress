FROM python:3.2-slim
# Dockerfile to run tests under python3.2

# docker build -t ipaddress-python3.2 . -f test-python3.2.Dockerfile

ADD . .
RUN python test_ipaddress.py
CMD python test_ipaddress.py
