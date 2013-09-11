/*
 * =====================================================================================
 *       Copyright (c), 2013-2020, Newland C&S.
 *       Filename:  st_sta_interface.c
 *
 *    Description:  接口实现文件
 *         Others:
 *   
 *        Version:  1.0
 *        Date:  Monday, September 09, 2013 02:16:47 HKT
 *       Revision:  none
 *       Compiler:  sh4-linux-gcc
 *
 *         Author:  housir , houwentaoff@gmail.com
 *   Organization:  Newland
 *        History:   Created by housir
 *
 * =====================================================================================
 */
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <spawn.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <bits/posix1_lim.h>

#include "st_sta_interface.h"
#define DBUG_WIFI
/*****************************************************************************/
extern int sta_ioctl(const struct sta_link_info *const link_info, const int cmd);
extern int get_security(INOUT struct sta_link_info *link_info);
extern int connect_ap(IN const struct sta_link_info *const link_info);
extern int get_ap_raw_info(IN struct wifi_info **ap_list, OUT int *ap_cnt, IN char *interface);
extern void extract_info(char *src, char sym, char *ss[]);
extern void store_info(OUT struct wifi_info *dev_info, IN char *src[]);
extern void show_list(IN int total, IN struct wifi_info *list);
extern int get_ap_count(OUT int *ap_count, IN char *interface);
extern int get_key_info(IN struct wifi_info **wifi_list, IN char *interface);
extern int scan_for_ap(OUT int *ap_cnt, IN char *interface);


/**
 * @brief ST_Sta_Ioctl - to control wifi 运行之前确保link_info结构已从UI中获取补全.
 *
 * @param link_info  key info to associate ap
 * @param cmd  action for sta
 *
 * @return  0 if cmd succeed, -1 if cmd fail
 */
int ST_Sta_Ioctl(struct sta_link_info *const link_info, const int cmd)
{
//    strncpy(link_info->interface, "wlan0", 6);
#if 0
    get_security(link_info);/*set security */
    if (!strncmp(link_info.security, "NULL", 4)) 
    {
	    printf("No match ssid.\n");
	    return -NOSUCHAP;
    }
    else if (strncmp(link_info.security, "NONE", 4)) 
    {
	    printf("Please input password:\t");
	    (void) scanf("%s", link_info.password);
	}
#endif

    return  sta_ioctl(link_info, cmd);
}

/**
 * @brief ST_GetAPinf2File 将搜索到的AP信息存入/dev/wifi/list_ap文件，若未搜索到则将no ap found 写入
 *
 * @param ap_cnt 搜索到的个数
 * @param interface 网卡名称 如 wlan0 
 *
 * @return : 0 if get ap count succeed, -1 if fail
 */
int ST_GetAPinf2File(int *ap_cnt, char * interface)
{

	return scan_for_ap(ap_cnt, interface);
}
/*
 * ST_Get_Ap_Raw_FromFile - 从文件/dev/wifi/ap_list读取解析之前搜索到的AP信息并放入结构链表ap_list中
 * @interface - wifi interface name, such as "ra0", "wlan0"
 * @ap_cnt  - total ap that were scanned
 *             NULL - just store the ap info
 * @ap_list   - the specific infomation of each ap
 *             NULL - just get the count of ap
 * Returns: 0 if collect raw info succeed, -1 if fail
 */
int ST_Get_Ap_Raw_FromFile(struct wifi_info **ap_list, int *ap_cnt, char * interface)
{
	return get_ap_raw_info(ap_list, ap_cnt, interface);
}


/*
 * ST_Show_List
 * @total: how many ap we scan
 * @list: the specific info of each ap
 */
void ST_Show_List(int total, struct wifi_info *list)
{	
	show_list(total, list);
}

