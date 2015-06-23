[org 0x7c00]
KERNEL_OFFSET equ 0x1000 ;Es el offset de memoria al cual cargaremos el kernel

mov [BOOT_DRIVE], dl ;El BIOS guarda el boot drive en dl al inicio,
                     ;Es buena practica guardarlo

mov bp, 0x9000 ;Setea la pila
mov sp, bp

mov bx, MSG_REAL_MODE ;Informa que estamos comenzando el booting
call print_string     ;de 16bit real mode

call load_kernel ;Subrutina que carga el kernel

call switch_to_pm ;Cambia a modo protegido (PM), del cual no regresaremos

jmp $ ;nunca se deberia de entrar a esta instruccion

%include "print_string.asm"
;%include "print_hex.asm"
%include "disk_load.asm"
%include "gdt.asm"
%include "print_string_pm.asm"
%include "switch_to_pm.asm"

[bits 16]
;Rutina de carga de kernel
load_kernel:
  mov bx, MSG_LOAD_KERNEL ;Informa que se cargara el kernel
  call print_string
  
  mov bx, KERNEL_OFFSET ;Inicia parametros para la carga
  mov dh, 15            ;se cargaran los primeros 15 sectores
  mov dl, [BOOT_DRIVE]  ;excluyendo los del boot, desde el boot disk (Kernel code)
  call disk_load        ;a la direccion KERNEL_OFFSET

  ret

[bits 32]
;Esta es el area que se llega luego de hacer el cambio e inicializar el modo protegido

BEGIN_PM:

  mov ebx, MSG_PROT_MODE
  call print_string_pm ;imprime una cadena en modo protegido

  call KERNEL_OFFSET ;Finalmente saltamos a la direccion donde se encuentra el 
                     ;codigo del kernel.

  jmp $ ;Termina

;GLOBAL VARIABLES
BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory.", 0

;Bootsector padding
times 510-($-$$) db 0
dw 0xaa55
