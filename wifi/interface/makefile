vpath %.c ./src/ #只指定%.c  因为这个不会因为makefile而生成.不会因为目录搜索机制而导致，变化
#vpath %.o ./obj/
#vpath %.so ./lib/

OBJ = ./obj
LIB = ./lib
SRC = ./src

all: $(LIB)/libwifi.so
#还是用 $(LIB)/libwifi.so: 好于用vpath配合 libwifi.so:vpath会出现下列问题：如最后所写
$(LIB)/libwifi.so (sta_inf.o st_sta_interface.o): $(OBJ)/sta_inf.o $(OBJ)/st_sta_interface.o
	ar cr $@ $?
#不能为$? 因为 $?是更新的文件,要慎重在自动变量前面加上路径名，因为有些是个文件名列表，有些是单个文件名
#	mv $@ ./lib/

$(OBJ)/%.o:%.c 
	$(CC) -c $< -o $@  

.PHONY:clean 
clean:
	-$(RM)  ./obj/*.o ./lib/*.so *.o *.so
