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

#include "hi_sta_inf.h"

/*****************************************************************************/
extern int sta_ioctl(struct sta_link_info *link_info, int cmd);
extern int get_security(INOUT struct sta_link_info *link_info);
extern int connect_ap(IN struct sta_link_info *link_info);
extern int get_ap_raw_info(IN struct wifi_info **ap_list, OUT int *ap_cnt, IN char *interface);
extern void extract_info(char *src, char sym, char *ss[]);
extern void store_info(OUT struct wifi_info *dev_info, IN char *src[]);
extern void show_list(IN int total, IN struct wifi_info *list);
extern int get_ap_count(OUT int *ap_count, IN char *interface);
extern int get_key_info(IN struct wifi_info **wifi_list, IN char *interface);
extern int scan_for_ap(OUT int *ap_cnt, IN char *interface);

/*****************************************************************************/
/*
 * HI_Sta_Ioctl - to control wifi
 * @link_info: key info to associate ap
 * @cmd: action for sta
 * Returns: 0 if cmd succeed, -1 if cmd fail
 */
int HI_Sta_Ioctl(struct sta_link_info *link_info, int cmd)
{
	return  sta_ioctl(link_info, cmd);
}

/*****************************************************************************/
/*
 * HI_Get_Security - set ap security type
 * @link_info: key info to associate ap
 * Returns: 0 if get type security succeed, -1 if fail
 */
int HI_Get_Security(struct sta_link_info *link_info)
{
	return get_security(link_info);
}

/*****************************************************************************/
/*
 * HI_Connect_Ap
 * @link_info: key info to associate ap
 * Returns: 0 if connect ap succeed, -1 if fail
 */
int HI_Connect_Ap(struct sta_link_info *link_info)
{
	return connect_ap(link_info);
}

/*****************************************************************************/
/*
 * HI_Get_Ap_Raw_Info - to collect the key info of ap for connecting
 * @interface - wifi interface name, such as "ra0", "wlan0"
 * @ap_cnt  - total ap that were scanned
 *             NULL - just store the ap info
 * @ap_list   - the specific infomation of each ap
 *             NULL - just get the count of ap
 * Returns: 0 if collect raw info succeed, -1 if fail
 */
int HI_Get_Ap_Raw_Info(struct wifi_info **ap_list, int *ap_cnt, char * interface)
{
	return get_ap_raw_info(ap_list, ap_cnt, interface);
}

/*****************************************************************************/
 /*
  * HI_Get_Ap_Count
  * @ap_acount: total ap we scan
  * @interface: such as "wlan0" "ra0"
  * Returns: 0 if get ap count succeed, -1 if fail
  */
int HI_Get_Ap_Count(int *ap_cnt, char * interface)
{
	return scan_for_ap(ap_cnt, interface);
}

/*****************************************************************************/
 /*
  * HI_Get_Ap_Info - to extract all key info of ap
  * @wifi_list: all key info of the ap we scan
  * @interface: such as "wlan0" "ra0"
  * Returns: 0 if succeed, -1 if fail
  */
int HI_Get_Ap_Info(struct wifi_info **wifi_list, char * interface)
{
	return HI_Get_Ap_Raw_Info(wifi_list, NULL, interface);
}

/*****************************************************************************/
/*
 * HI_Show_List
 * @total: how many ap we scan
 * @list: the specific info of each ap
 */
void HI_Show_List(int total, struct wifi_info *list)
{	
	show_list(total, list);
}

