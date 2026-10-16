CC = gcc
CFLAGS = -std=c11 -Wall -Wextra -Werror

all: floor_runner

floor_runner: main.o calc.o
	$(CC) $(CFLAGS) -o floor_runner main.o calc.o

main.o: main.c calc.h
	$(CC) $(CFLAGS) -c main.c -o main.o

calc.o: calc.c calc.h
	$(CC) $(CFLAGS) -c calc.c -o calc.o

clean:
	rm -f *.o floor_runner
