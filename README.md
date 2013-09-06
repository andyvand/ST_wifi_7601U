ST_wifi_7601U
=============

ST平台上的wifi移植（7601U模块）

上传wifi驱动模块代码至github

上传配置内核产生的包含内核参数的antoconfig.h文件

发现sudo iwlist scan 扫描不到到网络信息的bug开启分支

硬件问题，去掉2个压频电阻后一切恢复正常，能ping通百度。准备合并.
