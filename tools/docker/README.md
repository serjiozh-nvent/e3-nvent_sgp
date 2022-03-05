I. DOCKER DIRECTORY
-------------------

The docker directory contains Dockerfile and utility scripts
to build and run IOC with the e3-nvent_sgp module wrapper inside a container.

The container allows creating a consistent environment despite diversity
of host environments and hardware which is particularly convenient for
debugging and testing purposed.

The dockerfile and related scripts are provided for testing purposes 
only and bare no other meaining. They are auxiliary for the E3 wrapper,
and may be freely discarded. Though they may be helpful for quick and
seemless IOC deployment in order to try out EPICS support for nVent
SGP devices.

II. BUILDING CONTAINER
----------------------

An installed docker daemon is required to build a container.

$ sudo dnf install docker # Centos
$ sudo yum install docker # Fedora
$ sudo apt install docker # Debian/Mint/Ubuntu

The Dockerfile contains all the necessary commands to install all
EPICS prerequisit packagess, build and install EPICS 7.0.5, and
build and install the e3-nvent_sgp module wrapper itself.

Build steps:

1. If the network environment require a HTTP/FTP proxy for downloading
 files over the internet, make sure these are specified:
 $ export http_proxy=<HTTP_PROXY_IP:port>
 $ export ftp_proxy=<FTP_PROXY_IP:port>

2. Execute building script: 
 $ cd <e3-nvent_sgp>/docker
 $ ./build-container.sh

NOTE: The alternative way to specify the proxies is
  $ http_proxy=<...> ftp_proxy=<...> ./build-container.sh

On successful completion, an image tagged 'epics', and a container named
'epics-ioc' are created.

III. SUPPORTING SCRIPTS
-----------------------

Upon creation of the image and container, it is possible to either RUN an IOC
with support for nVent SGP environment in the container, or spawn additional
containers for querying information or working with the exposed EPICS database
from other containers using the environment provided by the Docker image.

The Docker directory contains two scripts for these purposes:

1. docker/run-ioc.sh
  This script interactively starts the epics-ioc container. Docker allows
  Docker allows only one instance of the container to run at a time.
  Using the same container allows maintaining modified information
  throughout susequent container runs. Such modification might include
  changes into IOC database configuration and other.
  Additionally, the container maintains binding to the host filesystem
  through $HOME directory, which allow maintaining non-volatile data
  in it.

  The IOC is not automatically started. In order to spawn an IOC,
  run the following command:
  $ iocsh.bash cmds/nvent_sgp.cmd

2. docker/run-epics.sh
  This script interactively spawns a new container from the 'epics'
  image, providing the consistent environment for every instance.
  It is possible to spaw several containers with the script.
  Each instance will maintain binding with the host filesystem
  through the $HOME directory. Otherwise, the containers have
  non-shared filesystems. Any modifications to the files made
  during an instance run other than in $HOME will be discarded
  on instance exit.

  Though, this was not original intent, containers spaw by
  this script are also capable of spawning an IOC. If you intent to use
  it for this purpose, make sure your changes (IOC) are located in the
  $HOME directory.

IV. Changing target SGP and database template
---------------------------------------------

The target SGP controller can be changed by modifying the cmds/nvent_sgp.cmd script.
The modifying must be done in the context of the epics-ioc container (i.e. use run-ioc.sh).
Otherwise, the made changes would be forgottent upon exit from the container.

The same regards to database template changes. Use run-ioc.sh to start epics-ioc container
in order to make database changes. For specific commands on how to change database templates
and apply the changes, see README.md.
