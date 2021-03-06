/*
 * =====================================================================================
 *       Copyright (c), 2013-2020, Newland C&S.
 *       Filename:  sta_inf.c
 *
 *    Description:  
 *         Others:
 *   
 *        Version:  1.0
 *        Date:  Tuesday, September 03, 2013 05:36:26 HKT
 *       Revision:  none
 *       Compiler:  gcc
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
#include <malloc.h>
#include <bits/posix1_lim.h>

#include "st_sta_interface.h"

#define MAX_PART	5     /** the max number of paramter of scan results*/
#define PRINTF_CA_FLAG 1

/*****************************************************************************/

#if !defined(PRINTF_CA) && !defined(FPRINTF_CA)
#ifdef  CONFIG_SUPPORT_CA_RELEASE
#define PRINTF_CA(fmt, args...)
#define FPRINTF_CA(file, fmt, args...)
#else
#define PRINTF_CA(fmt, args...) do{\
        printf("%s(%d): " fmt, __FILE__, __LINE__, ##args); \
} while (0)
#define FPRINTF_CA(file, fmt, args...) do{\
	fprintf((FILE *)file, fmt, ##args); \
} while (0)
#endif
#endif


int get_security(INOUT struct sta_link_info *link_info);
/**
 * @brief 设置ip等参数
 *
 * @param getip_way  ANTO or MANUAL
 * @param getdns_way  ANTO or MANUAL
 * @param ips_info
 * @param interface  wlan0 or other
 *
 * @return 
 */
int apply_for_ips(unsigned char getip_way, unsigned char getdns_way, IN struct wifi_ips_info *ips_info, IN char *interface)
{
    pid_t pid = 0;
    int err=0;
    int status=0;
    int exit_flag=0;

    if (ANTO == getip_way)
    {
        if ((pid = vfork()) == 0)
        {
            if ( (err = execlp("dhclient", "dhclient", interface, NULL)) <0)
                FPRINTF_CA(stderr, "execlp() error=%d\n", err);
    
        }
    }
    else    /*housir:  下面为手动*/
    {
        pid_t pid_setip = 0;

        if ((pid_setip = vfork()) == 0)
        {
            if ( (err = execlp("ifconfig", "ifconfig", interface, ips_info->ipaddress, "netmask", ips_info->netmask, NULL)) <0)
                FPRINTF_CA(stderr, "execlp() error=%d\n", err);
        }

        err = waitpid(pid_setip, &status, 0);

        printf("waitpid_setip ==> %d \n", status);
        if (-1 == err) {
            perror("waitpid\n");
            return -1;
        }
        exit_flag = WEXITSTATUS(status);
        printf("exit_flag ===> %d\n", exit_flag);

        pid_t pid_set_gateway = 0;
        if ( (pid_set_gateway = vfork()) == 0)
        {
#if 1
            if ( (err = execlp ("route", "route", "add", "default", "gw", ips_info->gateway, NULL)) < 0)
                FPRINTF_CA(stderr, "execlp() error=%d\n", err);
#endif
            exit(0);
//            return 0;
        }

        err = waitpid(pid_set_gateway, &status, 0);

        printf("waitpid _setgateway ==> %d \n", status);
        if (-1 == err) {
            perror("waitpid\n");
            return -1;
        }
        exit_flag = WEXITSTATUS(status);
        printf("exit_flag ===> %d\n", exit_flag);

    }/*housir:  手动设置ip等结束*/

    if (MANUAL == getdns_way)
    {
        pid_t pid_set_dns;
        if ( (pid_set_dns = vfork()) == 0)
        {
            if ( (err = execlp("echo ", "echo", "nameserver",  ips_info->dns, ">>", "/etc/resolv.conf", NULL)) < 0 )
                FPRINTF_CA(stderr, "execlp() error=%d\n", err);
        }

        err = waitpid(pid_set_dns, &status, 0);

        printf("waitpid_setdns ==> %d \n", status);
        if (-1 == err) {
            perror("waitpid\n");
            return -1;
        }
        exit_flag = WEXITSTATUS(status);
        printf("exit_flag ===> %d\n", exit_flag);
    }
    printf("===> set ips over\n");


    return 0;
}
/*****************************************************************************/
/*
 * extract_info - divide info 
 * @src: the raw source info the were scan
 * @sym: such as '\n' ' '
 * @ss: each partition divide 
 */
void extract_info(char *src, char sym, char *ss[])
{
//    printf("--->[%s]\n", __func__);
	*ss++ = src--;
	while (*++src) {
		if (*src == sym) {
			*src++ = '\0';
			*ss++ = src;
		}
	}
}

/*****************************************************************************/
/*
 * extract_ap_info - divide info 
 * @src: the raw source info the were scan
 * @sym: such as '\n' ' '
 * @ss: each partition divide 
 */
void extract_ap_info(char *src, char sym, char *ss[])
{
    printf("--->[%s]\n", __func__);
	char *p;

	p = strrchr(src, '"');
	if (p == NULL)
		return;

	*ss++ = src--;
	while (*++p) {
		if (*p == sym) {
			*p++ = '\0';
			*ss++ = p;
		}
	}
}

/*****************************************************************************/
/*
 * store_info
 * @dev_info: the specific info of eace ap
 * @src: the raw source info that were scan
 */
void store_info(OUT struct wifi_info *dev_info, IN char *src[])
{
    int len ;
//    printf("---> [%s]\n", __func__);
	if (dev_info == NULL)
		return;

	if (src == NULL || src[0] == NULL || src[1] == NULL
	   || src[2] == NULL || src[3] == NULL || src[4] == NULL)
		return;

	memset(dev_info, 0, sizeof(struct wifi_info));
	strcpy(dev_info->ssid, src[0]);
	strcpy(dev_info->channel, src[1]);
	strcpy(dev_info->signal, src[2]);
    if (dev_info->signal[1] == '/')/* 将5/100 转换成 05/100模式，方便中间件使用快排函数排序输出,100/100模式中间件另有处理*/
    {
        printf("dev_info->signal ==> %s \n", dev_info->signal);
        len = strlen(dev_info->signal);
        while (0 != len)
        {
            dev_info->signal[len+1] = dev_info->signal[len];
            len--;
        }
        dev_info->signal[0] = '0';
    }
	strcpy(dev_info->encrypt, src[3]);
	strcpy(dev_info->security, src[4]);

//    printf("<--- [%s]\n", __func__);
} 

/*****************************************************************************/
/*
 * connect_ap
 * @link_info: key info to associate ap
 * Returns: 0 if connect ap succeed, -1 if fail
 */
int connect_ap(const struct sta_link_info *const link_info)
{
    printf("--->[%s]\n", __func__);
    
	int pid = 0;
	int err = 0;
	int status = 0;
	char *spawn_env[] = {NULL};
	char *spawn_args[] = {"./sta_connect.sh", link_info->interface, 
		link_info->ssid, link_info->security, link_info->password, NULL};

	err = posix_spawnp(&pid, spawn_args[0], NULL, NULL,
		spawn_args, spawn_env);/*housir:  */
	if (0 != err) {
		FPRINTF_CA(stderr, "posix_spawnp() error = %d\n", err);
		return -1;
	}
	err = waitpid(pid, &status, 0);
	if (-1 == err) {
		perror("waitpid");
		return -1;
	}
    printf("<---[%s]\n", __func__);
	return 0;
}

/*****************************************************************************/
/*
 * sta_ioctl - to control wifi
 * @link_info: key info to associate ap
 * @cmd: action for sta
 * Returns: 0 if cmd succeed, -1 if cmd fail
 */

int sta_ioctl( struct sta_link_info * link_info,const int cmd)
{
    printf("--->[%s]\n", __func__);
	int err = 0;
	pid_t pid = 0;
	int status = 0;
	int exit_flag = 0;
	char *spawn_env[] = {NULL};
	char *spawn_args[] = {"./list_ap.sh", NULL, 
			link_info->interface, NULL};
	
	switch (cmd) {
		case CONNECT:
		case RESTART:
            get_security(link_info);
            if (!strncmp(link_info->security, "NULL", 4)) 
            {
                printf("No match ssid!!!!!!!!!!!!\n");
                return -2;
            }
			err = connect_ap(link_info);
			break;
		case CHKSTATUS:
			spawn_args[1] = "-c";
			break;
		case DISCONNECT:
			spawn_args[1] = "-d";
			break;
		case RECONNECT:
			spawn_args[1] = "-r";
			break;
        case CLOSE:
            spawn_args[1] = "-close";
            break;
		default:
			break;
	}

	if(cmd == CONNECT || cmd == RESTART) { 
		if(-1 == err)
			return -1;
		else 
			return 0;
	}

	err = posix_spawnp(&pid, spawn_args[0], NULL, NULL, 
		spawn_args, spawn_env);
	if (0 != err) {
		FPRINTF_CA(stderr, "posix_spawnp() error=%d\n", err);
		return -1;
	}

	err = waitpid(pid, &status, 0);
	if (-1 == err) {
		perror("waitpid");
		return -1;
	}

	if (!strcmp(spawn_args[1], "-c")) {
		exit_flag = WEXITSTATUS(status);
		if (8 == exit_flag)
			return 8;
	}
    else if (!strcmp(spawn_args[1], "-close")) 
    {
		exit_flag = WEXITSTATUS(status);
		if (3 == exit_flag)
			return 3;
	}


    printf("<---[%s]\n", __func__);
	return 0;
}

/*****************************************************************************/
/*
 * get security - set ap security type
 * @link_info: key info to associate ap
 * Returns: 0 if get security type succeed, -1 if fail
 */
int get_security(INOUT struct sta_link_info *link_info)
{
    printf("--->[%s]\n", __func__);
	int err = 0;
	pid_t pid = 0;
	int status = 0;
	int  exit_flag = 0;
	char *spawn_env[] = {NULL};
	char *spawn_args[] = {"./list_ap.sh", "-s", 
		link_info->interface, link_info->ssid, NULL};

	err = posix_spawnp(&pid, spawn_args[0], NULL, NULL, 
		spawn_args, spawn_env);
	if (0 != err) {
		FPRINTF_CA(stderr, "posix_spawnp() error=%d\n", err);
		return -1;
	}

	err = waitpid(pid, &status, 0);
	if (-1 == err) {
		perror("waitpid");
		return -1;
	}
	exit_flag = WEXITSTATUS(status);

	switch (exit_flag) {
		case 1:
			strcpy(link_info->security, "NONE");
			break;
		case 2:
			strcpy(link_info->security, "WEP");
			break;
		case 3:
			strcpy(link_info->security, "WPAPSK");
			break;
		case 4:
			strcpy(link_info->security, "NULL");
			break;
		default:
			break;
	}
    printf("<---[%s]\n", __func__);
	return 0;
}

/*****************************************************************************/
/*
 * get_ap_raw_info - to collect the key info of ap for connecting
 * @interface - wifi interface name, such as "ra0", "wlan0"
 * @ap_cnt  - total ap that were scanned
 *             NULL - just store the ap info
 * @ap_list   - the specific infomation of each ap
 *             NULL - just get the count of ap
 * Returns: 0 if collect raw info succeed, -1 if fail
 */
int get_ap_raw_info(IN struct wifi_info **ap_list, 
		OUT int *ap_cnt, IN char *interface)
{
    printf("--->[%s]\n", __func__);
	
    int cnt = 0;
	int all_ap = 0;
	int len = 0;
	char *buf;
	FILE *fp = NULL;

	if (ap_list == NULL)
		return -1;

	fp = fopen("/dev/wifi/list_ap","r");
	if(fp == NULL)
	{
		FPRINTF_CA(stderr, "cant find file /dev/wifi/list_ap\n");
		return -1;
	}

	fseek(fp,0,SEEK_END);
	len = ftell(fp);
	if(len == 0)
	{
		FPRINTF_CA(stderr, "file len is zero \n");
		fclose(fp);
		return -1;
	}

	buf = malloc(len);
	if(buf == NULL)
	{
		FPRINTF_CA(stderr, "malloc buff error  \n");
		fclose(fp);
		return -1;
	}

	fseek(fp,0,SEEK_SET);
	
	fread(buf,len,1,fp);
	fclose(fp);

	if (!strncmp(buf, "no such interface.", 18)) {
		PRINTF_CA("%s", buf);
		free(buf);
		return -NOSUCHINF;
	} else if (!strncmp(buf, "no ap found.", 12)) {
		PRINTF_CA("%s", buf);
		*ap_cnt = all_ap;
		free(buf);
		return -NOAPFOUND;
	}

	for (cnt = 0; cnt < strlen(buf); cnt++) {
		if ('\n' == buf[cnt])
			all_ap++;
	}

	if (ap_cnt != NULL) {
		if (all_ap > *ap_cnt)
			all_ap = *ap_cnt;

		*ap_cnt = all_ap;
	}
	
	int count;
	char **line_index;
	char *space_index[MAX_PART + 1] = {NULL};
	line_index = (char **)malloc(sizeof(char *) * (all_ap + 1));
	extract_info(buf, '\n', line_index);
	for (count = 0; count < all_ap; count++) {
		extract_ap_info(line_index[count], ' ' , space_index); 

		store_info(&(*ap_list)[count], space_index);
	}

	free(line_index);
	free(buf);

	return 0;
}

/*****************************************************************************/
/*
 * get_ap_raw_info - to collect the key info of ap for connecting
 * @interface - wifi interface name, such as "ra0", "wlan0"
 * @ap_cnt  - total ap that were scanned
 *             NULL - just store the ap info
 * @ap_list   - the specific infomation of each ap
 *             NULL - just get the count of ap
 * Returns: 0 if collect raw info succeed, -1 if fail
 */
int scan_for_ap(OUT int *ap_cnt, IN char *interface)
{
    printf("--->[%s]\n", __func__);
    
	int err = 0;
	pid_t pid = 0;
	int cnt = 0;
	int all_ap = 0;
	int status = 0;
	int len = 0;
	char *buf;
	char *spawn_env[] = {NULL};
	char *spawn_args[] = {"./list_ap.sh", "-l", interface, NULL};
	FILE *fp = NULL;

	
	err = posix_spawnp(&pid, spawn_args[0], NULL, NULL,
		spawn_args, spawn_env);
	if (0 != err) {
		FPRINTF_CA(stderr, "posix_spawnp() error = %d\n", err);
		return -1;
	}

	err = waitpid(pid, &status, 0);
    printf("waitpid ==> %d \n", status);
	if (-1 == err) {
		perror("waitpid\n");
		return -1;
	}

	fp = fopen("/dev/wifi/list_ap","r");/*housir: need to modify */
	if(fp == NULL)
	{
		FPRINTF_CA(stderr, "cant find file /dev/wifi/list_ap\n");
		return -1;
	}

	fseek(fp,0,SEEK_END);
	len = ftell(fp);
	if(len == 0)
	{
		FPRINTF_CA(stderr, "file len is zero \n");
		fclose(fp);
		return -1;
	}

	buf = malloc(len);
	if(buf == NULL)
	{
		FPRINTF_CA(stderr, "malloc buff error  \n");
		fclose(fp);
		return -1;
	}

	fseek(fp,0,SEEK_SET);
	fread(buf, len, 1, fp);
	fclose(fp);

	if (!strncmp(buf, "no such interface.", 18)) {
		PRINTF_CA("%s", buf);
		free(buf);
		return -NOSUCHINF;
	} else if (!strncmp(buf, "no ap found.", 12)) {
		PRINTF_CA("%s", buf);
		*ap_cnt = all_ap;
		free(buf);
		return -NOAPFOUND;
	}

	for (cnt = 0; cnt < strlen(buf); cnt++) {
		if ('\n' == buf[cnt])
			all_ap++;
	}

	if (NULL != ap_cnt) {
		*ap_cnt = all_ap;
	} 
	free(buf);

    printf("<---[%s]\n", __func__);
	return 0;
}

/*****************************************************************************/
/*
 * show_list
 * @total: how many ap we scan
 * @list: the specific info of each ap
 */
void show_list(IN int total, IN struct wifi_info *list)
{
    printf("--->[%s]\n", __func__);
	int cnt = 0;
	#define SHOW_FORMAT "%-40s %-10s %-10s %-10s %-10s\n"
	PRINTF_CA(SHOW_FORMAT, "SSID", "CHANNEL", "SIGNAL", "ENCRYPT", "SECURITY");

	for (cnt = 0; cnt < total; cnt++) {
		PRINTF_CA(SHOW_FORMAT,
			list[cnt].ssid,
			list[cnt].channel,
			list[cnt].signal,
			list[cnt].encrypt,
			list[cnt].security);
	}
	PRINTF_CA("\n");
}
