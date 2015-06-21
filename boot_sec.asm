[org 0x7c00]

mov bx, HELLO_MSG
call print_string

mov bx, GOODBYE_MSG
call print_string

mov dx, 0x101d
call print_hex

mov dx, 0x35fe
call print_hex

jmp $

%include "print_string.asm"
%include "print_hex.asm"

;DATA
HELLO_MSG:
  db 'Hello, World!', 0

GOODBYE_MSG:
  db 'Goodbye!', 0

times 510-($-$$) db 0
dw 0xaa55
