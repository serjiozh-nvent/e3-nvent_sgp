FROM centos:7.7.1908

ARG HTTP_PROXY
ARG FTP_PROXY

ENV http_proxy=$HTTP_PROXY
ENV ftp_proxy=$FTP_PROXY

LABEL maintainer "simon.rose@ess.eu"

# Add ESS repos to provide Ethercat support packages
#
# This process uses the standard yum repository configuration command, followed
# by additional repo configuration lines that are required to set up the GPG
# configuration for the repositories. Refer to
# https://gitlab.esss.lu.se/ics-ansible-galaxy/ics-ans-role-repository/-/blob/master/vars/RedHat.yml
# for repository configuration information. 
# Alternatively, refer to the following files on any ESS-configured host:
# * /etc/yum.repos.d/ESS-ICS.repo 
# * /etc/yum.repos.d/ESS-EPEL.repo
#

RUN yum-config-manager --add-repo=https://artifactory.esss.lu.se/artifactory/rpm-ics/centos/7/x86_64/

RUN echo "gpgcheck = 0" >> /etc/yum.repos.d/artifactory.esss.lu.se_artifactory_rpm-ics_centos_7_x86_64_.repo \
  && echo "gpgkey = https://artifactory.esss.lu.se/artifactory/rpm-ics/RPM-GPG-KEY-ICS" >> /etc/yum.repos.d/artifactory.esss.lu.se_artifactory_rpm-ics_centos_7_x86_64_.repo \
  && echo "repo_gpgcheck = 1" >> /etc/yum.repos.d/artifactory.esss.lu.se_artifactory_rpm-ics_centos_7_x86_64_.repo

RUN yum-config-manager --add-repo=https://artifactory.esss.lu.se/artifactory/epel-mirror/7/x86_64/

RUN echo "gpgcheck = 1" >> /etc/yum.repos.d/artifactory.esss.lu.se_artifactory_epel-mirror_7_x86_64_.repo \
  && echo "gpgkey = https://artifactory.esss.lu.se/artifactory/epel-mirror/RPM-GPG-KEY-EPEL-7" >> /etc/yum.repos.d/artifactory.esss.lu.se_artifactory_epel-mirror_7_x86_64_.repo \
  && echo "repo_gpgcheck = 0" >> /etc/yum.repos.d/artifactory.esss.lu.se_artifactory_epel-mirror_7_x86_64_.repo

RUN yum update -y \
  # Use IUS repository to install recent version of git (git2u)
  && yum -y install  https://repo.ius.io/ius-release-el7.rpm \
  && yum install -y \
    file \
    patch \
    tree \
    vim \
    m4 \
    gcc-c++ \
    git224-all \
    expectk \
    tclx \
    graphviz \
    libtirpc-devel \
    re2c \
    readline-devel \
    hdf5-devel \
    libxml2-devel \
    libjpeg-turbo-devel \
    libtiff-devel \
    blosc-devel \
    netcdf-devel \
    opencv-devel \
    wget \
    sudo \
    python-devel \
    python3-devel \
    patchelf \
    boost-devel \
    glib2-devel \
    libXt-devel \
    libXp-devel \
    libXmu-devel \
    libXpm-devel \
    libXp-devel \
    libpng12-devel \
    #lesstiff-devel \ Package does not exist, this line is to be deleted.
    libzip-devel \
    libusb-devel \
    libusbx-devel \
    libudev-devel \
    gsl-devel \
    unzip \
    libtool \
    popt-devel \
    net-snmp-devel \
    faketime \
    libraw1394 \
    bzip2-devel \
    freetype-devel \
    lcms2-devel \
    ethercat-generic-dkms-1.5.2.ESS1-1 \
  && yum clean all

# cross-compiler version
ENV E3_CROSS_COMPILER_VERSION=v0.0.25 \
    E3_CROSS_COMPILER_KERNEL=2.6-4.14 \
    E3_CROSS_COMPILER_SHORT_SHA=a905a95a

# Install ifc14xx toolchain
ENV IFC14XX_TOOLCHAIN_SCRIPT ifc14xx-glibc-x86_64-ifc14xx-toolchain-ppc64e6500-toolchain-${E3_CROSS_COMPILER_KERNEL}-${E3_CROSS_COMPILER_SHORT_SHA}.sh
RUN wget --quiet -P /tmp https://artifactory.esss.lu.se/artifactory/yocto/toolchain/${E3_CROSS_COMPILER_VERSION}/${IFC14XX_TOOLCHAIN_SCRIPT} \
  && chmod a+x /tmp/${IFC14XX_TOOLCHAIN_SCRIPT} \
  && /tmp/${IFC14XX_TOOLCHAIN_SCRIPT} -y \
  && rm -f /tmp/${IFC14XX_TOOLCHAIN_SCRIPT}

# Install cct toolchain
ENV CCT_TOOLCHAIN_SCRIPT cct-glibc-x86_64-cct-toolchain-corei7-64-toolchain-${E3_CROSS_COMPILER_KERNEL}-${E3_CROSS_COMPILER_SHORT_SHA}.sh
RUN wget --quiet -P /tmp https://artifactory.esss.lu.se/artifactory/yocto/toolchain/${E3_CROSS_COMPILER_VERSION}/${CCT_TOOLCHAIN_SCRIPT} \
  && chmod a+x /tmp/${CCT_TOOLCHAIN_SCRIPT} \
  && /tmp/${CCT_TOOLCHAIN_SCRIPT} -y \
  && rm -f /tmp/${CCT_TOOLCHAIN_SCRIPT}

# Install google git repo
RUN wget -O /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo \
  && chmod a+x /usr/local/bin/repo

# Install python packages
RUN python3 -m pip install --no-cache-dir --upgrade pip && \
    python3 -m pip install --no-cache-dir pyyaml && \
    python3 -m pip install --no-cache-dir e3 -i https://artifactory.esss.lu.se/artifactory/api/pypi/pypi-virtual/simple && \
    python3 -m pip install --no-cache-dir run-iocsh -i https://artifactory.esss.lu.se/artifactory/api/pypi/pypi-virtual/simple && \
    python3 -m pip install --no-cache-dir pytest && \
    python3 -m pip install --no-cache-dir pyepics==3.5.0 && \
    python3 -m pip install --no-cache-dir opcua && \
    python3 -m pip install --no-cache-dir pymodbus


# Add user that will be used by gitlab-ci to compile
# This user shall have the proper uid to have write access on E3 NFS share
# It shall match the uid and gid of the user defined in LDAP
ENV USERNAME gitlab-ci
RUN groupadd -r -g 100000 ${USERNAME} \
  && useradd --no-log-init -r -m -g ${USERNAME} -u 10043 ${USERNAME}

# Create /epics directory in the image so that we can test
# without mounting an external dir
RUN mkdir /epics && chown ${USERNAME}:${USERNAME} /epics

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Setup git
# Set color.ui to avoid google git repo to prompt for it
RUN git config --global user.name ${USERNAME} \
  && git config --global user.email ${USERNAME}@localhost.localdomain \
  && git config --global color.ui auto

# build core E3 modules
RUN git clone https://gitlab.esss.lu.se/e3/specifications.git
RUN e3-build -y specifications/specifications/2022q1-core.yml

# build SNMP
RUN echo -e 'config:\n\
  base_version: 7.0.6.1-NA/7.0.6.1-ff3e2c9-20220209T143845\n\
  require_version: 7.0.6.1-4.0.0/4.0.0-9184d78-20220215T133808\n\
meta:\n\
  datestamp: 20220414T133931\n\
modules:\n\
  snmp:\n\
    versions:\n\
    - 7.0.6.1-4.0.0/1.1.0-1.1.0.3+0-0fcbc3a-20220302T104537' > /tmp/myspec && e3-build -y /tmp/myspec && rm /tmp/myspec

COPY --chown=1000:1000 sample-cmds.txt /home/${USERNAME}

RUN echo . /epics/base-7.0.6.1/require/4.0.0/bin/setE3Env.bash >> .bashrc
RUN echo "cat ~/sample-cmds.txt" >> .bashrc

ARG CACHEBUST=1

# clone e3-nvent_sgp module
RUN git clone https://github.com/serjiozh-nvent/e3-nvent_sgp.git

# change base and require versions
RUN cd e3-nvent_sgp && make init patch build install

WORKDIR e3-nvent_sgp
#CMD ["/bin/bash", "-lc", "iocsh e3-nvent_sgp/cmds/sgp.cmd"]
