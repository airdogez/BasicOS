[org 0x7c00]

mov bp, 0x9000 ;Setea la pila
mov sp, bp

mov bx, MSG_REAL_MODE
call print_string

call switch_to_pm ;Ultima instruccion que se ejecuta en este bloque

jmp $ ;nunca se deberia de entrar a esta instruccion

%include "print_string.asm"
;%include "print_hex.asm"
;%include "disk_load.asm"
%include "gdt.asm"
%include "print_string_pm.asm"
%include "switch_to_pm.asm"

[bits 32]

BEGIN_PM:

  mov ebx, MSG_PROT_MODE
  call print_string_pm ;imprime una cadena en modo protegido

  jmp $ ;Termina

;GLOBAL VARIABLES
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode", 0
MSG_ERROR db "STUCK HERE", 0

times 510-($-$$) db 0
dw 0xaa55
