# setup
Notes on setting up systems

## Kubuntu Backports

Backports of new versions of KDE Platform, Plasma and Applications as well as major KDE apps for Kubuntu.

    sudo add-apt-repository ppa:kubuntu-ppa/backports
    sudo apt-get update
    sudo apt full-upgrade

More info at the [kubuntu wiki](https://community.kde.org/Kubuntu/PPAs)

## fasd

    sudo apt install fasd
    
add `eval "$(fasd --init auto)"` to your shell `rc` file.

## Python

Install the system python2 and python3

    sudo apt install python2 python3

### pip

Don't install the system pip. Instead, use get-pip.py.
This is because using pip to upgrade the system pip can cause problems.

    wget https://bootstrap.pypa.io/get-pip.py
    python get-pip.py --user
    
Probably add `$HOME/.local/bin` to the `PATH`.

### [pyenv](https://github.com/pyenv/pyenv)

Pyenv helps manage multiple python installs through shell shims.

[pyenv-installer](https://github.com/pyenv/pyenv-installer)

    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    
[common build problems](https://github.com/pyenv/pyenv/wiki/common-build-problems) lists some packages you probably have to install to build most pythons.

### Using pyenv with tox

Use pyenv to install the desired versions of python

    pyenv install 3.5.5
  
Make the versions of python available wherever you want to run tox

    pyenv local 3.5.5

### Instal [pipenv](https://docs.pipenv.org/)

## CUDA

On supported platforms, use the CUDA network deb installer

On unsupported platforms, install the Nvidia driver from the [graphics drivers ppa](https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa) and then install CUDA from the runfile **without installing the driver**.

    sudo ./run... --override

