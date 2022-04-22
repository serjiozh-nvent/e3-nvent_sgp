FROM centos

ARG HTTP_PROXY
ARG FTP_PROXY

ENV http_proxy=$HTTP_PROXY
ENV ftp_proxy=$FTP_PROXY

RUN cd /etc/yum.repos.d && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
        sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && \
        yum update -y

# instal EN_US.UTF8 locale
RUN dnf install -y glibc-langpack-en

# set up en_US.UTF8 locale
ENV LANG en_US.utf8

# install bash and other tools
RUN dnf install -y sudo bash nano mc

# enable epel-release distro feed
RUN dnf install -y epel-release

# install dev tools
RUN dnf install -y make git autoconf automake libtool

# install pre-requisites (base)
RUN dnf install -y gcc gcc-c++ gcc-toolset-9-make readline-devel perl-ExtUtils-Install

# enable powertools repo
RUN dnf install -y dnf-plugins-core
RUN dnf config-manager --enable powertools

# install pre-requisites (sequencer)
RUN dnf install -y re2c

# install pre-requisites (asyn)
RUN dnf install -y rpcgen libtirpc-devel

# install pre-requisites (mca)
RUN dnf install -y libnet-devel libpcap-devel libusb-devel

# install pre-requisites (medm)
#RUN dnf install -y libXt-devel motif-devel

# install pre-requisites for e3
RUN dnf install -y which python3 python3-pyyaml tree patch tcl-devel net-snmp-devel net-snmp-utils patchelf

# install user 'epics'
ENV USER_ID 1000
ENV USER epics
# add to sudoers
RUN groupadd -g ${USER_ID} ${USER} && \
        useradd -u ${USER_ID} -g ${USER_ID} -ms /bin/bash ${USER} && \
        usermod -aG wheel ${USER} && usermod -aG users ${USER}
# set password '123qwe'
RUN usermod -p cjXYR8rPAijWs ${USER}

# create EPICS base directory
RUN mkdir /epics && chown epics:epics /epics

WORKDIR /home/${USER}

# clone tclx package
RUN git clone https://github.com/flightaware/tclx.git
RUN cd tclx && ./configure --prefix=/usr --libdir=/usr/lib64/tcl8.6 && make install
RUN rm -rf tclx

USER ${USER}

# clone ESS EPICS Environment
RUN git clone https://gitlab.esss.lu.se/e3/e3.git && cd e3 && git checkout f763f102fa8d900ef662c682ad11a881d6ffb15c
RUN cd e3 && ./e3_building_config.bash -y -t /epics -b 7.0.5 -r 3.4.0 setup

# build base and require
RUN cd e3 && ./e3.bash base && ./e3.bash req && ./e3.bash -c mod

COPY --chown=1000:1000 sample-cmds.txt /home/$USER

# build snmp community module
RUN git clone https://gitlab.esss.lu.se/e3/wrappers/communication/e3-snmp.git
RUN sed -i -e 's/EPICS_BASE=\/epics\/base-7.0.6.1/EPICS_BASE=\/epics\/base-7.0.5/' \
        -e 's/E3_REQUIRE_VERSION:=4.0.0/E3_REQUIRE_VERSION:=3.4.0/' e3-snmp/configure/RELEASE
RUN cd e3-snmp && make init patch build install

# clone e3-nvent_sgp module
RUN git clone https://github.com/serjiozh-nvent/e3-nvent_sgp.git

# change base and require versions
RUN cd e3-nvent_sgp && make init patch build install

RUN echo . /epics/base-7.0.5/require/3.4.0/bin/setE3Env.bash >> .bashrc
RUN echo "cat ~/sample-cmds.txt" >> .bashrc

WORKDIR e3-nvent_sgp
#CMD ["/bin/bash", "-lc", "iocsh.bash e3-nvent_sgp/cmds/sgp.cmd"]
