/*
 * =====================================================================================
 *       Copyright (c), 2013-2020, Newland C&S.
 *       Filename:  st_sta_interface.h
 *
 *    Description:  st-wifi 接口文件，芯片为mt7601U,
 *         Others:  调用之前确保/dev/wifi文件夹存在，wpa已移植，否            则只能连接上wpe网络
 *
 *        Version:  1.0
 *        Date:  Monday, September 09, 2013 02:08:44 HKT
 *       Revision:  none
 *       Compiler:  sh4-linux-gcc
 *
 *         Author:  housir houwentaoff@gmail.com
 *   Organization:  Newland
 *
 * =====================================================================================
 */
#ifndef __ST_STA_INTERFACE_H__
#define __ST_STA_INTERFACE_H__

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <spawn.h>
#include <sys/wait.h>
#include <fcntl.h>


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
 * @brief 
 *
 * @param link_info 请求连接的AP配置
 * @param cmd
 *
 * @return 
 */
int HI_Sta_Ioctl(struct sta_link_info *const link_info, const int cmd);
/**
 * @brief ST_GetAPinf2File 将搜索到的AP信息存入/dev/wifi/list_ap文件，若未搜索到则将no ap found 写入
 *
 * @param ap_cnt 搜索到的个数
 * @param interface 网卡名称 如 wlan0 
 *
 * @return : 0 if get ap count succeed, -1 if fail
 */
int ST_GetAPinf2File(int *ap_cnt, char * interface);
/*
 * ST_Get_Ap_Raw_FromFile - 从文件/dev/wifi/ap_list读取解析之前搜索到的AP信息并放入结构链表ap_list中
 * @interface - wifi interface name, such as "ra0", "wlan0"
 * @ap_cnt  - total ap that were scanned
 *             NULL - just store the ap info
 * @ap_list   - the specific infomation of each ap
 *             NULL - just get the count of ap
 * Returns: 0 if collect raw info succeed, -1 if fail
 */
int ST_Get_Ap_Raw_FromFile(struct wifi_info **ap_list, int *ap_cnt, char * interface);

#ifdef DBUG_WIFI
/*
 * ST_Show_List
 * @total: how many ap we scan
 * @list: the specific info of each ap 很多AP点
 */
void ST_Show_List(int total, struct wifi_info *list);
#endif

#endif /* __ST_STA_INTERFACE_H__  */
