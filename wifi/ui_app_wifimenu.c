#include "../../osd/include/resource.h"
#include "fyf_common.h"

#define DEBUG
#define MAX_SSID_NUM        40
#define NUM_IN_PAGE         7/*由控件中的选项决定*/

static BU32 cur_wifi_page = 1;

char *wifiinfo[]=
{
    "wifi_1",
    "wifi_2",
};
static char *ssid_set[MAX_SSID_NUM];/*housir: 即时显示wifi ssid的信息 */
static struct wifi_info *scan_ap_info;/*存放AP的链表*/
/**
 * @brief 
 *
 * @return 
 */
static int iDisplay_Ap_Info()
{
    printf("--->[%s]\n", __func__);

 
    struct sta_link_info link_info;
    
    int total_ap = -1;
    int err = -1;
   /*清空显示并记住当前选项位置，准备刷新*/
    if (NULL != scan_ap_info)
    {
        free(scan_ap_info);
        scan_ap_info = NULL;
    }
    
    //memset(&link_info, 0, sizeof(struct sta_link_info));
    

    err = ST_GetAPinf2File(&total_ap, "wlan0");/*housir: 写入AP info ---> /dev/wifi/listap */
    printf("[total_ap][%d]\n", total_ap);

    if (-1 == err) 
    {
	fprintf(stderr, "ST_GetAPinf2File() = %d\n", err);
    }

    scan_ap_info = (struct wifi_info *)malloc(total_ap * 
		sizeof(struct wifi_info));
	memset(scan_ap_info, 0, total_ap * sizeof(struct wifi_info));
	err = ST_Get_Ap_Raw_FromFile(&scan_ap_info, &total_ap, "wlan0");/*housir: scan_ap_info<---读入AP info <--- /dev/wifi/listap */
    if (-1 == err) 
    {
	fprintf(stderr, "ST_Get_Ap_Raw_FromFile() = %d\n", err);
	free(scan_ap_info);
	return -1;
	}

    ST_Show_List(total_ap, scan_ap_info);
    
    int i = 0,j = 0;
    
    while(i < total_ap)
    {
        if (!strncmp(scan_ap_info[i].ssid, "\"\"", 2))
        {
            i++;
            continue;
        }
        ssid_set[j++] = &(scan_ap_info[i++].ssid);
        printf("ssid_set[num][%d]%s\n", j-1, ssid_set[j-1]);
    }
  
    GUI_ENC_API_SetValue(ID_LBP_Wifilist, WDT_LBP_SV_DATA, (BU32)ssid_set, j <= NUM_IN_PAGE ? j : NUM_IN_PAGE );


  //  free(scan_ap_info);//警告不能放在这里，上面的setvalue的效果可能还没执行完，不要释放

    return 0;
}

void UI_APP_WifiMenu_Enter(void)
{
    printf("--->[%s]\n", __func__);
    iDisplay_Ap_Info();

}

void UI_APP_WifiMenu_End(void)
{
       printf("--->[%s]\n", __func__);
}

void UI_APP_WifiMenu_Key(BU32 key)
{
    printf("--->[%s]\n", __func__);

    switch (key)
	{
		case GUI_VK_MENU:
		case GUI_VK_RECALL:
                GUI_ENC_API_SwitchState(ID_DLG_MainMenu, 1);/*housir: 返回到主菜单 */
			break;	

		default:
			break;
    }
}
void UI_APP_Wifilist_Key(BU32 keyValue)
{
    printf("--->[%s]\n", __func__);
    switch (keyValue)
	{
		case GUI_VK_UP:
		case GUI_VK_DOWN:
		case GUI_VK_P_UP:
		case GUI_VK_P_DOWN:
            	break;
        case GUI_VK_MENU:
		case GUI_VK_RECALL:
                GUI_ENC_API_SwitchState(ID_DLG_MainMenu, 1);
			break;	

		default:
			break;
    }
    
}

/*----------------------------------------------------------------------------
描述：显示当前页数据
-----------------------------------------------------------------------------*/
void UI_APP_Wifilist_ShowCurPage(void)
{

    printf("--->[%s]\n", __func__);
    BU32 total_ssid = strlen(ssid_set)/sizeof(char *);/*预计有bug ,地址中有'\0'?*/
    BU32 cur_num = total_ssid-NUM_IN_PAGE*(cur_wifi_page-1) > NUM_IN_PAGE ? NUM_IN_PAGE : total_ssid-NUM_IN_PAGE*(cur_wifi_page-1);
    printf("total_ssid==>[%d]\ncur_num==>[%d]\ncur_wifi_page==>[%d]\n", total_ssid, cur_num, cur_wifi_page);    
    GUI_ENC_API_SetValue(ID_LBP_Wifilist, WDT_LBP_SV_DATA, (BU32)&ssid_set[(cur_wifi_page-1)*NUM_IN_PAGE], cur_num);

}

void UI_APP_Wifilist_Change(void)
{
    BS32 state;
    BU32 max_cur_wifi_page = (strlen(ssid_set)/sizeof(char *))/NUM_IN_PAGE + 1;
        
    printf("--->[%s]\n", __func__);
    printf("max_cur_wifi_page==>[%d]\n", max_cur_wifi_page);
    
    GUI_ENC_API_GetValue(ID_LBP_Wifilist, WDT_LBP_SV_STATE, (BU32 *)&state,0);
    
    switch (state)
	{
		case 1:/*down*/
		/*超限返回第一页*/
			cur_wifi_page = cur_wifi_page+1 > max_cur_wifi_page ? 1 : cur_wifi_page+1;
            
			break;
			
		case -1:/*up*/
		/*超限返回最后一页*/
			cur_wifi_page = cur_wifi_page-1 == 0 ? max_cur_wifi_page : cur_wifi_page-1;
	
			break;
			
		default:
			break;
	}
    
    printf("max_cur_wifi_page==>[%d]\n", max_cur_wifi_page);
    UI_APP_Wifilist_ShowCurPage();//显示当前页
}
