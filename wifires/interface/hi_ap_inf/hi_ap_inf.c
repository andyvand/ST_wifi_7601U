#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <spawn.h>
#include <sys/wait.h>
#include <fcntl.h>

#include "hi_ap_inf.h"

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

/*
 * ap start
 * ssid      - wifi ap ssid
 * security  - security mode
 *             "NONE"
 *             "WEP"
 *             "WPAPSK"
 * password  - "security key"
 * channel   - "from 1 to 11"  housir:for what?
 *
 * if invoke this function fail,ruturn -1
 * if invoke this function succeed,ruturn 0
 *
 */
int HI_Ap_Start(char * ssid, char * security, char * password, int channel)
{
	pid_t pid = 0;
	int err = 0;
	char  env_str0[20] = {'\0'};
	char  *spawn_env[]  = {env_str0, NULL};
	char  *spawn_args[] = {"ap_start.sh", ssid, security, password, NULL};

	if (!strncmp(security, "WEP", 3)) {
		if (strlen(password) != 10) {
			PRINTF_CA("WEP's PASSWORD MUST BE 10 HEX NUM\n");
			return -1;
		}
	} else if (!strncmp(security, "WPAPSK", 6)) {
		if (strlen(password) < 8){
			PRINTF_CA("WPAPSK's PASSWORD NO LESS THAN 8 HEX NUM\n");
			return -1;
		}
	}

	if (channel > 11) {
		PRINTF_CA("CHANNEL MUST BE LESS THAN 12\n");
		return -1;
	}

	(void) snprintf(env_str0, 20, "CHANNEL=%d", channel);
	err = posix_spawnp(&pid, spawn_args[0], NULL, NULL,
		spawn_args, spawn_env);
	if (0 != err) {
		FPRINTF_CA(stderr, "posix_spawnp() error=%d\n", err);
		return -1;
	}

	(void) wait(NULL);
	return 0;
}
