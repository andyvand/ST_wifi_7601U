/******************************************************************************
  Copyright (C), 2004-2050, Hisilicon Tech. Co., Ltd.
******************************************************************************
  File Name     : hi_ap_inf.h
  Version       : Initial Draft
  Author        : Hisilicon sdk software group
  Created       :
  Last Modified :
  Description   : header file for wifi SoftAP
  Function List :
  History       :
  1.Date        :
  Author        :
  Modification  : Created file
******************************************************************************/

/**
 * \file
 * \brief describle the APIs and structs of WiFi SoftAP function. CNcomment:提供WiFi SoftAP功能组件相关接口、数据结构信息。
 */

#ifndef __HI_AP_INF_H__
#define __HI_AP_INF_H__
/*housir:  #include "hi_type.h"*/

#define IN          /** indicate [in] param*/
#define OUT         /** indicate [out] param*/
#define INOUT       /** indicate [in][out] param*/

/*
 * ap start
 * ssid      - wifi ap ssid
 * security  - security mode
 *             "NONE"
 *             "WEP"
 *             "WPAPSK"
 * password  - "security key"
 * channel   - "from 1 to 11"
 *
 * if invoke this function fail,ruturn -1
 * if invoke this function succeed,ruturn 0
 *
 */
/**
\brief: start SoftAP with configuration 
\attention \n
\param[in] ssid             AP's SSID
\param[in] security         Securtiy mode: "NONE", "WEP" or "WPAPSK"
\param[in] password         Passwork if Securtiy mode isn't "NONE"
\param[in] channel          channel used
\retval    0                Successfull
\retval    -1               fail to start SoftAP
\see \n
*/
int HI_Ap_Start(char * ssid, char * security, char * password, int channel);

#endif /*__HI_AP_INF_H__*/
