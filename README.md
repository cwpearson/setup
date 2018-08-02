# setup
Notes on setting up systems

## Python

Install the system python2 and python3

    sudo apt install python2 python3

## Install pip

Don't install the system pip. Instead, use get-pip.py.
This is because using pip to upgrade the system pip can cause problems.

## Install [pyenv](https://github.com/pyenv/pyenv)

## Instal [pipenv](https://docs.pipenv.org/)

## Using pyenv with tox

Use pyenv to install the desired versions of python

    pyenv install 3.5.5
  
Make the versions of python available wherever you want to run tox

    pyenv local 3.5.5

## CUDA

On supported platforms, use the CUDA network deb installer

On unsupported platforms, install the Nvidia driver from the [graphics drivers ppa](https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa) and then install CUDA from the runfile **without installing the driver**.

    ./run... --override
