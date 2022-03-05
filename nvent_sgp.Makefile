## The following lines are mandatory, please don't change them.
where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(E3_REQUIRE_CONFIG)/DECOUPLE_FLAGS

# If one would like to use the module dependency restrictly,
# one should look at other modules makefile to add more
# In most case, one should ignore the following lines:

## Exclude linux-ppc64e6500
##EXCLUDE_ARCHS += linux-ppc64e6500
##EXCLUDE_ARCHS += linux-corei7-poky

APP:=sgpApp
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src

TEMPLATES += $(wildcard $(APPDB)/*.db)
TEMPLATES += $(wildcard $(APPDB)/*.template)
TEMPLATES += $(wildcard $(APPDB)/*.substitutions)

DB        += sgp.db

SCRIPTS += $(wildcard $(APP)/../mibs/*-MIB.txt)
SCRIPTS += $(wildcard ../iocsh/*.iocsh)

#
USR_DBFLAGS += -I . -I ..
USR_DBFLAGS += -I $(EPICS_BASE)/db
USR_DBFLAGS += -I $(APPDB)

#
SUBS=$(wildcard $(APPDB)/*.substitutions)
TMPS=

db: $(SUBS) $(TMPS)
	echo $(CURDIR) APPDB=$(APPDB)
	echo subs=$(SUBS)

$(SUBS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db -S $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db -S $@

$(TMPS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db $@


.PHONY: db $(SUBS) $(TMPS)

vlibs:

.PHONY: vlibs

# vlibs: $(VENDOR_LIBS)

# $(VENDOR_LIBS):
# 	$(QUIET)$(SUDO) install -m 755 -d $(E3_MODULES_VENDOR_LIBS_LOCATION)/
# 	$(QUIET)$(SUDO) install -m 755 $@ $(E3_MODULES_VENDOR_LIBS_LOCATION)/

# .PHONY: $(VENDOR_LIBS) vlibs
