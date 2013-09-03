/******************************************************************************
  Copyright (C), 2004-2050, Hisilicon Tech. Co., Ltd.
******************************************************************************
  File Name     : hi_sta_inf.h
  Version       : Initial Draft
  Author        : Hisilicon sdk software group
  Created       :
  Last Modified :
  Description   : header file for wifi station
  Function List :
  History       :
  1.Date        :
  Author        :
  Modification  : Created file
******************************************************************************/

/**
 * \file
 * \brief describle the APIs and structs of WiFi Station function. CNcomment:提供WiFi station功能组件相关接口、数据结构信息。
 */

#ifndef __HI_STA_INF_H__
#define __HI_STA_INF_H__
/*housir:  #include "hi_type.h"*/

#define IN          /** indicate [in] param*/
#define OUT         /** indicate [out] param*/
#define INOUT       /** indicate [in][out] param*/

/** Command to controll wifi */
#define CONNECT		0       /** connect to a AP*/
#define	CHKSTATUS	1       /** check connection status*/
#define DISCONNECT	2       /** disconnect to AP*/
#define RECONNECT	3       /** reconnect to AP*/
#define RESTART		4       /** restart wifi sta, connect to a AP*/

/** Error code */
#define NOSUCHINF	2       /** cann't find wlan network interface*/
#define NOAPFOUND	3       /** scan result is null, no AP found*/
#define NOSUCHAP	4       /** the AP is not in the AP list*/
#define CONFAIL		5       /** fail to connect to AP*/
#define CHKSTATUSFAIL	6       /** fail to check connection status*/
#define ERRPASSWORD	7       /** password is not correct, cann't connect to the AP*/
#define DISCONFAIL	8       /** fail to disconnect to AP*/
#define RECONFAIL	9       /** fail to reconnect to the AP*/
#define RESTARTFAIL	10      /** fail to restart wifi and connect to the AP*/

/** configure information of AP connected or wanted to connect to */
struct sta_link_info {
	char interface[8];        /**< network interface, such as "wlan0" "ra0" */
	char ssid[32];            /**< AP's ssid which want to connect to */
	char security[10];        /**< AP's security mode, such as "NONE", "WEP", "WPAPSK" */
	char password[64];        /**< AP's password if AP's security mode isn't "NONE" */
};

/** AP's information */
struct wifi_info {
	char ssid[36];        /**< ssid */
	char channel[3];      /**< channel */
	char signal[8];       /**< signal level, such as 80/100, signal is stronger when the value is bigger */
	char encrypt[4];      /**< if AP uses WEP or WPA, this value is "on", else "off" */
	char security[8];     /**< security mode, such as "NONE", "WEP", "WPAPSK" */
};

/**
\brief: send ioctl to control wifi 
\attention \n
\param[in] link_info        ptr to AP configured
\param[in] cmd              Command sent to wifi   
\retval    0                Successfull
\retval    CONFAIL          fail to Connect
\retval    CHKSTATUSFAIL	  fail to check connection status
\retval    DISCONFAIL	      fail to disconnect to AP
\retval    RECONFAIL	      fail to reconnect to the AP
\retval    RESTARTFAIL	    fail to restart wifi and connect to the AP
\see \n
*/
int HI_Sta_Ioctl(struct sta_link_info *link_info, int cmd);

/**
\brief: Get ap security type 
\attention \n
\param[in] link_info        ptr to AP configured
\param[out] link_info       ptr to AP configured   
\retval    0                Successfull
\retval    -1               fail
\see \n
*/
int HI_Get_Security(struct sta_link_info *link_info);

/**
\brief: Connect to ap configured 
\attention \n
\param[in] link_info        ptr to AP configured
\retval    0                Successfull
\retval    -1               fail
\see \n
*/
int HI_Connect_Ap(struct sta_link_info *link_info);

/**
\brief: Get AP information of scan list 
\attention \n
\param[out] ap_list         ptr to scan list
\param[out] ap_cnt          number of AP in scan list
\param[in] interface        network interface, such as "wlan0"   
\retval    0                Successfull
\retval    -1               fail
\see \n
*/
int HI_Get_Ap_Raw_Info(struct wifi_info **ap_list, int *ap_cnt, char * interface);

/**
\brief: Get the number of AP in scan list 
\attention \n
\param[out] ap_cnt          number of APs in scan list
\param[in] interface        network interface, such as "wlan0"   
\retval    0                Successfull
\retval    -1               fail
\see \n
*/
int HI_Get_Ap_Count(int *ap_cnt, char * interface);

/**
\brief: Get AP information of scan list 
\attention \n
\param[out] ap_list         ptr to scan list
\param[in] interface        network interface, such as "wlan0"   
\retval    0                Successfull
\retval    -1               fail
\see \n
*/
int HI_Get_Ap_Info(struct wifi_info **wifi_list, char * interface);

/*****************************************************************************/
/*
 * HI_Show_List
 * @total: how many ap we scan
 * @list: the specific info of each ap
 */
/**
\brief: print scan list 
\attention \n
\param[in] total           number of AP in scan list
\param[in] ap_list         ptr to scan list 
\retval    null
\see \n
*/
void HI_Show_List(int total, struct wifi_info *list);


#endif /* __HI_STA_INF_H__ */
