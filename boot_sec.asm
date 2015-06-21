[org 0x7c00]

mov bx, HELLO_MSG
call print_string

mov bx, GOODBYE_MSG
call print_string

jmp $

print_string:
  pusha
  ;Prints a string on screen
  mov ah, 0x0e
continue:
  mov al, [bx]
  cmp al, 0x00
  je end_fun
  int 0x10
  add bx, 1
  jmp continue
end_fun:
  popa
  ret

;DATA
HELLO_MSG:
  db 'Hello, World!', 0

GOODBYE_MSG:
  db 'Goodbye!', 0

times 510-($-$$) db 0
dw 0xaa55
