CC = gcc
CFLAGS = -std=c11 -Wall -Wextra -Werror -O2 -Iinclude -I../shared
ASAN_FLAGS = -fsanitize=address -g

SRCS = src/safe_str.c \
       src/file_list.c \
       src/arg_parser.c \
       src/cmd_stat.c \
       src/cmd_memo.c \
       src/cmd_clean.c \
       src/main.c

OBJS = $(SRCS:.c=.o)
TARGET = gear

.PHONY: all asan install clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

asan: CFLAGS += $(ASAN_FLAGS)
asan: clean $(TARGET)

install: $(TARGET)
	mkdir -p ~/.local/bin
	cp $(TARGET) ~/.local/bin/$(TARGET)

clean:
	rm -f $(OBJS) $(TARGET)
