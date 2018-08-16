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
    
### Install oh-my-zsh
    
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

### vscode font for agnoster theme

    "editor.fontFamily": "'Hack'"

## fasd

    sudo apt install fasd
    echo 'eval "$(fasd --init auto)"' >> ~/.zshrc

## Python

Install the system python

    sudo apt install python python-dev

### pip

Don't install the system pip. Instead, use `get-pip.py`.
This is because using pip to upgrade the system pip can cause problems.
Install for both python2 and python3, if desired.

    wget https://bootstrap.pypa.io/get-pip.py
    python get-pip.py --user
    python3 get-pip.py --user
    
Probably add `$HOME/.local/bin` to the `PATH`.

    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

### [pyenv](https://github.com/pyenv/pyenv)

Pyenv helps manage multiple python installs through shell shims.

[pyenv-installer](https://github.com/pyenv/pyenv-installer)

    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    echo 'eval "$(pyenv virtualenv-init -)"' ~/.zshrc
    
[common build problems](https://github.com/pyenv/pyenv/wiki/common-build-problems) lists some packages you probably have to install to build most pythons.
As of 8/14/2018, it said

    sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev

### Using pyenv with tox

Use pyenv to install the desired versions of python

    pyenv install 3.5.5
  
Make the versions of python available wherever you want to run tox

    pyenv local 3.5.5

### Install [pipenv](https://docs.pipenv.org/)

    pip install --user pipenv

Add `PIPENV_VENV_IN_PROJECT` to the environment. This puts the `.venv` directory in the directory you run pipenv from, not in `.local/share/virtualenvs`.

    echo 'export PIPENV_VENV_IN_PROJECT=1' >> ~/.zshrc

## CUDA

On supported platforms, use the CUDA network deb installer

On unsupported platforms, install the Nvidia driver from the [graphics drivers ppa](https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa) and then install CUDA from the runfile **without installing the driver**.

    sudo ./run... --override
    
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
