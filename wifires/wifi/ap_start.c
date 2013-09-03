#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <spawn.h>
#include <sys/wait.h>
#include <fcntl.h>

#include "hi_ap_inf.h"

int main(int argc, char *argv[])
{
	char *ssid="hisi";
	char *security="WEP";
	char *password="12345678ab";
	int	channel=2;

	HI_Ap_Start(ssid, security, password, channel);
	return 0;
}
