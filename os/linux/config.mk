# Support ATE function
HAS_ATE=y

# Support QA ATE function
HAS_QA_SUPPORT=y

HAS_RSSI_FEEDBACK=n

# Support XLINK mode
HAS_XLINK=n

# Support WSC function
HAS_WSC=n
HAS_WSC_V2=n
HAS_WSC_LED=n
HAS_IWSC_SUPPORT=n


# Support LLTD function
HAS_LLTD=n


# Support AP-Client function
HAS_APCLI=n

# Support Wpa_Supplicant
# i.e. wpa_supplicant -Dralink
HAS_WPA_SUPPLICANT=y


# Support Native WpaSupplicant for Network Maganger
# i.e. wpa_supplicant -Dwext
HAS_NATIVE_WPA_SUPPLICANT_SUPPORT=y

#Support Net interface block while Tx-Sw queue full
HAS_BLOCK_NET_IF=n

#Support IGMP-Snooping function.
HAS_IGMP_SNOOP_SUPPORT=n

#Support DFS function
HAS_DFS_SUPPORT=n

#Support Carrier-Sense function
HAS_CS_SUPPORT=n


# Support user specific transmit rate of Multicast packet.
HAS_MCAST_RATE_SPECIFIC_SUPPORT=n

# Support for Multiple Cards
HAS_MC_SUPPORT=n

#Support for PCI-MSI
HAS_MSI_SUPPORT=n


#Support for IEEE802.11e DLS
HAS_QOS_DLS_SUPPORT=n

#Support for EXT_CHANNEL
HAS_EXT_BUILD_CHANNEL_LIST=n

#Support for IDS 
HAS_IDS_SUPPORT=n


#Support for Net-SNMP
HAS_SNMP_SUPPORT=n

#Support features of 802.11n Draft3
HAS_DOT11N_DRAFT3_SUPPORT=n

#Support features of Single SKU. 
HAS_SINGLE_SKU_SUPPORT=n

#Support features of Single SKU. 
HAS_SINGLE_SKU_V2_SUPPORT=n

#Support features of 802.11n
HAS_DOT11_N_SUPPORT=y

#Support for 802.11ac VHT
HAS_DOT11_VHT_SUPPORT=n

#Support for WAPI
HAS_WAPI_SUPPORT=n


#Support for 2860/2880 co-exist 
HAS_RT2880_RT2860_COEXIST=n

HAS_KTHREAD_SUPPORT=n



#Support for dot11z TDLS
HAS_DOT11Z_TDLS_SUPPORT=n

#Support for WiFi-Driect(Peer to Peer)
HAS_P2P_SUPPORT=n
HAS_P2P_ODD_MAC_ADJUST=n
HAS_P2P_SPECIFIC_WIRELESS_EVENT=n

#Support for Auto channel select enhance
HAS_AUTO_CH_SELECT_ENHANCE=n

#Support statistics count
HAS_STATS_COUNT=y

#Support TSSI Antenna Variation
HAS_TSSI_ANTENNA_VARIATION=n

#Support USB_BULK_BUF_ALIGMENT
HAS_USB_BULK_BUF_ALIGMENT=n

#Support for USB_SUPPORT_SELECTIVE_SUSPEND
HAS_USB_SUPPORT_SELECTIVE_SUSPEND=n

#Support USB load firmware by multibyte
HAS_USB_FIRMWARE_MULTIBYTE_WRITE=n

#Support PBF_MONITOR_SUPPORT
HAS_PBF_MONITOR_SUPPORT=y


#Support ANDROID_SUPPORT
HAS_ANDROID_SUPPORT=n

#HAS_IFUP_IN_PROBE_SUPPORT
HAS_IFUP_IN_PROBE_SUPPORT=n




#Support TXRX SW Antenna Diversity
HAS_TXRX_SW_ANTDIV_SUPPORT=n

#Client support WDS function
HAS_CLIENT_WDS_SUPPORT=n

#Support for Bridge Fast Path & Bridge Fast Path function open to other module
HAS_BGFP_SUPPORT=n
HAS_BGFP_OPEN_SUPPORT=n

# Support HOSTAPD function
HAS_HOSTAPD_SUPPORT=n

#Support GreenAP function
HAS_GREENAP_SUPPORT=n

#Support MAC80211 LINUX-only function
#Please make sure the version for CFG80211.ko and MAC80211.ko is same as the one
#our driver references to.
HAS_CFG80211_SUPPORT=y

#Support RFKILL hardware block/unblock LINUX-only function
HAS_RFKILL_HW_SUPPORT=n



HAS_APCLI_WPA_SUPPLICANT=n

HAS_RTMP_FLASH_SUPPORT=n

ifeq ($(OSABL),YES)
HAS_OSABL_FUNC_SUPPORT=y
HAS_OSABL_OS_PCI_SUPPORT=y
HAS_OSABL_OS_USB_SUPPORT=y
HAS_OSABL_OS_RBUS_SUPPORT=n
HAS_OSABL_OS_AP_SUPPORT=y
HAS_OSABL_OS_STA_SUPPORT=y
endif

HAS_LED_CONTROL_SUPPORT=y


#Support WIDI feature
#Must enable HAS_WSC at the same time.

HAS_TXBF_SUPPORT=n

HAS_STREAM_MODE_SUPPORT=n

HAS_NEW_RATE_ADAPT_SUPPORT=n

HAS_RATE_ADAPT_AGS_SUPPORT=n




#MT7601
HAS_RX_CSO_SUPPORT=y


HAS_WOW_SUPPORT=n
HAS_WOW_IFDOWN_SUPPORT=n

HAS_ANDES_FIRMWARE_SUPPORT=n

HAS_HDR_TRANS_SUPPORT=n

HAS_MULTI_CHANNEL=n

#################################################

CC := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)ld

WFLAGS := -DAGGREGATION_SUPPORT -DPIGGYBACK_SUPPORT -DWMM_SUPPORT  -DLINUX -Wall -Wstrict-prototypes -Wno-trigraphs
WFLAGS += -DSYSTEM_LOG_SUPPORT -DRT28xx_MODE=$(RT28xx_MODE) -DCHIPSET=$(MODULE) -DRESOURCE_PRE_ALLOC
#WFLAGS += -DFPGA_MODE
WFLAGS += -I$(RT28xx_DIR)/include






ifeq ($(HAS_KTHREAD_SUPPORT),y)
WFLAGS += -DKTHREAD_SUPPORT
endif

ifeq ($(HAS_RTMP_FLASH_SUPPORT),y)
WFLAGS += -DRTMP_FLASH_SUPPORT
endif

ifeq ($(HAS_STREAM_MODE_SUPPORT),y)
WFLAGS += -DSTREAM_MODE_SUPPORT
endif

ifeq ($(HAS_SINGLE_SKU_SUPPORT),y)
WFLAGS += -DSINGLE_SKU
endif

ifeq ($(HAS_SINGLE_SKU_V2_SUPPORT),y)
WFLAGS += -DSINGLE_SKU_V2
endif

ifeq ($(HAS_DOT11_VHT_SUPPORT),y)
WFLAGS += -DDOT11_VHT_AC
endif

ifeq ($(HAS_ANDES_FIRMWARE_SUPPORT),y)
WFLAGS += -DANDES_FIRMWARE_SUPPORT
endif

ifeq ($(HAS_HDR_TRANS_SUPPORT),y)
WFLAGS += -DHDR_TRANS_SUPPORT
endif

# config for AP mode

ifeq ($(RT28xx_MODE),AP)
WFLAGS += -DCONFIG_AP_SUPPORT  -DUAPSD_SUPPORT -DMBSS_SUPPORT -DIAPP_SUPPORT -DDBG -DDOT1X_SUPPORT -DAP_SCAN_SUPPORT -DSCAN_SUPPORT

ifeq ($(HAS_APCLI_WPA_SUPPLICANT),y)
WFLAGS += -DApCli_WPA_SUPPLICANT_SUPPORT
endif

ifeq ($(HAS_HOSTAPD_SUPPORT),y)
WFLAGS += -DHOSTAPD_SUPPORT
endif

ifeq ($(HAS_ATE),y)
WFLAGS += -DRALINK_ATE
WFLAGS += -DCONFIG_RT2880_ATE_CMD_NEW
WFLAGS += -I$(RT28xx_DIR)/ate/include
ifeq ($(HAS_QA_SUPPORT),y)
WFLAGS += -DRALINK_QA
endif
endif

ifeq ($(HAS_RSSI_FEEDBACK),y)
WFLAGS += -DRSSI_FEEDBACK
endif




ifeq ($(HAS_WSC),y)
WFLAGS += -DWSC_AP_SUPPORT

ifeq ($(HAS_WSC_V2),y)
WFLAGS += -DWSC_V2_SUPPORT
endif
ifeq ($(HAS_WSC_LED),y)
WFLAGS += -DWSC_LED_SUPPORT
endif
endif



ifeq ($(HAS_APCLI),y)
WFLAGS += -DAPCLI_SUPPORT -DMAT_SUPPORT -DAP_SCAN_SUPPORT -DSCAN_SUPPORT
#ifeq ($(HAS_ETH_CONVERT_SUPPORT), y)
#WFLAGS += -DETH_CONVERT_SUPPORT
endif

ifeq ($(HAS_IGMP_SNOOP_SUPPORT),y)
WFLAGS += -DIGMP_SNOOP_SUPPORT
endif

ifeq ($(HAS_CS_SUPPORT),y)
WFLAGS += -DCARRIER_DETECTION_SUPPORT
endif

ifeq ($(HAS_MCAST_RATE_SPECIFIC_SUPPORT), y)
WFLAGS += -DMCAST_RATE_SPECIFIC
endif



ifeq ($(HAS_QOS_DLS_SUPPORT),y)
WFLAGS += -DQOS_DLS_SUPPORT
endif

ifeq ($(HAS_SNMP_SUPPORT),y)
WFLAGS += -DSNMP_SUPPORT
endif

ifeq ($(HAS_DOT11_N_SUPPORT),y)
WFLAGS += -DDOT11_N_SUPPORT

ifeq ($(HAS_DOT11N_DRAFT3_SUPPORT),y)
WFLAGS += -DDOT11N_DRAFT3
endif

ifeq ($(HAS_TXBF_SUPPORT),y)
WFLAGS += -DTXBF_SUPPORT
endif

ifeq ($(HAS_NEW_RATE_ADAPT_SUPPORT),y)
WFLAGS += -DNEW_RATE_ADAPT_SUPPORT
endif

ifeq ($(HAS_RATE_ADAPT_AGS_SUPPORT),y)
WFLAGS += -DAGS_SUPPORT
endif

ifeq ($(HAS_GREENAP_SUPPORT),y)
WFLAGS += -DGREENAP_SUPPORT
endif

endif

ifeq ($(HAS_AUTO_CH_SELECT_ENHANCE),y)
WFLAGS += -DAUTO_CH_SELECT_ENHANCE
endif

ifeq ($(HAS_STATS_COUNT),y)
WFLAGS += -DSTATS_COUNT_SUPPORT
endif

ifeq ($(HAS_TSSI_ANTENNA_VARIATION),y)
WFLAGS += -DTSSI_ANTENNA_VARIATION
endif



ifeq ($(HAS_CFG80211_SUPPORT),y)
WFLAGS += -DRT_CFG80211_SUPPORT -DEXT_BUILD_CHANNEL_LIST
ifeq ($(HAS_RFKILL_HW_SUPPORT),y)
WFLAGS += -DRFKILL_HW_SUPPORT
endif
endif

ifeq ($(OSABL),YES)
WFLAGS += -DOS_ABL_SUPPORT
ifeq ($(HAS_OSABL_FUNC_SUPPORT),y)
WFLAGS += -DOS_ABL_FUNC_SUPPORT
endif
ifeq ($(HAS_OSABL_OS_PCI_SUPPORT),y)
WFLAGS += -DOS_ABL_OS_PCI_SUPPORT
endif
ifeq ($(HAS_OSABL_OS_USB_SUPPORT),y)
WFLAGS += -DOS_ABL_OS_USB_SUPPORT
endif
ifeq ($(HAS_OSABL_OS_RBUS_SUPPORT),y)
WFLAGS += -DOS_ABL_OS_RBUS_SUPPORT
endif
ifeq ($(HAS_OSABL_OS_AP_SUPPORT),y)
WFLAGS += -DOS_ABL_OS_AP_SUPPORT
endif
ifeq ($(HAS_OSABL_OS_STA_SUPPORT),y)
WFLAGS += -DOS_ABL_OS_STA_SUPPORT
endif
endif


ifeq ($(HAS_TXRX_SW_ANTDIV_SUPPORT),y)
WFLAGS += -DTXRX_SW_ANTDIV_SUPPORT
endif


endif #// endif of RT2860_MODE == AP //

#################################################

# config for STA mode

ifeq ($(RT28xx_MODE),STA)
WFLAGS += -DCONFIG_STA_SUPPORT -DSCAN_SUPPORT \
-DDBG

ifeq ($(HAS_XLINK),y)
WFLAGS += -DXLINK_SUPPORT
endif

WFLAGS += -DADHOC_WPA2PSK_SUPPORT

ifeq ($(HAS_WPA_SUPPLICANT),y)
WFLAGS += -DWPA_SUPPLICANT_SUPPORT
ifeq ($(HAS_NATIVE_WPA_SUPPLICANT_SUPPORT),y)
WFLAGS += -DNATIVE_WPA_SUPPLICANT_SUPPORT
endif
endif

ifeq ($(HAS_WSC),y)
WFLAGS += -DWSC_STA_SUPPORT
ifeq ($(HAS_WSC_V2),y)
WFLAGS += -DWSC_V2_SUPPORT
endif
ifeq ($(HAS_WSC_LED),y)
WFLAGS += -DWSC_LED_SUPPORT
endif
ifeq ($(HAS_IWSC_SUPPORT),y)
WFLAGS += -DIWSC_SUPPORT
endif
endif



ifeq ($(HAS_ATE),y)
WFLAGS += -DRALINK_ATE
WFLAGS += -DCONFIG_RT2880_ATE_CMD_NEW
WFLAGS += -I$(RT28xx_DIR)/ate/include
ifeq ($(HAS_QA_SUPPORT),y)
WFLAGS += -DRALINK_QA
endif
endif


ifeq ($(HAS_SNMP_SUPPORT),y)
WFLAGS += -DSNMP_SUPPORT
endif

ifeq ($(HAS_USB_BULK_BUF_ALIGMENT),y)
WFLAGS += -DUSB_BULK_BUF_ALIGMENT -DALIGMENT_BULKAGGRE_SIZE=14 -DBUF_ALIGMENT_RINGSIZE=3
endif

ifeq ($(HAS_QOS_DLS_SUPPORT),y)
WFLAGS += -DQOS_DLS_SUPPORT
endif

ifeq ($(HAS_DOT11_N_SUPPORT),y)
WFLAGS += -DDOT11_N_SUPPORT

ifeq ($(HAS_DOT11N_DRAFT3_SUPPORT),y)
WFLAGS += -DDOT11N_DRAFT3
endif

ifeq ($(HAS_TXBF_SUPPORT),y)
WFLAGS += -DTXBF_SUPPORT
endif

ifeq ($(HAS_NEW_RATE_ADAPT_SUPPORT),y)
WFLAGS += -DNEW_RATE_ADAPT_SUPPORT
endif

endif

ifeq ($(HAS_DOT11Z_TDLS_SUPPORT),y)
WFLAGS += -DDOT11Z_TDLS_SUPPORT -DUAPSD_SUPPORT
endif

ifeq ($(HAS_P2P_SUPPORT),y)
WFLAGS += -DP2P_SUPPORT -DAPCLI_SUPPORT -DMAT_SUPPORT -DAP_SCAN_SUPPORT -DSCAN_SUPPORT -DP2P_APCLI_SUPPORT -DCONFIG_AP_SUPPORT -DCONFIG_APSTA_MIXED_SUPPORT -DUAPSD_SUPPORT -DMBSS_SUPPORT -DIAPP_SUPPORT -DDOT1X_SUPPORT -DWSC_AP_SUPPORT -DWSC_STA_SUPPORT
endif

ifeq ($(HAS_P2P_ODD_MAC_ADJUST),y)
WFLAGS += -DP2P_ODD_MAC_ADJUST
endif

ifeq ($(HAS_P2P_SPECIFIC_WIRELESS_EVENT),y)
WFLAGS += -DRT_P2P_SPECIFIC_WIRELESS_EVENT
endif

ifeq ($(HAS_CS_SUPPORT),y)
WFLAGS += -DCARRIER_DETECTION_SUPPORT
endif

ifeq ($(HAS_STATS_COUNT),y)
WFLAGS += -DSTATS_COUNT_SUPPORT
endif

ifeq ($(HAS_TSSI_ANTENNA_VARIATION),y)
WFLAGS += -DTSSI_ANTENNA_VARIATION
endif

ifeq ($(HAS_PBF_MONITOR_SUPPORT),y)
WFLAGS += -DPBF_MONITOR_SUPPORT
endif

ifeq ($(HAS_ANDROID_SUPPORT),y)
WFLAGS += -DANDROID_SUPPORT
endif


ifeq ($(HAS_IFUP_IN_PROBE_SUPPORT),y)
WFLAGS += -DIFUP_IN_PROBE
endif

ifeq ($(HAS_USB_SUPPORT_SELECTIVE_SUSPEND),y)
WFLAGS += -DUSB_SUPPORT_SELECTIVE_SUSPEND
endif

ifeq ($(HAS_USB_FIRMWARE_MULTIBYTE_WRITE),y)
WFLAGS += -DUSB_FIRMWARE_MULTIBYTE_WRITE -DMULTIWRITE_BYTES=4
endif

ifeq ($(HAS_CFG80211_SUPPORT),y)
WFLAGS += -DRT_CFG80211_SUPPORT -DEXT_BUILD_CHANNEL_LIST
ifeq ($(HAS_RFKILL_HW_SUPPORT),y)
WFLAGS += -DRFKILL_HW_SUPPORT
endif
endif

ifeq ($(OSABL),YES)
WFLAGS += -DOS_ABL_SUPPORT
ifeq ($(HAS_OSABL_FUNC_SUPPORT),y)
WFLAGS += -DOS_ABL_FUNC_SUPPORT
endif
ifeq ($(HAS_OSABL_OS_PCI_SUPPORT),y)
WFLAGS += -DOS_ABL_OS_PCI_SUPPORT
endif
ifeq ($(HAS_OSABL_OS_USB_SUPPORT),y)
WFLAGS += -DOS_ABL_OS_USB_SUPPORT
endif
ifeq ($(HAS_OSABL_OS_RBUS_SUPPORT),y)
WFLAGS += -DOS_ABL_OS_RBUS_SUPPORT
endif
ifeq ($(HAS_OSABL_OS_AP_SUPPORT),y)
WFLAGS += -DOS_ABL_OS_AP_SUPPORT
endif
ifeq ($(HAS_OSABL_OS_STA_SUPPORT),y)
WFLAGS += -DOS_ABL_OS_STA_SUPPORT
endif
endif


ifeq ($(HAS_TXRX_SW_ANTDIV_SUPPORT),y)
WFLAGS += -DTXRX_SW_ANTDIV_SUPPORT
endif


ifeq ($(HAS_WIDI_SUPPORT),y)
WFLAGS += -DWIDI_SUPPORT

ifeq ($(HAS_P2P_SUPPORT),y)
ifeq ($(HAS_INTEL_WFD_SUPPORT),y)
WFLAGS += -DINTEL_WFD_SUPPORT
endif

ifeq ($(HAS_WFA_WFD_SUPPORT),y)
WFLAGS += -DWFA_WFD_SUPPORT
endif
endif

endif

ifeq ($(HAS_WOW_SUPPORT),y)
WFLAGS += -DWOW_SUPPORT
endif

ifeq ($(HAS_WOW_IFDOWN_SUPPORT),y)
WFLAGS += -DWOW_IFDOWN_SUPPORT
endif

endif
# endif of ifeq ($(RT28xx_MODE),STA)

#################################################

# config for APSTA

ifeq ($(RT28xx_MODE),APSTA)
WFLAGS += -DCONFIG_AP_SUPPORT -DCONFIG_STA_SUPPORT -DCONFIG_APSTA_MIXED_SUPPORT -DUAPSD_SUPPORT -DMBSS_SUPPORT -DIAPP_SUPPORT -DDOT1X_SUPPORT -DAP_SCAN_SUPPORT -DSCAN_SUPPORT -DDBG


ifeq ($(HAS_WSC),y)
WFLAGS += -DWSC_AP_SUPPORT -DWSC_STA_SUPPORT
endif


ifeq ($(HAS_APCLI),y)
WFLAGS += -DAPCLI_SUPPORT -DMAT_SUPPORT
endif

ifeq ($(HAS_IGMP_SNOOP_SUPPORT),y)
WFLAGS += -DIGMP_SNOOP_SUPPORT
endif

ifeq ($(HAS_CS_SUPPORT),y)
WFLAGS += -DCARRIER_DETECTION_SUPPORT
endif

ifeq ($(HAS_MCAST_RATE_SPECIFIC_SUPPORT), y)
WFLAGS += -DMCAST_RATE_SPECIFIC
endif

ifeq ($(HAS_QOS_DLS_SUPPORT),y)
WFLAGS += -DQOS_DLS_SUPPORT
endif

ifeq ($(HAS_WPA_SUPPLICANT),y)
WFLAGS += -DWPA_SUPPLICANT_SUPPORT
ifeq ($(HAS_NATIVE_WPA_SUPPLICANT_SUPPORT),y)
WFLAGS += -DNATIVE_WPA_SUPPLICANT_SUPPORT
endif
endif


ifeq ($(HAS_ATE),y)
WFLAGS += -DRALINK_ATE
WFLAGS += -DCONFIG_RT2880_ATE_CMD_NEW
WFLAGS += -I$(RT28xx_DIR)/ate/include
ifeq ($(HAS_QA_SUPPORT),y)
WFLAGS += -DRALINK_QA
endif
endif

ifeq ($(HAS_DOT11_N_SUPPORT),y)
WFLAGS += -DDOT11_N_SUPPORT
endif

ifeq ($(HAS_TXBF_SUPPORT),y)
WFLAGS += -DTXBF_SUPPORT
endif

ifeq ($(HAS_NEW_RATE_ADAPT_SUPPORT),y)
WFLAGS += -DNEW_RATE_ADAPT_SUPPORT
endif


ifeq ($(HAS_CS_SUPPORT),y)
WFLAGS += -DCARRIER_DETECTION_SUPPORT
endif

ifeq ($(HAS_STATS_COUNT),y)
WFLAGS += -DSTATS_COUNT_SUPPORT
endif

ifeq ($(HAS_TSSI_ANTENNA_VARIATION),y)
WFLAGS += -DTSSI_ANTENNA_VARIATION
endif

ifeq ($(HAS_CFG80211_SUPPORT),y)
WFLAGS += -DRT_CFG80211_SUPPORT
ifeq ($(HAS_RFKILL_HW_SUPPORT),y)
WFLAGS += -DRFKILL_HW_SUPPORT
endif
endif

ifeq ($(OSABL),YES)
WFLAGS += -DOS_ABL_SUPPORT
ifeq ($(HAS_OSABL_FUNC_SUPPORT),y)
WFLAGS += -DOS_ABL_FUNC_SUPPORT
endif
ifeq ($(HAS_OSABL_OS_PCI_SUPPORT),y)
WFLAGS += -DOS_ABL_OS_PCI_SUPPORT
endif
ifeq ($(HAS_OSABL_OS_USB_SUPPORT),y)
WFLAGS += -DOS_ABL_OS_USB_SUPPORT
endif
ifeq ($(HAS_OSABL_OS_RBUS_SUPPORT),y)
WFLAGS += -DOS_ABL_OS_RBUS_SUPPORT
endif
ifeq ($(HAS_OSABL_OS_AP_SUPPORT),y)
WFLAGS += -DOS_ABL_OS_AP_SUPPORT
endif
ifeq ($(HAS_OSABL_OS_STA_SUPPORT),y)
WFLAGS += -DOS_ABL_OS_STA_SUPPORT
endif
endif

ifeq ($(HAS_P2P_SUPPORT),y)
WFLAGS += -DP2P_SUPPORT
WFLAGS += -DAPCLI_SUPPORT -DMAT_SUPPORT -DAP_SCAN_SUPPORT -DSCAN_SUPPORT -DP2P_APCLI_SUPPORT
endif

endif
# endif of ifeq ($(RT28xx_MODE),APSTA)
#################################################

#
# Common compiler flag
#






ifeq ($(HAS_EXT_BUILD_CHANNEL_LIST),y)
WFLAGS += -DEXT_BUILD_CHANNEL_LIST
endif

ifeq ($(HAS_IDS_SUPPORT),y)
WFLAGS += -DIDS_SUPPORT
endif

ifeq ($(HAS_WAPI_SUPPORT),y)
WFLAGS += -DWAPI_SUPPORT -DSOFT_ENCRYPT -DEXPORT_SYMTAB
endif

ifeq ($(OSABL),YES)
WFLAGS += -DEXPORT_SYMTAB
endif

ifeq ($(HAS_CLIENT_WDS_SUPPORT),y)
WFLAGS += -DCLIENT_WDS
endif

ifeq ($(HAS_BGFP_SUPPORT),y)
WFLAGS += -DBG_FT_SUPPORT
endif

ifeq ($(HAS_BGFP_OPEN_SUPPORT),y)
WFLAGS += -DBG_FT_OPEN_SUPPORT
endif


ifeq ($(HAS_LED_CONTROL_SUPPORT),y)
WFLAGS += -DLED_CONTROL_SUPPORT
endif

ifeq ($(HAS_MULTI_CHANNEL),y)
WFLAGS += -DCONFIG_MULTI_CHANNEL
endif

#################################################
# ChipSet specific definitions.
#






ifneq ($(findstring 7601E,$(CHIPSET)),)
WFLAGS += -DMT7601E -DMT7601 -DRLT_MAC -DRLT_RF -DRTMP_MAC_PCI -DRTMP_PCI_SUPPORT -DRX_DMA_SCATTER -DVCORECAL_SUPPORT -DVCORECAL_SUPPORT -DRTMP_EFUSE_SUPPORT -DNEW_MBSSID_MODE -DRTMP_INTERNAL_TX_ALC -DCONFIG_ANDES_SUPPORT
#-DRTMP_FREQ_CALIBRATION_SUPPORT
ifneq ($(findstring $(RT28xx_MODE),AP),)
#WFLAGS += -DSPECIFIC_BCN_BUF_SUPPORT
endif

ifneq ($(findstring $(RT28xx_MODE),STA APSTA),)
WFLAGS += -DRTMP_FREQ_CALIBRATION_SUPPORT
endif

CHIPSET_DAT = 2860
endif


ifneq ($(findstring 7601U,$(CHIPSET)),)
WFLAGS += -DMT7601U -DMT7601 -DRLT_MAC -DRLT_RF -DRTMP_MAC_USB -DRTMP_USB_SUPPORT -DRTMP_TIMER_TASK_SUPPORT -DRX_DMA_SCATTER -DVCORECAL_SUPPORT -DRTMP_EFUSE_SUPPORT -DNEW_MBSSID_MODE -DRTMP_INTERNAL_TX_ALC -DCONFIG_ANDES_SUPPORT 
#WFLAGS += -DMT7601U -DMT7601 -DRLT_MAC -DRLT_RF -DRTMP_MAC_USB -DRTMP_USB_SUPPORT -DRTMP_TIMER_TASK_SUPPORT -DRX_DMA_SCATTER -DVCORECAL_SUPPORT -DNEW_MBSSID_MODE -DRTMP_INTERNAL_TX_ALC -DCONFIG_ANDES_SUPPORT
ifneq ($(findstring $(RT28xx_MODE),AP),)
#WFLAGS += -DSPECIFIC_BCN_BUF_SUPPORT
endif

ifeq ($(HAS_RX_CSO_SUPPORT), y)
WFLAGS += -DCONFIG_RX_CSO_SUPPORT
endif

ifneq ($(findstring $(RT28xx_MODE),AP),)
else
WFLAGS += -DRTMP_FREQ_CALIBRATION_SUPPORT
endif

CHIPSET_DAT = 2870
endif



ifneq ($(findstring $(RT28xx_MODE),AP),)
ifeq ($(HAS_CS_SUPPORT), y)
WFLAGS +=  -DCARRIER_DETECTION_FIRMWARE_SUPPORT
endif
endif

ifneq ($(findstring $(RT28xx_MODE),AP),)
WFLAGS += -DSPECIFIC_BCN_BUF_SUPPORT
endif
#endif




ifneq ($(findstring $(RT28xx_MODE),AP),)
#WFLAGS += -DSPECIFIC_BCN_BUF_SUPPORT
endif

#endif








#################################################


ifeq ($(HAS_BLOCK_NET_IF),y)
WFLAGS += -DBLOCK_NET_IF
endif

ifeq ($(HAS_DFS_SUPPORT),y)
WFLAGS += -DDFS_SUPPORT
endif

ifeq ($(HAS_MC_SUPPORT),y)
WFLAGS += -DMULTIPLE_CARD_SUPPORT
endif

ifeq ($(HAS_LLTD),y)
WFLAGS += -DLLTD_SUPPORT
endif





ifeq ($(PLATFORM),ST)
#WFLAGS += -DST
WFLAGS += -DST
endif

#kernel build options for 2.4
# move to Makefile outside LINUX_SRC := /opt/star/kernel/linux-2.4.27-star






##################################
#####解决各种头文件包含问题#######
##################################
ifeq ("1","1")
#	@echo -e ">>>>>>>>>>>>>>>>>>>>>>modify test housir<<<<<<<<<<<<<"
ifeq ($(PLATFORM),ST)

EXTRA_CFLAGS += \
-I$(LINUX_SRC)/include \
-I$(RT28xx_DIR)/include \
-I$(LINUX_SRC)/arch/sh/include \
-I/opt/STM/STLinux-2.4/devkit/sources/kernel/linux-sh4-2.6.32.59_stm24_0211/arch/sh/include/cpu-sh4 \
-I/opt/STM/STLinux-2.4/devkit/sources/kernel/linux-sh4-2.6.32.59_stm24_0211/arch/sh/include/cpu-sh5 \
-Wall -fno-strict-aliasing -std=gnu99   -fgnu89-inline\
-Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -Uarm  -pipe \
-I/opt/STM/STLinux-2.4/devkit/sources/kernel/linux-2.6.32/drivers/staging/rt2870 \
$(WFLAGS)
export EXTRA_CFLAGS
endif
endif

ifeq ($(PLATFORM),offcial_ST)
CFLAGS := -D__KERNEL__ -I$(LINUX_SRC)/include -DCONFIG_PAGE_SIZE_64KB\
-Wall -O2 -Wundef -Wstrict-prototypes -Wno-trigraphs -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-aliasing -fno-common -fomit-frame-pointer -ffreestanding -m4-nofpu -o $(WFLAGS) 
export CFLAGS

#EXTRA_CFLAGS := -I/opt/STM/STLinux-2.4/devkit/sources/kernel/linux-sh4-2.6.32.59_stm24_V6.0/drivers/staging/rt2870/ $(WFLAGS) 
endif



ifeq ($(PLATFORM),PC)
    ifneq (,$(findstring 2.4,$(LINUX_SRC)))
	# Linux 2.4
	CFLAGS := -D__KERNEL__ -I$(LINUX_SRC)/include -O2 -fomit-frame-pointer -fno-strict-aliasing -fno-common -pipe -mpreferred-stack-boundary=2 -march=i686 -DMODULE -DMODVERSIONS -include $(LINUX_SRC)/include/linux/modversions.h $(WFLAGS)
	export CFLAGS
    else
	# Linux 2.6
	EXTRA_CFLAGS := $(WFLAGS) 
    endif
endif


#If the kernel version of RMI is newer than 2.6.27, please change "CFLAGS" to "EXTRA_FLAGS"

ifeq ($(PLATFORM),MT85XX)
    ifneq (,$(findstring 2.4,$(LINUX_SRC)))
	# Linux 2.4
	CFLAGS := -D__KERNEL__ -I$(LINUX_SRC)/include -O2 -fomit-frame-pointer -fno-strict-aliasing -fno-common -pipe -mpreferred-stack-boundary=2 -march=i686 -DMODULE -DMODVERSIONS -include $(LINUX_SRC)/include/linux/modversions.h $(WFLAGS)
	export CFLAGS
    else
	# Linux 2.6
	EXTRA_CFLAGS += $(WFLAGS) 
	EXTRA_CFLAGS += -D _NO_TYPEDEF_BOOL_ \
	                -D _NO_TYPEDEF_UCHAR_ \
	                -D _NO_TYPEDEF_UINT8_ \
	                -D _NO_TYPEDEF_UINT16_ \
	                -D _NO_TYPEDEF_UINT32_ \
	                -D _NO_TYPEDEF_UINT64_ \
	                -D _NO_TYPEDEF_CHAR_ \
	                -D _NO_TYPEDEF_INT32_ \
	                -D _NO_TYPEDEF_INT64_ \
	                
    endif
endif


#	#
#	print_env:
#		-@echo -e ">>>>>>>>>>>>>>>><<<<<<<<<<<<<<"
#		-@echo -e "EXTRA_CFLAGS = "$(EXTRA_CFLAGS)
#		-@echo -e "CFLAGS = " $(CFLAGS)
#		-@echo -e "WFLAGS = " $(WFLAGS)
