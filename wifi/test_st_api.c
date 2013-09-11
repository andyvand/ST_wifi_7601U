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
    
    wifi_init(&link_info);
    ST_Sta_Ioctl(&link_info, CONNECT);

    return EXIT_SUCCESS;
}				/* ----------  end of function main  ---------- */
