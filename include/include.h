/*
 * =====================================================================================
 *       Copyright (c), 2013-2020, Newland C&S.
 *       Filename:  include.h
 *
 *    Description:  移植过程中,未定义的类型提前包含,该文件废弃，解决错编译2.4的出现的错误.2.6的核不用
 *         Others:
 *
 *        Version:  1.0
 *        Date:  Tuesday, August 27, 2013 10:20:47 HKT
 *       Revision:  none
 *       Compiler:  sh-linux-gcc
 *
 *         Author:  housir houwentaoff@gmail.com
 *   Organization:  Newland
 *
 * =====================================================================================
 */
#if 0
#include <asm/cache.h>
#include <linux/autoconf.h>
#include <rtmp_type.h>

#define IN    //unsigned int
#define OUT   //unsigned int
#include "chip/mt7601.h"
//#include <aaaa.h>
#include <mac_ral/nmac/ral_nmac_rxwi.h>
#include <mac_ral/nmac/ral_nmac.h>
#include <os/rt_os.h>
//#include <rtmp.h>
//#include <rtmp_and.h>
#e
