# setup
Notes on setting up systems

## Kubuntu Backports

Backports of new versions of KDE Platform, Plasma and Applications as well as major KDE apps for Kubuntu.

    sudo add-apt-repository ppa:kubuntu-ppa/backports
    sudo apt-get update
    sudo apt full-upgrade

More info at the [kubuntu wiki](https://community.kde.org/Kubuntu/PPAs)

## zsh

    sudo apt install zsh
    
or

    wget https://github.com/clvv/fasd/archive/1.0.1.tar.gz
    tar -xvf 1.0.1.tar.gz
    cd fasd-1.0.1
    PREFIX=$HOME/software/fasd-1.0.1 make install
    echo 'export $PATH=$HOME/software/fasd-1.0.1/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(fasd --init auto)"' >> ~/.zshrc
    
    
### Install oh-my-zsh
    
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

### vscode font for agnoster theme

    "editor.fontFamily": "'Hack'"

## fasd

    sudo apt install fasd
    echo 'eval "$(fasd --init auto)"' >> ~/.zshrc

### [macOS](https://github.com/clvv/fasd/wiki/Installing-via-Package-Managers#mac-os-x)

    brew install fasd
    echo 'eval "$(fasd --init auto)"' >> ~/.zshrc

## Python

This is to set up python with pipenv and pyenv, to support testing multiple pythons with tox.

Install the system python, python3, and python3 distutils

    sudo apt install python python-dev python3 python3-dev python3-distutils

### pip

#### Linux

Don't install the system pip. Instead, use `get-pip.py`.
This is because using pip to upgrade the system pip can cause problems in the future.

    wget https://bootstrap.pypa.io/get-pip.py
    python get-pip.py --user
    
Probably add `$HOME/.local/bin` to the `PATH` so you can use `pip`.

    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

#### macOS

Don't install pip, do everything in pipenvs (see below).

### [pyenv](https://github.com/pyenv/pyenv)

#### Linux

Pyenv helps manage multiple python installs through shell shims.

[pyenv-installer](https://github.com/pyenv/pyenv-installer)

    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

    
    echo 'export PATH="/home/pearson/.pyenv/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
    echo 'eval "$(pyenv virtualenv-init -)" /home/pearson/.zshrc' >> ~/.zshrc
    
    
[common build problems](https://github.com/pyenv/pyenv/wiki/common-build-problems) lists some packages you probably have to install to build most pythons.
As of 8/14/2018, it said

    sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev

#### [macOS](https://github.com/pyenv/pyenv#homebrew-on-mac-os-x)

    brew install pyenv
   
add `eval "$(pyenv init -)"` to the shell init

    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
   

### Using pyenv with tox

#### Linux

Use pyenv to install the desired versions of python

    pyenv install 3.5.5
    pyenv install 3.7.0
 
#### macOS

Some python packages need python installed as a "framework." The following is supposed to work:

      PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install 3.6.6
      
#### Finally 

Make the versions of python available wherever you want to run tox. For example:

    pyenv local 3.5.5 3.7.0

### Install [pipenv](https://docs.pipenv.org/)

#### Linux

    pip install --user pipenv

#### maxOS

    brew install pyenv

#### Finally 

Optionally add `PIPENV_VENV_IN_PROJECT` to the environment. This puts the `.venv` directory in the directory you run pipenv from, not in `.local/share/virtualenvs`.

    echo 'export PIPENV_VENV_IN_PROJECT=1' >> ~/.zshrc

## CUDA

On supported platforms, use the CUDA network deb installer

On unsupported platforms, install the Nvidia driver from the [graphics drivers ppa](https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa) and then install CUDA from the runfile **without installing the driver**.

* [x86 CUDA 9.2 Ubuntu 17.10 runfile](https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux)

    sudo ./run... --override
   
## Visual Studio Code

To get powerline fonts, do something like the following in user settings:
    
```json
{
    "terminal.integrated.fontFamily": "Source Code Pro for Powerline"
}
```

### Switching Python linter from pep8 to pycodestyle

Until the python plugin formally switches over:

```json
"python.linting.pep8Path": "pycodestyle",
"python.linting.pep8Enabled": true
```

## Syncthing GUI

To make it visible to the world ([source](https://superuser.com/questions/1026290/open-syncthing-port-on-raspberry-pi)):

The [config file](http://docs.syncthing.net/users/config.html) should have a line like

    <gui enabled="true" tls="false">
        <address>0.0.0.0:8384</address>

not

    <gui enabled="true" tls="false">
        <address>127.0.0.1:8384</address>

The documentation explains this:

    address
    Set the listen addresses. One or more address elements must be present. Allowed address formats are:

    IPv4 address and port (127.0.0.1:8384)
    The address and port is used as given.

    IPv6 address and port ([::1]:8384)
    The address and port is used as given. The address must be enclosed in square brackets.

    Wildcard and port (0.0.0.0:12345, [::]:12345, :12345)
    These are equivalent and will result in Syncthing listening on all interfaces and both IPv4 and IPv6.
    
## Minecraft Server

[minecraft@.service](minecraft@.service) is a system systemd service file.
It can probably be placed in `/etc/systemd/system`.
It's set up for a raspberry pi, but can work with other systems with minor modifications.
