game_of_life: main.c start_run.o
	gcc -std=c99 -g -Wall -o game_of_life main.c start_run.o

.SECONDARY:

%.o: %.asm
	nasm -f elf64 -F dwarf -g $<


%: %.o
	ld $< -o $@ -lc --dynamic-linker=/lib64/ld-linux-x86-64.so.2


clean:
	rm -f *.o
