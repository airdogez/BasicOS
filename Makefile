all: os-image

run: all
	bochs

#Combina los archivos binarios y genera la imagen final
os-image: boot_sec.bin kernel.bin
	cat $^ > os-image

#Build kernel bin
kernel.bin: kernel_entry.o kernel.o
	ld -o kernel.bin -Ttext 0x1000 $^ --oformat binary -melf_i386

#Build kernel object file
kernel.o: kernel.c
	gcc -ffreestanding -m32 -c $< -o $@

#Build kernel entry object file
kernel_entry.o: kernel_entry.asm
	nasm $< -f elf -o  $@

boot_sec.bin : boot_sec.asm
	nasm $< -f bin -o $@

clean:
	rm -fr *.bin *.dis *.o os-image *.map

kernel.dis : kernel.bin
	ndisasm -b 32 $< > $@
