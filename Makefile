#Generar listas de fuente para usar en las wildcards
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

#Convierte los archivos *.c a *.o para la lista de objectos a construir
OBJ = ${C_SOURCES:.c=.o}

#Default build target
all: os-image

run: all
	bochs

#Combina los archivos binarios y genera la imagen final
os-image: boot/boot_sec.bin kernel.bin
	cat $^ > os-image

#Build kernel bin
kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary -melf_i386

#Build kernel object file
%.o : %.c ${HEADERS}
	gcc -ffreestanding -m32 -c $< -o $@

#Build kernel entry object file
%.o : %.asm
	nasm $< -f elf -o  $@

%.bin : %.asm
	nasm $< -f bin -I 'boot/' -o $@

clean:
	rm -fr *.bin *.dis *.o os-image
	rm -fr kernel/*.o boot/*.bin drivers/*.o

kernel.dis : kernel.bin
	ndisasm -b 32 $< > $@
