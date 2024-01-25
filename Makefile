
all: caesar.o
	ld -m elf_x86_64 -o caesar caesar.o

caesar.o: caesar.asm
	as -o caesar.o caesar.asm

clean:
	rm -rf *.o