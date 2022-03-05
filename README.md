E3 module wrapper for nVent SGP devices
==

I. SUMMARY
--
This module wrapper adds device support for nVent SGP controllers.

The module has been tested against EPICS base 7.0.5
and REQUIRE 3.4.0. It is likely, that it would also work on older
EPICS stable version (3.15), but that was not validated.

II. DIRECTORY LAYOUT
--
* `cmds/`
 * `sgp.cmd` - command script for spawning an IOC
 * `snmpv3.conf` - sample SNMPv3 security configuration
* `configure/` - E3/EPICS build scripts
* `iocsh/`
 * `sgp_snmpv2.iocsh`	- IOC shell script to configure SGP SNMPv2 access
 * `sgp_snmpv3.iocsh`	- IOC shell script to configure SGP SNMPv3 access
* `nvent_sgp/`	- placeholder for nvent_sgp module
* `patch/`		- patches for nvent_sgp module
* `tools/`		- various tools and scripts
* `Makefile`	- main build script
* `README.md`	- this file
* `nvent_sgp.Makefile`	- subordinate build script for building nvent_sgp module

III. BUILDING AND INSTALLING
--

Module must be built in the deployed E3 (EPICS) environment.

Typically, E3 is installed at the following locations:
 * /epics/base-`<revision>`
 * /opt/epics/base-`<revision>`

Once the EPICS is deployed, activate its build/run environment.

`$ . /epics/base-7.0.5/require/3.4.0/bin/setE3Env.bash`

Then, make sure the module is configured for correct EPICS version and paths:

Open configure/RELEASE file for editing, and set the following variables with appropriate values:
 * EPICS_BASE - must point to the EPICS base location  
   EXAMPLE1: EPICS_BASE:=/epics/base-7.0.5
   EXAMPLE2: EPICS_BASE:=/opt/epics/base-7.0.4
 * E3_REQUIRE_VERSION - must be set to the correct REQUIRE module version  
   EXAMPLE: E3_REQUIRE_VERSION:=3.4.0

Build and install the module:

`$ make init patch build install`

Upon successful completion the module is basically ready for use.

**NOTE:** The module comes with the default database template which may not correspond to
a specific SGP controller configuration to be used with. To regenerate database templates
for a specific SGP controller, see the README.md in the `nvent_sgp` module.

IV. RUNNING IOC
--

`cmds/sgp.cmd` is the IOC shell script to spawn an IOC with SGP device support.

Before staring an IOC, open the script for editing and set appropriate values for
the following variables:
* IOC - the IOC name
* HOST - host name or IP address of SGP controoller

**WARNING:** In the case when it is required to spawn several IOCs for identical SGP
controllers, the script can be copied and altered for each SGP controller.

If the EPICS environment is not activated, activate it, and then run:

`$ iocsh.bash cmds/nvent-sgp.cmd`
