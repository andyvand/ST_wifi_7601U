#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <spawn.h>
#include <sys/wait.h>
#include <fcntl.h>

#include "hi_sta_inf.h"

#define MAX_SCAN_AP 100

/**
 * @brief 
 *
 * @param name
 */
void HI_Do_Help(char *name)
{
	printf("Usage:\n");
	printf("\t%s interface\n", name);
	printf("Example:\n");
	printf("\t%s wlan0\n", name);
}

/**
 * @brief 为什么为main?
 *
 * @param argc
 * @param argv[]
 *
 * @return 
 */
int main(int argc, char *argv[])
{
	int err;
	int total_ap;
	struct wifi_info *scan_ap_info;
	struct sta_link_info link_info;
#define DEBUG 

	if (argc < 2){
		HI_Do_Help(argv[0]);
		return -1;
	}
	
	memset(&link_info, 0, sizeof(struct sta_link_info));
	strcpy(link_info.interface, argv[1]);

	err = HI_Get_Ap_Count(&total_ap, link_info.interface);
	if (-1 == err) {
#ifdef DEBUG
		fprintf(stderr, "get_ap_info() = %d\n", err);
#endif
		return -1;
	} else if (-NOSUCHINF == err) 
		return -NOSUCHINF;
	else if (-NOAPFOUND == err) 
		return -NOAPFOUND;

	if (total_ap > MAX_SCAN_AP)
		return -1;

	scan_ap_info = (struct wifi_info *)malloc(total_ap * 
		sizeof(struct wifi_info));
	memset(scan_ap_info, 0, total_ap * sizeof(struct wifi_info));

	err = HI_Get_Ap_Info(&scan_ap_info, link_info.interface);
	if (-1 == err) {
#ifdef DEBUG
		fprintf(stderr, "get_ap_info() = %d\n", err);
#endif
		free(scan_ap_info);
		return -1;
	}

	HI_Show_List(total_ap, scan_ap_info);
	printf("Select one you prefer:\t");
	(void) scanf("%[^\n]", link_info.ssid);

	(void) HI_Get_Security(&link_info);

	if (!strncmp(link_info.security, "NULL", 4)) {
		printf("No match ssid.\n");
		free(scan_ap_info);
		return -NOSUCHAP;
	} else if (strncmp(link_info.security, "NONE", 4)) {
		printf("Please input password:\t");
		(void) scanf("%s", link_info.password);
	}

	err = HI_Sta_Ioctl(&link_info, CONNECT);
	if (-1 == err) {
		printf("connect failed!\n");
		free(scan_ap_info);
		return -CONFAIL;
	}

	err = HI_Sta_Ioctl(&link_info, CHKSTATUS);
	if (-1 == err) {
		printf("password incorrect\n");
		free(scan_ap_info);
		return -CHKSTATUSFAIL;	
	}
	
	err = HI_Sta_Ioctl(&link_info, DISCONNECT);
	if (-1 == err) {
		printf("disconnect failed!\n");
		free(scan_ap_info);
		return -DISCONFAIL;
	}	
	
	err = HI_Sta_Ioctl(&link_info, RECONNECT);
	if (-1 == err) {
		printf("reconnect failed!\n");
		free(scan_ap_info);
		return -RECONFAIL;
	}	

	err = HI_Sta_Ioctl(&link_info, RESTART);
	if (-1 == err) {
		printf("restart failed!\n");
		free(scan_ap_info);
		return -RESTARTFAIL;
	}	

	free(scan_ap_info);
	return 0;
} 
