#! /bin/bash

set -eou pipefail -x

echo "current dir is" `pwd`
echo "current python is " `pyenv version`

echo "using pip" `which pip`


mkdir -p python3.7.3
cd python3.7.3
pyenv install 3.7.3
pyenv local 3.7.3
python3 --version
which python3
pipenv shell --python python3