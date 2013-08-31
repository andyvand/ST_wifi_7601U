CHIPSET = 7601U
FI_MODE = STA
TARGET = LINUX


ifeq ($(WIFI_MODE),)
RT28xx_MODE = STA
else
RT28xx_MODE = $(WIFI_MODE)
endif

ifeq ($(TARGET),)
TARGET = LINUX
endif

ifeq ($(CHIPSET),)
CHIPSET = 7601U
endif

MODULE = $(word 1, $(CHIPSET))

#OS ABL - YES or NO
OSABL = NO#housir0O0O0O0O0O0O0O0O0O0O

ifneq ($(TARGET),THREADX)
#RT28xx_DIR = home directory of RT28xx source code
RT28xx_DIR = $(shell pwd)
endif

include $(RT28xx_DIR)/os/linux/config.mk

RTMP_SRC_DIR = $(RT28xx_DIR)/RT$(MODULE)

#PLATFORM: Target platform
PLATFORM = ST

#APSOC

#RELEASE Package
RELEASE = DPA


ifeq ($(TARGET),LINUX)
MAKE = make
endif

ifeq ($(TARGET), UCOS)
MAKE = make
endif
ifeq ($(TARGET),THREADX)
MAKE = gmake
endif

ifeq ($(TARGET), ECOS)
MAKE = make
MODULE = $(shell pwd | sed "s/.*\///" ).o
export MODULE
endif


ifeq ($(PLATFORM),PC)
# Linux 2.6
LINUX_SRC = /lib/modules/$(shell uname -r)/build
# Linux 2.4 Change to your local setting
#LINUX_SRC = /usr/src/linux-2.4
LINUX_SRC_MODULE = /lib/modules/$(shell uname -r)/kernel/drivers/net/wireless/
CROSS_COMPILE = 
endif

#>>>>>>>>>>>>>>>>>>>>>>>
ifeq ($(PLATFORM),ST)
LINUX_SRC = ./linux-2.6.20
CROSS_COMPILE = /opt/STM/STLinux-2.4/devkit/sh4/bin/sh4-linux-
LINUX_SRC_MODULE = /opt/STM/STLinux-2.4/devkit/sources/kernel/linux-2.6.32/drivers/staging/rt2870
ARCH := sh
export ARCH
endif



export OSABL RT28xx_DIR RT28xx_MODE LINUX_SRC CROSS_COMPILE CROSS_COMPILE_INCLUDE PLATFORM RELEASE CHIPSET MODULE RTMP_SRC_DIR LINUX_SRC_MODULE TARGET HAS_WOW_SUPPORT HAS_SWITCH_CHANNEL_OFFLOAD

# The targets that may be used.
PHONY += all build_tools test UCOS THREADX LINUX release prerelease clean uninstall install libwapi osabl

ifeq ($(TARGET),LINUX)
all: build_tools $(TARGET)
else
all: $(TARGET)
endif 



build_tools:
	$(MAKE) -C tools
	$(RT28xx_DIR)/tools/bin2h

test:
	$(MAKE) -C tools test

UCOS:
	$(MAKE) -C os/ucos/ MODE=$(RT28xx_MODE)
	echo $(RT28xx_MODE)

ECOS:
	$(MAKE) -C os/ecos/ MODE=$(RT28xx_MODE)
	cp -f os/ecos/$(MODULE) $(MODULE)

THREADX:
	$(MAKE) -C $(RT28xx_DIR)/os/Threadx -f $(RT28xx_DIR)/os/ThreadX/Makefile
#housir
LINUX:
ifneq (,$(findstring 2.4,$(LINUX_SRC)))

ifeq ($(OSABL),YES)
	cp -f os/linux/Makefile.4.util $(RT28xx_DIR)/os/linux/Makefile
	$(MAKE) -C $(RT28xx_DIR)/os/linux/
endif

	cp -f os/linux/Makefile.4 $(RT28xx_DIR)/os/linux/Makefile
	$(MAKE) -C $(RT28xx_DIR)/os/linux/

ifeq ($(OSABL),YES)
	cp -f os/linux/Makefile.4.netif $(RT28xx_DIR)/os/linux/Makefile
	$(MAKE) -C $(RT28xx_DIR)/os/linux/
endif

ifeq ($(RT28xx_MODE),AP)
#	cp -f $(RT28xx_DIR)/os/linux/rt$(MODULE)ap.o /tftpboot
ifeq ($(OSABL),YES)
#	cp -f $(RT28xx_DIR)/os/linux/rtutil$(MODULE)ap.o /tftpboot
#	cp -f $(RT28xx_DIR)/os/linux/rtnet$(MODULE)ap.o /tftpboot
endif
ifeq ($(PLATFORM),INF_AMAZON_SE)
#	cp -f /tftpboot/rt2870ap.o /backup/ifx/build/root_filesystem/lib/modules/2.4.31-Amazon_SE-3.6.2.2-R0416_Ralink/kernel/drivers/net
endif
else	
ifeq ($(RT28xx_MODE),APSTA)
#	cp -f $(RT28xx_DIR)/os/linux/rt$(MODULE)apsta.o /tftpboot
ifeq ($(OSABL),YES)
#	cp -f $(RT28xx_DIR)/os/linux/rtutil$(MODULE)apsta.o /tftpboot
#	cp -f $(RT28xx_DIR)/os/linux/rtnet$(MODULE)apsta.o /tftpboot
endif
else
#	cp -f $(RT28xx_DIR)/os/linux/rt$(MODULE)sta.o /tftpboot
ifeq ($(OSABL),YES)
#	cp -f $(RT28xx_DIR)/os/linux/rtutil$(MODULE)sta.o /tftpboot
#	cp -f $(RT28xx_DIR)/os/linux/rtnet$(MODULE)sta.o /tftpboot
endif#
endif#	
endif#	
else
#2.6 kernel#->
ifeq ($(OSABL),YES)
	cp -f os/linux/Makefile.6.util $(RT28xx_DIR)/os/linux/Makefile
	$(MAKE) -C $(LINUX_SRC) SUBDIRS=$(RT28xx_DIR)/os/linux modules
endif

	cp -f os/linux/Makefile.6 $(RT28xx_DIR)/os/linux/Makefile
ifeq ($(PLATFORM),DM6446)
	$(MAKE)  ARCH=arm CROSS_COMPILE=arm_v5t_le- -C  $(LINUX_SRC) SUBDIRS=$(RT28xx_DIR)/os/linux modules
else
ifeq ($(PLATFORM),FREESCALE8377)
	$(MAKE) ARCH=powerpc CROSS_COMPILE=$(CROSS_COMPILE) -C  $(LINUX_SRC) SUBDIRS=$(RT28xx_DIR)/os/linux modules
else#
	$(MAKE) -C $(LINUX_SRC) SUBDIRS=$(RT28xx_DIR)/os/linux modules 
	#->
endif
endif

ifeq ($(OSABL),YES)
	cp -f os/linux/Makefile.6.netif $(RT28xx_DIR)/os/linux/Makefile
	$(MAKE) -C $(LINUX_SRC) SUBDIRS=$(RT28xx_DIR)/os/linux modules
endif

ifeq ($(RT28xx_MODE),AP)
ifneq ($(findstring 7601,$(CHIPSET)),)
#	cp -f $(RT28xx_DIR)/os/linux/mt$(MODULE)ap.ko /tftpboot
else
#	cp -f $(RT28xx_DIR)/os/linux/rt$(MODULE)ap.ko /tftpboot
endif
ifeq ($(OSABL),YES)
#	cp -f $(RT28xx_DIR)/os/linux/rtutil$(MODULE)ap.ko /tftpboot
#	cp -f $(RT28xx_DIR)/os/linux/rtnet$(MODULE)ap.ko /tftpboot
endif
#	rm -f os/linux/rt$(MODULE)ap.ko.lzma
#	/root/bin/lzma e os/linux/rt$(MODULE)ap.ko os/linux/rt$(MODULE)ap.ko.lzma
else	
ifeq ($(RT28xx_MODE),APSTA)
#	cp -f $(RT28xx_DIR)/os/linux/rt$(MODULE)apsta.ko /tftpboot
ifeq ($(OSABL),YES)
#	cp -f $(RT28xx_DIR)/os/linux/rtutil$(MODULE)apsta.ko /tftpboot
#	cp -f $(RT28xx_DIR)/os/linux/rtnet$(MODULE)apsta.ko /tftpboot
endif
else
ifneq ($(findstring 7601,$(CHIPSET)),)  
	echo ">>>>><<<<<<<<<<<7601"
	cp -f $(RT28xx_DIR)/os/linux/mt$(MODULE)sta.ko $(LICHEE_MOD_DIR)/
else
#	cp -f $(RT28xx_DIR)/os/linux/rt$(MODULE)sta.ko /tftpboot
endif
ifeq ($(OSABL),YES)
ifneq ($(findstring 7601,$(CHIPSET)),)
#	cp -f $(RT28xx_DIR)/os/linux/mtutil$(MODULE)sta.ko /tftpboot
#	cp -f $(RT28xx_DIR)/os/linux/mtnet$(MODULE)sta.ko /tftpboot
else
#	cp -f $(RT28xx_DIR)/os/linux/rtutil$(MODULE)sta.ko /tftpboot
#	cp -f $(RT28xx_DIR)/os/linux/rtnet$(MODULE)sta.ko /tftpboot
endif
endif
endif
endif
endif
ifeq ($(PLATFORM),ALLWINNER)
	$(CROSS_COMPILE)strip --strip-debug $(RT28xx_DIR)/os/linux/mt$(MODULE)sta.ko
endif

release: build_tools
	$(MAKE) -C $(RT28xx_DIR)/striptool -f Makefile.release clean
	$(MAKE) -C $(RT28xx_DIR)/striptool -f Makefile.release
	striptool/striptool.out
ifeq ($(RELEASE), DPO)
	gcc -o striptool/banner striptool/banner.c
	./striptool/banner -b striptool/copyright.gpl -s DPO/ -d DPO_GPL -R
	./striptool/banner -b striptool/copyright.frm -s DPO_GPL/include/firmware.h
endif

prerelease:
ifeq ($(MODULE), 2880)
	$(MAKE) -C $(RT28xx_DIR)/os/linux -f Makefile.release.2880 prerelease
else
	$(MAKE) -C $(RT28xx_DIR)/os/linux -f Makefile.release prerelease
endif
	cp $(RT28xx_DIR)/os/linux/Makefile.DPB $(RTMP_SRC_DIR)/os/linux/.
	cp $(RT28xx_DIR)/os/linux/Makefile.DPA $(RTMP_SRC_DIR)/os/linux/.
	cp $(RT28xx_DIR)/os/linux/Makefile.DPC $(RTMP_SRC_DIR)/os/linux/.
ifeq ($(RT28xx_MODE),STA)
	cp $(RT28xx_DIR)/os/linux/Makefile.DPD $(RTMP_SRC_DIR)/os/linux/.
	cp $(RT28xx_DIR)/os/linux/Makefile.DPO $(RTMP_SRC_DIR)/os/linux/.
endif	

clean:
ifeq ($(TARGET), LINUX)
	cp -f os/linux/Makefile.clean os/linux/Makefile
	$(MAKE) -C os/linux clean
	rm -rf os/linux/Makefile
endif	
ifeq ($(TARGET), UCOS)
	$(MAKE) -C os/ucos clean MODE=$(RT28xx_MODE)
endif
ifeq ($(TARGET), ECOS)
	$(MAKE) -C os/ecos clean MODE=$(RT28xx_MODE)
endif

uninstall:
ifeq ($(TARGET), LINUX)
ifneq (,$(findstring 2.4,$(LINUX_SRC)))
	$(MAKE) -C $(RT28xx_DIR)/os/linux -f Makefile.4 uninstall
else
	$(MAKE) -C $(RT28xx_DIR)/os/linux -f Makefile.6 uninstall
endif
endif

install:
ifeq ($(TARGET), LINUX)
ifneq (,$(findstring 2.4,$(LINUX_SRC)))
	$(MAKE) -C $(RT28xx_DIR)/os/linux -f Makefile.4 install
else
	$(MAKE) -C $(RT28xx_DIR)/os/linux -f Makefile.6 install
endif
endif

libwapi:
ifneq (,$(findstring 2.4,$(LINUX_SRC)))
	cp -f os/linux/Makefile.libwapi.4 $(RT28xx_DIR)/os/linux/Makefile
	$(MAKE) -C $(RT28xx_DIR)/os/linux/
else
	cp -f os/linux/Makefile.libwapi.6 $(RT28xx_DIR)/os/linux/Makefile	
	$(MAKE) -C  $(LINUX_SRC) SUBDIRS=$(RT28xx_DIR)/os/linux modules	
endif	

osutil:
ifeq ($(OSABL),YES)
ifneq (,$(findstring 2.4,$(LINUX_SRC)))
	cp -f os/linux/Makefile.4.util $(RT28xx_DIR)/os/linux/Makefile
	$(MAKE) -C $(RT28xx_DIR)/os/linux/
else
	cp -f os/linux/Makefile.6.util $(RT28xx_DIR)/os/linux/Makefile
	$(MAKE) -C $(LINUX_SRC) SUBDIRS=$(RT28xx_DIR)/os/linux modules
endif
endif

osnet:
ifeq ($(OSABL),YES)
ifneq (,$(findstring 2.4,$(LINUX_SRC)))
	cp -f os/linux/Makefile.4.netif $(RT28xx_DIR)/os/linux/Makefile
	$(MAKE) -C $(RT28xx_DIR)/os/linux/
else
	cp -f os/linux/Makefile.6.netif $(RT28xx_DIR)/os/linux/Makefile
	$(MAKE) -C $(LINUX_SRC) SUBDIRS=$(RT28xx_DIR)/os/linux modules
endif
endif

osdrv:
ifneq (,$(findstring 2.4,$(LINUX_SRC)))
	cp -f os/linux/Makefile.4 $(RT28xx_DIR)/os/linux/Makefile
	$(MAKE) -C $(RT28xx_DIR)/os/linux/
else
	cp -f os/linux/Makefile.6 $(RT28xx_DIR)/os/linux/Makefile
	$(MAKE) -C $(LINUX_SRC) SUBDIRS=$(RT28xx_DIR)/os/linux modules
endif

printenv:
	@echo -e "RT28xx_MODE = " $(RT28xx_MODE)
	@echo -e "RT28xx_DIR = " $(RT28xx_DIR)
	@echo -e "TARGET = " $(TARGET)
	@echo -e "MODULE = " $(MODULE)
	@echo -e "LINUX_SRC  = /opt/STM/STLinux-2.4/devkit/sources/kernel/linux-sh4" $(LINUX_SRC )
	@echo  "CHIPSET_DAT  = " $(CHIPSET_DAT)
	@echo  "DAT_PATH = " $(DAT_PATH) 
	@echo -e "MOD_NAME = " $(MOD_NAME)
	
# Declare the contents of the .PHONY variable as phony.  We keep that information in a variable
.PHONY: $(PHONY)



