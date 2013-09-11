
INTERFACE_PATH = ../interface/hi_sta_inf
CC = gcc
#/opt/STM/STLinux-2.4/devkit/sh4/bin/sh4-linux-gcc

all:lib main.o
	$(CC) main.o sta_inf.o hi_sta_inf.o -o main

lib:
	$(CC) -c $(INTERFACE_PATH)/*.c 

main.o:
	$(CC) -c sta_start.c -o main.o

test_st_api:
	$(CC) -c ../interface/st_sta_inf/*.c
	$(CC) -c test_st_api.c -o test_st_api.o
	$(CC)  sta_inf.o st_sta_interface.o test_st_api.o -o test_st_api

clean:
	rm *.o
