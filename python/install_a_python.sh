#! /bin/bash

set -eou pipefail -x

echo "current dir:" 
pwd
echo "current python:"
pyenv version

echo "using pip:"
which pip

# make sure python3 and python2 can be installed
pyenv install 3.7.3
pyenv install 2.7.15

# running in /python2.7.15 would cause an assertion error
mkdir -p /root/python3.7.3
mkdir -p /root/python2.7.15

# mess around with python3
cd /root/python3.7.3
pipenv run --python 3.7.3 python --version
pipenv install networkx

# mess around with python2
cd /root/python2.7.15
pipenv run --python 2.7.15 python --version
pipenv install networkx

