# setup
Notes on setting up systems

## Debian 10 Testing

* Updates may frequently break 3rd-party software (e.g., upgrading to a kernel unsupported by CUDA)

* Use the btrfs filesystem
  * make a snaptshot right away and before updates
    * `btrfs subvolume snapshot / /snapshots/YYYY-MM-DD-<description>`
  * periodically defragment source subvolumes (not snapshots)
    * `sudo btrfs filesystem defragment -r /`
  * try to keep the number of extant snapshots lowish
    * `sudo btrfs subvolume delete /snapshots/<your snapshot here>`
    
* Switch sources to testing
  * ```
    deb http://deb.debian.org/debian/ testing main
    deb-src http://deb.debian.org/debian/ testing main
    deb http://security.debian.org testing-security main contrib
    deb-src http://security.debian.org testing-security main contrib
    ```
  * `apt full-upgrade`

* Install Firefox from flatpak, since only firefox-esr is installed
  * Profiles are in `~/.var/app/org.mozilla.firefox/.mozilla/firefox/`
  * Binary is in `/var/lib/flatpak/exports/bin/org.mozilla.firefox`
  * `apt-get remove --purge firefox-esr`
* Probably want to install binary instead, flatpak doesn't use system fonts (as of 11/2020).

* Install Thunderbird from Flathub

* Install libreoffice debs from website.
  * `sudo apt-get remvoe libreoffice* --purge`
  
* During upgrade, many packages may be kept back
  * `sudo apt-get --with-new-pkgs upgrade` will upgrade any packages that were held because upgrading them requires a new dependency to be installed.
  * `sudo apt-get install --only-upgrade <package>` will try to upgrade the package without marking it as manually installed

 * Install the best KDE
   * `sudo apt install task-kde-desktop`

## Kubuntu 20.04

### Install [Kubuntu Backports](https://community.kde.org/Kubuntu/PPAs#Kubuntu_Backports)

Backports of new versions of KDE Platform, Plasma and Applications as well as major KDE apps for Kubuntu.

    sudo add-apt-repository ppa:kubuntu-ppa/backports
    sudo apt-get update
    sudo apt full-upgrade

## KDE 5

### Network Manager Openconnect
Needed for Cisco AnyConnect VPN through KDE network manager.

    sudo apt install openconnect network-manager-openconnect

### Virtual Desktops
* Enable virtual desktops: System Settings > Workspace Behavior > Virtual Desktops
* Enable switching shortcuts: System Settings > Global Shortcuts > KWin
  * "Switch One Desktop Down": Ctrl+Alt+Down
  * "Window One Desktop Down": Ctrl+Alt+Shift+Down


## zsh
    sudo apt install zsh
    
### Install oh-my-zsh
    
    sudo apt install -y curl git
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

Edit `~/.zshrc`
    
    ZSH_THEME="agnoster"
    plugins=(git z)
    
May have to `touch ~/.z` if complains about missing file.

## [CMake](https://cmake.org/download/) 3.12.2

To build from source

    sudo apt install zlib1g-dev libcurl4-openssl-dev
    wget https://cmake.org/files/v3.12/cmake-3.12.2.tar.gz
    tar -xvf cmake-3.12.2.tar.gz
    cd cmake-3.12.2
    ./bootstrap --prefix=$HOME/software/cmake-3.12.2 --parallel=`nproc` --system-curl
    make -j`nproc` install
    echo 'export PATH="$HOME/software/cmake-3.12.2/bin:$PATH"' >> ~/.zshrc

Or binaries on x86 (zsh)

    sudo apt install -y wget
    wget https://cmake.org/files/v3.12/cmake-3.12.2-Linux-x86_64.sh
    chmod +x cmake-3.12.2-Linux-x86_64.sh
    mkdir -p $HOME/software/cmake-3.12.2
    ./cmake-3.12.2-Linux-x86_64.sh --skip-license --prefix=$HOME/software/cmake-3.12.2
    echo 'export PATH="$HOME/software/cmake-3.12.2/bin:$PATH"' >> ~/.zshrc
    rm cmake-3.12.2-Linux-x86_64.sh
    
(bash)
    
    sudo apt install -y wget
    wget https://cmake.org/files/v3.12/cmake-3.12.2-Linux-x86_64.sh
    chmod +x cmake-3.12.2-Linux-x86_64.sh
    mkdir -p $HOME/software/cmake-3.12.2
    ./cmake-3.12.2-Linux-x86_64.sh --skip-license --prefix=$HOME/software/cmake-3.12.2
    echo 'export PATH="$HOME/software/cmake-3.12.2/bin:$PATH"' >> ~/.bashrc
    rm cmake-3.12.2-Linux-x86_64.sh

### vscode font for agnoster theme

#### macOS

    "editor.fontFamily": "'Hack'"

### [macOS](https://github.com/clvv/fasd/wiki/Installing-via-Package-Managers#mac-os-x)

    brew install fasd
    echo 'eval "$(fasd --init auto)"' >> ~/.zshrc

## Python

This is to set up python with pipenv and pyenv, to support testing multiple pythons with tox.

We use this setup to avoid the following problems:
* using `sudo pip`: shouldn't need root to install local packages
* using `pip --user`: conflicting package versions for different projects
* project 1 needs python 3.5, project 2 needs python 3.7

Four tools:
* `pyenv`: allows you to install and use specific versions of Python and its related tools. Messes with $PATH and symlinks.
* `pip`: installs python packages
* `virtualenv`: tricks pip into installing packages into arbitrary directories
* `pipenv`: puts all of the above together
  * `pipenv install`: satisfy deps, use virtualenv to create a project-specific package dir, uses pip to install
  * `pipenv shell`: uses pyenv to create a directory with the right python version, integrates deps into that environment

Basically, use as little of your OS's package management tools as possible with python. A full example of setting up python on Linux can be found in `python/Dockerfile.1604` and `python/Dockerfile.1804`.


### macOS

macOS comes with an old python 2.7 for compatibility, and a newer python 3.
But, we want to avoid using the system pythons as much as possible.

[Install pyenv](https://github.com/pyenv/pyenv#homebrew-on-macos)

    brew install pyenv
    
Then get pipenv too. As of 5/2021, not recommended to use brew to install pipenv.
So, install a pipenv per python you use with pyenv

    pip install pipenv
    
You may at some later date see this error: `pkg_resources.DistributionNotFound: The 'pipenv==2018.11.26' ...`. If so, do

    brew reinstall pipenv

### Other

### Install the system python (probably already done)

    sudo apt install python python-dev

### Install pip

#### Linux

Don't install the system pip. Instead, use `get-pip.py`.
This is because using pip to upgrade the system pip can cause problems in the future.

    wget https://bootstrap.pypa.io/get-pip.py
    python get-pip.py --user
    
Probably add `$HOME/.local/bin` to the `PATH` so you can use `pip`.

    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

#### macOS

Don't install pip, do everything in pipenvs (see below).

### Install [pyenv](https://github.com/pyenv/pyenv)

#### Linux

Pyenv helps manage multiple python installs through shell shims.

[pyenv-installer](https://github.com/pyenv/pyenv-installer)

(zsh)

    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
    
(bash)

    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

[common build problems](https://github.com/pyenv/pyenv/wiki/common-build-problems) lists some packages you probably have to install to build most pythons.
As of 8/14/2018, it said

    sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev
   
### Install [pipenv](https://docs.pipenv.org/)

#### Linux

    pip install --user pipenv


#### Finally 

Optionally add `PIPENV_VENV_IN_PROJECT` to the environment. This puts the `.venv` directory in the directory you run pipenv from, not in `.local/share/virtualenvs`.
Not recommended if the directory will be synced between multiple machines.

    echo 'export PIPENV_VENV_IN_PROJECT=1' >> ~/.zshrc

#### FAQ

*Why does `pipenv shell` always `cd` me into `~`?*

make sure your `~` does not have a `Pipfile` / `Pipefile.lock`


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



## CUDA

On supported platforms, use the CUDA network deb installer

On unsupported platforms, install the Nvidia driver from the [graphics drivers ppa](https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa) and then install CUDA from the runfile **without installing the driver**.

* [x86 CUDA 9.2 Ubuntu 17.10 runfile](https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux)

    sudo ./run... --override
   
## Visual Studio Code

On Kubuntu & Debian 10, it's easiest to use `hack` for the `Terminal > Integrated: Font Family` setting.
    
### Switching Python linter from pep8 to pycodestyle

Until the python plugin formally switches over:

```json
"python.linting.pep8Path": "pycodestyle",
"python.linting.pep8Enabled": true
```

## Boost

    curl -L https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.bz2 -o boost_1_68_0.tar.bz2
    nice -n20 tar -xvf boost_1_68_0.tar.bz2
    cd boost_1_68_0
    nice -n20 ./bootstrap --prefix=$HOME/software/boost_1_68_0
    mkdir -p $HOME/software/boost_1_68_0
    nice -n20 ./b2 --prefix=$HOME/software/boost_1_68_0 -j`nproc` install

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

## CUDA 10 Toolkit, Ubuntu 18.04

    curl -LO https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64
    sudo dpkg -i cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64
    sudo apt-key add /var/cuda-repo-10-0-local-10.0.130-410.48/7fa2af80.pub
    sudo apt-get update
    sudo apt-get install cuda-toolkit-10-0
    
## Private Internet Access through Kubuntu Network Manager


Import the pia config file, then set

* Cipher: AES-128-CBC
* HMCA auth: SHA-1
* Size of cipher key: 128, but shouldn't need to enter it

## CSL Printer on KDE

Install samba client to get the windows printers

    sudo apt install smbclient

run `system-config-printer` to get the ubuntu printer installer

Follow the directions [here](https://answers.uillinois.edu/illinois.engineering/page.php?id=85135)

## Manual UEFI Paritioning

Create an efi partition of around 500MB on the boot device.
Otherwise, do as you like.

## Thunderbird

* from flathub: `flatpak install flathub org.mozilla.Thunderbird`
  * install extensions from within Thunderbird

## Thunderbird and Microsoft Exchange Email

Use the ExQuilla extension

## NVVP and Kubuntu 18.04

You may see an error that looks something like
```
!SESSION 2019-11-26 16:10:14.044 -----------------------------------------------
eclipse.buildId=unknown
java.version=11.0.4
java.vendor=Ubuntu
BootLoader constants: OS=linux, ARCH=x86_64, WS=gtk, NL=en_US
Command-line arguments:  -os linux -ws gtk -arch x86_64 -data @noDefault

!ENTRY org.eclipse.cdt.core 4 0 2019-11-26 16:10:15.652
!MESSAGE FrameworkEvent ERROR
!STACK 0
org.osgi.framework.BundleException: Could not resolve module: org.eclipse.cdt.core [69]
  Unresolved requirement: Require-Capability: osgi.ee; filter:="(&(osgi.ee=JavaSE)(version=1.7))"

        at org.eclipse.osgi.container.Module.start(Module.java:434)
        at org.eclipse.osgi.container.ModuleContainer$ContainerStartLevel.incStartLevel(ModuleContainer.java:1582)
        at org.eclipse.osgi.container.ModuleContainer$ContainerStartLevel.incStartLevel(ModuleContainer.java:1561)
        at org.eclipse.osgi.container.ModuleContainer$ContainerStartLevel.doContainerStartLevel(ModuleContainer.java:1533)
        at org.eclipse.osgi.container.ModuleContainer$ContainerStartLevel.dispatchEvent(ModuleContainer.java:1476)
        at org.eclipse.osgi.container.ModuleContainer$ContainerStartLevel.dispatchEvent(ModuleContainer.java:1)
        at org.eclipse.osgi.framework.eventmgr.EventManager.dispatchEvent(EventManager.java:230)
        at org.eclipse.osgi.framework.eventmgr.EventManager$EventThread.run(EventManager.java:340)
```

When opening Nvidia Visual Profiler.
This might be because it is bit compatible with openjdk-11.
Install java 8 jre

```
sudo apt install openjdk-8-jre
```

add java 8 path to **the end** of `/usr/local/cuda/libnvvp/nvvp.ini`
```
-vm
/usr/lib/jvm/java-8-openjdk-amd64/jre/bin
```

## Nsight and Kubuntu 18.04

It may not be compatible with openjdk-11.
Install java 8 jre

```
sudo apt install openjdk-8-jre
```

Add the path to java 8 to **the top** of `/usr/local/cuda/libnsight/nsight.ini`.
```
-vm
/usr/lib/jvm/java-8-openjdk-amd64/jre/bin
```

## deja-dup and afp shares

network location: `afp://memoralpha.local/backups`

folder: `deneb`

## mounting cifs shares in /etc/fstab

`noperm` causes chmod to be silently ignored, which may be important for some autmated backup software

```
//memoryalpha.local/backups 	/mnt/memoryalpha/backups	cifs	noperm,file_mode=0777,dir_mode=0777,username=pearson,password=PASSWORD,vers=2.0	0	2
```
