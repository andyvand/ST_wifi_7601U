vpath %.so ./interface/lib/

SUBDIRS = interface 
#切忌在上面的变量中加入./目录,否则会死循环
export CC = gcc
#/opt/STM/STLinux-2.4/devkit/sh4/bin/sh4-linux-gcc

all:
	for d in $(SUBDIRS); do [ -d $$d ] && $(MAKE) -C $$d all; done


#依赖中带有库,检查库的更新情况，但是此时的$?中已经有libwifi.so的文件了
#若是上面为 .c 下面不变(14 15 raw)，则不行
test_st_api: -lwifi test_st_api.o
	$(CC) test_st_api.o -o $@ -L./interface/lib -lwifi

clean:
	for d in $(SUBDIRS); do [ -d $$d ] && $(MAKE) -C $$d clean; done
	$(RM) *~ test_st_api test_st_api.o
	
