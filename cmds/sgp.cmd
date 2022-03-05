require snmp,1.1.0-1.1.0.3+0
require nvent_sgp,1.0.0
require iocstats

epicsEnvSet("TOP",    "$(E3_CMD_TOP)")
epicsEnvSet("HOST",   "80.240.102.61")
epicsEnvSet("IOC",    "SGP")
epicsEnvSet("IOCST",  "$(IOC):IocStats")

#devSnmpSetParam("DebugLevel",100)

# SNMP v2
iocshLoad("$(nvent_sgp_DIR)sgp_snmpv2.iocsh")

# SNMP v3
#iocshLoad("$(nvent_sgp_DIR)sgp_snmpv3.iocsh")
#epicsEnvSet("SNMP_V3_CONFIG", "$(TOP)/snmp_v3.conf")

dbLoadRecords("iocAdminSoft.db", "IOC=$(IOCST)")

iocInit()

dbl > "$(TOP)/$(IOC)_PVs.list"
