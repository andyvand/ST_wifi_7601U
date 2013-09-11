/*
 * =====================================================================================
 *       Copyright (c), 2013-2020, Newland C&S.
 *       Filename:  test_st_api.c
 *
 *    Description:  测试连接wifi api的程序，若成功即可在中间件中 调用
 *         Others:
 *   
 *        Version:  1.0
 *        Date:  Monday, September 09, 2013 03:25:21 HKT
 *       Revision:  none
 *       Compiler:  sh4-linux-gcc
 *
 *         Author:  housir , houwentaoff@gmail.com
 *   Organization:  Newland
 *        History:   Created by housir
 *
 * =====================================================================================
 */
#include "st_sta_interface.h"

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  wifi_init
 *  Description:
 *  Param      :
 *  Return     :
 * =====================================================================================
 */
void wifi_init( struct sta_link_info *link_info)
{
    memset(link_info, 0, sizeof(struct sta_link_info));
	strcpy(link_info->interface, "wlan1");
	strcpy(link_info->ssid, "wifist");
	strcpy(link_info->security, "NONE");
	strcpy(link_info->password, "NONE");



    return ;
}		/* -----  end of function wifi_init  ----- */
/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  main
 *  Description:  
 * =====================================================================================
 */
int main ( int argc, char *argv[] )
{
    struct sta_link_info link_info;
    struct wifi_info *scan_ap_info;
    
    int total_ap = 0;
    int err = 0;

    memset(&link_info, 0, sizeof(struct sta_link_info));
    

    err = ST_GetAPinf2File(&total_ap, "wlan1");/*housir: ÐŽÈëAP info ---> /dev/wifi/listap */

    printf("[total_ap][%d]\n", total_ap);
    scan_ap_info = (struct wifi_info *)malloc(total_ap * 
		sizeof(struct wifi_info));
	memset(scan_ap_info, 0, total_ap * sizeof(struct wifi_info));

    printf("[total_ap][%d]\n", total_ap);

    if (-1 == err) 
    {
	fprintf(stderr, "ST_GetAPinf2File() = %d\n", err);
    }
	err = ST_Get_Ap_Raw_FromFile(&scan_ap_info, &total_ap, "wlan1");/*housir: scan_ap_info<---¶ÁÈëAP info <--- /dev/wifi/listap */
    if (-1 == err) 
    {
	fprintf(stderr, "ST_Get_Ap_Raw_FromFile() = %d\n", err);
	free(scan_ap_info);
	return -1;
	}

    ST_Show_List(total_ap, scan_ap_info);/*housir:  */
	free(scan_ap_info);
    
//    wifi_init(&link_info);
//    ST_Sta_Ioctl(&link_info, CONNECT);

    return EXIT_SUCCESS;
}				/* ----------  end of function main  ---------- */
